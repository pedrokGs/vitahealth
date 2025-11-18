import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vita_health/di/shared_providers.dart';
import 'package:vita_health/shared/models/user.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    User? user = ref.watch(loginNotifierProvider).currentUser;
    user ??= User(email: '', password: '', celular: '', usuario: '', foto: '');

    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [

            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundImage: user.foto.isNotEmpty
                        ? FileImage(File(user.foto))
                        : null,
                    child: user.foto.isEmpty
                        ? Icon(Icons.person, size: 30)
                        : null,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    user.usuario.isNotEmpty ? user.usuario : "Usuário",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  Text(
                    user.email,
                    style: TextStyle(fontSize: 14, color: Colors.white70),
                  ),
                ],
              ),
            ),

            ListTile(
              leading: Icon(Icons.person),
              title: Text("Home"),
              onTap: () {

              },
            ),

            ListTile(
              leading: Icon(Icons.fitness_center),
              title: Text("Exercícios"),
              onTap: () {
                context.goNamed('selecionar');
              },
            ),

            ListTile(
              leading: Icon(Icons.attach_money),
              title: Text(r"W$ Coin"),
              onTap: () {

              },
            ),

            ListTile(
              leading: Icon(Icons.shop),
              title: Text("Loja"),
              onTap: () {

              },
            ),

            ListTile(
              leading: Icon(Icons.settings),
              title: Text("Configurações"),
              onTap: () {
              },
            ),

            const Divider(),

            ListTile(
              leading: Icon(Icons.logout, color: Colors.red),
              title: Text(
                "Sair",
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
                context.go('/login');
              },
            ),
          ],
        ),
      ),

      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            onPressed: () => Scaffold.of(context).openDrawer(),
            icon: Icon(Icons.menu),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      height: MediaQuery.of(context).size.height * 0.4,
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Text(
                        "Texto do arquivo",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  );
                },
              );
            },
            icon: Icon(Icons.info_outline),
          ),
        ],
      ),
    );
  }
}
