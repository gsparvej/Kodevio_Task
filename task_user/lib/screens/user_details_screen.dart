import 'package:flutter/material.dart';
import '../models/user_model.dart';

class UserDetailsScreen extends StatelessWidget {
  final User user;

  const UserDetailsScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // হালকা ব্যাকগ্রাউন্ড কালার
      appBar: AppBar(
        title: const Text('User Profile'),
        elevation: 0,
        backgroundColor: Colors.deepPurple, // প্রফেশনাল কালার থিম
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ১. হেডার সেকশন (Profile Picture + Name)
            _buildHeader(),

            const SizedBox(height: 20),

            // ২. কন্টাক্ট ইনফরমেশন (Email, Phone, Website)
            _buildSectionCard(
              title: 'Contact Info',
              icon: Icons.contact_page,
              child: Column(
                children: [
                  _buildListTile(
                    icon: Icons.email_outlined,
                    title: 'Email',
                    subtitle: user.email,
                  ),
                  _buildDivider(),
                  _buildListTile(
                    icon: Icons.phone_outlined,
                    title: 'Phone',
                    subtitle: user.phone,
                  ),
                  _buildDivider(),
                  _buildListTile(
                    icon: Icons.language_outlined,
                    title: 'Website',
                    subtitle: user.website,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ৩. ঠিকানা সেকশন
            _buildSectionCard(
              title: 'Address',
              icon: Icons.location_on_outlined,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${user.address.street}, ${user.address.suite}',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${user.address.city}, ${user.address.zipcode}',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ৪. কোম্পানি সেকশন
            _buildSectionCard(
              title: 'Company',
              icon: Icons.business_outlined,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.company.name,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    user.company.catchPhrase,
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30), // নিচে কিছু ফাঁকা জায়গা
          ],
        ),
      ),
    );
  }

  // হেডার বিল্ড করার মেথড
  Widget _buildHeader() {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 10),
          // প্রোফাইল পিকচার বা অবতার
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 4),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.deepPurple.shade100,
              child: Text(
                user.name[0], // নামের প্রথম অক্ষর
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple.shade800,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // নাম
          Text(
            user.name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          // ইউজারনেম
          Text(
            '@${user.username}',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  // সেকশন কার্ড বিল্ড করার মেথড (রিয়েজেবল উইজেট)
  Widget _buildSectionCard({required String title, required IconData icon, required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // সেকশন টাইটেল
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 16, bottom: 8),
            child: Row(
              children: [
                Icon(icon, size: 20, color: Colors.deepPurple),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: child,
          ),
        ],
      ),
    );
  }

  // লিস্ট আইটেম বিল্ড করার মেথড
  Widget _buildListTile({required IconData icon, required String title, required String subtitle}) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 20, color: Colors.grey[700]),
      ),
      title: Text(
        title,
        style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontSize: 15, color: Colors.black87),
      ),
    );
  }

  // বিভাজক লাইন (Divider)
  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Divider(height: 1, color: Colors.grey[300]),
    );
  }
}