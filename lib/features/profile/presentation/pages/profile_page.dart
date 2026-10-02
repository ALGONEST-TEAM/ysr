import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ysr/core/theme/app_colors.dart';
import '../../../../../core/helpers/navigateTo.dart';
import '../../../../../core/widgets/show_modal_bottom_sheet_widget.dart';
import '../../../../../generated/l10n.dart';
import '../../../../../services/auth/auth.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/widgets/auto_size_text_widget.dart';
import '../../../../core/widgets/main_app_bar_widget.dart';
import '../../../shop/address/presentation/pages/view_all_address_page.dart';
import '../../../shop/productManagement/wishlist/presentation/pages/wishlist_page.dart';
import '../../../shop/productManagement/wishlist/presentation/riverpod/wishlist_riverpod.dart';
import 'privacy_policy_page.dart';
import 'settings_page.dart';
import 'terms_and_conditions_page.dart';
import '../widgets/list_tile_profile_widget.dart';
import '../widgets/profile_header_card_widget.dart';
import 'edit_profile_page.dart';
import 'support_channels_bottom_sheet.dart';
import 'logout_or_delete_account_bottom_sheet.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  void _refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      appBar: MainAppBarWidget(title: S.of(context).profile),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileHeaderCardWidget(onLogoutSuccess: _refresh),
            16.h.verticalSpace,

            // Group 1: User services (Profile Details, Addresses, Favorites)
            if (Auth().loggedIn) ...[
              _buildGroup(
                children: [
                  ListTileProfileWidget(
                  title: S.of(context).personalInfo,
                  icon: AppIcons.personalInfo,
                    onTap: () {
                    navigateTo(context, EditProfilePage(onSuccess: _refresh));
                    },
                  ),
                  ListTileProfileWidget(
                  title: S.of(context).addressBook,
                  icon: AppIcons.address,
                    onTap: () {
                      navigateTo(context, const ViewAllAddressPage());
                    },
                  ),
                  Consumer(
                    builder: (context, ref, child) {
                      return ListTileProfileWidget(
                      title: S.of(context).favorites,
                      icon: AppIcons.wishlist,
                      iconHeight: 15.h,
                        onTap: () {
                          ref.invalidate(getAllWishesProductsProvider);
                          ref.invalidate(getAllListProvider);
                          navigateTo(context, const WishlistPage());
                        },
                      );
                    },
                  ),
                ],
              ),
              16.h.verticalSpace,
            ],

            // Group 2: App settings & Help (Settings, Privacy, Terms, Support)
            _buildGroup(
              children: [
                ListTileProfileWidget(
            title: S.of(context).settings,
            icon: AppIcons.settings,
                  onTap: () {
                    navigateTo(context, SettingsPage(onSuccess: _refresh));
                  },
                ),
                ListTileProfileWidget(
                  title: isArabic ? 'سياسة الخصوصية' : 'Privacy Policy',
                  icon: AppIcons.faq,
                  onTap: () {
                    navigateTo(context, const PrivacyPolicyPage());
                  },
                ),
                ListTileProfileWidget(
            title: 'الشروط والأحكام',
            icon: AppIcons.faq,
                  onTap: () {
                    navigateTo(context, const TermsAndConditionsPage());
                  },
                ),
                ListTileProfileWidget(
            title: S.of(context).support,
            icon: AppIcons.support,
                  onTap: () {
                    scrollShowModalBottomSheetWidget(
                title: S.of(context).support,
                      fontSize: 13.4.sp,
                      context: context,
                      page: const SupportChannelsBottomSheet(),
                    );
                  },
                ),
              ],
            ),
            16.h.verticalSpace,

            // Group 3: Logout (in its own rounded white card at the bottom)
            if (Auth().loggedIn) ...[
              _buildGroup(
                children: [
                  ListTileProfileWidget(
                    title: isArabic ? 'تسجيل الخروج' : 'Logout',
                    icon: AppIcons.logout,
                    onTap: () {
                      showModalBottomSheetWidget(
                        context: context,
                        page: LogoutOrDeleteAccountBottomSheet(
                          onSuccess: _refresh,
                        ),
                      );
                    },
                  ),
                ],
              ),
              20.h.verticalSpace,
            ] else
              20.h.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                AutoSizeTextWidget(text:  '  تم التطوير بواسطة ',colorText: AppColors.secondaryColor,),
                AutoSizeTextWidget(text:  'Algonest ',colorText: AppColors.primaryColor,fontWeight: FontWeight.w600,),

              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGroup({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0x0A1E2024),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        spacing: 2,
        children: [
          for (int i = 0; i < children.length; i++) ...[
            children[i],
            if (i < children.length - 1)
              Divider(
                height: 1,
                thickness: 1,
                indent: 18.w,
                endIndent: 18.w,
                color: const Color(0xFFF1F3F5),
              ),
          ],
        ],
      ),
    );
  }
}

