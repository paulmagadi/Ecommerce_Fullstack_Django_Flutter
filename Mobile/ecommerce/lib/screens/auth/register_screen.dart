import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';

class RegisterScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _emailController, decoration: InputDecoration(labelText: 'Email')),
            TextField(controller: _passwordController, decoration: InputDecoration(labelText: 'Password')),
            TextField(controller: _firstNameController, decoration: InputDecoration(labelText: 'First Name')),
            TextField(controller: _lastNameController, decoration: InputDecoration(labelText: 'Last Name')),
            ElevatedButton(
              onPressed: () async {
                await authProvider.register(
                  _emailController.text,
                  _passwordController.text,
                  _firstNameController.text,
                  _lastNameController.text,
                );
                if (authProvider.isAuthenticated) {
                  Navigator.pushReplacementNamed(context, '/home');
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Registration failed')));
                }
              },
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
