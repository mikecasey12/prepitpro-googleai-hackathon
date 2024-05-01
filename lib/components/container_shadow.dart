import 'package:flutter/material.dart';

class ContainerShadow extends StatelessWidget {
  final double? borderRadius;
  final bool filled;
  final BoxShadow? boxShadow;
  final Widget child;
  const ContainerShadow(
      {super.key,
      this.borderRadius,
      this.boxShadow,
      required this.child,
      this.filled = true});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(boxShadow: [
          if (filled)
            boxShadow ??
                BoxShadow(
                    color: Colors.black45.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 1,
                    offset: const Offset(0, 2))
        ], borderRadius: BorderRadius.circular(borderRadius ?? 999)),
        child: child);
  }
}
