import 'package:flutter/material.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/services/api_service.dart';
import '../../../shared/widgets/frosted_card.dart';
import '../../../shared/widgets/gradient_button.dart';

class SearchInputForm extends StatefulWidget {
  final SearchParams? initialParams;
  final bool isLoading;
  final void Function(SearchParams params) onSearch;

  const SearchInputForm({
    super.key,
    this.initialParams,
    required this.isLoading,
    required this.onSearch,
  });

  @override
  State<SearchInputForm> createState() => _SearchInputFormState();
}

class _SearchInputFormState extends State<SearchInputForm> {
  late final TextEditingController _skillsCtrl;
  late final TextEditingController _expCtrl;
  late final TextEditingController _salaryCtrl;
  String? _selectedWorkType;
  final _formKey = GlobalKey<FormState>();

  static const _workTypes = ['Full-Time', 'Part-Time', 'Contract'];

  @override
  void initState() {
    super.initState();
    final p = widget.initialParams;
    _skillsCtrl = TextEditingController(text: p?.skills ?? '');
    _expCtrl = TextEditingController(text: p?.experience ?? '');
    _salaryCtrl = TextEditingController(text: p?.expectedSalary ?? '');
    _selectedWorkType = p?.workType;
  }

  @override
  void dispose() {
    _skillsCtrl.dispose();
    _expCtrl.dispose();
    _salaryCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    widget.onSearch(SearchParams(
      skills: _skillsCtrl.text.trim(),
      experience: _expCtrl.text.trim(),
      workType: _selectedWorkType,
      expectedSalary: _salaryCtrl.text.trim().isEmpty ? null : _salaryCtrl.text.trim(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return FrostedCard(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Find Your Match', style: AppTextStyles.headlineMedium),
            const SizedBox(height: 4),
            Text(
              'Enter your skills and experience to get personalized job recommendations',
              style: AppTextStyles.bodyMedium.copyWith(
                color: Colors.white.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _skillsCtrl,
              style: AppTextStyles.bodyMedium,
              decoration: const InputDecoration(
                labelText: 'Skills',
                hintText: 'e.g. python, machine learning, sql',
                prefixIcon: Icon(Icons.code_rounded, color: Colors.white54),
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Please enter your skills' : null,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _expCtrl,
              style: AppTextStyles.bodyMedium,
              decoration: const InputDecoration(
                labelText: 'Experience',
                hintText: 'e.g. 3 years, 2 years',
                prefixIcon: Icon(Icons.work_history_rounded, color: Colors.white54),
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Please enter your experience' : null,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 14),
            // Optional: work type chips
            Text('Work Type (optional)', style: AppTextStyles.labelMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: _workTypes.map((type) {
                final selected = _selectedWorkType == type;
                return GestureDetector(
                  onTap: () => setState(() =>
                      _selectedWorkType = selected ? null : type),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                    decoration: BoxDecoration(
                      gradient: selected
                          ? const LinearGradient(
                              colors: [Color(0xFFF97316), Color(0xFFEF4444)],
                            )
                          : null,
                      color: selected ? null : AppColors.cardFill,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: selected
                            ? Colors.transparent
                            : AppColors.cardBorder,
                      ),
                      boxShadow: selected
                          ? [
                              BoxShadow(
                                color: AppColors.cta.withValues(alpha: 0.3),
                                blurRadius: 8,
                              ),
                            ]
                          : null,
                    ),
                    child: Text(
                      type,
                      style: AppTextStyles.labelMedium.copyWith(
                        color: selected
                            ? Colors.white
                            : Colors.white.withValues(alpha: 0.55),
                        fontWeight:
                            selected ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _salaryCtrl,
              style: AppTextStyles.bodyMedium,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Expected Salary (optional)',
                hintText: 'e.g. 90000',
                prefixIcon: Icon(Icons.attach_money_rounded, color: Colors.white54),
              ),
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _submit(),
            ),
            const SizedBox(height: 20),
            GradientButton(
              label: 'Find Jobs',
              isLoading: widget.isLoading,
              onPressed: widget.isLoading ? null : _submit,
            ),
          ],
        ),
      ),
    );
  }
}
