import 'package:flutter/material.dart';
import 'package:flutter_up/helpers/up_datetime_helper.dart';

Future<DateTime> getPicker(BuildContext context) async {
  DateTime? pickedDate = await UpDateTimeHelper.upDatePicker(
    context,
    initialDate: DateTime.now(),
    firstDate: DateTime(2000),
    lastDate: DateTime(2101),
  );

  TimeOfDay? pickedTime = await UpDateTimeHelper.upTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
  );

  if (pickedDate != null) {
    if (pickedTime != null) {
      pickedDate = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
    }
  }
  return pickedDate ?? DateTime.now();
}
