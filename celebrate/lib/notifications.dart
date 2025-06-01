import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ListView(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          children: <Widget>[
            _buildHeader(),
            _buildTabBar(),
            const SizedBox(height: 10.0),
            Container(
              color: Colors.white,
              height: MediaQuery.of(context).size.height,
              child: TabBarView(
                controller: tabController,
                children: <Widget>[
                  _buildNotificationList(),
                  Container(child: Text('Posts')),
                  Container(child: Text('Hashtags')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Notifications',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
          Icon(Icons.message),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return TabBar(
      controller: tabController,
      indicatorColor: Theme.of(context).primaryColor,
      indicatorSize: TabBarIndicatorSize.label,
      indicatorWeight: 4.0,
      isScrollable: true,
      labelColor: const Color(0xFF440206),
      unselectedLabelColor: const Color(0xFF440206),
      tabs: const [
        Tab(
            child: Text('Alkato',
                style: TextStyle(fontFamily: 'Montserrat', fontSize: 15.0))),
        Tab(
            child: Text('Posts',
                style: TextStyle(fontFamily: 'Montserrat', fontSize: 15.0))),
        Tab(
            child: Text('Hashtag',
                style: TextStyle(fontFamily: 'Montserrat', fontSize: 15.0))),
      ],
    );
  }

  Widget _buildNotificationList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: 8,
      itemBuilder: (context, index) {
        return _buildNotificationItem(
          name: names[index],
          message: messages[index],
          time: times[index],
          image: images[index],
        );
      },
    );
  }

  Widget _buildNotificationItem(
      {required String name,
      required String message,
      required String time,
      required String image}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundImage: AssetImage(image),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: GoogleFonts.andika(
                          fontSize: 17, fontWeight: FontWeight.bold)),
                  Text(message, style: GoogleFonts.andika(fontSize: 15)),
                ],
              ),
            ],
          ),
          Text(time, style: GoogleFonts.andika(fontSize: 17)),
        ],
      ),
    );
  }

  // Sample data for notifications
  final List<String> names = [
    'Sarah Moore',
    'Wilson Don',
    'Jon Doe',
    'Wilson Don',
    'Maryanne Yvvone',
    'Jackline Jane',
    'Jackson Jo',
    'Wilson Don',
  ];

  final List<String> messages = [
    'Connad Lunch',
    'Is that product still available?',
    'Are you coming',
    'Is that product still available?',
    'Are you coming?',
    'Are you at work?',
    'On the way',
    'Is that product still available?',
  ];

  final List<String> times = [
    '12min',
    '1 hour',
    '12min',
    '1 hour',
    '11 am',
    '11pm',
    'yesterday',
    '1 hour',
  ];

  final List<String> images = [
    'lib/images/wall.png',
    'lib/images/img.png',
    'lib/images/feed.png',
    'lib/images/wall.png',
    'lib/images/img.png',
    'lib/images/feed.png',
    'lib/images/img.png',
    'lib/images/wall.png',
  ];
}
