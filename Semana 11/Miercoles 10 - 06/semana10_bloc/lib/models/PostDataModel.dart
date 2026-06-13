

class PostDataModel {

  int userId;
  int id;
  String title;
  String body;

  PostDataModel({
    required this.userId,
    required this.id,
    required this.title,
    required this.body
});

  static PostDataModel objJson(Map<String,dynamic> json){
    return PostDataModel(
        userId: json['userId'] as int,
        id: json['id'] as int,
        title: json['title'] as String,
        body: json['body'] as String);
  }

}