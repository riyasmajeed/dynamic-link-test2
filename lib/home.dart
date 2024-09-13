import 'dart:async';
import 'package:flutter/material.dart';
import 'package:uni_links_desktop/uni_links_desktop.dart'; // Import for desktop deep linking
import 'package:share_plus/share_plus.dart'; // Import for sharing functionality

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomePage> {
  int _selectedIndex = 0;
  StreamSubscription? _sub;

  static final List<Widget> _widgetOptions = <Widget>[
    const TextPost(),
    const VideoPost(),
    const ImagePost(),
  ];

  @override
  void initState() {
    super.initState();
    _handleDeepLinks();
  }

  // Handle deep links
  void _handleDeepLinks() {
    // Listen for deep links (for desktop)
    _sub = getUriLinksStream().listen((Uri? uri) {
      if (uri != null) {
        _navigateToPost(uri);
      }
    }, onError: (err) {
      print('Failed to receive link: $err');
    });

    // Handle the initial deep link when the app starts (for desktop)
    getInitialUri().then((Uri? uri) {
      if (uri != null) {
        _navigateToPost(uri);
      }
    }).catchError((err) {
      print('Error getting initial link: $err');
    });
  }

  // Navigate to the appropriate post based on the deep link
  void _navigateToPost(Uri uri) {
    String? postId = uri.queryParameters['id'];

    if (postId == 'text_post_id') {
      setState(() {
        _selectedIndex = 0;
      });
    } else if (postId == 'video_post_id') {
      setState(() {
        _selectedIndex = 1;
      });
    } else if (postId == 'image_post_id') {
      setState(() {
        _selectedIndex = 2;
      });
    } else {
      print('Unknown Post ID');
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GuideUs Posts'),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.text_fields), label: 'Text'),
          BottomNavigationBarItem(icon: Icon(Icons.video_library), label: 'Video'),
          BottomNavigationBarItem(icon: Icon(Icons.image), label: 'Image'),
        ],
        currentIndex: _selectedIndex,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
  
  getUriLinksStream() {}
  
  getInitialUri() {}
}

// Share post function
void sharePost(String postId) {
  final String link = 'myapp://post?id=$postId';
  Share.share('Check out this post: $link');
}

// Text Post
class TextPost extends StatelessWidget {
  const TextPost({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('This is a Text Post'),
        ElevatedButton(
          onPressed: () => sharePost('text_post_id'),
          child: const Text('Share Text Post'),
        ),
      ],
    );
  }
}

// Video Post
class VideoPost extends StatelessWidget {
  const VideoPost({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('This is a Video Post (replace with video player)'),
        ElevatedButton(
          onPressed: () => sharePost('video_post_id'),
          child: const Text('Share Video Post'),
        ),
      ],
    );
  }
}

// Image Post
class ImagePost extends StatelessWidget {
  const ImagePost({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('This is an Image Post (replace with image display)'),
        ElevatedButton(
          onPressed: () => sharePost('image_post_id'),
          child: const Text('Share Image Post'),
        ),
      ],
    );
  }
}
