import 'package:flutter/material.dart';

class Badge extends StatelessWidget {
  final Widget child;
  final String value;
  final Color? color;

  const Badge({
    Key? key,
    required this.child,
    required this.value,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        child,
        Positioned(
          right: 8,
          top: 8,
          child: Container(
            child: Text(
              value,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 10),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: color ?? Theme.of(context).colorScheme.secondary,
            ),
            padding: const EdgeInsets.all(2),
            constraints: const BoxConstraints(
              minHeight: 16,
              minWidth: 16,
            ),
          ),
        ),
      ],
    );
  }
}