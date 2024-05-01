import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:prepitpro/components/action_button.dart';
import 'package:prepitpro/components/gap.dart';
import 'package:prepitpro/theme/theme.dart';

const actionBtn = ActionButton(
  icon: Icons.arrow_right_alt_outlined,
  size: 30,
  backgroundColor: Colors.black87,
  iconColor: Colors.white,
);

class PrimaryButton extends StatelessWidget {
  final double? borderRadius;
  final double? padding;
  final Color? backgroundColor;
  final Function()? onTap;
  final bool? reverse;
  final double? height;
  final double? width;
  final String text;
  final TextStyle? textStyle;
  final Widget? actionWidget;
  final Widget? leadingWidget;
  final IconData? icon;
  final MainAxisAlignment? spacing;
  final EdgeInsetsGeometry? mainPadding;
  final EdgeInsetsGeometry? margin;
  final bool hideTrailingButton;
  const PrimaryButton({
    super.key,
    required this.text,
    this.icon,
    this.height,
    this.width,
    this.borderRadius,
    this.padding,
    this.backgroundColor,
    this.actionWidget,
    this.leadingWidget,
    this.onTap,
    this.textStyle,
    this.reverse,
    this.hideTrailingButton = false,
    this.spacing,
    this.mainPadding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> list = [
      if (leadingWidget != null) leadingWidget!,
      if (leadingWidget != null) const Gap(width: 2),
      if (text != "")
        AutoSizeText(
          text,
          style: textStyle,
          overflow: TextOverflow.ellipsis,
          softWrap: true,
        ),
      if (text != "") const Gap(width: 2),
      if (!hideTrailingButton)
        actionWidget ??
            ActionButton(
              icon: icon ?? Icons.arrow_right_alt_outlined,
              size: 30,
              backgroundColor: Colors.black87,
              iconColor: Colors.white,
              borderColor: Colors.transparent,
            )
    ];
    if (reverse == true) {
      list = list.reversed.toList();
    }
    final isDark = ThemeController.themeMode.value == ThemeMode.dark;
    return InkWell(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(minWidth: 80),
        height: height,
        width: width,
        margin: margin,
        padding: mainPadding ?? EdgeInsets.all(padding ?? 4),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius ?? 999),
            color: backgroundColor ??
                (isDark
                    ? Theme.of(context).colorScheme.secondary
                    : Colors.white)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: spacing ?? MainAxisAlignment.spaceEvenly,
          children: list,
        ),
      ),
    );
  }
}
