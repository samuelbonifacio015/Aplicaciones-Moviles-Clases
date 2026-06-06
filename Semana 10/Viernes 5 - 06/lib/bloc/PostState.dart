part of 'PostBloc.dart';

abstract class Poststate {}

class PostFechingSuccessfullState extends Poststate{

  final List<PostDataModel> posts;
  PostFechingSuccessfullState({
    required this.posts
});

}