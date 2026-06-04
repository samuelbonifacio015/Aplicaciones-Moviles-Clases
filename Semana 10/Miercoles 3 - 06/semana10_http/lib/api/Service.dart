

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:semana10_http/beans/Post.dart';

import 'ListPost.dart';

class Service {

  static Future <List<Post>> getPost() async {
    final rspta = await http.get(
        Uri.parse('https://jsonplaceholder.typicode.com/posts'),
        headers: {'Accept': 'application/json'});

    if (rspta.statusCode == 200) {
      final rsptaJSON = json.decode(rspta.body);
      final todosPost = ListPost.listaPost(rsptaJSON);
      return todosPost;
    }
    return <Post>[];
  }
}