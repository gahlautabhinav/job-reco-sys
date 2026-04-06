import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../data/models/user_profile.dart';
import '../../providers/auth_provider.dart';
import '../../providers/profile_provider.dart';
import '../../shared/widgets/frosted_card.dart';
import '../../shared/widgets/gradient_button.dart';
import 'widgets/preference_chip_row.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _skillsCtrl = TextEditingController();
  final _expCtrl = TextEditingController();
  final _salaryCtrl = TextEditingController();
  String? _workType;
  int _topN = 10;
  bool _saving = false;
  bool _dirty = false;

  static const _workTypes = ['Full-Time', 'Part-Time', 'Contract'];
  static const _topNOptions = [5, 10, 15, 20];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadProfile());
  }

  void _loadProfile() {
    final p = context.read<ProfileProvider>().profile;
    _skillsCtrl.text = p.skills;
    _expCtrl.text = p.experience;
    _salaryCtrl.text = p.expectedSalary ?? '';
    setState(() {
      _workType = p.preferredWorkType;
      _topN = p.topN;
    });
  }

  @override
  void dispose() {
    _skillsCtrl.dispose();
    _expCtrl.dispose();
    _salaryCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    await context.read<ProfileProvider>().save(UserProfile(
          skills: _skillsCtrl.text.trim(),
          experience: _expCtrl.text.trim(),
          preferredWorkType: _workType,
          expectedSalary:
              _salaryCtrl.text.trim().isEmpty ? null : _salaryCtrl.text.trim(),
          topN: _topN,
        ));
    setState(() {
      _saving = false;
      _dirty = false;
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Profile saved'),
          backgroundColor: Colors.green.shade700,
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text('My Profile',
                              style: AppTextStyles.displayLarge),
                        ),
                        GestureDetector(
                          onTap: () => context.read<AuthProvider>().logout(),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.red.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: Colors.red.withValues(alpha: 0.3)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.logout_rounded,
                                    size: 14,
                                    color: AppColors.white
                                        .withValues(alpha: 0.7)),
                                const SizedBox(width: 5),
                                Text(
                                  'Sign out',
                                  style: AppTextStyles.labelMedium.copyWith(
                                    color:
                                        AppColors.white.withValues(alpha: 0.7),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Set your default search preferences',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: const Color(0xFFD2BBFF).withValues(alpha: 0.8),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Hero avatar with gradient ring
                    Center(
                      child: Consumer<AuthProvider>(
                        builder: (context, auth, _) {
                          final username = auth.username ?? '';
                          final initials = username.isNotEmpty
                              ? username[0].toUpperCase()
                              : '?';
                          return Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF7C3AED),
                                      Color(0xFF3B82F6),
                                      Color(0xFFF97316),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF7C3AED)
                                          .withValues(alpha: 0.5),
                                      blurRadius: 20,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xFF151024),
                                  ),
                                  child: CircleAvatar(
                                    radius: 38,
                                    backgroundColor: const Color(0xFF221C31),
                                    child: Text(
                                      initials,
                                      style: AppTextStyles.displayLarge
                                          .copyWith(fontSize: 28),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              // Username
                              Text(
                                username,
                                style: AppTextStyles.titleLarge.copyWith(
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: -0.3,
                                ),
                              ),
                              const SizedBox(height: 8),
                              // Stat pills row
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _StatPill(
                                      label: _expCtrl.text.isEmpty
                                          ? 'Experience'
                                          : _expCtrl.text),
                                  const SizedBox(width: 8),
                                  _StatPill(
                                      label: _workType ?? 'Any Type'),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),

                    FrostedCard(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Skills & Experience',
                              style: AppTextStyles.titleMedium),
                          const SizedBox(height: 14),
                          TextField(
                            controller: _skillsCtrl,
                            style: AppTextStyles.bodyMedium,
                            onChanged: (_) => setState(() => _dirty = true),
                            decoration: const InputDecoration(
                              labelText: 'Default Skills',
                              hintText: 'Python, SQL, Machine Learning',
                              prefixIcon:
                                  Icon(Icons.code_rounded, color: Colors.white54),
                            ),
                          ),
                          const SizedBox(height: 14),
                          TextField(
                            controller: _expCtrl,
                            style: AppTextStyles.bodyMedium,
                            onChanged: (_) => setState(() => _dirty = true),
                            decoration: const InputDecoration(
                              labelText: 'Experience',
                              hintText: '3 years',
                              prefixIcon: Icon(Icons.work_history_rounded,
                                  color: Colors.white54),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    FrostedCard(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Preferences', style: AppTextStyles.titleMedium),
                          const SizedBox(height: 14),
                          PreferenceChipRow(
                            label: 'Preferred Work Type',
                            options: _workTypes,
                            selected: _workType,
                            onChanged: (v) =>
                                setState(() { _workType = v; _dirty = true; }),
                          ),
                          const SizedBox(height: 14),
                          TextField(
                            controller: _salaryCtrl,
                            style: AppTextStyles.bodyMedium,
                            keyboardType: TextInputType.number,
                            onChanged: (_) => setState(() => _dirty = true),
                            decoration: const InputDecoration(
                              labelText: 'Expected Salary',
                              hintText: '90000',
                              prefixIcon: Icon(Icons.attach_money_rounded,
                                  color: Colors.white54),
                            ),
                          ),
                          const SizedBox(height: 14),
                          PreferenceChipRow(
                            label: 'Results to show',
                            options: _topNOptions.map((n) => '$n').toList(),
                            selected: '$_topN',
                            onChanged: (v) => setState(() {
                              if (v != null) _topN = int.parse(v);
                              _dirty = true;
                            }),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    GradientButton(
                      label: 'Save Profile',
                      isLoading: _saving,
                      onPressed: _dirty && !_saving ? _save : null,
                    ),

                    const SizedBox(height: 20),
                    const _AboutSection(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AboutSection extends StatelessWidget {
  const _AboutSection();

  @override
  Widget build(BuildContext context) {
    return FrostedCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.info_outline_rounded,
                  size: 16, color: Color(0xFFD2BBFF)),
              const SizedBox(width: 8),
              Text('About', style: AppTextStyles.titleMedium),
            ],
          ),
          const SizedBox(height: 16),
          _AboutItem(
            icon: Icons.lock_outline_rounded,
            color: const Color(0xFF7C3AED),
            title: 'Login & Accounts',
            body:
                'Accounts are stored locally in SQLite with SHA-256 hashed passwords — '
                'no data leaves your device. Your session persists across restarts via SharedPreferences.',
          ),
          const SizedBox(height: 14),
          _AboutItem(
            icon: Icons.storage_rounded,
            color: const Color(0xFF3B82F6),
            title: 'SQLite',
            body:
                'Bookmarks, your profile, search cache, and user accounts all live in a single '
                'on-device SQLite database. Everything works fully offline.',
          ),
          const SizedBox(height: 14),
          _AboutItem(
            icon: Icons.auto_awesome_rounded,
            color: const Color(0xFFF97316),
            title: 'Recommender System',
            body:
                'Job matches use a semantic similarity model on Hugging Face. Your skills are '
                'encoded as vectors and ranked by cosine similarity — "96% match" means your '
                'profile is geometrically close to that job\'s embedding.',
          ),
        ],
      ),
    );
  }
}

class _AboutItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String body;

  const _AboutItem({
    required this.icon,
    required this.color,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: color),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: AppTextStyles.labelMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  )),
              const SizedBox(height: 4),
              Text(
                body,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.white.withValues(alpha: 0.55),
                  fontSize: 13,
                  height: 1.55,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatPill extends StatelessWidget {
  final String label;

  const _StatPill({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.15),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: const Color(0xFFD2BBFF).withValues(alpha: 0.9),
        ),
      ),
    );
  }
}
