import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/profile_provider.dart';

Drawer appDrawer(BuildContext context) {
  final authProvider = Provider.of<AuthProvider>(context);
  // final profileProvider = Provider.of<ProfileProvider>(context);

  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        if (authProvider.isAuthenticated)
          Consumer<ProfileProvider>(
            builder: (context, profileProvider, child) {
              return UserAccountsDrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.blue,
                ),
                accountName: Text(authProvider.userName ?? 'User Name'),
                accountEmail:
                    Text(authProvider.userEmail ?? 'user@example.com'),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: profileProvider.profile?.image != null
                      ? NetworkImage(profileProvider.profile!.image!)
                      : const AssetImage('assets/default_user.png')
                          as ImageProvider,
                ),
              );
            },
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
        ListTile(
          leading: const Icon(Icons.shopping_basket),
          title: const Text('Products'),
          onTap: () {
            Navigator.pushNamed(context, '/product_list');
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
