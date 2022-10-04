import 'package:flutter/material.dart';

class CardMainPage extends StatelessWidget {
  final String? title;

  const CardMainPage({
    this.title,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsetsDirectional.only(top: 31),
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Container(
          height: 79,
          width: 115,
          decoration: const BoxDecoration(
            borderRadius: BorderRadiusDirectional.all(
              Radius.circular(15.0),
            ),
          ),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "$title",
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              const Text("R\$ 3.000,00")
            ],
          ),
        ),
      ),
    );
  }
}
