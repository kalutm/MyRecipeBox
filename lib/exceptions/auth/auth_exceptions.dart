// generic AuthExcpetion

class AuthException implements Exception{}
// exceptions used for both login and register

class CouldNotLogUserInAuthException implements AuthException{}
class InvalidEmailAuthException implements AuthException{}
class NetworkErrorAuthException implements AuthException{}
// login AuthExceptions

class UserNotFoundAuthException implements AuthException{}
class WrongPasswordAuthException implements AuthException{}
// register AuthExceptins

class EmailAlreadyInUseAuthException implements AuthException{}
class WeakPasswordAuthException implements AuthException{}

// logout AuthExeptions
class UserAlreadyLoggedOutAuthException implements AuthException{}
class LogginOutAuthException implements AuthException{}

// verification email sending AuthExceptions
class UserNotLoggedInAuthException implements AuthException{}
class VerificationSendingAuthException implements AuthException{}

// email verification check authexceptions
class EmailVerificationCheckAuthException implements AuthException{}
class EmailVerificationCheckTimeoutException implements AuthException{}