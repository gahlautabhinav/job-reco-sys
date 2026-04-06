import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/job_recommendation.dart';
import '../models/user_profile.dart';

class DatabaseService {
  DatabaseService._();
  static final DatabaseService instance = DatabaseService._();

  Database? _db;

  Future<Database> get database async {
    _db ??= await _init();
    return _db!;
  }

  Future<Database> _init() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'job_search.db'),
      version: 2,
      onCreate: (db, version) async {
        await _createAllTables(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('''
            CREATE TABLE IF NOT EXISTS users (
              id            INTEGER PRIMARY KEY AUTOINCREMENT,
              username      TEXT    UNIQUE NOT NULL,
              password_hash TEXT    NOT NULL,
              created_at    INTEGER NOT NULL
            )
          ''');
        }
      },
    );
  }

  Future<void> _createAllTables(Database db) async {
    await db.execute('''
      CREATE TABLE bookmarks (
        id           INTEGER PRIMARY KEY AUTOINCREMENT,
        job_title    TEXT    NOT NULL,
        work_type    TEXT    NOT NULL,
        salary_range TEXT    NOT NULL,
        similarity   REAL    NOT NULL,
        saved_at     INTEGER NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE user_profile (
        id                  INTEGER PRIMARY KEY CHECK (id = 1),
        skills              TEXT    NOT NULL DEFAULT '',
        experience          TEXT    NOT NULL DEFAULT '',
        preferred_work_type TEXT    DEFAULT NULL,
        expected_salary     TEXT    DEFAULT NULL,
        top_n               INTEGER NOT NULL DEFAULT 10,
        updated_at          INTEGER NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE result_cache (
        id           INTEGER PRIMARY KEY AUTOINCREMENT,
        cache_key    TEXT    NOT NULL UNIQUE,
        results_json TEXT    NOT NULL,
        fetched_at   INTEGER NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE users (
        id            INTEGER PRIMARY KEY AUTOINCREMENT,
        username      TEXT    UNIQUE NOT NULL,
        password_hash TEXT    NOT NULL,
        created_at    INTEGER NOT NULL
      )
    ''');
  }

  // ── Bookmarks ──────────────────────────────────────────────────────────────

  Future<List<JobRecommendation>> getBookmarks() async {
    final db = await database;
    final rows = await db.query('bookmarks', orderBy: 'saved_at DESC');
    return rows
        .map((r) => JobRecommendation(
              title: r['job_title'] as String,
              workType: r['work_type'] as String,
              salary: r['salary_range'] as String,
              similarity: r['similarity'] as double,
            ))
        .toList();
  }

  Future<void> addBookmark(JobRecommendation job) async {
    final db = await database;
    await db.insert(
      'bookmarks',
      {
        'job_title': job.title,
        'work_type': job.workType,
        'salary_range': job.salary,
        'similarity': job.similarity,
        'saved_at': DateTime.now().millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<void> removeBookmark(JobRecommendation job) async {
    final db = await database;
    await db.delete(
      'bookmarks',
      where: 'job_title = ? AND work_type = ? AND salary_range = ?',
      whereArgs: [job.title, job.workType, job.salary],
    );
  }

  Future<bool> isBookmarked(JobRecommendation job) async {
    final db = await database;
    final result = await db.query(
      'bookmarks',
      where: 'job_title = ? AND work_type = ? AND salary_range = ?',
      whereArgs: [job.title, job.workType, job.salary],
      limit: 1,
    );
    return result.isNotEmpty;
  }

  // ── User Profile ───────────────────────────────────────────────────────────

  Future<UserProfile?> getProfile() async {
    final db = await database;
    final rows = await db.query('user_profile', limit: 1);
    if (rows.isEmpty) return null;
    return UserProfile.fromDbMap(rows.first);
  }

  Future<void> saveProfile(UserProfile profile) async {
    final db = await database;
    await db.insert(
      'user_profile',
      profile.toDbMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // ── Users ──────────────────────────────────────────────────────────────────

  Future<bool> createUser(String username, String passwordHash) async {
    final db = await database;
    try {
      await db.insert('users', {
        'username': username.trim().toLowerCase(),
        'password_hash': passwordHash,
        'created_at': DateTime.now().millisecondsSinceEpoch,
      });
      return true;
    } catch (_) {
      return false; // username already exists (UNIQUE constraint)
    }
  }

  Future<String?> getUserPasswordHash(String username) async {
    final db = await database;
    final rows = await db.query(
      'users',
      columns: ['password_hash'],
      where: 'username = ?',
      whereArgs: [username.trim().toLowerCase()],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return rows.first['password_hash'] as String;
  }

  // ── Result Cache ───────────────────────────────────────────────────────────

  Future<({List<JobRecommendation> jobs, bool isStale})?> getCached(
      String key) async {
    final db = await database;
    final rows = await db.query(
      'result_cache',
      where: 'cache_key = ?',
      whereArgs: [key],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    final row = rows.first;
    final fetchedAt =
        DateTime.fromMillisecondsSinceEpoch(row['fetched_at'] as int);
    final isStale = DateTime.now().difference(fetchedAt).inMinutes > 60;
    final jobs =
        JobRecommendation.listFromJson(row['results_json'] as String);
    return (jobs: jobs, isStale: isStale);
  }

  Future<void> putCache(String key, List<JobRecommendation> jobs) async {
    final db = await database;
    await db.insert(
      'result_cache',
      {
        'cache_key': key,
        'results_json': JobRecommendation.listToJson(jobs),
        'fetched_at': DateTime.now().millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
