import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/auto_size_text_widget.dart';
import '../../../../core/widgets/buttons/default_button.dart';
import '../../../../core/widgets/radio_widget.dart';
import '../pages/financing_request_page.dart';

class InstallmentCalculatorBottomSheet extends StatefulWidget {
  final double productPrice;

  const InstallmentCalculatorBottomSheet({
    super.key,
    required this.productPrice,
  });

  @override
  State<InstallmentCalculatorBottomSheet> createState() =>
      _InstallmentCalculatorBottomSheetState();
}

class _InstallmentCalculatorBottomSheetState
    extends State<InstallmentCalculatorBottomSheet> {
  int _selectedBankIndex = 0;
  int _selectedDurationMonths = 12;

  final NumberFormat _currencyFormat = NumberFormat('#,###', 'en_US');

  final List<Map<String, dynamic>> _banks = [
    {
      'name': 'بنك الكريمي للتمويل الأصغر',
      'shortName': 'الكريمي',
      'sub': 'مرابحة إسلامية 5% • بدون كفيل غارم',
      'tag': 'الأكثر اختياراً',
      'rate': 0.05,
      'icon': Icons.account_balance_rounded,
      'color': const Color(0xFF0F5A96),
    },
    {
      'name': 'بنك اليمن والكويت',
      'shortName': 'YKB',
      'sub': 'مرابحة 6% • فترة سداد مرنة حتى 24 شهر',
      'tag': 'موافقة سريعة',
      'rate': 0.06,
      'icon': Icons.corporate_fare_rounded,
      'color': const Color(0xFF1E7E34),
    },
    {
      'name': 'بنك التضامن الإسلامي',
      'shortName': 'التضامن',
      'sub': 'مرابحة 4.5% • بدون رسوم إدارية إضافية',
      'tag': 'أقل نسبة مرابحة',
      'rate': 0.045,
      'icon': Icons.account_balance_wallet_rounded,
      'color': const Color(0xFFB57C1E),
    },
  ];

  final List<Map<String, dynamic>> _durations = [
    {'months': 12, 'label': 'سنة واحدة'},
    {'months': 18, 'label': 'سنة ونصف'},
    {'months': 24, 'label': 'سنتان'},
  ];

  double get _interestAmount {
    return widget.productPrice * _banks[_selectedBankIndex]['rate'];
  }

  double get _totalAmount {
    return widget.productPrice + _interestAmount;
  }

  double get _monthlyInstallment {
    return _totalAmount / _selectedDurationMonths;
  }

  double _calculateMonthlyFor(int months) {
    final interest = widget.productPrice * _banks[_selectedBankIndex]['rate'];
    return (widget.productPrice + interest) / months;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.88,
        decoration: BoxDecoration(
          color: const Color(0xFFF9FAFC),
          borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 25,
              offset: const Offset(0, -6),
            ),
          ],
        ),
        child: Column(
          children: [
            // Top Drag Handle & Header
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey.shade200,
                    width: 1,
                  ),
                ),
              ),
              child: Column(
                children: [
                  Center(
                    child: Container(
                      width: 44.w,
                      height: 4.5.h,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                  ),
                  14.h.verticalSpace,
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10.w),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.primarySwatch[700]!,
                              AppColors.primaryColor,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12.r),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryColor.withValues(alpha: 0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.calculate_rounded,
                          color: Colors.white,
                          size: 22.sp,
                        ),
                      ),
                      12.w.horizontalSpace,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AutoSizeTextWidget(
                              text: 'حاسبة الأقساط والتمويل البنكي',
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                              colorText: const Color(0xFF1E2348),
                            ),
                            4.h.verticalSpace,
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8.w,
                                    vertical: 2.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryColor.withValues(alpha: 0.08),
                                    borderRadius: BorderRadius.circular(6.r),
                                  ),
                                  child: AutoSizeTextWidget(
                                    text: 'الخطوة 1 من 3',
                                    fontSize: 9.sp,
                                    fontWeight: FontWeight.bold,
                                    colorText: AppColors.primaryColor,
                                  ),
                                ),
                                6.w.horizontalSpace,
                                AutoSizeTextWidget(
                                  text: 'دراسة الخطة المالية المناسبة',
                                  fontSize: 10.sp,
                                  colorText: Colors.grey.shade600,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        borderRadius: BorderRadius.circular(20.r),
                        child: Container(
                          padding: EdgeInsets.all(6.w),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.close_rounded,
                            size: 18.sp,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Scrollable Content
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
                children: [
                  // Base Price Banner
                  _buildPriceBanner(),
                  20.h.verticalSpace,

                  // Bank Selection
                  _buildSectionHeader(
                    icon: Icons.account_balance_outlined,
                    title: 'اختر البنك الممول',
                    badge: 'بنوك معتمدة',
                  ),
                  12.h.verticalSpace,
                  _buildBankSelection(),
                  22.h.verticalSpace,

                  // Duration Selection
                  _buildSectionHeader(
                    icon: Icons.date_range_outlined,
                    title: 'مدة التقسيط المرغوبة',
                    badge: 'سداد شهري ميسر',
                  ),
                  12.h.verticalSpace,
                  _buildDurationSelection(),
                  22.h.verticalSpace,

                  // Financial Summary Card
                  _buildSectionHeader(
                    icon: Icons.receipt_long_outlined,
                    title: 'تفاصيل الخطة المالية',
                    badge: 'حساب فوري',
                  ),
                  12.h.verticalSpace,
                  _buildFinancialSummary(),
                  24.h.verticalSpace,

                  // CTA Button
                  DefaultButtonWidget(
                    text: 'متابعة وإدخال بيانات التمويل',
                    height: 48.h,
                    borderRadius: 14.r,
                    gradientColors: [
                      AppColors.primarySwatch[800]!,
                      AppColors.primaryColor,
                    ],
                    withIcon: true,
                    iconData: Icons.arrow_back_rounded,
                    iconColor: Colors.white,
                    iconHeight: 20.sp,
                    onPressed: () {
                      final selectedBank = _banks[_selectedBankIndex];
                      Navigator.pop(context); // Close sheet
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FinancingRequestPage(
                            productPrice: widget.productPrice,
                            bankName: selectedBank['name'] as String,
                            bankRate: selectedBank['rate'] as double,
                            durationMonths: _selectedDurationMonths,
                            monthlyInstallment: _monthlyInstallment,
                            totalAmount: _totalAmount,
                          ),
                        ),
                      );
                    },
                  ),
                  12.h.verticalSpace,

                  // Security notice
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.verified_user_outlined,
                        color: Colors.green.shade600,
                        size: 14.sp,
                      ),
                      6.w.horizontalSpace,
                      AutoSizeTextWidget(
                        text: 'حساب تقديري متوافق مع ضوابط التمويل الإسلامي',
                        fontSize: 10.sp,
                        colorText: Colors.grey.shade600,
                      ),
                    ],
                  ),
                  16.h.verticalSpace,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceBanner() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: const Color(0xFFE5E9F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  Icons.shopping_bag_outlined,
                  color: AppColors.primaryColor,
                  size: 20.sp,
                ),
              ),
              10.w.horizontalSpace,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoSizeTextWidget(
                    text: 'مبلغ السلعة المطلوب تمويلها',
                    fontSize: 10.sp,
                    colorText: Colors.grey.shade600,
                  ),
                  2.h.verticalSpace,
                  AutoSizeTextWidget(
                    text: '${_currencyFormat.format(widget.productPrice)} ريال',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    colorText: const Color(0xFF1E2348),
                  ),
                ],
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: Colors.green.shade200),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.check_circle_rounded,
                  color: Colors.green.shade700,
                  size: 13.sp,
                ),
                4.w.horizontalSpace,
                AutoSizeTextWidget(
                  text: 'مؤهل للتقسيط',
                  fontSize: 9.5.sp,
                  fontWeight: FontWeight.bold,
                  colorText: Colors.green.shade800,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
    required String badge,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, size: 18.sp, color: AppColors.primaryColor),
            8.w.horizontalSpace,
            AutoSizeTextWidget(
              text: title,
              fontSize: 13.sp,
              fontWeight: FontWeight.bold,
              colorText: const Color(0xFF1E2348),
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(6.r),
          ),
          child: AutoSizeTextWidget(
            text: badge,
            fontSize: 9.sp,
            colorText: Colors.grey.shade700,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildBankSelection() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _banks.length,
      separatorBuilder: (context, index) => 10.h.verticalSpace,
      itemBuilder: (context, index) {
        final bank = _banks[index];
        final isSelected = _selectedBankIndex == index;
        final bankColor = bank['color'] as Color;

        return InkWell(
          onTap: () {
            setState(() {
              _selectedBankIndex = index;
            });
          },
          borderRadius: BorderRadius.circular(14.r),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: isSelected ? Colors.white : const Color(0xFFFCFDFF),
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(
                color: isSelected
                    ? AppColors.primaryColor
                    : const Color(0xFFE7EBF0),
                width: isSelected ? 1.8 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: isSelected
                      ? AppColors.primaryColor.withValues(alpha: 0.1)
                      : Colors.black.withValues(alpha: 0.02),
                  blurRadius: isSelected ? 12 : 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                // Bank Icon container
                Container(
                  width: 44.w,
                  height: 44.w,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? bankColor.withValues(alpha: 0.12)
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: isSelected
                          ? bankColor.withValues(alpha: 0.3)
                          : Colors.transparent,
                    ),
                  ),
                  child: Icon(
                    bank['icon'] as IconData,
                    color: isSelected ? bankColor : Colors.grey.shade600,
                    size: 24.sp,
                  ),
                ),
                12.w.horizontalSpace,

                // Bank details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: AutoSizeTextWidget(
                              text: bank['name'],
                              fontSize: 12.sp,
                              fontWeight:
                                  isSelected ? FontWeight.bold : FontWeight.w600,
                              colorText: isSelected
                                  ? const Color(0xFF1E2348)
                                  : Colors.black87,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6.w,
                              vertical: 2.h,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primaryColor.withValues(alpha: 0.08)
                                  : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            child: AutoSizeTextWidget(
                              text: bank['tag'],
                              fontSize: 8.5.sp,
                              fontWeight: FontWeight.bold,
                              colorText: isSelected
                                  ? AppColors.primaryColor
                                  : Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                      5.h.verticalSpace,
                      AutoSizeTextWidget(
                        text: bank['sub'],
                        fontSize: 9.5.sp,
                        colorText: Colors.grey.shade600,
                      ),
                    ],
                  ),
                ),
                12.w.horizontalSpace,

                // Selection Radio
                RadioWidget(
                  selected: isSelected,
                  selectedColor: AppColors.primaryColor,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDurationSelection() {
    return Row(
      children: _durations.map((item) {
        final months = item['months'] as int;
        final label = item['label'] as String;
        final isSelected = _selectedDurationMonths == months;
        final monthly = _calculateMonthlyFor(months);

        return Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: InkWell(
              onTap: () {
                setState(() {
                  _selectedDurationMonths = months;
                });
              },
              borderRadius: BorderRadius.circular(12.r),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? LinearGradient(
                          colors: [
                            AppColors.primarySwatch[800]!,
                            AppColors.primaryColor,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        )
                      : null,
                  color: isSelected ? null : Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primaryColor
                        : const Color(0xFFE2E7EE),
                    width: isSelected ? 1.5 : 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isSelected
                          ? AppColors.primaryColor.withValues(alpha: 0.25)
                          : Colors.black.withValues(alpha: 0.02),
                      blurRadius: isSelected ? 10 : 4,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    AutoSizeTextWidget(
                      text: '$months',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w900,
                      colorText: isSelected ? Colors.white : const Color(0xFF1E2348),
                    ),
                    2.h.verticalSpace,
                    AutoSizeTextWidget(
                      text: 'شهراً',
                      fontSize: 11.sp,
                      fontWeight: FontWeight.bold,
                      colorText: isSelected ? Colors.white : Colors.black87,
                    ),
                    4.h.verticalSpace,
                    AutoSizeTextWidget(
                      text: label,
                      fontSize: 8.5.sp,
                      colorText: isSelected
                          ? Colors.white.withValues(alpha: 0.8)
                          : Colors.grey.shade500,
                    ),
                    6.h.verticalSpace,
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 4.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.white.withValues(alpha: 0.2)
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: AutoSizeTextWidget(
                        text: '${_currencyFormat.format(monthly.toInt())} /ش',
                        fontSize: 8.sp,
                        fontWeight: FontWeight.bold,
                        colorText: isSelected
                            ? Colors.white
                            : AppColors.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFinancialSummary() {
    final selectedBank = _banks[_selectedBankIndex];
    final ratePercent = ((selectedBank['rate'] as double) * 100).toStringAsFixed(1);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: const Color(0xFFE2E7F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Upper calculation details
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                _buildSummaryRow(
                  label: 'سعر المنتج الأصلي',
                  value: '${_currencyFormat.format(widget.productPrice)} ريال',
                  isBold: false,
                ),
                10.h.verticalSpace,
                _buildSummaryRow(
                  label: 'نسبة المرابحة ($ratePercent%)',
                  value: '+ ${_currencyFormat.format(_interestAmount.toInt())} ريال',
                  valueColor: const Color(0xFFCA9A2C),
                  isBold: true,
                ),
                10.h.verticalSpace,
                _buildSummaryRow(
                  label: 'الرسوم الإدارية',
                  value: '0 ريال (مجاناً)',
                  valueColor: Colors.green.shade700,
                  isBold: false,
                ),
                12.h.verticalSpace,
                Divider(color: Colors.grey.shade200, height: 1),
                12.h.verticalSpace,
                _buildSummaryRow(
                  label: 'إجمالي مبلغ التمويل المستحق',
                  value: '${_currencyFormat.format(_totalAmount.toInt())} ريال',
                  isBold: true,
                  fontSize: 12.5.sp,
                  valueColor: const Color(0xFF1E2348),
                ),
              ],
            ),
          ),

          // Lower Hero Monthly Installment Card
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF1B204E),
                  AppColors.primaryColor,
                ],
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
              ),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(17.r)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.auto_awesome_rounded,
                          color: const Color(0xFFF3C458),
                          size: 14.sp,
                        ),
                        6.w.horizontalSpace,
                        AutoSizeTextWidget(
                          text: 'القسط الشهري المستحق',
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                          colorText: Colors.white.withValues(alpha: 0.9),
                        ),
                      ],
                    ),
                    4.h.verticalSpace,
                    AutoSizeTextWidget(
                      text: 'لمدة $_selectedDurationMonths شهراً عبر ${selectedBank['shortName']}',
                      fontSize: 9.sp,
                      colorText: Colors.white.withValues(alpha: 0.65),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    AutoSizeTextWidget(
                      text: _currencyFormat.format(_monthlyInstallment.toInt()),
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w900,
                      colorText: const Color(0xFFF7D178),
                    ),
                    4.w.horizontalSpace,
                    AutoSizeTextWidget(
                      text: 'ريال/شهر',
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                      colorText: Colors.white.withValues(alpha: 0.8),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow({
    required String label,
    required String value,
    Color? valueColor,
    bool isBold = false,
    double? fontSize,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AutoSizeTextWidget(
          text: label,
          fontSize: fontSize ?? 11.sp,
          colorText: isBold ? Colors.black87 : Colors.grey.shade700,
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
        ),
        AutoSizeTextWidget(
          text: value,
          fontSize: fontSize ?? 11.5.sp,
          fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
          colorText: valueColor ?? Colors.black87,
        ),
      ],
    );
  }
}
