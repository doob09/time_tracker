import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:time_tracker/src/widgets/input_dropdown.dart';

class DateTimePicker extends StatelessWidget {
  final String labelText;

  final DateTime selectedDate;
  final ValueChanged<DateTime> onSelectedDate;

  final TimeOfDay selectedTime;
  final ValueChanged<TimeOfDay> onSelectedTime;

  DateTimePicker({
    this.labelText,

    this.selectedDate,
    this.onSelectedDate,

    this.selectedTime,
    this.onSelectedTime,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 3,
          child: new InputDropdown(
            labelText: labelText,
            valueText: DateFormat.yMMMd().format(selectedDate),
            onPressed: () => _selectDate(context),
          ),
        ),
        SizedBox(
          width: 12.0,
         
        ),
        Expanded(
          flex: 4,
          child: new InputDropdown(
            valueText: selectedTime.format(context),
            onPressed: () => _selectTime(context),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final pickedDate = await showDatePicker( // widget to pick date
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2019, 1),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      onSelectedDate(pickedDate); // change the date state after pick up one
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final pickedTime = await showTimePicker( // widget to pick time 
      context: context,
      initialTime: selectedTime,
    );
    if (pickedTime != null && pickedTime != selectedTime) {
      onSelectedTime(pickedTime); // change the time state  after pick up one
    }
  }
}
