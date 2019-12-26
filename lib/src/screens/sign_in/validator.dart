abstract class StringValidator {
  bool isValid(String value);
}

class NonEmptyValidator implements StringValidator {
  @override
  bool isValid(String value) {
    return value.isNotEmpty;
  }
}

class EmailAndPasswordValidators {
  final StringValidator emailValidator = NonEmptyValidator();
  final StringValidator passwordValidator = NonEmptyValidator();
  final String invalidEmailError = ' Email can\'t be empty';
  final String invalidPasswordError = ' Password cant\'t be empty';
}
