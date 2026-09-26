import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../../../../../core/helpers/flash_bar_helper.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/widgets/bottomNavbar/button_bottom_navigation_bar_design_widget.dart';
import '../../../../../../core/widgets/secondary_app_bar_widget.dart';
import '../../../../../../core/widgets/auto_size_text_widget.dart';
import '../../../../../../core/widgets/online_images_widget.dart';
import '../../../../../../generated/l10n.dart';
import '../../../../../../services/auth/auth.dart';
import '../../../../../payment/data/model/payment_request_context_model.dart';
import '../../../../../payment/presentation/riverpod/payment_riverpod.dart';
import '../../../../../payment/presentation/widget/payment_action_button_widget.dart';
import '../../../../../payment/presentation/widget/payment_methods_section_widget.dart';
import '../../../../home/data/model/vendor_model.dart';
import '../../../cart/data/model/cart_model.dart';
import '../../data/model/confirm_order_model.dart';
import '../riverpod/confirm_order_riverpod.dart';
import '../widgets/address_to_confirm_the_order_widget.dart';
import '../widgets/bill_widget.dart';
import '../widgets/checkout_progress_stepper_widget.dart';
import '../widgets/order_confirmation_product_card_widget.dart';
import '../widgets/order_success_dialog_widget.dart';
import '../widgets/coupon_discount_card_widget.dart';
import '../widgets/shipping_methods_section_widget.dart';

class ConfirmOrderPage extends ConsumerStatefulWidget {
  final List<CartModel> products;
  final VendorModel? vendor;

  const ConfirmOrderPage({
    super.key,
    required this.products,
    this.vendor,
  });

  @override
  ConsumerState<ConfirmOrderPage> createState() => _ConfirmOrderPageState();
}

class _ConfirmOrderPageState extends ConsumerState<ConfirmOrderPage> {
  final TextEditingController couponCodeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _confirmOrderController = ConfirmOrderController();

  num? shippingPrice;

  String _normalizeLocalPhone(String value) {
    final digits = value.replaceAll(RegExp(r'\D'), '');
    if (digits.startsWith('967') && digits.length > 9) {
      return digits.substring(digits.length - 9);
    }
    return digits;
  }

  String? _validatePhone(BuildContext context, String? value) {
    final phone = _normalizeLocalPhone(value ?? '');
    if (phone.isEmpty) {
      return 'قم بإدخال رقم الهاتف';
    }
    if (phone.length < 9) {
      return S.of(context).phoneMustBe9Digits;
    }
    if (!phone.startsWith('7')) {
      return S.of(context).phoneMustStartWith7;
    }
    return null;
  }

  ConfirmOrderModel _buildConfirmOrderModel({
    required List<CartModel> cart,
    required String couponCode,
  }) {
    final printNotes = <int, String>{
      for (final item in cart)
        item.id: ((item.isPrintable ?? 0) != 0)
            ? ref.read(printCtrlProvider(item.id)).text.trim()
            : '',
    };
    final formData = _confirmOrderController.form.group.value;

    return ConfirmOrderModel(
      cartProducts: cart,
      addressId: formData['address_id'] as int,
      paymentId: formData['payment_method'] as int,
      deliveryTypeId: formData['shipping_method_id'] as int,
      copon: couponCode,
      printNotesById: printNotes,
    );
  }

  PaymentRequestContextModel _buildPaymentRequest({
    required ConfirmOrderModel confirmOrderModel,
    required num totalPayable,
  }) {
    final initialPhone = _normalizeLocalPhone(Auth().phoneNumber);
    return PaymentRequestContextModel(
      confirmOrderModel: confirmOrderModel,
      depositAmount: totalPayable.toDouble(),
      initialPhoneNumber: initialPhone,
      phoneMaxLength: 9,
      phoneValidator: _validatePhone,
      phoneNumberMapper: _normalizeLocalPhone,
      floosakTargetPhoneMapper: (value) => '967${_normalizeLocalPhone(value)}',
    );
  }

