import 'package:flutter/material.dart';

class AppHorizontalList<T> extends StatelessWidget {
  final List<T> items;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final double height;
  final double itemSpacing;
  final String emptyMessage;

  const AppHorizontalList({
    super.key,
    required this.items,
    required this.itemBuilder,
    required this.height,
    this.itemSpacing = 12.0,
    this.emptyMessage = 'لا توجد بيانات',
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return SizedBox(
        height: height, 
        child: Center(
          child: Text(emptyMessage, style: const TextStyle(color: Colors.white)),
        ),
      );
    }

    return SizedBox(
      height: height,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(left: index == items.length - 1 ? 0 : itemSpacing),
            child: itemBuilder(context, items[index], index),
          );
        },
      ),
    );
  }
}
