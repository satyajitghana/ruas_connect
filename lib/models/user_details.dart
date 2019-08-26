class UserDetails {
  String uid;
  String userName;
  String email;
  String branch;
  String semester;

  UserDetails({
    this.uid,
    this.userName,
    this.email,
    this.branch,
    this.semester,
  });

  UserDetails.fromFirestoreDocument(Map<String, dynamic> user) {
    if (user == null) {
      throw UserDetailsFieldException('data was null');
    }

    this.uid = user['uid'];
    this.userName = user['userName'];
    this.email = user['email'];
    this.branch = user['branch'];
    this.semester = user['semester'];

    if (!isValidUserDetails(this)) {
      throw UserDetailsFieldException('a field was null or empty');
    }
  }

  static bool isValidUserDetails(UserDetails details) {
    if (details == null) {
      return false;
    }

    if (details.uid == null ||
        details.userName == null ||
        details.email == null ||
        details.branch == null ||
        details.semester == null) {
      return false;
    }

    if (details.uid.isEmpty ||
        details.userName.isEmpty ||
        details.email.isEmpty ||
        details.branch.isEmpty ||
        details.semester.isEmpty) {
      return false;
    }

    return true;
  }

  @override
  String toString() => '''{ uid : $uid,
  userName : $userName,
  email : $email,
  branch : $branch,
  semester : $semester }''';
}

class UserDetailsFieldException implements Exception {
  String errorInfo;

  UserDetailsFieldException(this.errorInfo);

  @override
  String toString() => 'UserDetailsFieldException : $errorInfo';
}
