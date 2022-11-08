import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:intl/intl.dart';

class DatePicker extends StatefulWidget {
  const DatePicker({super.key});

  @override
  State<StatefulWidget> createState() {
    return _DatePicker();
  }
}

class _DatePicker extends State<DatePicker> {
  TextEditingController dateInput = TextEditingController();

  @override
  void initState() {
    dateInput.text = ""; //set the initial value of text field
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: dateInput,
      //editing controller of this TextField
      decoration: InputDecoration(
        labelText: "Insira a data",
        border: OutlineInputBorder(
          borderSide: const BorderSide(
              width: 0.8, color: Colors.blueAccent), //<-- SEE HERE
          borderRadius: BorderRadius.circular(50.0),
        ),
      ),
      readOnly: true,
      //set it true, so that user will not able to edit text
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1950),
            //DateTime.now() - not to allow to choose before today.
            lastDate: DateTime(2100));

        if (pickedDate != null) {
          print(
              pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
          String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
          print(
              formattedDate); //formatted date output using intl package =>  2021-03-16
          setState(() {
            dateInput.text =
                formattedDate; //set output date to TextField value.
          });
        } else {}
      },
    );
  }
}
