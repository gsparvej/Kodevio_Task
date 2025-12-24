import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';
import 'user_details_screen.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final ApiService _apiService = ApiService();
  final TextEditingController _searchController = TextEditingController();

  // ডাটা রাখার জন্য ভেরিয়েবল
  List<User> _allUsers = [];
  List<User> _filteredUsers = [];

  // স্টেট ভেরিয়েবল (Loading, Error)
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
    // সার্চ বারে লেখার পরিবর্তন ধরার জন্য লিসেনার
    _searchController.addListener(_onSearchChanged);
  }

  // API থেকে ইউজার আনা
  Future<void> _fetchUsers() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final users = await _apiService.fetchUsers();
      setState(() {
        _allUsers = users;
        // শুরুতে সব ইউজার দেখাবে
        _filteredUsers = users;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load users. Please check your internet.';
        _isLoading = false;
      });
    }
  }

  // সার্চ লজিক (নাম দিয়ে ফিল্টার)
  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredUsers = _allUsers
          .where((user) => user.name.toLowerCase().contains(query))
          .toList();
    });
  }

  // রিফ্রেশ করার ফাংশন (Pull to Refresh)
  Future<void> _refreshUsers() async {
    _searchController.clear(); // রিফ্রেশের সময় সার্চ ক্লিয়ার হবে
    await _fetchUsers();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
        elevation: 2,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search users by name...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshUsers,
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    // ১. যদি লোডিং চলছে
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // ২. যদি এরর থাকে
    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 48),
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _fetchUsers,
                icon: const Icon(Icons.refresh),
                label: const Text('Try Again'),
              )
            ],
          ),
        ),
      );
    }

    // ৩. যদি ডাটা খালি থাকে (সার্চের পর কিছু না পাওয়া গেলে)
    if (_filteredUsers.isEmpty) {
      return const Center(
        child: Text(
          'No users found.',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }

    // ৪. লিস্ট দেখানো
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: _filteredUsers.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final user = _filteredUsers[index];
        return _buildUserTile(user);
      },
    );
  }

  Widget _buildUserTile(User user) {
    return Card(
      elevation: 2, // সামান্য শ্যাডো
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: Colors.deepPurple.shade100,
          child: Text(
            user.name[0], // নামের প্রথম অক্ষর
            style: TextStyle(color: Colors.deepPurple.shade800, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          user.name,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.email,
                style: const TextStyle(fontSize: 13),
              ),
              const SizedBox(height: 4),
              // রিকোয়ারমেন্ট অনুযায়ী কোম্পানির নাম যোগ করা হয়েছে
              Text(
                user.company.name,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => UserDetailsScreen(user: user),
            ),
          );
        },
      ),
    );
  }
}