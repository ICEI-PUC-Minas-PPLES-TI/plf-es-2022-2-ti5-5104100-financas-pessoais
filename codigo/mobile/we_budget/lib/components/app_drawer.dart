import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:we_budget/models/auth.dart';
import 'package:we_budget/utils/app_routes.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text("Bem vindo usuário"),
            automaticallyImplyLeading: false,
            backgroundColor: const Color(0xFF923DF8),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("Usuário"),
            onTap: () {
              Navigator.of(context).pushNamed(AppRoutes.editDataUser);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text("Logout"),
            onTap: () {
              Provider.of<Auth>(context, listen: false).logout();
              Navigator.of(context).pushReplacementNamed(AppRoutes.authOrHome);
            },
          )
        ],
      ),
    );
  }
}
