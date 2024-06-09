import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

Drawer drawer(BuildContext context) {
  final authProvider = Provider.of<AuthProvider>(context);

  return Drawer(
    elevation: 0,
    child: Column(
      children: [
        UserAccountsDrawerHeader(
          decoration: const BoxDecoration(
            color: Colors.blue,
          ),
          currentAccountPicture: const CircleAvatar(
            backgroundImage: AssetImage('assets/images/cassidy.jpg'),
          ),
          accountName: authProvider.isAuthenticated
              ? Text(authProvider.user.email)
              : const Text('Guest'),
          accountEmail: authProvider.isAuthenticated
              ? Text(authProvider.user.email)
              : const Text('Not logged in'),
        ),
        ListTile(
          title: const Text('Home'),
          leading: const Icon(
            Icons.home,
            color: Colors.blue,
          ),
          onTap: () {
            Navigator.pushNamed(context, '/');
          },
        ),
        ListTile(
          title: const Text('Contact Us'),
          leading: const Icon(
            Icons.message,
            color: Colors.blue,
          ),
          onTap: () {
            Navigator.pushNamed(context, '/contact');
          },
        ),
        ListTile(
          title: const Text('About'),
          leading: const Icon(
            Icons.info,
            color: Colors.blue,
          ),
          onTap: () {
            Navigator.pushNamed(context, '/about');
          },
        ),
        ListTile(
          title: const Text('Help'),
          leading: const Icon(
            Icons.help_center,
            color: Colors.blue,
          ),
          onTap: () {
            Navigator.pushNamed(context, '/help');
          },
        ),
        const Spacer(),
        if (authProvider.isAuthenticated) ...[
          ListTile(
            title: const Text('Profile'),
            leading: const Icon(
              Icons.person,
              color: Colors.blue,
            ),
            onTap: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
          ListTile(
            title: const Text('Logout'),
            leading: const Icon(
              Icons.logout,
              color: Colors.blue,
            ),
            onTap: () {
              authProvider.logout();
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ] else ...[
          ListTile(
            title: const Text('Login'),
            leading: const Icon(
              Icons.login,
              color: Colors.blue,
            ),
            onTap: () {
              Navigator.pushNamed(context, '/login');
            },
          ),
          ListTile(
            title: const Text('Register'),
            leading: const Icon(
              Icons.app_registration,
              color: Colors.blue,
            ),
            onTap: () {
              Navigator.pushNamed(context, '/register');
            },
          ),
        ],
      ],
    ),
  );
}
