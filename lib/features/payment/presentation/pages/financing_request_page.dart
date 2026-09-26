import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:ysr/core/widgets/buttons/icon_button_widget.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/auto_size_text_widget.dart';
import '../../../../core/widgets/buttons/default_button.dart';
import '../../../../core/widgets/radio_widget.dart';

class FinancingRequestPage extends StatefulWidget {
  final double? productPrice;
  final String? bankName;
  final double? bankRate;
  final int? durationMonths;
  final double? monthlyInstallment;
  final double? totalAmount;

  const FinancingRequestPage({
    super.key,
    this.productPrice,
    this.bankName,
    this.bankRate,
    this.durationMonths,
    this.monthlyInstallment,
    this.totalAmount,
  });

  @override
  State<FinancingRequestPage> createState() => _FinancingRequestPageState();
}

class _FinancingRequestPageState extends State<FinancingRequestPage> {
  final _formKey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();
  final NumberFormat _currencyFormat = NumberFormat('#,###', 'en_US');

  // Multi-step progress (0: الحاسبة والخطة, 1: البيانات والمستندات, 2: المراجعة والاعتماد)
  int _currentStep = 0;

  // Step 1: Calculator & Bank Plan State
  late double _productPrice;
  int _selectedBankIndex = 0;
  int _selectedDurationMonths = 12;

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
    return _productPrice * _banks[_selectedBankIndex]['rate'];
  }

  double get _totalAmount {
    return _productPrice + _interestAmount;
  }

  double get _monthlyInstallment {
    return _totalAmount / _selectedDurationMonths;
  }

  double _calculateMonthlyFor(int months) {
    final interest = _productPrice * _banks[_selectedBankIndex]['rate'];
    return (_productPrice + interest) / months;
  }

  // Step 2: Controllers & Personal Data
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _ibanController = TextEditingController();
  final TextEditingController _salaryController = TextEditingController();

  int _selectedWorkSectorIndex = 0;
  final List<String> _workSectors = [
    'قطاع حكومي',
    'قطاع خاص',
    'أعمال حرة / تجارة',
    'متقاعد',
  ];

  // Uploaded documents state
  final Map<String, Map<String, dynamic>?> _uploadedDocs = {
    'national_id': null,
    'salary_certificate': null,
    'residence_proof': null,
  };

  // Step 3: Agreement & Submitting State
  bool _isAgreed = false;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _productPrice = widget.productPrice ?? 250000;

    // Pre-select bank if passed
    if (widget.bankName != null) {
      final idx = _banks.indexWhere((b) => b['name'] == widget.bankName);
      if (idx != -1) _selectedBankIndex = idx;
    }
    if (widget.durationMonths != null) {
      _selectedDurationMonths = widget.durationMonths!;
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _idController.dispose();
    _ibanController.dispose();
    _salaryController.dispose();
    super.dispose();
  }

  void _goToStep(int step) {
    setState(() => _currentStep = step);
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _simulateUpload(String key, String defaultName, String size) {
    setState(() {
      if (_uploadedDocs[key] == null) {
        _uploadedDocs[key] = {
          'name': defaultName,
          'size': size,
          'date': 'الآن',
        };
      } else {
        _uploadedDocs[key] = null;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _uploadedDocs[key] != null
              ? 'تم رفع $defaultName بنجاح'
              : 'تم حذف المستند',
        ),
        backgroundColor:
            _uploadedDocs[key] != null ? Colors.green.shade700 : Colors.black87,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showTermsDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.all(22.w),
        height: MediaQuery.of(context).size.height * 0.65,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 44.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
            ),
            16.h.verticalSpace,
            Row(
              children: [
                Icon(
                  Icons.gavel_rounded,
                  color: AppColors.primaryColor,
                  size: 22.sp,
                ),
                10.w.horizontalSpace,
                AutoSizeTextWidget(
                  text: 'الشروط والأحكام لاتفاقية التمويل',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  colorText: const Color(0xFF1E2348),
                ),
              ],
            ),
            16.h.verticalSpace,
            Divider(color: Colors.grey.shade200, height: 1),
            14.h.verticalSpace,
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  _buildTermItem(
                    '1. أهلية التمويل:',
                    'يشترط أن يكون العميل حاملاً لهوية سارية المفعول، ولديه مصدر دخل شهري مثبت أو نشاط تجاري قائم.',
                  ),
                  _buildTermItem(
                    '2. الاستعلام الائتماني:',
                    'بموافقتك، فإنك تفوض البنك الممول رسمياً بالاستعلام عن تاريخك الائتماني والالتزامات المالية المسجلة.',
                  ),
                  _buildTermItem(
                    '3. الالتزام بالسداد:',
                    'يتم سداد الأقساط الشهرية في المواعيد المحددة عبر استقطاع بنكي أو إيداع مباشر في حساب البنك.',
                  ),
                  _buildTermItem(
                    '4. سرية وأمان البيانات:',
                    'تلتزم المنظمة والبنك الشريك بحماية بياناتك الشخصية وعدم مشاركتها مع أي جهة خارج إطار تنفيذ التمويل.',
                  ),
                ],
              ),
            ),
            16.h.verticalSpace,
            DefaultButtonWidget(
              text: 'فهمت وموافق',
              height: 44.h,
              borderRadius: 12.r,
              background: AppColors.primaryColor,
              onPressed: () {
                setState(() => _isAgreed = true);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTermItem(String title, String desc) {
    return Padding(
      padding: EdgeInsets.only(bottom: 14.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoSizeTextWidget(
            text: title,
            fontSize: 11.5.sp,
            fontWeight: FontWeight.bold,
            colorText: const Color(0xFF1E2348),
          ),
          4.h.verticalSpace,
          AutoSizeTextWidget(
            text: desc,
            fontSize: 10.5.sp,
            colorText: Colors.grey.shade700,
            maxLines: 4,
          ),
        ],
      ),
    );
  }

  void _submitFinancingRequest() async {
    setState(() => _isSubmitting = true);

    await Future.delayed(const Duration(milliseconds: 1400));
    if (!mounted) return;

    setState(() => _isSubmitting = false);

    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72.w,
              height: 72.w,
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.green.shade200, width: 2),
              ),
              child: Icon(
                Icons.check_circle_rounded,
                color: Colors.green.shade600,
                size: 42.sp,
              ),
            ),
            18.h.verticalSpace,
            AutoSizeTextWidget(
              text: 'تم تقديم طلب التمويل بنجاح!',
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              colorText: const Color(0xFF1E2348),
            ),
            8.h.verticalSpace,
            AutoSizeTextWidget(
              text:
                  'تم استلام طلبك ومستنداتك بنجاح. سيتم مراجعتها من قبل قسم الائتمان بـ ${_banks[_selectedBankIndex]['shortName']} والتواصل معك خلال 24 ساعة.',
              fontSize: 11.sp,
              colorText: Colors.grey.shade600,
              textAlign: TextAlign.center,
              maxLines: 4,
            ),
            16.h.verticalSpace,
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: const Color(0xFFF7F8FA),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AutoSizeTextWidget(
                    text: 'رقم مرجع الطلب:',
                    fontSize: 11.sp,
                    colorText: Colors.grey.shade600,
                  ),
                  Row(
                    children: [
                      AutoSizeTextWidget(
                        text: '#FIN-78942',
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        colorText: AppColors.primaryColor,
                      ),
                      8.w.horizontalSpace,
                      Icon(
                        Icons.copy_rounded,
                        size: 14.sp,
                        color: Colors.grey.shade500,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            24.h.verticalSpace,
            DefaultButtonWidget(
              text: 'العودة للرئيسية',
              height: 48.h,
              borderRadius: 14.r,
              gradientColors: [
                AppColors.primarySwatch[800]!,
                AppColors.primaryColor,
              ],
              onPressed: () {
                Navigator.pop(context); // Close bottomsheet
                Navigator.popUntil(context, (route) => route.isFirst);
              },
            ),
            10.h.verticalSpace,
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _currentStep == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && _currentStep > 0) {
          _goToStep(_currentStep - 1);
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF9FAFC),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,

          leading:    IconButtonWidget(
            onPressed: () {
              if (_currentStep > 0) {
                _goToStep(_currentStep - 1);
              } else {
                Navigator.pop(context);
              }
            },
          ),
          title: AutoSizeTextWidget(
            text: 'طلب التقسيط والتمويل البنكي',
            fontSize: 15.sp,
            fontWeight: FontWeight.bold,
            colorText: const Color(0xFF1E2348),
          ),
          actions: [

            IconButton(
              icon: Icon(
                Icons.help_outline_rounded,
                size: 20.sp,
                color: Colors.grey.shade600,
              ),
              onPressed: () {},
            ),
          ],
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Visual Stepper
                _buildModernStepper(),
                18.h.verticalSpace,

                // Content of current step
                if (_currentStep == 0) ...[
                  _buildStep1CalculatorContent(),
                ] else if (_currentStep == 1) ...[
                  _buildStep2DataAndDocsContent(),
                ] else ...[
                  _buildStep3ReviewAndConfirmContent(),
                ],

                20.h.verticalSpace,
                // Trust badges footer
                _buildTrustFooter(),
                16.h.verticalSpace,
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================
  // STEPPER HEADER
  // ==========================================
  Widget _buildModernStepper() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFE5E9F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildStepItem(
            stepIndex: 0,
            label: 'الحاسبة والخطة',
            isCompleted: _currentStep > 0,
            isActive: _currentStep == 0,
          ),
          Expanded(
            child: Container(
              height: 2.5.h,
              color: _currentStep > 0
                  ? AppColors.primaryColor
                  : Colors.grey.shade300,
            ),
          ),
          _buildStepItem(
            stepIndex: 1,
            label: 'المستندات',
            isCompleted: _currentStep > 1,
            isActive: _currentStep == 1,
          ),
          Expanded(
            child: Container(
              height: 2.5.h,
              color: _currentStep > 1
                  ? AppColors.primaryColor
                  : Colors.grey.shade300,
            ),
          ),
          _buildStepItem(
            stepIndex: 2,
            label: 'المراجعة والاعتماد',
            isCompleted: false,
            isActive: _currentStep == 2,
          ),
        ],
      ),
    );
  }

  Widget _buildStepItem({
    required int stepIndex,
    required String label,
    required bool isCompleted,
    required bool isActive,
  }) {
    Color circleColor;
    Widget innerContent;

    if (isCompleted) {
      circleColor = Colors.green.shade600;
      innerContent = Icon(Icons.check_rounded, color: Colors.white, size: 14.sp);
    } else if (isActive) {
      circleColor = AppColors.primaryColor;
      innerContent = AutoSizeTextWidget(
        text: '${stepIndex + 1}',
        fontSize: 11.sp,
        fontWeight: FontWeight.bold,
        colorText: Colors.white,
      );
    } else {
      circleColor = Colors.grey.shade300;
      innerContent = AutoSizeTextWidget(
        text: '${stepIndex + 1}',
        fontSize: 11.sp,
        fontWeight: FontWeight.bold,
        colorText: Colors.grey.shade600,
      );
    }

    return InkWell(
      onTap: () {
        // Allow going back to previous steps
        if (stepIndex < _currentStep) {
          _goToStep(stepIndex);
        }
      },
      borderRadius: BorderRadius.circular(12.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        child: Column(
          children: [
            Container(
              width: 26.w,
              height: 26.w,
              decoration: BoxDecoration(
                color: circleColor,
                shape: BoxShape.circle,
                boxShadow: isActive
                    ? [
                        BoxShadow(
                          color: AppColors.primaryColor.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : [],
              ),
              child: Center(child: innerContent),
            ),
            4.h.verticalSpace,
            AutoSizeTextWidget(
              text: label,
              fontSize: 9.sp,
              fontWeight: isActive || isCompleted ? FontWeight.bold : FontWeight.w500,
              colorText: isActive
                  ? AppColors.primaryColor
                  : (isCompleted ? Colors.green.shade700 : Colors.grey.shade500),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // STEP 1: CALCULATOR & PLAN CONTENT (ON-PAGE)
  // ==========================================
  Widget _buildStep1CalculatorContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Base Price Banner
        _buildPriceBanner(),
        18.h.verticalSpace,

        // Bank Selection Section
        _buildSectionHeader(
          icon: Icons.account_balance_outlined,
          title: 'اختر البنك الممول',
          badge: 'بنوك معتمدة',
        ),
        12.h.verticalSpace,
        _buildBankSelection(),
        22.h.verticalSpace,

        // Duration Selection Section
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
        26.h.verticalSpace,

        // Action Button: Advance to Step 2
        DefaultButtonWidget(
          text: 'المتابعة لإدخال البيانات والمستندات',
          height: 48.h,
          borderRadius: 14.r,
          gradientColors: [
            AppColors.primarySwatch[800]!,
            AppColors.primaryColor,
          ],
          withIcon: true,
          iconData: Icons.arrow_forward_rounded,
          iconColor: Colors.white,
          iconHeight: 20.sp,
          onPressed: () => _goToStep(1),
        ),
        12.h.verticalSpace,
        Center(
          child: Row(
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
        ),
      ],
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
                    text: '${_currencyFormat.format(_productPrice)} ريال',
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
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                _buildSummaryRow(
                  label: 'سعر المنتج الأصلي',
                  value: '${_currencyFormat.format(_productPrice)} ريال',
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

  // ==========================================
  // STEP 2: DATA & DOCUMENTS CONTENT
  // ==========================================
  Widget _buildStep2DataAndDocsContent() {
    final selectedBank = _banks[_selectedBankIndex];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Selected Plan Snapshot Card
        _buildPlanSummaryCard(
          bankName: selectedBank['name'] as String,
          durationMonths: _selectedDurationMonths,
          monthly: _monthlyInstallment,
          total: _totalAmount,
        ),
        16.h.verticalSpace,

        // Security Trust Banner
        _buildSecurityBanner(),
        20.h.verticalSpace,

        // Personal & Financial Data Section
        _buildSectionHeader(
          icon: Icons.person_pin_outlined,
          title: 'البيانات الشخصية والمالية',
        ),
        12.h.verticalSpace,
        _buildPersonalDataCard(),
        22.h.verticalSpace,

        // Documents Upload Section
        _buildSectionHeader(
          icon: Icons.cloud_upload_outlined,
          title: 'المستندات والوثائق المطلوبة',
          badge: 'مطلوب إرفاقها',
        ),
        6.h.verticalSpace,
        AutoSizeTextWidget(
          text: 'يرجى إرفاق صور واضحة أو مستندات بصيغة PDF (الحد الأقصى 5MB لكل ملف).',
          fontSize: 10.sp,
          colorText: Colors.grey.shade600,
        ),
        14.h.verticalSpace,

        _buildDocumentCard(
          key: 'national_id',
          title: 'صورة الهوية الوطنية / الإقامة',
          subtitle: 'صورة واضحة للوجهين وسارية المفعول',
          defaultFileName: 'national_id_card.pdf',
          defaultFileSize: '1.2 MB',
          isRequired: true,
        ),
        12.h.verticalSpace,
        _buildDocumentCard(
          key: 'salary_certificate',
          title: 'كشف حساب بنكي / تعريف بالراتب',
          subtitle: 'لآخر 3 أشهر مصدق من جهة العمل أو البنك',
          defaultFileName: 'salary_statement_3m.pdf',
          defaultFileSize: '2.4 MB',
          isRequired: true,
        ),
        12.h.verticalSpace,
        _buildDocumentCard(
          key: 'residence_proof',
          title: 'إثبات سكن أو فاتورة خدمات (اختياري)',
          subtitle: 'عقد إيجار، فاتورة كهرباء أو ماء حديثة',
          defaultFileName: 'utility_bill.jpg',
          defaultFileSize: '850 KB',
          isRequired: false,
        ),
        26.h.verticalSpace,

        // Navigation Buttons for Step 2
        DefaultButtonWidget(
          text: 'المتابعة للمراجعة والاعتماد',
          height: 48.h,
          borderRadius: 14.r,
          gradientColors: [
            AppColors.primarySwatch[800]!,
            AppColors.primaryColor,
          ],
          withIcon: true,
          iconData: Icons.arrow_forward_rounded,
          iconColor: Colors.white,
          iconHeight: 20.sp,
          onPressed: () => _goToStep(2),
        ),
        12.h.verticalSpace,
        DefaultButtonWidget(
          text: 'الرجوع للحاسبة وتعديل الخطة',
          height: 44.h,
          borderRadius: 14.r,
          background: Colors.white,
          textColor: const Color(0xFF1E2348),
          border: Border.all(color: const Color(0xFFD2D8E2)),
          onPressed: () => _goToStep(0),
        ),
      ],
    );
  }

  // ==========================================
  // STEP 3: REVIEW & CONFIRMATION CONTENT
  // ==========================================
  Widget _buildStep3ReviewAndConfirmContent() {
    final selectedBank = _banks[_selectedBankIndex];
    final hasIdUploaded = _uploadedDocs['national_id'] != null;
    final hasSalaryUploaded = _uploadedDocs['salary_certificate'] != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          icon: Icons.assignment_turned_in_outlined,
          title: 'مراجعة بيانات الطلب قبل الإرسال',
          badge: 'الخطوة الأخيرة',
        ),
        12.h.verticalSpace,

        // Review summary container
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: const Color(0xFFE2E7EE)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Financing Details Box
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AutoSizeTextWidget(
                    text: 'خطة التمويل المختارة',
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    colorText: const Color(0xFF1E2348),
                  ),
                  InkWell(
                    onTap: () => _goToStep(0),
                    child: AutoSizeTextWidget(
                      text: 'تعديل الخطة',
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                      colorText: AppColors.primaryColor,
                    ),
                  ),
                ],
              ),
              10.h.verticalSpace,
              _buildReviewRow('البنك الممول', selectedBank['name'] as String),
              8.h.verticalSpace,
              _buildReviewRow('مدة التقسيط', '$_selectedDurationMonths شهراً'),
              8.h.verticalSpace,
              _buildReviewRow(
                'القسط الشهري',
                '${_currencyFormat.format(_monthlyInstallment.toInt())} ريال/ش',
                highlight: true,
              ),
              8.h.verticalSpace,
              _buildReviewRow(
                'الإجمالي المستحق',
                '${_currencyFormat.format(_totalAmount.toInt())} ريال',
              ),

              14.h.verticalSpace,
              Divider(color: Colors.grey.shade200, height: 1),
              14.h.verticalSpace,

              // Personal Info Box
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AutoSizeTextWidget(
                    text: 'البيانات الشخصية والوظيفية',
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    colorText: const Color(0xFF1E2348),
                  ),
                  InkWell(
                    onTap: () => _goToStep(1),
                    child: AutoSizeTextWidget(
                      text: 'تعديل البيانات',
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                      colorText: AppColors.primaryColor,
                    ),
                  ),
                ],
              ),
              10.h.verticalSpace,
              _buildReviewRow(
                'رقم الهوية',
                _idController.text.isNotEmpty
                    ? _idController.text
                    : '10982347102 (افتراضي)',
              ),
              8.h.verticalSpace,
              _buildReviewRow(
                'الآيبان البنكي',
                _ibanController.text.isNotEmpty
                    ? _ibanController.text
                    : 'YE00 2300 0001 ...',
              ),
              8.h.verticalSpace,
              _buildReviewRow(
                'صافي الراتب',
                _salaryController.text.isNotEmpty
                    ? '${_salaryController.text} ريال'
                    : '150,000 ريال',
              ),
              8.h.verticalSpace,
              _buildReviewRow('جهة العمل', _workSectors[_selectedWorkSectorIndex]),

              14.h.verticalSpace,
              Divider(color: Colors.grey.shade200, height: 1),
              14.h.verticalSpace,

              // Documents Status
              AutoSizeTextWidget(
                text: 'المستندات المرفقة',
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
                colorText: const Color(0xFF1E2348),
              ),
              10.h.verticalSpace,
              _buildDocStatusRow(
                'الهوية الوطنية',
                hasIdUploaded,
              ),
              8.h.verticalSpace,
              _buildDocStatusRow(
                'كشف الراتب / الحساب',
                hasSalaryUploaded,
              ),
            ],
          ),
        ),
        20.h.verticalSpace,

        // Terms & Agreement Box
        _buildAgreementSection(),
        24.h.verticalSpace,

        // Submit Button
        DefaultButtonWidget(
          text: 'إرسال طلب التمويل للبنك',
          height: 48.h,
          borderRadius: 14.r,
          isLoading: _isSubmitting,
          gradientColors: _isAgreed
              ? [
                  AppColors.primarySwatch[800]!,
                  AppColors.primaryColor,
                ]
              : null,
          background: _isAgreed ? null : Colors.grey.shade400,
          withIcon: _isAgreed,
          iconData: Icons.send_rounded,
          iconColor: Colors.white,
          iconHeight: 18.sp,
          onPressed: _isAgreed ? _submitFinancingRequest : null,
        ),
        12.h.verticalSpace,
        DefaultButtonWidget(
          text: 'الرجوع لتعديل المستندات والبيانات',
          height: 44.h,
          borderRadius: 14.r,
          background: Colors.white,
          textColor: const Color(0xFF1E2348),
          border: Border.all(color: const Color(0xFFD2D8E2)),
          onPressed: () => _goToStep(1),
        ),
      ],
    );
  }

  Widget _buildReviewRow(String label, String value, {bool highlight = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AutoSizeTextWidget(
          text: label,
          fontSize: 10.5.sp,
          colorText: Colors.grey.shade600,
        ),
        AutoSizeTextWidget(
          text: value,
          fontSize: 11.sp,
          fontWeight: highlight ? FontWeight.bold : FontWeight.w600,
          colorText: highlight ? AppColors.primaryColor : const Color(0xFF1E2348),
        ),
      ],
    );
  }

  Widget _buildDocStatusRow(String label, bool isUploaded) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AutoSizeTextWidget(
          text: label,
          fontSize: 10.5.sp,
          colorText: Colors.grey.shade600,
        ),
        Row(
          children: [
            Icon(
              isUploaded ? Icons.check_circle_rounded : Icons.info_outline_rounded,
              size: 14.sp,
              color: isUploaded ? Colors.green.shade600 : Colors.amber.shade700,
            ),
            4.w.horizontalSpace,
            AutoSizeTextWidget(
              text: isUploaded ? 'مرفق ومؤكد' : 'سيتم رفعه لاحقاً',
              fontSize: 10.sp,
              fontWeight: FontWeight.bold,
              colorText: isUploaded ? Colors.green.shade800 : Colors.amber.shade800,
            ),
          ],
        ),
      ],
    );
  }

  // ==========================================
  // REUSABLE COMPONENTS
  // ==========================================
  Widget _buildPlanSummaryCard({
    required String bankName,
    required int durationMonths,
    required double monthly,
    required double total,
  }) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryColor.withValues(alpha: 0.04),
            AppColors.primaryColor.withValues(alpha: 0.08),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColors.primaryColor.withValues(alpha: 0.18),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(6.w),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(
                      Icons.account_balance_rounded,
                      color: AppColors.primaryColor,
                      size: 16.sp,
                    ),
                  ),
                  8.w.horizontalSpace,
                  AutoSizeTextWidget(
                    text: bankName,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    colorText: const Color(0xFF1E2348),
                  ),
                ],
              ),
              InkWell(
                onTap: () => _goToStep(0),
                borderRadius: BorderRadius.circular(6.r),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  child: Row(
                    children: [
                      Icon(
                        Icons.edit_outlined,
                        size: 12.sp,
                        color: AppColors.primaryColor,
                      ),
                      4.w.horizontalSpace,
                      AutoSizeTextWidget(
                        text: 'تعديل الخطة',
                        fontSize: 9.5.sp,
                        fontWeight: FontWeight.bold,
                        colorText: AppColors.primaryColor,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          10.h.verticalSpace,
          Divider(color: AppColors.primaryColor.withValues(alpha: 0.12), height: 1),
          10.h.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildPlanPill(
                title: 'مدة السداد',
                value: '$durationMonths شهراً',
              ),
              _buildPlanPill(
                title: 'القسط الشهري',
                value: '${_currencyFormat.format(monthly.toInt())} ريال/ش',
                isHighlighted: true,
              ),
              _buildPlanPill(
                title: 'إجمالي التمويل',
                value: '${_currencyFormat.format(total.toInt())} ريال',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlanPill({
    required String title,
    required String value,
    bool isHighlighted = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AutoSizeTextWidget(
          text: title,
          fontSize: 8.5.sp,
          colorText: Colors.grey.shade600,
        ),
        3.h.verticalSpace,
        AutoSizeTextWidget(
          text: value,
          fontSize: 11.sp,
          fontWeight: FontWeight.bold,
          colorText: isHighlighted ? AppColors.primaryColor : const Color(0xFF1E2348),
        ),
      ],
    );
  }

  Widget _buildSecurityBanner() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: const Color(0xFFEDF8F1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFBCE7CC)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.shield_outlined,
            color: Colors.green.shade700,
            size: 20.sp,
          ),
          10.w.horizontalSpace,
          Expanded(
            child: AutoSizeTextWidget(
              text:
                  'بياناتك ومستنداتك مشفرة بالكامل 256-bit وفق اشتراطات البنك المركزي لحماية الخصوصية.',
              fontSize: 9.5.sp,
              colorText: Colors.green.shade900,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
    String? badge,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(6.w),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(icon, size: 16.sp, color: AppColors.primaryColor),
            ),
            8.w.horizontalSpace,
            AutoSizeTextWidget(
              text: title,
              fontSize: 13.sp,
              fontWeight: FontWeight.bold,
              colorText: const Color(0xFF1E2348),
            ),
          ],
        ),
        if (badge != null)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(6.r),
              border: Border.all(color: Colors.red.shade100),
            ),
            child: AutoSizeTextWidget(
              text: badge,
              fontSize: 8.5.sp,
              fontWeight: FontWeight.bold,
              colorText: Colors.red.shade700,
            ),
          ),
      ],
    );
  }

  Widget _buildPersonalDataCard() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFE5E9F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInputField(
            controller: _idController,
            label: 'رقم الهوية الوطنية / الإقامة',
            hint: 'أدخل رقم الهوية (11 رقماً)',
            icon: Icons.badge_outlined,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
          16.h.verticalSpace,
          _buildInputField(
            controller: _ibanController,
            label: 'رقم الحساب البنكي الدولي (IBAN)',
            hint: 'YE00 0000 0000 0000 0000 00',
            icon: Icons.account_balance_outlined,
            keyboardType: TextInputType.text,
          ),
          16.h.verticalSpace,
          _buildInputField(
            controller: _salaryController,
            label: 'صافي الراتب الشهري (ريال)',
            hint: 'مثال: 150000',
            icon: Icons.payments_outlined,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
          18.h.verticalSpace,
          AutoSizeTextWidget(
            text: 'جهة العمل / النشاط',
            fontSize: 11.5.sp,
            fontWeight: FontWeight.w600,
            colorText: const Color(0xFF1E2348),
          ),
          8.h.verticalSpace,
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: List.generate(_workSectors.length, (index) {
              final isSelected = _selectedWorkSectorIndex == index;
              return InkWell(
                onTap: () {
                  setState(() {
                    _selectedWorkSectorIndex = index;
                  });
                },
                borderRadius: BorderRadius.circular(8.r),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 7.h,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primaryColor
                        : Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primaryColor
                          : Colors.grey.shade300,
                    ),
                  ),
                  child: AutoSizeTextWidget(
                    text: _workSectors[index],
                    fontSize: 10.sp,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    colorText: isSelected ? Colors.white : Colors.grey.shade800,
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required TextInputType keyboardType,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            AutoSizeTextWidget(
              text: label,
              fontSize: 11.5.sp,
              fontWeight: FontWeight.w600,
              colorText: const Color(0xFF1E2348),
            ),
            4.w.horizontalSpace,
            Text(
              '*',
              style: TextStyle(
                color: Colors.red.shade600,
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        8.h.verticalSpace,
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          style: TextStyle(fontSize: 12.sp, color: Colors.black87),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(fontSize: 11.sp, color: Colors.grey.shade400),
            prefixIcon: Icon(icon, color: AppColors.primaryColor, size: 19.sp),
            filled: true,
            fillColor: const Color(0xFFF9FAFC),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: Color(0xFFE2E7EE)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: Color(0xFFE2E7EE)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(
                color: AppColors.primaryColor,
                width: 1.5,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 14.w,
              vertical: 12.h,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDocumentCard({
    required String key,
    required String title,
    required String subtitle,
    required String defaultFileName,
    required String defaultFileSize,
    required bool isRequired,
  }) {
    final file = _uploadedDocs[key];
    final isUploaded = file != null;

    return InkWell(
      onTap: () => _simulateUpload(key, defaultFileName, defaultFileSize),
      borderRadius: BorderRadius.circular(14.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: isUploaded ? const Color(0xFFF5FAF6) : Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: isUploaded ? Colors.green.shade300 : const Color(0xFFE2E7EE),
            width: isUploaded ? 1.4 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44.w,
              height: 44.w,
              decoration: BoxDecoration(
                color: isUploaded
                    ? Colors.green.shade100
                    : AppColors.primaryColor.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                isUploaded
                    ? Icons.check_circle_rounded
                    : Icons.cloud_upload_outlined,
                color: isUploaded ? Colors.green.shade700 : AppColors.primaryColor,
                size: 24.sp,
              ),
            ),
            12.w.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: AutoSizeTextWidget(
                          text: title,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                          colorText: const Color(0xFF1E2348),
                        ),
                      ),
                      if (isRequired)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6.w,
                            vertical: 1.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: AutoSizeTextWidget(
                            text: 'إلزامي',
                            fontSize: 8.sp,
                            colorText: Colors.grey.shade600,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                    ],
                  ),
                  4.h.verticalSpace,
                  if (!isUploaded)
                    AutoSizeTextWidget(
                      text: subtitle,
                      fontSize: 9.5.sp,
                      colorText: Colors.grey.shade500,
                    )
                  else
                    Row(
                      children: [
                        Icon(
                          Icons.insert_drive_file_outlined,
                          size: 11.sp,
                          color: Colors.green.shade700,
                        ),
                        4.w.horizontalSpace,
                        AutoSizeTextWidget(
                          text: '${file['name']} (${file['size']})',
                          fontSize: 9.5.sp,
                          fontWeight: FontWeight.bold,
                          colorText: Colors.green.shade800,
                        ),
                      ],
                    ),
                ],
              ),
            ),
            10.w.horizontalSpace,
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: isUploaded
                    ? Colors.red.shade50
                    : AppColors.primaryColor.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                  color: isUploaded
                      ? Colors.red.shade200
                      : AppColors.primaryColor.withValues(alpha: 0.2),
                ),
              ),
              child: AutoSizeTextWidget(
                text: isUploaded ? 'إزالة' : 'إرفاق',
                fontSize: 10.sp,
                fontWeight: FontWeight.bold,
                colorText:
                    isUploaded ? Colors.red.shade700 : AppColors.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAgreementSection() {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: _isAgreed
              ? AppColors.primaryColor.withValues(alpha: 0.3)
              : const Color(0xFFE2E7EE),
        ),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 22.w,
                height: 22.w,
                child: Checkbox(
                  value: _isAgreed,
                  onChanged: (val) {
                    setState(() {
                      _isAgreed = val ?? false;
                    });
                  },
                  activeColor: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.r),
                  ),
                ),
              ),
              10.w.horizontalSpace,
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() => _isAgreed = !_isAgreed);
                  },
                  child: AutoSizeTextWidget(
                    text:
                        'أقر بصحة البيانات المدخلة والمستندات المرفقة، وأوافق على تفويض البنك الممول بإجراء الفحص والاستعلام الائتماني وفق أحكام التمويل وضوابط البنك المركزي.',
                    fontSize: 10.sp,
                    colorText: const Color(0xFF1E2348),
                    maxLines: 4,
                  ),
                ),
              ),
            ],
          ),
          8.h.verticalSpace,
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: _showTermsDialog,
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              icon: Icon(
                Icons.open_in_new_rounded,
                size: 13.sp,
                color: AppColors.primaryColor,
              ),
              label: AutoSizeTextWidget(
                text: 'قراءة الشروط والأحكام الكاملة',
                fontSize: 10.sp,
                fontWeight: FontWeight.bold,
                colorText: AppColors.primaryColor,
              ),
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

  Widget _buildTrustFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildTrustItem(
          icon: Icons.verified_rounded,
          text: 'معتمد رسمياً',
        ),
        _buildTrustItem(
          icon: Icons.bolt_rounded,
          text: 'دراسة سريعة',
        ),
        _buildTrustItem(
          icon: Icons.lock_outline_rounded,
          text: 'تشفير آمن 256-bit',
        ),
      ],
    );
  }

  Widget _buildTrustItem({required IconData icon, required String text}) {
    return Row(
      children: [
        Icon(icon, size: 14.sp, color: Colors.grey.shade600),
        4.w.horizontalSpace,
        AutoSizeTextWidget(
          text: text,
          fontSize: 9.sp,
          colorText: Colors.grey.shade600,
        ),
      ],
    );
  }
}
