class CelebrityStats {
  final int postsCount;
  final int followersCount;
  final int followingCount;

  CelebrityStats({
    required this.postsCount,
    required this.followersCount,
    required this.followingCount,
  });

  factory CelebrityStats.fromJson(Map<String, dynamic> json) {
    return CelebrityStats(
      postsCount: json['postsCount'] as int,
      followersCount: json['followersCount'] as int,
      followingCount: json['followingCount'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'postsCount': postsCount,
      'followersCount': followersCount,
      'followingCount': followingCount,
    };
  }
}

class Celebrity {
  final int id;
  final String username;
  final String displayName;
  final String stageName;
  final String fullName;
  final String? profileImage;
  final String? category;
  final String dateOfBirth;
  final String placeOfBirth;
  final String nationality;
  final String ethnicity;
  final String netWorth;
  final List<String> professions;
  final List<String> debutWorks;
  final List<String> majorAchievements;
  final List<String> notableProjects;
  final List<String> collaborations;
  final List<String> agenciesOrLabels;
  final CelebrityStats stats;

  Celebrity({
    required this.id,
    required this.username,
    required this.displayName,
    required this.stageName,
    required this.fullName,
    this.profileImage,
    this.category,
    required this.dateOfBirth,
    required this.placeOfBirth,
    required this.nationality,
    required this.ethnicity,
    required this.netWorth,
    required this.professions,
    required this.debutWorks,
    required this.majorAchievements,
    required this.notableProjects,
    required this.collaborations,
    required this.agenciesOrLabels,
    required this.stats,
  });

  factory Celebrity.fromJson(Map<String, dynamic> json) {
    return Celebrity(
      id: json['id'] as int,
      username: json['username'] as String,
      displayName: json['displayName'] as String,
      stageName: json['stageName'] as String,
      fullName: json['fullName'] as String,
      profileImage: json['profileImage'] as String?,
      category: json['category'] as String?,
      dateOfBirth: json['dateOfBirth'] as String,
      placeOfBirth: json['placeOfBirth'] as String,
      nationality: json['nationality'] as String,
      ethnicity: json['ethnicity'] as String,
      netWorth: json['netWorth'] as String,
      professions: List<String>.from(json['professions'] as List),
      debutWorks: List<String>.from(json['debutWorks'] as List),
      majorAchievements: List<String>.from(json['majorAchievements'] as List),
      notableProjects: List<String>.from(json['notableProjects'] as List),
      collaborations: List<String>.from(json['collaborations'] as List),
      agenciesOrLabels: List<String>.from(json['agenciesOrLabels'] as List),
      stats: CelebrityStats.fromJson(json['stats'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'displayName': displayName,
      'stageName': stageName,
      'fullName': fullName,
      'profileImage': profileImage,
      'category': category,
      'dateOfBirth': dateOfBirth,
      'placeOfBirth': placeOfBirth,
      'nationality': nationality,
      'ethnicity': ethnicity,
      'netWorth': netWorth,
      'professions': professions,
      'debutWorks': debutWorks,
      'majorAchievements': majorAchievements,
      'notableProjects': notableProjects,
      'collaborations': collaborations,
      'agenciesOrLabels': agenciesOrLabels,
      'stats': stats.toJson(),
    };
  }
}
