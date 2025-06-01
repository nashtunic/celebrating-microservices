import 'package:flutter/material.dart';
import '../services/search_service.dart';
import '../models/user.dart';
import '../models/celebrity.dart';
import '../models/post.dart';
import '../widgets/user_list_item.dart';
import '../widgets/celebrity_list_item.dart';
import '../widgets/post_list_item.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with SingleTickerProviderStateMixin {
  final SearchService _searchService = SearchService();
  final TextEditingController _searchController = TextEditingController();
  late TabController _tabController;
  List<User> _users = [];
  List<Celebrity> _celebrities = [];
  List<Post> _posts = [];
  bool _isLoading = false;
  String _lastQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _performSearch(String query) async {
    if (query.isEmpty || query == _lastQuery) return;

    setState(() {
      _isLoading = true;
      _lastQuery = query;
    });

    try {
      final results = await _searchService.searchAll(query);
      setState(() {
        _users = results['users'];
        _celebrities = results['celebrities'];
        _posts = results['posts'];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error performing search: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Search...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white70),
          ),
          style: const TextStyle(color: Colors.white),
          onChanged: (query) {
            if (query.length >= 2) {
              _performSearch(query);
            }
          },
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Users'),
            Tab(text: 'Celebrities'),
            Tab(text: 'Posts'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                // Users tab
                _users.isEmpty
                    ? const Center(child: Text('No users found'))
                    : ListView.builder(
                        itemCount: _users.length,
                        itemBuilder: (context, index) {
                          return UserListItem(user: _users[index]);
                        },
                      ),

                // Celebrities tab
                _celebrities.isEmpty
                    ? const Center(child: Text('No celebrities found'))
                    : ListView.builder(
                        itemCount: _celebrities.length,
                        itemBuilder: (context, index) {
                          return CelebrityListItem(
                              celebrity: _celebrities[index]);
                        },
                      ),

                // Posts tab
                _posts.isEmpty
                    ? const Center(child: Text('No posts found'))
                    : ListView.builder(
                        itemCount: _posts.length,
                        itemBuilder: (context, index) {
                          return PostListItem(post: _posts[index]);
                        },
                      ),
              ],
            ),
    );
  }
}
