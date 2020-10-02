import 'package:video_player/video_player.dart';

//Model class used for feed categories
class Feed {
  //final int categoryID;
  final String url;
  final  int commentcount;
  final  int sharecount;
  final  int likecount;
  final String name;
  final String image;
  final String title;

  VideoPlayerController controller;
  Feed({this.name, this.image, this.title,this.commentcount,this.likecount,this.sharecount,this.url});

  //Parsing the JSON and keeping the values
  factory Feed.fromJSON(Map<String, dynamic> json) {
    // print(json["fields"]["categoryid"]["integerValue"]);
    return Feed(
      // categoryID: json["fields"]["categoryid"]["integerValue"],
        name: json["user"]["name"],
        image: json["user"]["headshot"],
        title: json["title"],
        commentcount:json["comment-count"],
        likecount: json["like-count"],
        sharecount: json["share-count"],
        url: json["url"],

    );
  }
//to load the video from url
  Future<Null> loadController() async {
    controller = VideoPlayerController.network(url);
    await controller.initialize();
    controller.setLooping(true);

  }


}