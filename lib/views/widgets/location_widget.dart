import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce/models/address_model.dart';

import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';

class LocationWidget extends StatelessWidget {
  final AddressModel address;
  final Color borderColor;
  const LocationWidget({
    super.key,
    required this.address,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSelected = borderColor == AppColors.primary;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primaryLight : AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: borderColor,
          width: isSelected ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: address.image,
                width: 56,
                height: 56,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    Container(color: AppColors.grey2),
                errorWidget: (context, url, error) =>
                    const Icon(Icons.location_on),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    address.city,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "${address.city}, ${address.country}",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.grey,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
             const Icon(
                Icons.check_circle_rounded,
                color: AppColors.primary,
                size: 22,
              )
            else
              Icon(
                Icons.radio_button_unchecked_rounded,
                color: Colors.grey.shade300,
                size: 22,
              ),
          ],
        ),
      ),
    );
  }
}
