import '../../app/config/regex_config.dart';

extension Validator on String {
  bool isValidEmail() {
    return RegexConfig.emailRegex.hasMatch(this);
  }

  bool isEmptyData() {
    return isEmpty;
  }

  bool isPasswordLength() {
    return (length < 6 || length > 32);
  }

  bool isOtpLength() {
    return !(length == 6);
  }

  bool isLengthTwoOrMore() {
    return (length >= 2);
  }

  bool isLengthThreeOrMore() {
    return !(length >= 3);
  }

  bool isLengthTenOrMore() {
    return (length != 10);
  }

  bool isGreaterThan250() {
    return (length <= 8 || length >= 250);
  }

  bool lessOrEqualToZero() {
    double? enteredVal = double.tryParse(this);
    return (enteredVal == null || enteredVal <= 0);
  }

  bool isValidOtp() {
    return RegexConfig.numberRegex.hasMatch(this);
  }

  bool isSamePassword(String newPassword) {
    return this != newPassword;
  }

  bool isValidPhoneNumber() {
    return RegexConfig.phoneNumberRegex.hasMatch(this);
  }
}
