import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/helpers/navigateTo.dart';
import '../../../../../../core/state/check_state_in_post_api_data_widget.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../productManagement/detailsProducts/presentation/page/details_page.dart';
import '../riverpod/cart_riverpod.dart';
import 'cart_card_widget.dart';
import 'vendor_cart_header_widget.dart';

class ListForCartWidget extends ConsumerStatefulWidget {
  const ListForCartWidget({super.key});

  @override
  ConsumerState<ListForCartWidget> createState() => _ListForCartWidgetState();
}

class _ListForCartWidgetState extends ConsumerState<ListForCartWidget> {
  int loadingId = 0;
  bool delete = false;

  @override
  Widget build(BuildContext context) {
    var state = ref.watch(getAllCartProvider);
    var cartStateNotifier = ref.watch(cartProvider.notifier);
    var cartState = ref.watch(cartProvider);

    return CheckStateInPostApiDataWidget(
      state: cartState,
      hasMessageSuccess: false,
      functionSuccess: () {
        setState(() {
          if (delete) {
            delete = false;
          } else {
            ref.read(cartProductProvider(loadingId).notifier).updateProduct(
                  ref
                      .read(cartProductProvider(loadingId))
                      .updateCartProduct(ref.read(cartProvider).data),
                );
            final index = state.data.indexWhere((item) => item.id == loadingId);
            if (index != -1) {
              state.data[index] =
                  state.data[index].updateCartProduct(cartState.data);
            }
          }
        });
      },
      bottonWidget: Builder(
        builder: (context) {
          final groupedData = ref.read(getAllCartProvider.notifier).groupedByVendor;
          final vendorIds = groupedData.keys.toList();

          return ListView.builder(
            itemCount: vendorIds.length,
            padding: EdgeInsets.symmetric(horizontal: 12.w).copyWith(bottom: 28.h),
            itemBuilder: (context, index) {
              final vendorId = vendorIds[index];
              final products = groupedData[vendorId]!;
              final vendor = products.isNotEmpty ? products.first.vendor : null;

              return Container(
                margin: EdgeInsets.only(bottom: 12.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: AppColors.greySwatch.shade100,
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 6.r,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    VendorCartHeaderWidget(vendor: vendor, products: products),
                    ...products.asMap().entries.map((entry) {
                      final itemIndex = entry.key;
                      final item = entry.value;

                      return Column(
                        children: [
                          if (itemIndex > 0)
                            Divider(
                              height: 1,
                              thickness: 0.8,
                              color: AppColors.greySwatch.shade100,
                              indent: 12.w,
                              endIndent: 12.w,
                            ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4.w),
                            child: GestureDetector(
                              onTap: () {
                                navigateTo(
                                  context,
                                  DetailsPage(
                                    idProduct: item.productId!,
                                    name: item.productName.toString(),
                                    price: item.price,
                                    image: [item.images!],
                                  ),
                                );
                              },
                              child: CartCardWidget(
                                productId: item.id,
                                loadingId: loadingId,
                                onDelete: () {
                                  setState(() {
                                    loadingId = item.id;
                                    delete = true;
                                  });
                                  cartStateNotifier.deleteAProductFromTheCart(
                                      id: item.id, ref: ref);
                                },
                                onUpdateQuantity: (int newQuantity) {
                                  setState(
                                    () {
                                      loadingId = item.id;
                                      cartStateNotifier.updateCart(
                                        id: item.id,
                                        prodectId: item.productId!,
                                        colorId: item.colorId,
                                        sizeId: item.sizeId!,
                                        price: item.price.toString(),
                                        quantity: newQuantity,
                                        numberId: item.numberId,
                                        isPrintable: item.isPrintable!,
                                      );
                                    },
                                  );
                                },
                                onCancelPrinting: () {
                                  setState(() {
                                    loadingId = item.id;
                                    delete = false;
                                  });
                                  cartStateNotifier.updateCart(
                                    id: item.id,
                                    prodectId: item.productId!,
                                    colorId: item.colorId,
                                    sizeId: item.sizeId!,
                                    price: item.price.toString(),
                                    quantity: item.quantity!,
                                    numberId: item.numberId,
                                    isPrintable: 0,
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                    4.h.verticalSpace,
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
