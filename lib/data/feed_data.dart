import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';
import 'package:video_player/video_player.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/feed.dart';
import '../utils/constants.dart';

class FeedViewModel extends BaseViewModel {
  List<Feed> listVideos = List<Feed>();
  VideoPlayerController controller;

  //initial value defination
  int prevVideo = 0;

  int actualScreen = 0;

  FeedViewModel() {
    load();
  }

  void load() async {
    listVideos = await getVideoList();
    await  loadVideo(0);


  }
  //api call for fetching data
  Future<List<Feed>> getVideoList() async {
    http.Response response = await http
        .get(Constants.FEED_BASE_API)
        .timeout(Duration(seconds: Constants.NETWORK_TIMEOUT_SECONDS),
        onTimeout: () => throw Exception);

    if (response.statusCode == 200) {
      if (response.body
          .toString()
          .trim()
          .length > 2) {
        //Decoding and parsing the json to FeedCategory model
        var responseData = jsonDecode(response.body);
        var documents = responseData as List;
        var videoList = <Feed>[];
        var videos;

        if (documents.length == 0) {
          return List<Feed>();
        } else {
          videos = documents;
        }


        videos.forEach((element) {
          Feed video = Feed.fromJSON(element);
          videoList.add(video);
        });

        return videoList;

      } else {
        return List<Feed>();
      }
    } else {
      // If service call was not successful, throw an error.
      throw Exception(Constants.INVALID_RESPONSE);
    }

  }
// change video
  changeVideo(index) async {
    listVideos[prevVideo].controller.pause();
    if (listVideos[index].controller == null) {
      await listVideos[index].loadController();
    }
    listVideos[index].controller.play();
    listVideos[prevVideo].controller.removeListener(() {});

    //videoSource.listVideos[prevVideo].controller.dispose();

    prevVideo = index;
    notifyListeners();

  }
//load video
  void loadVideo(int index) async {
    await listVideos[index].loadController();
    listVideos[index].controller.play();
    notifyListeners();
  }

//set screen overlay
  void setActualScreen(index) {
    actualScreen = index;
    if (index == 0) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    } else {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    }
    notifyListeners();
  }
}