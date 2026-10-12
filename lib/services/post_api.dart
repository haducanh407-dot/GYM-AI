import 'dart:convert';

import '../models/comment.dart';
import '../models/post.dart';
import 'api_client.dart';

class PostApi {
  PostApi({List<Post>? initialPosts}) : _posts = [...?initialPosts];

  factory PostApi.seeded() {
    final now = DateTime(2026, 10, 9, 20);
    return PostApi(
      initialPosts: [
        Post(
          id: 'post-1',
          authorName: 'Linh Nguyen',
          avatarAsset: 'assets/images/avatar.jpg',
          content: 'Hom nay pha ky luc ca nhan Squat 100kg! Nho AI kiem tra form dung goc do cuc chuan luon.',
          imageAsset: 'assets/images/community.jpg',
          createdAt: now.subtract(const Duration(hours: 2)),
          likeCount: 128,
          comments: [
            Comment(
              id: 'comment-seed-1',
              authorName: 'Minh Anh',
              content: 'Qua dinh! Cung co gang nhe.',
              createdAt: now.subtract(const Duration(hours: 1)),
            ),
          ],
        ),
        Post(
          id: 'post-2',
          authorName: 'AI GYM Club',
          avatarAsset: 'assets/images/trainer.jpg',
          content: 'Thu thach 7 ngay: moi ngay them 10 phut cardio sau buoi tap chinh.',
          createdAt: now.subtract(const Duration(hours: 5)),
          likeCount: 47,
          comments: const [],
          tag: 'Thu thach',
        ),
      ],
    );
  }

  final List<Post> _posts;
  var _nextCommentId = 2;

  Future<List<Post>> getPosts() async {
    final response = await ApiClient.instance.get('/api/posts', includeAuth: true);
    if (response.statusCode != 200) {
      throw ApiException(response.statusCode, 'Không thể tải bài viết từ máy chủ.');
    }

    final decoded = jsonDecode(response.body) as List<dynamic>;
    final posts = decoded
        .map((item) => _fromJson(item as Map<String, dynamic>))
        .toList();
    _posts
      ..clear()
      ..addAll(posts);
    return List.unmodifiable(posts);
  }

  Future<Post?> createPost(String content) async {
    final trimmed = content.trim();
    if (trimmed.isEmpty) return null;

    final response = await ApiClient.instance.post(
      '/api/posts',
      {'content': trimmed, 'tag': 'Bai viet'},
      includeAuth: true,
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw ApiException(response.statusCode, 'Không thể tạo bài viết.');
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final post = _fromJson(decoded);
    _posts.insert(0, post);
    return post;
  }

  Future<Post?> updatePost(String postId, String content) async {
    final trimmed = content.trim();
    if (trimmed.isEmpty) return null;

    final response = await ApiClient.instance.put(
      '/api/posts/$postId',
      {'content': trimmed},
      includeAuth: true,
    );
    if (response.statusCode != 200) {
      throw ApiException(response.statusCode, 'Không thể cập nhật bài viết.');
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final updated = _fromJson(decoded);

    final index = _posts.indexWhere((post) => post.id == postId);
    if (index != -1) {
      _posts[index] = updated;
    }
    return updated;
  }

  Future<void> deletePost(String postId) async {
    final response = await ApiClient.instance.delete(
      '/api/posts/$postId',
      includeAuth: true,
    );
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw ApiException(response.statusCode, 'Không thể xóa bài viết.');
    }
    _posts.removeWhere((post) => post.id == postId);
  }

  Future<Post?> toggleLike(String postId) async {
    final index = _posts.indexWhere((post) => post.id == postId);
    if (index == -1) return null;
    final post = _posts[index];
    final liked = !post.liked;
    final updated = post.copyWith(
      liked: liked,
      likeCount: liked ? post.likeCount + 1 : post.likeCount - 1,
    );
    _posts[index] = updated;
    return updated;
  }

  Future<Post?> addComment(String postId, String content) async {
    final trimmed = content.trim();
    if (trimmed.isEmpty) return null;
    final index = _posts.indexWhere((post) => post.id == postId);
    if (index == -1) return null;
    final post = _posts[index];
    final comment = Comment(
      id: 'comment-${_nextCommentId++}',
      authorName: 'Ban',
      content: trimmed,
      createdAt: DateTime.now(),
    );
    final updated = post.copyWith(comments: [...post.comments, comment]);
    _posts[index] = updated;
    return updated;
  }

  Post _fromJson(Map<String, dynamic> json) => Post(
        id: (json['id'] ?? '').toString(),
        authorName: (json['authorName'] ?? 'User').toString(),
        avatarAsset: 'assets/images/avatar.jpg',
        content: (json['content'] ?? '').toString(),
        createdAt: DateTime.tryParse((json['createdAt'] ?? '').toString()) ??
            DateTime.now(),
        likeCount: int.tryParse((json['likeCount'] ?? '0').toString()) ?? 0,
        comments: const [],
        imageAsset: json['imageAsset']?.toString(),
        liked: json['liked'] == true,
        tag: (json['tag'] ?? 'Bai viet').toString(),
      );
}
