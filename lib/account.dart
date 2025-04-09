import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final email = user?.email ?? 'No email found';
    final name = user?.displayName ?? 'Your Name'; 

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          // Top green section with profile
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 40),
            decoration: BoxDecoration(
              color: Colors.green.shade700,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 45,
                  backgroundImage: AssetImage('assets/profile.png'), 
                ),
                const SizedBox(height: 12),
                Text(
                  name,
                  style: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  email,
                  style: const TextStyle(fontSize: 14, color: Colors.white70),
                ),
              ],
            ),
          ),

          // Settings list
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(top: 20),
              children: [
                _ProfileOption(
                  icon: Icons.bookmark_border,
                  label: 'Saved Recipes',
                  onTap: () {},
                ),
                _ProfileOption(
                  icon: Icons.workspace_premium,
                  label: 'Super Plan',
                  onTap: () {},
                ),
                _ProfileOption(
                  icon: Icons.language,
                  label: 'Change Language',
                  onTap: () {},
                ),
                _ProfileOption(
                  icon: Icons.help_outline,
                  label: 'Help',
                  onTap: () {},
                ),
                _ProfileOption(
                  icon: Icons.logout,
                  label: 'Logout',
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.popUntil(context, (route) => route.isFirst); // go back to login
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              'EDIT',
              style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

// Reusable tile widget
class _ProfileOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ProfileOption({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.green[800]),
      title: Text(label, style: const TextStyle(fontSize: 16)),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}

