import 'package:flutter/material.dart';
import '../../../data/models/post_model.dart';
import '../../../data/services/posts_service.dart';
import '../../../core/constants/app_constants.dart';

class PostsViewModel extends ChangeNotifier {
  final PostsService _service = PostsService();

  List<PostModel> _posts = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  String? _error;
  bool _hasMore = true;
  int _currentPage = 0;
  bool _initialized = false;

  List<PostModel> get posts => _posts;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  String? get error => _error;
  bool get hasMore => _hasMore;
  bool get isInitialized => _initialized;

  void initializeIfNeeded() {
    if (_initialized) return;
    _initialized = true;
    // Trigger initial load after current frame to avoid notifyListeners during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // ignore: discarded_futures
      loadPosts(refresh: true);
    });
  }

  Future<void> loadPosts({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 0;
      _posts.clear();
      _hasMore = true;
    }

    if (!_hasMore) return;

    _setLoading(true);
    _setError(null);

    try {
      final newPosts = await _service.getPosts(
        start: _currentPage * AppConstants.postsPerPage,
        limit: AppConstants.postsPerPage,
      );

      if (refresh) {
        _posts = newPosts;
      } else {
        _posts.addAll(newPosts);
      }

      _hasMore = newPosts.length == AppConstants.postsPerPage;
      _currentPage++;

      notifyListeners();
    } catch (e) {
      _setError(
          'Failed to load posts. Please check your connection and try again.');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadMorePosts() async {
    if (_isLoadingMore || !_hasMore) return;

    _setLoadingMore(true);

    try {
      final newPosts = await _service.getPosts(
        start: _currentPage * AppConstants.postsPerPage,
        limit: AppConstants.postsPerPage,
      );

      _posts.addAll(newPosts);
      _hasMore = newPosts.length == AppConstants.postsPerPage;
      _currentPage++;

      notifyListeners();
    } catch (e) {
      _setError('Could not load more posts. Please try again.');
    } finally {
      _setLoadingMore(false);
    }
  }

  Future<void> retry() async {
    await loadPosts(refresh: true);
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setLoadingMore(bool loading) {
    _isLoadingMore = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  void clearError() {
    _setError(null);
  }
}
