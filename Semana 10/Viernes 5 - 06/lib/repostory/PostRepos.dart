import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/PostDataModel.dart';

class Postrepos {
  
  static Future<List<PostDataModel>> fetchPost() async{
    var client=http.Client();
    
    List<PostDataModel> post=[];
    
    try{
      var response=await client.get(Uri.parse("https://jsonplaceholder.typicode.com/posts"),
      headers: {'Accept':'application/json'});

      List result=jsonDecode(response.body);

      for(int i=0;i<result.length;i++){
        PostDataModel p=PostDataModel.objJson(
          result[i] as Map<String,dynamic>);
        post.add(p);
      }
      return post;
    }catch(e){
      return [];
    }
    
  }
  
}