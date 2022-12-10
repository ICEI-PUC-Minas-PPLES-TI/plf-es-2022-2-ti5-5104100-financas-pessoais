import 'package:flutter/material.dart';
import 'package:we_budget/utils/app_routes.dart';

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
    Object? data = ModalRoute.of(context)!.settings.arguments;

    return InputDecorator(
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20.0, vertical: 7.0),
        labelText: ('Categoria'),
        border: OutlineInputBorder(
          borderSide:
              const BorderSide(width: 0.8, color: Colors.grey), //<-- SEE HERE
          borderRadius: BorderRadius.circular(50.0),
        ),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent, // <- Here
          highlightColor: Colors.transparent, // <- Here
          hoverColor: Colors.transparent,
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: dropdownValue,
            focusColor: Colors.transparent,
            //icon: const Icon(Icons.arrow_downward),
            elevation: 16,
            //style: const TextStyle(color: Colors.deepPurple),
            //underline: Container(
            // height: 2,
            //color: Colors.deepPurpleAccent,
            //),
            onChanged: (String? value) {},
            onTap: (() {
              Navigator.of(context).pushNamed(AppRoutes.listCategory);
            }),
            items: list.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
