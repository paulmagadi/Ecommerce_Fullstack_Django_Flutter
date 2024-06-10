import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/profile_provider.dart';

class ProfileFormScreen extends StatefulWidget {
  @override
  _ProfileFormScreenState createState() => _ProfileFormScreenState();
}

class _ProfileFormScreenState extends State<ProfileFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _phoneController;
  late TextEditingController _address1Controller;
  late TextEditingController _address2Controller;
  late TextEditingController _cityController;
  late TextEditingController _stateController;
  late TextEditingController _zipcodeController;
  late TextEditingController _countryController;

  @override
  void initState() {
    super.initState();
    final profile = Provider.of<ProfileProvider>(context, listen: false).profile;
    _phoneController = TextEditingController(text: profile?.phone ?? '');
    _address1Controller = TextEditingController(text: profile?.address1 ?? '');
    _address2Controller = TextEditingController(text: profile?.address2 ?? '');
    _cityController = TextEditingController(text: profile?.city ?? '');
    _stateController = TextEditingController(text: profile?.state ?? '');
    _zipcodeController = TextEditingController(text: profile?.zipcode ?? '');
    _countryController = TextEditingController(text: profile?.country ?? '');
  }

  void _submitProfile() async {
    if (_formKey.currentState!.validate()) {
      try {
        await Provider.of<ProfileProvider>(context, listen: false).updateProfile(
          phone: _phoneController.text,
          address1: _address1Controller.text,
          address2: _address2Controller.text,
          city: _cityController.text,
          state: _stateController.text,
          zipcode: _zipcodeController.text,
          country: _countryController.text,
        );
        Navigator.pushReplacementNamed(context, '/home');
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.toString())),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Complete Profile')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(labelText: 'Phone'),
                ),
                TextFormField(
                  controller: _address1Controller,
                  decoration: InputDecoration(labelText: 'Address 1'),
                ),
                TextFormField(
                  controller: _address2Controller,
                  decoration: InputDecoration(labelText: 'Address 2'),
                ),
                TextFormField(
                  controller: _cityController,
                  decoration: InputDecoration(labelText: 'City'),
                ),
                TextFormField(
                  controller: _stateController,
                  decoration: InputDecoration(labelText: 'State'),
                ),
                TextFormField(
                  controller: _zipcodeController,
                  decoration: InputDecoration(labelText: 'Zip Code'),
                ),
                TextFormField(
                  controller: _countryController,
                  decoration: InputDecoration(labelText: 'Country'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitProfile,
                  child: Text('Submit'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/home');
                  },
                  child: Text('Skip'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
