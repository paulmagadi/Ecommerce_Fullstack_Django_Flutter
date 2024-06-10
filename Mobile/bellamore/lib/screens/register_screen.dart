import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'profile_screen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _email, _password1, _password2, _firstName, _lastName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                onSaved: (value) {
                  _email = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                onSaved: (value) {
                  _password1 = value;
                },
                validator: (value) {
                  if (value == null || value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Confirm Password'),
                obscureText: true,
                onSaved: (value) {
                  _password2 = value;
                },
                validator: (value) {
                  if (value == null || _password2 != _password1) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'First Name'),
                onSaved: (value) {
                  _firstName = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Last Name'),
                onSaved: (value) {
                  _lastName = value;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    _formKey.currentState?.save();
                    if (_email != null && _password1 != null && _password2 != null && _firstName != null && _lastName != null) {
                      try {
                        await Provider.of<AuthProvider>(context, listen: false)
                            .register(_email!, _password1!, _password2!, _firstName!, _lastName!);
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => ProfileScreen()),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Registration failed')),
                        );
                      }
                    }
                  }
                },
                child: Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
