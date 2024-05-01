import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final IconData? icon;
  final Function()? onTap;
  final double? size;
  final double? padding;
  final double? borderWidth;
  final Color? borderColor;
  final double? iconSize;
  final Color? iconColor;
  final Color? backgroundColor;

  const ActionButton(
      {super.key,
      required this.icon,
      required this.size,
      this.onTap,
      this.padding,
      this.borderWidth,
      this.borderColor,
      this.iconColor,
      this.iconSize,
      this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap,
        child: Container(
          height: size,
          width: size,
          padding: EdgeInsets.all(padding ?? 2),
          decoration: BoxDecoration(
              color: backgroundColor ?? Colors.transparent,
              borderRadius: BorderRadius.circular(999),
              border: borderWidth == 0
                  ? Border.all(width: 0, color: Colors.transparent)
                  : Border.all(
                      width: borderWidth ?? 1,
                      color: borderColor ??
                          Theme.of(context).textTheme.bodySmall!.color!)),
          child: Icon(
            icon,
            color: iconColor ?? Theme.of(context).textTheme.bodySmall?.color,
            size: iconSize ?? 16,
          ),
        ));
  }
}
