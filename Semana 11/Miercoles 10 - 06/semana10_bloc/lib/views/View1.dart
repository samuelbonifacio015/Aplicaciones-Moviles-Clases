import 'package:flutter/material.dart';
import '../bloc/PostBloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';



class View1 extends StatefulWidget {
  const View1({super.key});

  @override
  State<View1> createState() => _View1State();
}

class _View1State extends State<View1> {

  final PostBloc postsBloc=PostBloc();
  @override
  void initState() {
    super.initState();
    postsBloc.add(PostsInitialFetchEvent());
  }

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bloc Http'),
        backgroundColor: Colors.amber,
        foregroundColor: Colors.white,
      ),

      body: BlocConsumer<PostBloc,Poststate>(
          bloc: postsBloc,
          listener: (context,state){},
          builder:(context,state){
            switch(state.runtimeType){
              case PostFechingSuccessfullState:
                final successState=state as PostFechingSuccessfullState;
                return Container(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ListView.builder(
                        itemCount: successState.posts.length,
                        itemBuilder: (context,index){
                          return Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('ID: '+successState.posts[index].id.toString()),
                                  Text('Title: '+successState.posts[index].title.toString()),
                                  Text('Body: '+successState.posts[index].body.toString()),
                                ],
                              ),
                            ),
                          );
                        }),
                  ),
                );
                default:
                  return const SizedBox();
            }
            return Container();
    }
      ),

    );
  }


}
