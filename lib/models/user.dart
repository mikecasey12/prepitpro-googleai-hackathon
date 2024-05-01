class User {
  final String? id;
  final String? email;
  final String? fname;
  final String? lname;
  final int? userClass;
  final String? gender;
  final String? username;
  final String? avatar;
  final String? phonenum;
  final String? lastSignIn;
  final String? joinDate;
  final int? points;
  final bool? subscribed;
  final String? subscriptionKey;

  const User(
      {this.id,
      this.email,
      this.avatar,
      this.fname,
      this.lname,
      this.userClass,
      this.gender,
      this.username,
      this.phonenum,
      this.subscribed = false,
      this.subscriptionKey,
      this.joinDate,
      this.lastSignIn,
      this.points = 0});

  @override
  String toString() {
    return 'User(id: $id, email: $email, avatar: $avatar, fname: $fname, lname: $lname, userClass: $userClass, gender: $gender, username: $username, phonenum: $phonenum, subscribed:$subscribed, subscriptionKey:$subscriptionKey, joinDate:$joinDate, lastSignIn: $lastSignIn, points:$points)';
  }
}
