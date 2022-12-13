import 'package:flutter/material.dart';
import '../components/edit_auth_form.dart';

class EditDataUser extends StatefulWidget {
  const EditDataUser({Key? key}) : super(key: key);

  @override
  State<EditDataUser> createState() => _EditDataUserState();
}

class _EditDataUserState extends State<EditDataUser> {
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.05),
        child: AppBar(
          elevation: 0,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF923DF8),
                  Color(0xFF4C94F8),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: deviceSize.height * 0.20,
                    width: 200,
                    child: SizedBox.expand(
                      child: Image.asset(
                        'assets/imagem_fundo.jpeg',
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsetsDirectional.only(top: 20.0),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: const [
                      Text(
                        "Edição cadastro",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const UpdateAuthData(),
            ],
          ),
        ],
      ),
    );
  }
}
