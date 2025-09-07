import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/post_model.dart';
import '../../core/constants/app_constants.dart';

class PostsService {
  Future<List<PostModel>> getPosts({
    int start = 0,
    int limit = AppConstants.postsPerPage,
  }) async {
    try {
      final response = await http.get(
        Uri.parse(
            '${AppConstants.baseUrl}${AppConstants.postsEndpoint}?_start=$start&_limit=$limit'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList =
            jsonDecode(response.body) as List<dynamic>;
        return jsonList
            .map((json) => PostModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to load posts: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load posts: $e');
    }
  }

  Future<PostModel?> getPostById(int id) async {
    try {
      final response = await http.get(
        Uri.parse('${AppConstants.baseUrl}${AppConstants.postsEndpoint}/$id'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> json =
            jsonDecode(response.body) as Map<String, dynamic>;
        return PostModel.fromJson(json);
      } else {
        throw Exception('Failed to load post: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load post: $e');
    }
  }
}
