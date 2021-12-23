import 'dart:math';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../services/sqlite_helper.dart';
class HomePageScreen extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}
class _HomePageState extends State<HomePageScreen> {
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: VideoScreen(),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          unselectedItemColor: Colors.white,
          backgroundColor: Colors.black,
          currentIndex: 0, // this will be set when a new tab is tapped
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home,size:36),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search,size:36),
              label: 'Discover',
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.add,size:36),
                label: ''
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.message,size:36),
              label: 'Inbox',
            ),
            BottomNavigationBarItem(
              icon:Icon(Icons.account_circle,size:36),
              label: 'Me',
            )
          ],
        ));
  }
}
class VideoScreen extends StatefulWidget {
  @override
  _VideoScreenState createState() => _VideoScreenState();
}
class _VideoScreenState extends State<VideoScreen> {
  late VideoPlayerController _videoController;
  late Future<void> _initializeVideoPlayerFuture;
  final videos = [
    'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
    'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4',
    'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
    'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WeAreGoingOnBullrun.mp4'
  ];
  @override
  void initState() {
    _videoController =
        VideoPlayerController.network(videos[Random().nextInt(4)]);
    _initializeVideoPlayerFuture = _videoController.initialize();
    _videoController.play();
    _videoController.setLooping(true);
    super.initState();
  }
  bool _isvideoLiked=false;
  var likedColor=Colors.white;
  int likesCount=0;



  void videoLiked() async{
    setState(() {
      _isvideoLiked=_isvideoLiked==true?false:true;
      if(_isvideoLiked==true)
        {
          likedColor=Colors.red;
          ++likesCount;
        }
      else
        {
          likedColor=Colors.white;
          --likesCount;
        }
    });
  }
  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }
  Widget _video(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Colors.black,
      child: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return AspectRatio(
              aspectRatio: _videoController.value.aspectRatio,
              child: VideoPlayer(_videoController),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
  Widget _top() {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        padding: const EdgeInsets.only(left: 16.0,top:18.0,right:16.0),
        width: double.infinity,
        height: 60,
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
             Text(
           'Following',
            style: TextStyle(color: Colors.white,
            fontSize: 18),
          ),
            VerticalDivider(
              color: Colors.white,
            ),
            Text(
              'For you',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
  Widget _right(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Container(
        width: 60,
        height: MediaQuery.of(context).size.height / 2,
        color: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 60,
              child: Stack(
                children: [
                  const CircleAvatar(
                      radius: 24,
                      backgroundImage: NetworkImage(
                          'https://images.unsplash.com/photo-1611575330633-551252bafad7?crop=entropy&cs=tinysrgb&fit=crop&fm=jpg&h=200&ixlib=rb-1.2.1&q=80&w=300')),
                  Positioned(
                    top: 40,
                    left: 17,
                    child: ClipOval(
                      child: Material(
                        color: Colors.red,
                        child: InkWell(
                          splashColor: Colors.orange,
                          child: const SizedBox(
                              width: 16,
                              height: 16,
                              child: Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 14,
                              )),
                          onTap: () {},
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 14),
              IconButton(
                icon: const Icon(Icons.favorite,size: 30),
                onPressed: () =>  videoLiked(),
                color: likedColor,
              ),
             Text(
              likesCount.toString(),
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18),
            ),
            const SizedBox(height: 14),
            IconButton(
              icon: const Icon(Icons.comment, size: 25),
              onPressed: () {},
              color: Colors.white,
            ),
          const Text(
            '35',
            style: TextStyle(
                color: Colors.white,
                fontSize: 18),
          ),
            const SizedBox(height: 14),
            IconButton(
              icon: const Icon(Icons.send,size: 25),
              onPressed: () {},
              color: Colors.white,
            ),
            const Text('1',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
  Widget _bottom() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        padding: const EdgeInsets.all(8),
        width: double.infinity,
        height: 120,
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.grey,
                  ),
                  padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                  child: Row(children: const [
                    Icon(Icons.shopping_cart,size: 36
                    ),
                    Text('Shop', style: TextStyle(
                        fontSize: 18)),
                  ]),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: const [
                Text('@account_name', style: TextStyle(color: Colors.white,
                    fontSize: 18),),
                Icon(
                  Icons.check_circle,
                  color: Colors.blue,
                )
              ],
            ),
            const SizedBox(height: 6),
            const Text('This is caption #hashtag ', style: TextStyle(color: Colors.white,
                fontSize: 13),),
            const SizedBox(height: 6),

          ],
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        _video(context),
        _top(),
        _bottom(),
        _right(context),
      ],
    );
  }
}