  bool _validateBeforePaymentOpen(BuildContext context) {
    if (!_confirmOrderController.validateAndNotify(context)) return false;

    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      showFlashBarWarring(
        context: context,
        message: S.of(context).pleaseEnterProductPrintDescription,
      );
      return false;
    }

    FocusManager.instance.primaryFocus?.unfocus();
    return true;
  }

  void _handlePaymentSuccess({
    required BuildContext context,
    required WidgetRef ref,
  }) {
    resetPaymentSelectionState(ref);
    CompleteOrder.successDialog(context);
  }

  @override
  void initState() {
    super.initState();
    _confirmOrderController.form.reset();
    _confirmOrderController.form.group.control('payment_method').reset();
  }

  @override
  void dispose() {
    couponCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = ref.read(fetchOrderConfirmationDataProvider.notifier);
    final state = ref.watch(fetchOrderConfirmationDataProvider);

    return Scaffold(
      appBar: SecondaryAppBarWidget(title: S.of(context).confirmOrder),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: ReactiveFormBuilder(
            form: () => _confirmOrderController.form.group,
            builder: (context, form, child) {
              shippingPrice = form.value['shipping_price'] as num?;
              final hasPrintableProduct = state.data.products.any(
                (product) => (product.isPrintable ?? 0) != 0,
              );

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  10.h.verticalSpace,
                  const CheckoutProgressStepperWidget(),
                  6.h.verticalSpace,

                  AddressToConfirmTheOrderWidget(
                    products: widget.products,
                    address: state.data.userAddresses,
                    form: form,
                    onSelectionChanged: () => setState(() {}),
                  ),
                  12.h.verticalSpace,
                  ReactiveValueListenableBuilder<int>(
                    formControl: form.control('city_id') as FormControl<int>,
                    builder: (context, control, child) {
                      final cityId = control.value ?? 0;
                      final excludeCashOnDelivery =
                          hasPrintableProduct || (cityId != 3 && cityId != 0);
                      return PaymentMethodsSectionWidget(
                        title: S.of(context).paymentMethod,
                        excludeCashOnDelivery: excludeCashOnDelivery,
                        onPaymentMethodCleared: () {
                          form.control('payment_method').reset();
                        },
                        onMethodSelected: (method) {
                          _confirmOrderController.form.group
                                  .control('payment_method')
                                  .value =
                              method.id;
                        },
                      );
                    },
                  ),
                  12.h.verticalSpace,
                  ShippingMethodsSectionWidget(
                    deliveryTypes: state.data.deliveryTypes,
                    form: form,
                  ),
                  12.h.verticalSpace,
                  // Coupon / Discount Voucher Card
                  CouponDiscountCardWidget(
                    couponCodeController: couponCodeController,
                    state: state,
                    ctrl: ctrl,
                    products: widget.products,
                  ),
                  12.h.verticalSpace,
                  // Vendor & Products Unified Card
                  Container(
                    margin: EdgeInsets.only(top: 12.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14.r),
                      border: Border.all(color: const Color(0xFFE5E9F0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.025),
                          blurRadius: 10.r,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Vendor Header (Unified Package Header)
                        if (widget.vendor != null)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 10.h,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF9FAFC),
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(13.r),
                              ),
                              border: const Border(
                                bottom: BorderSide(
                                  color: Color(0xFFEBEFF5),
                                  width: 1,
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                // Store Logo / Icon
                                Container(
                                  width: 36.w,
                                  height: 36.w,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8.r),
                                    border: Border.all(
                                      color: const Color(0xFFE5E9F0),
                                      width: 1,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.02),
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
                                  padding: EdgeInsets.all(2.w),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(6.r),
                                    child: ((widget.vendor!.logo ?? '').isNotEmpty)
                                        ? OnlineImagesWidget(
                                            imageUrl: widget.vendor!.logo!,
                                            size: Size(32.w, 32.w),
                                            fit: BoxFit.cover,
                                          )
                                        : Icon(
                                            Icons.storefront_rounded,
                                            color: AppColors.primaryColor,
                                            size: 20.sp,
                                          ),
                                  ),
                                ),
                                10.w.horizontalSpace,
                                // Store Name & Meta
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Flexible(
                                            child: AutoSizeTextWidget(
                                              text: widget.vendor!.name.isNotEmpty
                                                  ? widget.vendor!.name
                                                  : 'متجر غير معروف',
                                              fontSize: 12.5.sp,
                                              fontWeight: FontWeight.bold,
                                              colorText: AppColors.mainColorFont,
                                              maxLines: 1,
                                            ),
                                          ),
                                          4.w.horizontalSpace,
                                          Icon(
                                            Icons.verified_rounded,
                                            size: 14.sp,
                                            color: AppColors.primaryColor,
                                          ),
                                        ],
                                      ),
                                      2.h.verticalSpace,
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.store_outlined,
                                            size: 11.sp,
                                            color: AppColors.fontColor2,
                                          ),
                                          4.w.horizontalSpace,
                                          AutoSizeTextWidget(
                                            text: (widget.vendor!.city != null && widget.vendor!.city!.isNotEmpty)
                                                ? 'متجر معتمد • ${widget.vendor!.city}'
                                                : 'متجر معتمد',
                                            fontSize: 10.sp,
                                            colorText: AppColors.fontColor2,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                // Package items count badge
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8.w,
                                    vertical: 4.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryColor.withValues(alpha: 0.08),
                                    borderRadius: BorderRadius.circular(6.r),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.inventory_2_outlined,
                                        size: 11.sp,
                                        color: AppColors.primaryColor,
                                      ),
                                      4.w.horizontalSpace,
                                      AutoSizeTextWidget(
                                        text: '${state.data.products.length} ${state.data.products.length == 1 ? "منتج" : "منتجات"}',
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.bold,
                                        colorText: AppColors.primaryColor,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                        // Products List inside the Unified Card
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          itemCount: state.data.products.length,
                          separatorBuilder: (context, index) => Divider(
                            height: 1,
                            thickness: 0.8,
                            color: const Color(0xFFF0F2F5),
                            indent: 12.w,
                            endIndent: 12.w,
                          ),
                          itemBuilder: (context, index) {
                            final items = state.data.products[index];
                            final needs = (items.isPrintable ?? 0) != 0;
                            final ctrl = needs
                                ? ref.watch(printCtrlProvider(items.id))
                                : null;
                            return OrderConfirmationProductCardWidget(
                              data: items,
                              printableController: ctrl,
                              isInsideCard: true,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  ReactiveValueListenableBuilder(
                    formControl: form.control('shipping_price'),
                    builder: (context, control, child) {
                      final deliveryCost = control.value is num
                          ? control.value as num
                          : 0;

                      return BillWidget(
                        deliveryCost: deliveryCost,
                        billData: state.data.billData!,
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: ButtonBottomNavigationBarDesignWidget(
        child: ReactiveValueListenableBuilder(
          formControl: _confirmOrderController.form.group.control('shipping_price'),
          builder: (context, control, child) {
            final deliveryCost = control.value is num
                ? control.value as num
                : 0;
            final totalPayable = (state.data.billData?.totalPayable ?? 0) + deliveryCost;

            return PaymentActionButtonWidget(
              totalAmount: totalPayable,
              paymentRequestBuilder: (context, ref) => _buildPaymentRequest(
                confirmOrderModel: _buildConfirmOrderModel(
                  cart: state.data.products,
                  couponCode: couponCodeController.text,
                ),
                totalPayable: totalPayable,
              ),
              buttonText: S.of(context).confirmOrder,
              onBeforeOpen: (context, ref) => _validateBeforePaymentOpen(context),
              onPaymentSuccess: (context, ref, purchaseId) =>
                  _handlePaymentSuccess(context: context, ref: ref),
            );
          },
        ),
      ),
    );
  }
}
