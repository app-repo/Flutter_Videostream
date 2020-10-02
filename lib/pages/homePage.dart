import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../model/feed.dart';
import '../data/feed_data.dart';
import '../widgets/toolbar.dart';
import '../widgets/description.dart';
import 'package:get_it/get_it.dart';
import 'package:stacked/stacked.dart';
import 'package:video_player/video_player.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final locator = GetIt.instance;
  final feedViewModel = GetIt.instance<FeedViewModel>();
  @override
  void initState() {
    feedViewModel.load();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<FeedViewModel>.reactive(
        disposeViewModel: false,
        builder: (context, model, child) => videoScreen(),
        viewModelBuilder: () => feedViewModel);
  }

//set full screen for video
  Widget videoScreen() {
    return Scaffold(
      backgroundColor: GetIt.instance<FeedViewModel>().actualScreen == 0
          ? Colors.black
          : Colors.white,
      body: Stack(
        children: [
          PageView.builder(
            itemCount: 2,
            onPageChanged: (value) {
              print(value);
              if (value == 1)
                SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
              else
                SystemChrome.setSystemUIOverlayStyle(
                    SystemUiOverlayStyle.light);
            },
            itemBuilder: (context, index) {
              if (index == 0) {
                return scrollFeed();
              }else{
               return scrollFeed();
            }},
          )
        ],
      ),
    );
  }


  Widget scrollFeed() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(child: feedVideos()),
      ],
    );
  }

//widget to show list of videos
  Widget feedVideos() {
    return Stack(
      children: [
        PageView.builder(
          controller: PageController(
            initialPage: 0,
            viewportFraction: 1,
          ),
          itemCount: feedViewModel.listVideos.length,
          onPageChanged: (index) {

            index = index % (feedViewModel.listVideos.length);
            feedViewModel.changeVideo(index);
          },
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            index = index % (feedViewModel.listVideos.length);
            return videoCard(feedViewModel.listVideos[index]);
          },
        ),
        SafeArea(
          child: Container(
            padding: EdgeInsets.only(top: 20),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text('Following',
                      style: TextStyle(
                          fontSize: 17.0,
                          fontWeight: FontWeight.normal,
                          color: Colors.white70)),
                  SizedBox(
                    width: 7,
                  ),
                  Container(
                    color: Colors.white70,
                    height: 10,
                    width: 1.0,
                  ),
                  SizedBox(
                    width: 7,
                  ),
                  Text('For You',
                      style: TextStyle(
                          fontSize: 17.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white))
                ]),
          ),
        ),
      ],
    );
  }


//widget for videocard
  Widget videoCard(Feed video) {
    return Stack(
      children: [
        video.controller != null
            ? GestureDetector(
          onTap: () {
            if (video.controller.value.isPlaying) {
              video.controller.pause();
            } else {
              video.controller.play();
            }
          },
          child: SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: video.controller.value.size?.width ?? 0,
                  height: video.controller.value.size?.height ?? 0,
                  child: VideoPlayer(video.controller),
                ),
              )),
        )
            : Container(
          color: Colors.black,
          child: Center(
            child: Text("Loading"),
          ),
        ),
    Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                VideoDescription(video.name, video.title, video.name),
               ActionsToolbar(video.likecount.toString(), video.commentcount.toString(),video.image,video.sharecount.toString()),
              ],
            ),
            SizedBox(height: 20)
          ],
        ),
      ],
    );
  }

//controller dispose
  @override
  void dispose() {
    feedViewModel.controller.dispose();
    super.dispose();
  }
}