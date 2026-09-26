import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/auto_size_text_widget.dart';
import '../../../../core/widgets/radio_widget.dart';
import '../../data/model/payment_methods_model.dart';
import '../pages/financing_request_page.dart';
import '../riverpod/payment_riverpod.dart';
import 'pay_method_card_widget.dart';

class ListOfPaymentMethodWidget extends ConsumerStatefulWidget {
  final List<PaymentMethodsModel> paymentData;
  final ValueChanged<PaymentMethodsModel>? onMethodSelected;

  const ListOfPaymentMethodWidget({
    super.key,
    required this.paymentData,
    this.onMethodSelected,
  });

  @override
  ConsumerState<ListOfPaymentMethodWidget> createState() =>
      _ListOfPaymentMethodWidgetState();
}

class _ListOfPaymentMethodWidgetState
    extends ConsumerState<ListOfPaymentMethodWidget> {
  bool _isWalletExpanded = false;

  final _bankInstallmentMethod = PaymentMethodsModel(
    id: -1,
    name: 'bank_installment',
    title: 'التقسيط البنكي',
    type: 2,
    isConnected: true,
    manualPointNumber: '',
    note: '',
    image: '',
  );

  @override
  Widget build(BuildContext context) {
    final selectedPayMethod = ref.watch(selectedPayMethodProvider);

    final codMethod = widget.paymentData.firstWhere(
      (m) => m.name == 'cash_on_delivery',
      orElse: () => PaymentMethodsModel.empty(),
    );

    final walletMethods = widget.paymentData
        .where((m) => m.name != 'cash_on_delivery')
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (codMethod.id != 0) ...[
          _buildMainCategoryCard(
            title: 'الدفع عند الاستلام',
            subtitle: 'ادفع نقداً عند وصول الطلب إلى منزلك',
            trailingText: 'الرسوم: حسب الطلب/فوري',
            icon: '💵',
            isSelected: selectedPayMethod?.id == codMethod.id,
            onTap: () {
              setState(() => _isWalletExpanded = false);
              _selectMethod(codMethod);
            },
          ),
          12.h.verticalSpace,
        ],

        if (walletMethods.isNotEmpty) ...[
          _buildMainCategoryCard(
            title: 'المحفظة الإلكترونية',
            subtitle: 'الكريمي حاسب، جوالي، محفظة جيب',
            trailingText: 'الرسوم: مجاناً/معالجة فورية',
            icon: '💳',
            isSelected: walletMethods.any((m) => m.id == selectedPayMethod?.id),
            onTap: () {
              setState(() => _isWalletExpanded = true);
              if (selectedPayMethod == null ||
                  !walletMethods.any((m) => m.id == selectedPayMethod.id)) {
                _selectMethod(walletMethods.first);
              }
            },
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox(width: double.infinity),
            secondChild: Padding(
              padding: EdgeInsets.only(top: 8.h, right: 12.w, left: 12.w),
              child: Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: walletMethods.length,
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    final method = walletMethods[index];
                    return PayMethodCardWidget(
                      name: method.title,
                      value: method.id.toString(),
                      paymentMethodGroupValue:
                          selectedPayMethod?.id.toString() ?? '',
                      image: method.image ?? '',
                      onPressed: () => _selectMethod(method),
                    );
                  },
                  separatorBuilder: (context, index) => 10.h.verticalSpace,
                ),
              ),
            ),
            crossFadeState: _isWalletExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
          ),
          12.h.verticalSpace,
        ],

        _buildMainCategoryCard(
          title: 'التقسيط والتمويل البنكي',
          subtitle: 'خطط دفع ميسرة عبر البنوك المحلية',
          trailingText: 'الرسوم: حسب البنك/ميسر',
          icon: '🏛️',
          isSelected: selectedPayMethod?.id == _bankInstallmentMethod.id,
          onTap: () {
            setState(() => _isWalletExpanded = false);
            _selectMethod(_bankInstallmentMethod);
            _openFinancingRequestPage(context);
          },
        ),
      ],
    );
  }

  void _selectMethod(PaymentMethodsModel method) {
    ref.read(selectedPayMethodProvider.notifier).state = method;
    ref.read(selectedPayMethodErrorProvider.notifier).state = null;
    widget.onMethodSelected?.call(method);
  }

  Widget _buildMainCategoryCard({
    required String title,
    required String subtitle,
    required String trailingText,
    required String icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryColor.withValues(alpha: 0.04) : Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? AppColors.primaryColor : Colors.grey.shade300,
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primaryColor.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  )
                ]
              : [],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(icon, style: TextStyle(fontSize: 22.sp)),
            12.w.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: AutoSizeTextWidget(
                          text: title,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                          colorText: isSelected ? AppColors.primaryColor : Colors.black87,
                        ),
                      ),
                      2.horizontalSpace,
                      AutoSizeTextWidget(
                        text: trailingText,
                        fontSize: 9.sp,
                        colorText: isSelected ? AppColors.primaryColor : Colors.grey.shade600,
                      ),
                    ],
                  ),
                  4.h.verticalSpace,
                  AutoSizeTextWidget(
                    text: subtitle,
                    fontSize: 10.sp,
                    colorText: Colors.grey.shade500,
                  ),
                ],
              ),
            ),
            12.w.horizontalSpace,
            RadioWidget(selected: isSelected),
          ],
        ),
      ),
    );
  }

  void _openFinancingRequestPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const FinancingRequestPage(
          productPrice: 250000, // Placeholder for actual total amount
        ),
      ),
    );
  }
}
