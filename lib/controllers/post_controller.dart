import 'package:flutter/foundation.dart';

import '../models/post.dart';
import '../services/post_api.dart';

class PostController extends ChangeNotifier {
  PostController({required this.api});

  final PostApi api;
  var _posts = <Post>[];
  var _loading = false;

  List<Post> get posts => List.unmodifiable(_posts);
  bool get loading => _loading;

  Future<void> loadPosts() async {
    _loading = true;
    notifyListeners();
    _posts = await api.getPosts();
    _loading = false;
    notifyListeners();
  }

  Future<bool> createPost(String content) async {
    final post = await api.createPost(content);
    if (post == null) return false;
    await _refresh();
    return true;
  }

  Future<bool> updatePost(String postId, String content) async {
    final post = await api.updatePost(postId, content);
    if (post == null) return false;
    await _refresh();
    return true;
  }

  Future<void> deletePost(String postId) async {
    await api.deletePost(postId);
    await _refresh();
  }

  Future<void> toggleLike(String postId) async {
    await api.toggleLike(postId);
    await _refresh();
  }

  Future<bool> addComment(String postId, String content) async {
    final post = await api.addComment(postId, content);
    if (post == null) return false;
    await _refresh();
    return true;
  }

  Future<void> _refresh() async {
    _posts = await api.getPosts();
    notifyListeners();
  }
}
