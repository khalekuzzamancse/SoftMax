part of 'login_screen.dart';

///Inspired by the `MVC` design pattern, this moves some view-related logic to the controller.
///To avoid memory leaks or cyclic dependencies, the state instance is taken on demand instead of being stored as an instance variable.
///
/// Since Dart Streams are asynchronous in nature and not as powerful as Kotlin's `StateFlow`,
/// keeping the state in the business logic/controller introduces some noticeable overhead.
/// Moreover, in many cases, it is more efficient to store the state in the view,
/// as the Flutter framework is designed such that in most of cases, state needs to be managed by the view(either explicitly or implicitly).
/// This also helps eliminate redundancy.
final class LoginViewController {
  void init(_LoginScreenState self) {
    self._usernameController.text = "emilys";
    self._passwordController.text = "emilyspass";
  }
  Future<bool> login(_LoginScreenState self) async {
    final username = self._usernameController.text.trim();
    final password = self._passwordController.text.trim();
    final error = self.controller.validate(username, password);
    if (error != null) {
      self.safeSetState(() {
        self.error = error;
      });
      return false;
    }
    else{
      self.safeSetState(() {
        self.error = LoginUiError();
      });
    }
    ;
    if (self.context.mounted) FocusScope.of(self.context).unfocus();
    self.startLoading();
    final success = await self.controller.login(username, password);
    self.stopLoading();
    if (success) {
      return true;
    }
    return false;
  }
  void dispose(_LoginScreenState self) {
    self._usernameController.dispose();
    self._passwordController.dispose();
  }
}
