abstract final class FunctionHelper {
  static String usernameGen(String firstname, String lastname) {
    final random = DateTime.now().millisecond.toString();
    final username =
        "pp-${firstname.toLowerCase().substring(0, firstname.length < 3 ? firstname.length : 3).trim()}${lastname.toLowerCase().substring(0, lastname.length < 2 ? lastname.length : 2).trim()}$random";

    return username;
  }
}
