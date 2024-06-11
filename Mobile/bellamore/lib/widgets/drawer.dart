import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

Drawer appDrawer(BuildContext context) {
  final authProvider = Provider.of<AuthProvider>(context);

  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        if (authProvider.isAuthenticated) 
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
            accountName: Text(authProvider.userName ?? 'User Name'),
            accountEmail: Text(authProvider.userEmail ?? 'user@example.com'),
            currentAccountPicture: CircleAvatar(
              // backgroundImage: authProvider.userImage != null
                  // ? NetworkImage(authProvider.userImage!)
                  //  const AssetImage('assets/default_user.png') as ImageProvider, // Provide a default image if none is set
            ),
          )
        else
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text('Welcome Guest'),
          ),
        ListTile(
          leading: const Icon(Icons.home),
          title: const Text('Home'),
          onTap: () {
            Navigator.pushReplacementNamed(context, '/');
          },
        ),
        if (authProvider.isAuthenticated) 
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () {
              Navigator.pushNamed(context, '/profile');
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
        if (authProvider.isAuthenticated) 
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              authProvider.logout();
              Navigator.pushReplacementNamed(context, '/');
            },
          )
        else
          ListTile(
            leading: const Icon(Icons.login),
            title: const Text('Login'),
            onTap: () {
              Navigator.pushNamed(context, '/login');
            },
          ),
        if (!authProvider.isAuthenticated)
          ListTile(
            leading: const Icon(Icons.person_add),
            title: const Text('Register'),
            onTap: () {
              Navigator.pushNamed(context, '/register');
            },
          ),
      ],
    ),
  );
}
