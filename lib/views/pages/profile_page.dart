import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce/utils/app_colors.dart';
import 'package:e_commerce/utils/app_routes.dart';
import 'package:e_commerce/views/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../view_models/auth_cubit/auth_cubit.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final logoutCubit = BlocProvider.of<AuthCubit>(context);
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [

          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Container(
                height: 200,
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF7E57C2), Color(0xFF4527A0)],
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
              ),
              Positioned(
                top: 120,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.12),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const CircleAvatar(
                    radius: 52,
                    backgroundImage: CachedNetworkImageProvider(
                      'https://randomuser.me/api/portraits/men/46.jpg',
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 68),


          Text(
            "Jack Mith",
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: Colors.black87,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "jackmith@example.com",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.grey,
            ),
          ),
          const SizedBox(height: 24),


          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 8),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStatItem(context, "Orders", "12",
                      Icons.shopping_bag_outlined),
                  _verticalDivider(),
                  _buildStatItem(
                      context, "Wishlist", "25", Icons.favorite_outline),
                  _verticalDivider(),
                  _buildStatItem(
                      context, "Coupons", "3", Icons.local_offer_outlined),
                ],
              ),
            ),
          ),
          const SizedBox(height: 28),


          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                _buildProfileItem(
                  context,
                  icon: Icons.person_outline,
                  title: "Edit Profile",
                ),
                _buildProfileItem(
                  context,
                  icon: Icons.shopping_bag_outlined,
                  title: "My Orders",
                ),
                _buildProfileItem(
                  context,
                  icon: Icons.location_on_outlined,
                  title: "Shipping Address",
                ),
                _buildProfileItem(
                  context,
                  icon: Icons.payment_outlined,
                  title: "Payment Methods",
                ),
                _buildProfileItem(
                  context,
                  icon: Icons.notifications_none_outlined,
                  title: "Notifications",
                ),
                const SizedBox(height: 16),
                Divider(thickness: 1, color: AppColors.grey2),
                const SizedBox(height: 16),

                BlocConsumer<AuthCubit, AuthState>(
                  listenWhen: (previous, current) =>
                      current is AuthLoggedOut ||
                      current is AuthLoggingOutFailed,
                  listener: (context, state) {
                    if (state is AuthLoggedOut) {
                      Navigator.of(context, rootNavigator: true)
                          .pushNamedAndRemoveUntil(
                        AppRoutes.loginRoute,
                        (route) => false,
                      );
                    } else if (state is AuthLoggingOutFailed) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.message)),
                      );
                    }
                  },
                  bloc: logoutCubit,
                  buildWhen: (previous, current) => current is AuthLoggingOut,
                  builder: (context, state) {
                    if (state is AuthLoggingOut) {
                      return CustomElevatedButton(isLoading: true);
                    }
                    return CustomElevatedButton(
                      text: "Logout",
                      backgroundColor: Colors.red.withValues(alpha: 0.1),
                      textColor: Colors.red,
                      onPressed: () async {
                        await logoutCubit.logout();
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }

  Widget _verticalDivider() {
    return Container(height: 36, width: 1, color: Colors.grey.shade200);
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppColors.primary,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.grey,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildProfileItem(
    BuildContext context, {
    required IconData icon,
    required String title,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColors.primary, size: 19),
            ),
            const SizedBox(width: 14),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }
}
