import 'dart:math';

import 'package:flutter/material.dart';

class Counter extends StatefulWidget {
  final Function onChange;
  int defaultValue;
  final int? maxItems;
  Counter(
      {Key? key,
      required this.onChange,
      this.defaultValue = 1,
      this.maxItems = 0})
      : super(key: key);

  @override
  State<Counter> createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  void _increment() {
    if (widget.defaultValue < widget.maxItems! ||
        widget.defaultValue > widget.maxItems!) {
      widget.defaultValue++;
      widget.onChange(widget.defaultValue);
      setState(() {
        widget.defaultValue;
      });
    }
  }

  void _decrement() {
    widget.defaultValue = max(widget.defaultValue - 1, 1);
    widget.onChange(widget.defaultValue);
    setState(() {
      widget.defaultValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black,
              width: 1,
            ),
          ),
          child: IconButton(
            onPressed: _increment,
            icon: const Icon(
              Icons.add,
              size: 15,
            ),
          ),
        ),
        Container(
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.black,
                  width: 1,
                ),
                bottom: BorderSide(
                  color: Colors.black,
                  width: 1,
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text("${widget.defaultValue}"),
            )),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black,
              width: 1,
            ),
          ),
          child: IconButton(
            onPressed: _decrement,
            icon: const Icon(
              Icons.remove,
              size: 15,
            ),
          ),
        ),
      ],
    );
  }
}
