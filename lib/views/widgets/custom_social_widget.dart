import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

class CustomSocialWidget extends StatelessWidget {
  final String? title;
  final String? socialImage;
  final VoidCallback? onTap;
  final bool isLoading;

   CustomSocialWidget({
    super.key,
     this.title,
     this.socialImage,
     this.onTap,
    this.isLoading=false,

  }){
    assert((title != null && socialImage != null ) || isLoading==true);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.grey1,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
          child:isLoading?const CircularProgressIndicator.adaptive(strokeWidth: 2): Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CachedNetworkImage(
                imageUrl: socialImage!,
                height: 24,
                width: 24,
                placeholder: (context, url) => const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator.adaptive(strokeWidth: 2),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error, size: 24),
              ),
              const SizedBox(width: 12),
              Text(
                title!,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
