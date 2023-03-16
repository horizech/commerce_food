import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_up/themes/up_style.dart';
import 'package:flutter_up/widgets/up_icon.dart';
import 'package:flutter_up/widgets/up_text.dart';

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
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: SizedBox(
              child: GestureDetector(
                onTap: _decrement,
                child: const UpIcon(
                  icon: Icons.remove,
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: SizedBox(
            child: UpText(
              "${widget.defaultValue}",
              style: UpStyle(
                textWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: SizedBox(
              child: GestureDetector(
                onTap: _increment,
                child: const UpIcon(
                  icon: Icons.add,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class DeleteCounter extends StatefulWidget {
  final Function onChange;
  int defaultValue;
  final int? maxItems;
  DeleteCounter(
      {Key? key,
      required this.onChange,
      this.defaultValue = 1,
      this.maxItems = 0})
      : super(key: key);

  @override
  State<DeleteCounter> createState() => _DeleteCounterState();
}

class _DeleteCounterState extends State<DeleteCounter> {
  bool isDeleteIconShow = false;
  @override
  void initState() {
    super.initState();
  }

  void _increment() {
    if (widget.defaultValue == 0) {
      isDeleteIconShow = false;
    }
    if (widget.defaultValue < widget.maxItems! ||
        widget.defaultValue > widget.maxItems! ||
        isDeleteIconShow == false) {
      widget.defaultValue++;
      widget.onChange(widget.defaultValue);
      setState(() {
        widget.defaultValue;
      });
    }
  }

  void _decrement() {
    widget.defaultValue = max(widget.defaultValue - 1, 0);
    widget.onChange(widget.defaultValue);
    setState(() {
      if (widget.defaultValue == 0) {
        isDeleteIconShow = true;
      }
      widget.defaultValue;
    });
  }

  void _onDeleteClick() {
    widget.onChange(-1);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (widget.defaultValue == 0) {
      isDeleteIconShow = true;
    } else {
      isDeleteIconShow = false;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        isDeleteIconShow
            ? Padding(
                padding: const EdgeInsets.all(4.0),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: SizedBox(
                    child: GestureDetector(
                      onTap: _onDeleteClick,
                      child: const UpIcon(
                        icon: Icons.delete,
                      ),
                    ),
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(4.0),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: SizedBox(
                    child: GestureDetector(
                      onTap: _decrement,
                      child: const UpIcon(
                        icon: Icons.remove,
                      ),
                    ),
                  ),
                ),
              ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: SizedBox(
            child: UpText(
              "${widget.defaultValue}",
              style: UpStyle(
                textWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: SizedBox(
              child: GestureDetector(
                onTap: _increment,
                child: const UpIcon(
                  icon: Icons.add,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
