

import '../beans/Post.dart';

class ListPost {

  static List<Post> listaPost(List<dynamic> listaJson) {
    List<Post> listadoPost = [];

    if (listaJson != null) {
      for (var p in listaJson) {
        final po = Post.objJson(p);
        listadoPost.add(po);
      }
    }

    return listadoPost;
  }
}