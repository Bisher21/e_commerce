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
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        title: Text(
          address.city,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text("${address.city}, ${address.country}"),
        trailing: Container(
          width: 75,
          height: 75,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: borderColor, width: 2),
            image: DecorationImage(
              image: CachedNetworkImageProvider(address.image),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
