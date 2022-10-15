import 'package:flutter/material.dart';

const List<String> list = <String>['Categoria', 'Two', 'Three', 'Four'];

class DropdownButtonExample extends StatefulWidget {
  const DropdownButtonExample({super.key});

  @override
  State<DropdownButtonExample> createState() => _DropdownButtonExampleState();
}

class _DropdownButtonExampleState extends State<DropdownButtonExample> {
  String dropdownValue = list.first;

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
            horizontal: 20.0, vertical: 15.0),
        labelText: ('Categoria'),
        border: OutlineInputBorder(
          borderSide: BorderSide(width: 0.8, color: Colors.grey), //<-- SEE HERE
          borderRadius: BorderRadius.circular(50.0),
        ),
      ),
      child: DropdownButton<String>(
        value: dropdownValue,
        //icon: const Icon(Icons.arrow_downward),
        elevation: 16,
        //style: const TextStyle(color: Colors.deepPurple),
        //underline: Container(
         // height: 2,
          //color: Colors.deepPurpleAccent,
        //),
        onChanged: (String? value) {
          // This is called when the user selects an item.
          setState(() {
            dropdownValue = value!;
          });
        },
        items: list.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}
