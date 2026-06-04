import 'package:flutter/material.dart';
import '../api/Service.dart';
import '../beans/Post.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Posts'),
        backgroundColor: Colors.amber,
      ),
      body: FutureBuilder<List<Post>>(
        future: Service.getPost(),
        builder: (context, AsyncSnapshot<List<Post>> snapshot) {
          // Loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Error state
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          // No data or empty list
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No posts found'));
          }

          // Data ready (safe to use snapshot.data!)
          final posts = snapshot.data!;
          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final posteo = posts[index];
              return ListTile(
                title: Text('Id: ${posteo.id}'),
                subtitle: Text('Title: ${posteo.title}'),
              );
            },
          );
        },
      ),
    );
  }
}
