import '../../../core/usecases/constants.dart';
import '../../../core/models/post_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'comment_post.dart';



class SearchPost extends SearchDelegate<PostModel?> {


  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        tooltip: 'clear'.tr,
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      tooltip: 'back'.tr,
      icon: const Icon(Icons.arrow_back_ios),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(
      child: Text('no_result_found'.tr),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<List<PostModel>>(
      future: query == "" ? null : postController.fetchPost(query),
      builder: (context, snapshot) => query == ''
          ? Container() : snapshot.hasData
          ? ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 16),
        itemBuilder: (context, index) => ListTile(
          title: Text((snapshot.data![index]).content),
          onTap: () async {
            // close(context, snapshot.data![index]);
            final model = snapshot.data![index];
            final userAuthor = await userLogic.getUserById(model.uid);
            Get.to(() => CommentPost(
              author: userAuthor!,
              post: model,
            ));
          },
        ),
        separatorBuilder: (BuildContext context, int index) {
          return const Divider(thickness: 1.0);
        },
        itemCount: snapshot.data?.length??0,
      ) : const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
