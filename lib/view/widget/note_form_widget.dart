import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NoteFormWidget extends StatelessWidget {
  final String? title;

  final String? description;

  final DateTime? timeForNotfication;

  final ValueChanged<String> onChangedTitle;
  final ValueChanged<String> onChangedDescription;

  final ValueChanged<DateTime?> onChangeDateTime;

  const NoteFormWidget(
      {Key? key,
      this.title = '',
      this.description = '',
      this.timeForNotfication,
      required this.onChangedTitle,
      required this.onChangedDescription,
      required this.onChangeDateTime})
      : super(key: key);

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [],
              ),
              buildTitle(),
              const SizedBox(height: 8),
              buildDescription(),
              buildFieldDateTime()
            ],
          ),
        ),
      );

  Widget buildTitle() => TextFormField(
        maxLines: 1,
        autofocus: true,
        initialValue: title,
        style: const TextStyle(
          color: Colors.white70,
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
        decoration: const InputDecoration(
            icon: Icon(Icons.note, color: Colors.white70),
            border: InputBorder.none,
            hintText: 'Add header',
            hintStyle: TextStyle(color: Colors.white70)),
        validator: (title) =>
            title != null && title.isEmpty ? 'Value is required' : null,
        onChanged: onChangedTitle,
      );

  Widget buildDescription() => TextFormField(
        maxLines: 5,
        initialValue: description,
        style: const TextStyle(color: Colors.white60, fontSize: 18),
        decoration: const InputDecoration(
          icon: Icon(Icons.speaker_notes, color: Colors.white70),
          border: InputBorder.none,
          hintText: 'Add descrption',
          hintStyle: TextStyle(color: Colors.white60),
        ),
        onChanged: onChangedDescription,
      );

  Widget buildFieldDateTime() => DateTimeField(
        validator: (value) => value != null && value.isBefore(DateTime.now())
            ? 'Value is not vaild'
            : null,
        autovalidateMode: AutovalidateMode.always,
        decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: 'Set notification',
            hintStyle: TextStyle(color: Colors.white70),
            icon: Icon(Icons.notifications, color: Colors.white70)),
        style: const TextStyle(
          color: Colors.white70,
        ),
        strutStyle: StrutStyle(),
        initialValue: timeForNotfication,
        format: DateFormat("y MMM d, H:mm"),
        onChanged: onChangeDateTime,
        onShowPicker: (context, currentValue) async {
          final date = await showDatePicker(
              context: context,
              firstDate: DateTime.now(),
              initialDate: currentValue ?? DateTime.now(),
              lastDate: DateTime.now().add(Duration(days: 365 * 2)));

          if (date != null) {
            final time = await showTimePicker(
                context: context,
                initialTime:
                    TimeOfDay.fromDateTime(currentValue ?? DateTime.now().add(Duration(minutes: 2))));
            return DateTimeField.combine(date, time);
          }
        },
      );
}
