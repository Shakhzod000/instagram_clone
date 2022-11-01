

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StoryWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  final bool isaddWidget;
  final String imageUrl;


  const StoryWidget({Key? key,
  required this.title,
  required this.onPressed,
  required this.imageUrl,
  this.isaddWidget = false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        isaddWidget 
        ? Container(
          height: 56.w,
          width: 56.w,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(width: 1, color: const Color(0xFF48484A),
            )
          ),
          child: Icon(
            Icons.add,
            size: 18.w,
            color: Theme.of(context).focusColor,
          ),
        )
        : ClipRRect(
          borderRadius: BorderRadius.circular(28.w),
          child: SizedBox(
            height: 56.w,
            width: 56.w,
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              errorWidget: (context, url, error)=> const SizedBox.shrink(),
              placeholder: (context, url,) => const SizedBox.shrink(),
            ),
          ),
        ),
        SizedBox(height: 3.h),

        Text(
          title,
          style: Theme.of(context)
          .textTheme
          .displayMedium!.copyWith(fontSize: 12.sp,fontWeight: FontWeight.w400),
        )
      ],
    );
  }
}