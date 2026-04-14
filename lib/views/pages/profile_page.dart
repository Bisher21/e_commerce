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
      child: Column(
        children: [
          // Header Section
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Container(
                height: 220,
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.primary, Colors.deepPurpleAccent],
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(50),
                  ),
                ),
              ),
              Positioned(
                top: 140,
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                    color: AppColors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: const CircleAvatar(
                    radius: 60,
                    backgroundImage: CachedNetworkImageProvider(
                      'https://randomuser.me/api/portraits/men/46.jpg',
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 80),

          // User Info Section
          Text(
            "Jack Mith",
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            "jackmith@example.com",
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.grey),
          ),
          const SizedBox(height: 24),

          // Statistics Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatItem("Orders", "12"),
              _buildStatItem("Wishlist", "25"),
              _buildStatItem("Coupons", "3"),
            ],
          ),
          const SizedBox(height: 32),

          // Menu Items
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
                const SizedBox(height: 20),
                Divider(thickness: 1, color: AppColors.grey2),
                const SizedBox(height: 20),

                BlocConsumer<AuthCubit, AuthState>(
                  listenWhen: (previous, current) =>
                      current is AuthLoggedOut ||
                      current is AuthLoggingOutFailed,
                  listener: (context, state) {
                    if (state is AuthLoggedOut) {
                      Navigator.of(context,rootNavigator: true).pushNamedAndRemoveUntil(
                        AppRoutes.loginRoute,
                        (route) => false,
                      );
                    } else if (state is AuthLoggingOutFailed) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(state.message)));
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

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: AppColors.grey, fontSize: 14),
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
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.primary, size: 20),
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
            const Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: AppColors.grey.withValues(alpha: 0.5),
            ),
          ],
        ),
      ),
    );
  }
}
