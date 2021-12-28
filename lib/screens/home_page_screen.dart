import 'dart:math';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../utils/bottom_navigation.dart';
import '../services/sqlite_helper.dart';
import '../screens/login_screen.dart';
import '../screens/profile.dart';

class HomePageScreen extends StatefulWidget {
  final String account_id;
   int curr_index;
   HomePageScreen({Key? key,required this.account_id,required this.curr_index}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState(this.account_id,this.curr_index);


}
class _HomePageState extends State<HomePageScreen> {
  String acc_id;
  int curr_index;
  _HomePageState(this.acc_id,this.curr_index);
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: VideoScreen(account_id:acc_id),
        bottomNavigationBar: BottomMenu(account_id:acc_id,curr_index:curr_index)
    );
  }
}
class VideoScreen extends StatefulWidget {
  @override
  _VideoScreenState createState() => _VideoScreenState(this.account_id);
  final String account_id;
  const VideoScreen({Key? key,required this.account_id}) : super(key: key);
}
class _VideoScreenState extends State<VideoScreen> {
  String account_id;
  _VideoScreenState(this.account_id);
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
    _getUserInfo();
    super.initState();
  }
  bool _isvideoLiked=false;
  bool _isUserFollowed=false;
  var likedColor=Colors.white;
  int likesCount=0;
  var followedIcon=Icons.add;
  bool isVisible=false;
  var getUser;
  var _userName;
  var _avatar;



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

  void followUser(){
    setState(() {
      _isUserFollowed=_isUserFollowed==true?false:true;
      followedIcon=(_isUserFollowed==true)?Icons.check:followedIcon=Icons.add;
    });
  }

  void _getUserInfo() async
  {

      getUser=await SQLHelper.getUser(this.account_id);
      setState(() {
      var getRecords = getUser.first;
      print(getRecords);
      _userName=getRecords['names'];
      _avatar=getRecords['avatar'];
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
            SizedBox(
              height: 60,
              child: Stack(
                children: [
                  const CircleAvatar(
                      radius: 24,
                      backgroundImage: NetworkImage(
                          'https://images.unsplash.com/photo-1611575330633-551252bafad7?crop=entropy&cs=tinysrgb&fit=crop&fm=jpg&h=200&ixlib=rb-1.2.1&q=80&w=300')
                  ),
                  Positioned(
                    top: 40,
                    left: 20,
                    child: ClipOval(
                      child: Material(
                        color: Colors.red,
                        child: InkWell(
                          splashColor: Colors.orange,
                          child:  SizedBox(
                              width: 16,
                              height: 16,
                              child: Icon(
                                followedIcon,
                                color: Colors.white,
                                size: 16,
                              )),
                          onTap: () {
                            followUser();
                          },
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
              onPressed: () {
                setState(() {
                  isVisible=isVisible==true?false:true;
                });
              },
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
            const SizedBox(height:40),
            Row(
              children:  [
                Text(_userName.toString(), style: const TextStyle(color: Colors.white,
                    fontSize: 18),),
                const Icon(
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

  Widget _commentsPanel()
  {
    return Visibility (
        visible: isVisible?true:false,
        child:Container(
          // Provide an optional curve to make the animation feel smoother.
          margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.2),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(30.0),
              topLeft: Radius.circular(30.0),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.blueAccent,
                blurRadius: 25.0, // soften the shadow
                spreadRadius: 5.0, //extend the shadow
                offset: Offset(
                  15.0, // Move to right 10  horizontally
                  15.0, // Move to bottom 10 Vertically
                ),
              )
            ],
          ),
          child: ListView(
            padding:const EdgeInsets.only(top: 10) ,
            children:  [
              Row(
                children: [
                  IconButton(
                    icon:  const Icon(Icons.close),
                    onPressed: () {
                      setState(() {
                        isVisible=isVisible==true?false:true;
                      });
                    },
                    color: Colors.blue,
                  ),
                  const Spacer(),
                  const Text(
                    'Comments',
                    style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w200,
                        fontSize: 25),

                  ),
                  Spacer(),
                ],
              ),


            ],
          ),
        )
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
        _commentsPanel()
      ],
    );
  }
}

