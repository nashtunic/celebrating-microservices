import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CelebrityProfile extends StatefulWidget {
  const CelebrityProfile({super.key});

  @override
  State<CelebrityProfile> createState() => _CelebrityProfileState();
}

class _CelebrityProfileState extends State<CelebrityProfile>
    with SingleTickerProviderStateMixin {
  // final user = FirebaseAuth.instance.currentUser!;
  late TabController tabController;
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 5, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: ListView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage('lib/images/img.png'),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Row(
                    children: [
                      Text(
                        'CELEB',
                        style: GoogleFonts.lato(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      Text(
                        'R',
                        style: GoogleFonts.lato(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange),
                      ),
                      CircleAvatar(
                        backgroundImage: AssetImage('lib/images/img.png'),
                        radius: 9,
                      ),
                      Text(
                        'TING',
                        style: GoogleFonts.lato(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            TabBar(
              controller: tabController,
              indicatorColor: Theme.of(context).primaryColor,
              // indicatorColor: Color(0xFFFE8A7E),
              indicatorSize: TabBarIndicatorSize.label,
              indicatorWeight: 9.0,

              isScrollable: true,
              labelColor: const Color(0xFF440206),
              unselectedLabelColor: const Color(0xFF440206),
              tabs: const [
                Tab(
                  child: Text(
                    'Basic Information',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 15.0,
                    ),
                  ),
                ),
                Tab(
                  child: Text(
                    'Career Highlights',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 15.0,
                    ),
                  ),
                ),
                Tab(
                  child: Text(
                    'Personal Life',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 15.0,
                    ),
                  ),
                ),
                Tab(
                  child: Text(
                    'Public Persona',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 15.0,
                    ),
                  ),
                ),
                Tab(
                  child: Text(
                    'Fun or Niche',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 15.0,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10.0,
            ),
            Container(
              color: Colors.white,
              //  color: Theme.of(context).colorScheme.primary,
              height: MediaQuery.of(context).size.height,
              child: TabBarView(
                controller: tabController,
                children: <Widget>[
                  CelebrityBasicInfo(),
                  CelebrityCareerHighlights(),
                  CelebrityPersonalLife(),
                  CelebrityPublicPersona(),
                  CelebrityFun(),

                  //   DevtTab(),
                  //   EventsTabLocation(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CelebrityBasicInfo extends StatefulWidget {
  @override
  _CelebrityBasicInfoState createState() => _CelebrityBasicInfoState();
}

class _CelebrityBasicInfoState extends State<CelebrityBasicInfo> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for each form field
  final TextEditingController stageNameController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController dateOfBirthController = TextEditingController();
  final TextEditingController placeOfBirthController = TextEditingController();
  final TextEditingController ethnicityController = TextEditingController();
  final TextEditingController professionController = TextEditingController();
  final TextEditingController debutWorkController = TextEditingController();
  final TextEditingController majorAchievementsController =
      TextEditingController();
  final TextEditingController notableProjectsController =
      TextEditingController();
  final TextEditingController collaborationsController =
      TextEditingController();
  final TextEditingController netWorthController = TextEditingController();
  final TextEditingController agenciesOrLabelsController =
      TextEditingController();
  final TextEditingController relationshipsController = TextEditingController();
  final TextEditingController familyMembersController = TextEditingController();
  final TextEditingController educationBackgroundController =
      TextEditingController();
  final TextEditingController hobbiesInterestsController =
      TextEditingController();
  final TextEditingController lifestyleDetailsController =
      TextEditingController();
  final TextEditingController philanthropyController = TextEditingController();
  final TextEditingController socialMediaPresenceController =
      TextEditingController();
  final TextEditingController publicImageController = TextEditingController();
  final TextEditingController controversiesController = TextEditingController();
  final TextEditingController fashionStyleController = TextEditingController();
  final TextEditingController quotesController = TextEditingController();
  final TextEditingController tattoosController = TextEditingController();
  final TextEditingController petsController = TextEditingController();
  final TextEditingController favoriteThingsController =
      TextEditingController();
  final TextEditingController hiddenTalentsController = TextEditingController();
  final TextEditingController fanTheoriesController = TextEditingController();

  // Dropdown values
  String? selectedAstrologicalSign;
  String? selectedNationality;

  // List of astrological signs
  List<String> astrologicalSigns = [
    'Aries',
    'Taurus',
    'Gemini',
    'Cancer',
    'Leo',
    'Virgo',
    'Libra',
    'Scorpio',
    'Sagittarius',
    'Capricorn',
    'Aquarius',
    'Pisces'
  ];

  // List of nationalities (abbreviated for brevity)
  List<String> nationalities = [
    'Afghan',
    'Albanian',
    'Algerian',
    'American',
    'Andorran',
    'Angolan',
    'Antiguans',
    'Argentinean',
    'Armenian',
    'Australian',
    'Austrian',
    'Azerbaijani',
    // Add more nationalities as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              // Basic Information
              TextFormField(
                controller: stageNameController,
                decoration: _buildInputDecoration('Stage Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter stage name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0), // Additional spacing
              TextFormField(
                controller: fullNameController,
                decoration: _buildInputDecoration('Official Full Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter full name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0), // Additional spacing
              TextFormField(
                controller: dateOfBirthController,
                decoration: _buildInputDecoration('Date of Birth / Age'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter date of birth';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0), // Additional spacing
              TextFormField(
                controller: placeOfBirthController,
                decoration:
                    _buildInputDecoration('Place of Birth / Celebritytown'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter place of birth';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0), // Additional spacing
              DropdownButtonFormField<String>(
                value: selectedNationality,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedNationality = newValue;
                  });
                },
                items:
                    nationalities.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: _buildInputDecoration('Nationality'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select nationality';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0), // Additional spacing
              DropdownButtonFormField<String>(
                value: selectedAstrologicalSign,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedAstrologicalSign = newValue;
                  });
                },
                items: astrologicalSigns
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: _buildInputDecoration('Astrological Sign'),
              ),
              SizedBox(height: 16.0), // Additional spacing
              // Additional spacing
              // Career Highlights

              // Personal Life

              // Public Persona

              // Fun or Niche Details

              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: Colors.white),
                      color: Colors.orange),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Update',
                        style: GoogleFonts.lato(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String labelText) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(color: Colors.black54),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: Colors.black38),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: Colors.blueAccent),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: Colors.black38),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: Colors.orange),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: Colors.orange),
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: EdgeInsets.all(16.0),
    );
  }
}

class CelebrityCareerHighlights extends StatefulWidget {
  const CelebrityCareerHighlights({super.key});

  @override
  State<CelebrityCareerHighlights> createState() =>
      _CelebrityCareerHighlightsState();
}

class _CelebrityCareerHighlightsState extends State<CelebrityCareerHighlights> {
  final _formKey = GlobalKey<FormState>();

  // Lists to store multiple values for each field
  List<TextEditingController> professionControllers = [TextEditingController()];
  List<TextEditingController> debutWorkControllers = [TextEditingController()];
  List<TextEditingController> majorAchievementsControllers = [
    TextEditingController()
  ];
  List<TextEditingController> notableProjectsControllers = [
    TextEditingController()
  ];
  List<TextEditingController> collaborationsControllers = [
    TextEditingController()
  ];
  List<TextEditingController> agenciesOrLabelsControllers = [
    TextEditingController()
  ];

  // Function to add new field
  void addField(List<TextEditingController> controllers) {
    controllers.add(TextEditingController());
    setState(() {});
  }

  // Function to remove field
  void removeField(List<TextEditingController> controllers, int index) {
    if (controllers.length > 1) {
      controllers.removeAt(index);
      setState(() {});
    }
  }

  // Custom InputDecoration for stunning borders
  InputDecoration customInputDecoration(String labelText) {
    return InputDecoration(
      labelText: labelText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade400),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.blue.shade700),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade400),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.red.shade700),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.red.shade700),
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: EdgeInsets.all(16),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                // Profession(s)
                ...List.generate(professionControllers.length, (index) {
                  return Column(
                    children: [
                      TextFormField(
                        controller: professionControllers[index],
                        decoration: customInputDecoration('Profession(s)'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter profession';
                          }
                          return null;
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () => addField(professionControllers),
                          ),
                          if (index > 0)
                            IconButton(
                              icon: Icon(Icons.remove),
                              onPressed: () =>
                                  removeField(professionControllers, index),
                            ),
                        ],
                      ),
                    ],
                  );
                }),

                // Debut Work / Breakthrough Role
                ...List.generate(debutWorkControllers.length, (index) {
                  return Column(
                    children: [
                      TextFormField(
                        controller: debutWorkControllers[index],
                        decoration: customInputDecoration(
                            'Debut Work / Breakthrough Role'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter debut work';
                          }
                          return null;
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () => addField(debutWorkControllers),
                          ),
                          if (index > 0)
                            IconButton(
                              icon: Icon(Icons.remove),
                              onPressed: () =>
                                  removeField(debutWorkControllers, index),
                            ),
                        ],
                      ),
                    ],
                  );
                }),

                // Major Achievements
                ...List.generate(majorAchievementsControllers.length, (index) {
                  return Column(
                    children: [
                      TextFormField(
                        controller: majorAchievementsControllers[index],
                        decoration: customInputDecoration('Major Achievements'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter major achievements';
                          }
                          return null;
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () =>
                                addField(majorAchievementsControllers),
                          ),
                          if (index > 0)
                            IconButton(
                              icon: Icon(Icons.remove),
                              onPressed: () => removeField(
                                  majorAchievementsControllers, index),
                            ),
                        ],
                      ),
                    ],
                  );
                }),

                // Notable Projects
                ...List.generate(notableProjectsControllers.length, (index) {
                  return Column(
                    children: [
                      TextFormField(
                        controller: notableProjectsControllers[index],
                        decoration: customInputDecoration('Notable Projects'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter notable projects';
                          }
                          return null;
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () =>
                                addField(notableProjectsControllers),
                          ),
                          if (index > 0)
                            IconButton(
                              icon: Icon(Icons.remove),
                              onPressed: () => removeField(
                                  notableProjectsControllers, index),
                            ),
                        ],
                      ),
                    ],
                  );
                }),

                // Collaborations with Other Celebrities
                ...List.generate(collaborationsControllers.length, (index) {
                  return Column(
                    children: [
                      TextFormField(
                        controller: collaborationsControllers[index],
                        decoration: customInputDecoration(
                            'Collaborations with Other Celebrities'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter collaborations';
                          }
                          return null;
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () =>
                                addField(collaborationsControllers),
                          ),
                          if (index > 0)
                            IconButton(
                              icon: Icon(Icons.remove),
                              onPressed: () =>
                                  removeField(collaborationsControllers, index),
                            ),
                        ],
                      ),
                    ],
                  );
                }),

                // Agencies or Labels
                ...List.generate(agenciesOrLabelsControllers.length, (index) {
                  return Column(
                    children: [
                      TextFormField(
                        controller: agenciesOrLabelsControllers[index],
                        decoration: customInputDecoration('Agencies or Labels'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter agencies or labels';
                          }
                          return null;
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () =>
                                addField(agenciesOrLabelsControllers),
                          ),
                          if (index > 0)
                            IconButton(
                              icon: Icon(Icons.remove),
                              onPressed: () => removeField(
                                  agenciesOrLabelsControllers, index),
                            ),
                        ],
                      ),
                    ],
                  );
                }),

                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(color: Colors.white),
                        color: Colors.orange),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Update',
                          style: GoogleFonts.lato(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CelebrityPersonalLife extends StatefulWidget {
  const CelebrityPersonalLife({super.key});

  @override
  State<CelebrityPersonalLife> createState() => _CelebrityPersonalLifeState();
}

class _CelebrityPersonalLifeState extends State<CelebrityPersonalLife> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for each form field
  final TextEditingController relationshipsController = TextEditingController();
  final TextEditingController familyMembersController = TextEditingController();
  final TextEditingController educationBackgroundController =
      TextEditingController();
  final TextEditingController hobbiesInterestsController =
      TextEditingController();
  final TextEditingController lifestyleDetailsController =
      TextEditingController();
  final TextEditingController philanthropyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              // Personal Life
              TextFormField(
                controller: relationshipsController,
                decoration:
                    _buildInputDecoration('Relationships / Dating History'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter relationships';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0), // Additional spacing
              TextFormField(
                controller: familyMembersController,
                decoration: _buildInputDecoration('Family Members'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter family members';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0), // Additional spacing
              TextFormField(
                controller: educationBackgroundController,
                decoration: _buildInputDecoration('Education Background'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter education background';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0), // Additional spacing
              TextFormField(
                controller: hobbiesInterestsController,
                decoration: _buildInputDecoration('Hobbies / Interests'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter hobbies';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0), // Additional spacing
              TextFormField(
                controller: lifestyleDetailsController,
                decoration: _buildInputDecoration('Lifestyle Details'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter lifestyle details';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0), // Additional spacing
              TextFormField(
                controller: philanthropyController,
                decoration:
                    _buildInputDecoration('Philanthropy / Causes Supported'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter philanthropy';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20), // Additional spacing before the button
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: Colors.white),
                      color: Colors.orange),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Update',
                        style: GoogleFonts.lato(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String labelText) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(color: Colors.black54),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: Colors.black38),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: Colors.blueAccent),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: Colors.black38),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: Colors.red),
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: EdgeInsets.all(16.0),
    );
  }
}

class CelebrityPublicPersona extends StatefulWidget {
  const CelebrityPublicPersona({super.key});

  @override
  State<CelebrityPublicPersona> createState() => _CelebrityPublicPersonaState();
}

class _CelebrityPublicPersonaState extends State<CelebrityPublicPersona> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for each form field
  final TextEditingController socialMediaPresenceController =
      TextEditingController();
  final TextEditingController publicImageController = TextEditingController();
  final TextEditingController controversiesController = TextEditingController();
  final TextEditingController fashionStyleController = TextEditingController();
  final TextEditingController quotesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              // Public Persona
              TextFormField(
                controller: socialMediaPresenceController,
                decoration: _buildInputDecoration('Social Media Presence'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter social media presence';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0), // Additional spacing
              TextFormField(
                controller: publicImageController,
                decoration: _buildInputDecoration('Public Image / Reputation'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter public image';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0), // Additional spacing
              TextFormField(
                controller: controversiesController,
                decoration: _buildInputDecoration('Controversies or Scandals'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter controversies';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0), // Additional spacing
              TextFormField(
                controller: fashionStyleController,
                decoration:
                    _buildInputDecoration('Fashion Style / Red Carpet Moments'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter fashion style';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0), // Additional spacing
              TextFormField(
                controller: quotesController,
                decoration:
                    _buildInputDecoration('Quotes or Public Statements'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter quotes';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20), // Additional spacing before the button
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: Colors.white),
                      color: Colors.orange),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Update',
                        style: GoogleFonts.lato(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String labelText) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(color: Colors.black54),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: Colors.black38),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: Colors.blueAccent),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: Colors.black38),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: Colors.red),
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: EdgeInsets.all(16.0),
    );
  }
}

class CelebrityFun extends StatefulWidget {
  const CelebrityFun({super.key});

  @override
  State<CelebrityFun> createState() => _CelebrityFunState();
}

class _CelebrityFunState extends State<CelebrityFun> {
  final _formKey = GlobalKey<FormState>();

  // Lists to store multiple values for each field
  List<TextEditingController> tattoosControllers = [TextEditingController()];
  List<TextEditingController> petsControllers = [TextEditingController()];
  List<TextEditingController> favoriteThingsControllers = [
    TextEditingController()
  ];
  List<TextEditingController> hiddenTalentsControllers = [
    TextEditingController()
  ];
  List<TextEditingController> fanTheoriesControllers = [
    TextEditingController()
  ];

  // Function to add new field
  void addField(List<TextEditingController> controllers) {
    controllers.add(TextEditingController());
    setState(() {});
  }

  // Function to remove field
  void removeField(List<TextEditingController> controllers, int index) {
    if (controllers.length > 1) {
      controllers.removeAt(index);
      setState(() {});
    }
  }

  // Custom InputDecoration for stunning borders
  InputDecoration _buildInputDecoration(String labelText) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(color: Colors.black54),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: Colors.black38),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: Colors.blueAccent),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: Colors.black38),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: Colors.red),
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: EdgeInsets.all(16.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              // Tattoos or Unique Physical Traits
              ...List.generate(tattoosControllers.length, (index) {
                return Column(
                  children: [
                    TextFormField(
                      controller: tattoosControllers[index],
                      decoration: _buildInputDecoration(
                          'Tattoos or Unique Physical Traits'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter tattoos';
                        }
                        return null;
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () => addField(tattoosControllers),
                        ),
                        if (index > 0)
                          IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () =>
                                removeField(tattoosControllers, index),
                          ),
                      ],
                    ),
                  ],
                );
              }),

              SizedBox(height: 16),

              // Pets
              ...List.generate(petsControllers.length, (index) {
                return Column(
                  children: [
                    TextFormField(
                      controller: petsControllers[index],
                      decoration: _buildInputDecoration('Pets'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter pets';
                        }
                        return null;
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () => addField(petsControllers),
                        ),
                        if (index > 0)
                          IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () =>
                                removeField(petsControllers, index),
                          ),
                      ],
                    ),
                  ],
                );
              }),

              SizedBox(height: 16),

              // Favorite Things
              ...List.generate(favoriteThingsControllers.length, (index) {
                return Column(
                  children: [
                    TextFormField(
                      controller: favoriteThingsControllers[index],
                      decoration: _buildInputDecoration('Favorite Things'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter favorite things';
                        }
                        return null;
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () => addField(favoriteThingsControllers),
                        ),
                        if (index > 0)
                          IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () =>
                                removeField(favoriteThingsControllers, index),
                          ),
                      ],
                    ),
                  ],
                );
              }),

              SizedBox(height: 16),

              // Hidden Talents
              ...List.generate(hiddenTalentsControllers.length, (index) {
                return Column(
                  children: [
                    TextFormField(
                      controller: hiddenTalentsControllers[index],
                      decoration: _buildInputDecoration('Hidden Talents'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter hidden talents';
                        }
                        return null;
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () => addField(hiddenTalentsControllers),
                        ),
                        if (index > 0)
                          IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () =>
                                removeField(hiddenTalentsControllers, index),
                          ),
                      ],
                    ),
                  ],
                );
              }),

              SizedBox(height: 16),

              // Fan Theories or Fan Interactions
              ...List.generate(fanTheoriesControllers.length, (index) {
                return Column(
                  children: [
                    TextFormField(
                      controller: fanTheoriesControllers[index],
                      decoration: _buildInputDecoration(
                          'Fan Theories or Fan Interactions'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter fan theories';
                        }
                        return null;
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () => addField(fanTheoriesControllers),
                        ),
                        if (index > 0)
                          IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () =>
                                removeField(fanTheoriesControllers, index),
                          ),
                      ],
                    ),
                  ],
                );
              }),

              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: Colors.white),
                    color: Colors.orange,
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Update',
                        style: GoogleFonts.lato(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
