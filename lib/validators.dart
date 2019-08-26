class Validators {
  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );
  static final RegExp _passwordRegExp = RegExp(
    r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$',
  );

  static final RegExp _usernameRegExp = RegExp(
      r'^(?=.{6,25}$)[a-zA-Z0-9]+([a-zA-Z0-9](_|.)[a-zA-Z0-9])*[a-zA-Z0-9]+$');

  static RegExp _minMaxLengthText(int min, int max) {
    return RegExp(
      r'^[a-zA-Z0-9.!#&' ']{$min, $max}\$',
    );
  }

  static isValidUsername(String username) {
    return _usernameRegExp.hasMatch(username);
  }

  static isValidEmail(String email) {
    return _emailRegExp.hasMatch(email);
  }

  static isValidPassword(String password) {
    return _passwordRegExp.hasMatch(password);
  }

  static isMinimumMaximumLengthText(String text, int min, int max) {
    return _minMaxLengthText(min, max).hasMatch(text);
  }
}
