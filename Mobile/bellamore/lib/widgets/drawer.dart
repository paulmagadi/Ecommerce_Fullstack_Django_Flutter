import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

Drawer appDrawer(BuildContext context) {
  final authProvider = Provider.of<AuthProvider>(context);

  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
         UserAccountsDrawerHeader(
          decoration: const BoxDecoration(
            color: Colors.blue,
          ),
          currentAccountPicture: const CircleAvatar(
            backgroundImage: AssetImage('assets/images/cassidy.jpg'),
          ),
          // accountName: authProvider.isAuthenticated
              // ? Text(authProvider.user.firstName)
              // : const Text('Guest'),
          // accountEmail: authProvider.isAuthenticated
              // ? Text(authProvider.user)
              // : const Text('Not logged in'),
        ),
        ListTile(
          leading: const Icon(Icons.home),
          title: const Text('Home'),
          onTap: () {
            Navigator.pushReplacementNamed(context, '/');
          },
        ),
        ListTile(
          leading: const Icon(Icons.info),
          title: const Text('About'),
          onTap: () {
            Navigator.pushNamed(context, '/about');
          },
        ),
        ListTile(
          leading: const Icon(Icons.help),
          title: const Text('Help'),
          onTap: () {
            Navigator.pushNamed(context, '/help');
          },
        ),
        const Divider(),
        if (authProvider.isAuthenticated)
          Column(
            children: [
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Profile'),
                onTap: () {
                  Navigator.pushNamed(context, '/profile');
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                onTap: () {
                  authProvider.logout();
                  Navigator.pushReplacementNamed(context, '/');
                },
              ),
            ],
          )
        else
          Column(
            children: [
              ListTile(
                leading: const Icon(Icons.person_add),
                title: const Text('Register'),
                onTap: () {
                  Navigator.pushNamed(context, '/register');
                },
              ),
              ListTile(
                leading: const Icon(Icons.login),
                title: const Text('Login'),
                onTap: () {
                  Navigator.pushNamed(context, '/login');
                },
              ),
            ],
          ),
      ],
    ),
  );
}
