import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../providers/auth_provider.dart';
import '../../shared/widgets/aurora_background.dart';
import '../../shared/widgets/frosted_card.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isSignIn = true;
  final _formKey = GlobalKey<FormState>();
  final _userCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;
  String? _errorMessage;

  @override
  void dispose() {
    _userCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _errorMessage = null);

    final auth = context.read<AuthProvider>();
    final error = _isSignIn
        ? await auth.login(_userCtrl.text, _passCtrl.text)
        : await auth.register(_userCtrl.text, _passCtrl.text);

    if (error != null && mounted) {
      setState(() => _errorMessage = error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: AuroraBackground()),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 32),

                    // Logo / title
                    Column(
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            gradient: AppColors.ctaGradient,
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.cta.withValues(alpha: 0.45),
                                blurRadius: 20,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.work_rounded,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text('JobFinder', style: AppTextStyles.displayLarge),
                        const SizedBox(height: 4),
                        Text(
                          'AI-powered job recommendations',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.lavender.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    )
                        .animate()
                        .fadeIn(duration: 500.ms)
                        .slideY(begin: -0.1, end: 0, duration: 500.ms),

                    const SizedBox(height: 36),

                    // Card
                    FrostedCard(
                      padding: const EdgeInsets.all(24),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Sign In / Sign Up toggle
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.07),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.all(4),
                              child: Row(
                                children: [
                                  _TabButton(
                                    label: 'Sign In',
                                    active: _isSignIn,
                                    onTap: () => setState(() {
                                      _isSignIn = true;
                                      _errorMessage = null;
                                    }),
                                  ),
                                  _TabButton(
                                    label: 'Sign Up',
                                    active: !_isSignIn,
                                    onTap: () => setState(() {
                                      _isSignIn = false;
                                      _errorMessage = null;
                                    }),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 24),

                            // Username field
                            TextFormField(
                              controller: _userCtrl,
                              style: AppTextStyles.bodyMedium,
                              textInputAction: TextInputAction.next,
                              autocorrect: false,
                              decoration: const InputDecoration(
                                labelText: 'Username',
                                hintText: 'e.g. aryan',
                                prefixIcon: Icon(Icons.person_outline_rounded,
                                    color: Colors.white54),
                              ),
                              validator: (v) => (v == null || v.trim().isEmpty)
                                  ? 'Enter a username'
                                  : null,
                            ),

                            const SizedBox(height: 14),

                            // Password field
                            TextFormField(
                              controller: _passCtrl,
                              style: AppTextStyles.bodyMedium,
                              obscureText: _obscure,
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (_) => _submit(),
                              decoration: InputDecoration(
                                labelText: 'Password',
                                hintText: _isSignIn
                                    ? 'Your password'
                                    : 'Min. 6 characters',
                                prefixIcon: const Icon(Icons.lock_outline_rounded,
                                    color: Colors.white54),
                                suffixIcon: GestureDetector(
                                  onTap: () =>
                                      setState(() => _obscure = !_obscure),
                                  child: Icon(
                                    _obscure
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    color: Colors.white38,
                                    size: 20,
                                  ),
                                ),
                              ),
                              validator: (v) {
                                if (v == null || v.isEmpty) {
                                  return 'Enter a password';
                                }
                                if (!_isSignIn && v.length < 6) {
                                  return 'Must be at least 6 characters';
                                }
                                return null;
                              },
                            ),

                            // Error message
                            if (_errorMessage != null) ...[
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.red.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: Colors.red.withValues(alpha: 0.3)),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.error_outline_rounded,
                                        color: Colors.redAccent, size: 16),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        _errorMessage!,
                                        style: AppTextStyles.labelMedium
                                            .copyWith(
                                                color: Colors.redAccent,
                                                fontSize: 13),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],

                            const SizedBox(height: 20),

                            // Submit button
                            Consumer<AuthProvider>(
                              builder: (context, auth, _) => GestureDetector(
                                onTap: auth.isLoading ? null : _submit,
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 150),
                                  width: double.infinity,
                                  height: 54,
                                  decoration: BoxDecoration(
                                    gradient: auth.isLoading
                                        ? null
                                        : AppColors.ctaGradient,
                                    color: auth.isLoading
                                        ? Colors.white.withValues(alpha: 0.12)
                                        : null,
                                    borderRadius: BorderRadius.circular(14),
                                    boxShadow: auth.isLoading
                                        ? null
                                        : [
                                            BoxShadow(
                                              color: AppColors.cta
                                                  .withValues(alpha: 0.4),
                                              blurRadius: 16,
                                              offset: const Offset(0, 6),
                                            ),
                                          ],
                                  ),
                                  child: Center(
                                    child: auth.isLoading
                                        ? const SizedBox(
                                            width: 22,
                                            height: 22,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2.5,
                                              color: Colors.white,
                                            ),
                                          )
                                        : Text(
                                            _isSignIn ? 'Sign In' : 'Create Account',
                                            style:
                                                AppTextStyles.titleMedium.copyWith(
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                            ),
                                          ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                        .animate()
                        .fadeIn(duration: 500.ms, delay: 100.ms)
                        .slideY(
                            begin: 0.1,
                            end: 0,
                            duration: 500.ms,
                            delay: 100.ms),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 38,
          decoration: BoxDecoration(
            gradient: active ? AppColors.ctaGradient : null,
            borderRadius: BorderRadius.circular(9),
            boxShadow: active
                ? [
                    BoxShadow(
                      color: AppColors.cta.withValues(alpha: 0.3),
                      blurRadius: 8,
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              label,
              style: AppTextStyles.labelMedium.copyWith(
                color: active ? Colors.white : Colors.white.withValues(alpha: 0.5),
                fontWeight: active ? FontWeight.w700 : FontWeight.w400,
                fontSize: 13,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
