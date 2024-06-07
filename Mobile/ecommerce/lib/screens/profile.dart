import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';

// class ProfileScreen extends StatelessWidget {
//   const ProfileScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(child: 
//     SingleChildScrollView(
//       child: Row(
//         children: [
//           Text('Account')
//         ],
//       ),
//     ));
//   }
// }


// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../providers/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    if (authProvider.isAuthenticated) {
      return Scaffold(
        appBar: AppBar(title: Text('Profile')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Welcome! You are logged in.'),
              ElevatedButton(
                onPressed: () {
                  authProvider.logout();
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: Text('Logout'),
              ),
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(title: Text('Profile')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('You are not logged in.'),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: Text('Login'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/register');
                },
                child: Text('Register'),
              ),
            ],
          ),
        ),
      );
    }
  }
}




