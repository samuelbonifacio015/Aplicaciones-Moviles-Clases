import 'dart:async';
import 'package:bloc/bloc.dart';
import '../repostory/PostRepos.dart';
import '../models/PostDataModel.dart';

part 'PostEvent.dart';
part 'PostState.dart';

class PostBloc extends Bloc<Postevent,Poststate>{

  PostBloc():super(PostFechingSuccessfullState(posts: [])){
    on<PostsInitialFetchEvent>(postsInitialFechEvent);
  }

  FutureOr<void> postsInitialFechEvent(event,Emitter<dynamic> emit) async{
    List<PostDataModel> posts=await Postrepos.fetchPost();
    emit(PostFechingSuccessfullState(posts: posts));
  }

}