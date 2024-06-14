import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/profile_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final profileProvider = Provider.of<ProfileProvider>(context);

    // Fetch profile if not already fetched
    if (authProvider.isAuthenticated && profileProvider.profile == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        profileProvider.fetchProfile();
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: authProvider.isAuthenticated
          ? Consumer<ProfileProvider>(
              builder: (context, profileProvider, child) {
                if (profileProvider.profile == null) {
                  return const Center(child: CircularProgressIndicator());
                }
                final profile = profileProvider.profile!;
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: profile.image != null
                            ? NetworkImage(profile.image!)
                            : const AssetImage('assets/images/pic.png')
                                as ImageProvider,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        authProvider.userName ?? 'Name',
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Email: ${authProvider.userEmail ?? 'user@example.com'}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Phone: ${profile.phone ?? 'N/A'}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Address: ${profile.address1 ?? 'N/A'}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/profile_form');
                        },
                        child: const Text('Edit Profile Info'),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/shipping_address_form');
                        },
                        child: const Text('Edit Shipping Address'),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          authProvider.logout();
                          Navigator.pushReplacementNamed(context, '/');
                        },
                        child: const Text('Logout'),
                      ),
                    ],
                  ),
                );
              },
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('You are not logged in.'),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    child: const Text('Login'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/register');
                    },
                    child: const Text('Register'),
                  ),
                ],
              ),
            ),
    );
  }
}
