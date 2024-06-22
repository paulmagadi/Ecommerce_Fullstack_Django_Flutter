import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/profile_provider.dart';

Drawer appDrawer(BuildContext context) {
  final authProvider = Provider.of<AuthProvider>(context);
  final profileProvider = Provider.of<ProfileProvider>(context);

  // Fetch profile if not already fetched
  if (authProvider.isAuthenticated && profileProvider.profile == null) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      profileProvider.fetchProfile();
    });
  }

  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        if (authProvider.isAuthenticated)
          Consumer<ProfileProvider>(
            builder: (context, profileProvider, child) {
              return UserAccountsDrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.orange,
                ),
                accountName: Text(authProvider.userName ?? 'User Name'),
                accountEmail:
                    Text(authProvider.userEmail ?? 'user@example.com'),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: profileProvider.profile?.image != null
                      ? NetworkImage(profileProvider.profile!.image!)
                      : const AssetImage('assets/images/pic.png')
                          as ImageProvider,
                ),
              );
            },
          )
        else
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.orange,
            ),
            child: Text(
              'Welcome Guest',
              style: TextStyle(color: Colors.white),
            ),
          ),
        _createDrawerItem(
          icon: Icons.home,
          
          text: 'Home',
          onTap: () => Navigator.pushReplacementNamed(context, '/'),
        ),
        _createDrawerItem(
          icon: Icons.shopping_basket,
          text: 'Products',
          onTap: () => Navigator.pushNamed(context, '/product_list'),
        ),
        if (authProvider.isAuthenticated)
          _createDrawerItem(
            icon: Icons.person,
            text: 'Profile',
            onTap: () => Navigator.pushNamed(context, '/profile'),
          ),
        _createDrawerItem(
          icon: Icons.info,
          text: 'About',
          onTap: () => Navigator.pushNamed(context, '/about'),
        ),
        _createDrawerItem(
          icon: Icons.help,
          text: 'Help',
          onTap: () => Navigator.pushNamed(context, '/help'),
        ),
        if (authProvider.isAuthenticated)
          _createDrawerItem(
            icon: Icons.logout,
            
            text: 'Logout',
            onTap: () {
              authProvider.logout();
              Navigator.pushReplacementNamed(context, '/');
            },
          )
        else
          _createDrawerItem(
            icon: Icons.login,
            text: 'Login',
            onTap: () => Navigator.pushNamed(context, '/login'),
          ),
        if (!authProvider.isAuthenticated)
          _createDrawerItem(
            icon: Icons.person_add,
            text: 'Register',
            onTap: () => Navigator.pushNamed(context, '/register'),
          ),
      ],
    ),
  );
}

Widget _createDrawerItem({
  required IconData icon,
  required String text,
  required GestureTapCallback onTap,
}) {
  return ListTile(
    leading: Icon(icon),
    title: Text(text),
    onTap: onTap,
  );
}
