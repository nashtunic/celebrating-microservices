import 'package:celebrate/custom_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CelebrityFeed extends StatefulWidget {
  const CelebrityFeed({super.key});

  @override
  State<CelebrityFeed> createState() => _CelebrityFeedState();
}

class _CelebrityFeedState extends State<CelebrityFeed> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'EMMA SMIT',
                        style: GoogleFonts.bebasNeue(fontSize: 20),
                      ),
                      Row(
                        children: [
                          Text(
                            'Birth: ',
                            style: GoogleFonts.andika(color: Colors.orange),
                          ),
                          Text('July 1,1998 (34)'),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'Place: ',
                            style: GoogleFonts.andika(color: Colors.orange),
                          ),
                          Text('Los Angeles, California'),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'Nationality: ',
                            style: GoogleFonts.andika(color: Colors.orange),
                          ),
                          Text('Kenyan'),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'Networth: ',
                            style: GoogleFonts.andika(color: Colors.orange),
                          ),
                          Text('KES 10 Million'),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            Icons.facebook,
                            color: Colors.blue,
                          ),
                          Icon(
                            Icons.g_mobiledata_outlined,
                            color: Colors.red,
                            size: 30,
                          ),
                          Icon(
                            Icons.social_distance,
                            color: Colors.orange,
                          ),
                        ],
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        CircleAvatar(
                          backgroundImage: AssetImage('lib/images/feed.png'),
                          radius: 80,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: Colors.orange,
                            ),
                            Icon(
                              Icons.star,
                              color: Colors.orange,
                            ),
                            Icon(
                              Icons.star,
                              color: Colors.orange,
                            ),
                            Icon(
                              Icons.star,
                              color: Colors.grey,
                            ),
                            Icon(
                              Icons.star,
                              color: Colors.grey,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Career Highlights',
                    style: GoogleFonts.andika(
                        fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Text(
                        'Profession: ',
                        style: GoogleFonts.andika(color: Colors.orange),
                      ),
                      Text('Actor'),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Debut Work(2010): ',
                        style: GoogleFonts.andika(color: Colors.orange),
                      ),
                      Text('Los Angeles, California'),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Major Achievements: ',
                        style: GoogleFonts.andika(color: Colors.orange),
                      ),
                      Text('M'),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Notable Projects: ',
                        style: GoogleFonts.andika(color: Colors.orange),
                      ),
                      Text('Movie Title'),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Philanthropy: ',
                        style: GoogleFonts.andika(color: Colors.orange),
                      ),
                      Text('Cause Supported'),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Public Persona',
                    style: GoogleFonts.andika(
                        fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Text(
                        'Follower Count: ',
                        style: GoogleFonts.andika(color: Colors.orange),
                      ),
                      Text('Actor'),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Controversies or Scandals: ',
                        style: GoogleFonts.andika(color: Colors.orange),
                      ),
                      Text('Los Angeles, California'),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Fashion style: ',
                        style: GoogleFonts.andika(color: Colors.orange),
                      ),
                      Text('M'),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 50,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Fun Fact',
                        style: GoogleFonts.andika(
                            fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Text(
                    '. Likes Italian Cuisine',
                    style: GoogleFonts.andika(),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              border: Border.all(color: Colors.orange),
                              color: Colors.orange),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.facebook,
                                  size: 14,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  'Follow',
                                  style:
                                      GoogleFonts.andika(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            border: Border.all(color: Colors.orange),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.message,
                                  size: 14,
                                  color: Colors.orange,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  'Message',
                                  style: GoogleFonts.andika(),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            border: Border.all(color: Colors.orange),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.share,
                                  size: 14,
                                  color: Colors.orange,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  'Share',
                                  style: GoogleFonts.andika(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
