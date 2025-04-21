// os related error
class UnableToProvideDocumentsDirectory implements Exception {}

// database related
class DatabaseAlreadyOpened implements Exception {}

class DatabaseAlreadyClosed implements Exception {}

class DatabaseIsnotOpen implements Exception {}

class DatabaseDoesNotExist implements Exception {}

// user related
class UserAlreadyFoundCrudException implements Exception {}

class CouldNotCreateUserCrudException implements Exception {}

class UserNotFoundCrudException implements Exception {}

class CouldNotDeleteUserCrudException implements Exception {}

// recipe related
class CouldNotCreateRecipeCrudException implements Exception {}

class CouldNotFindRcipeCrudException implements Exception {}

class CouldNotDeleteRecipeCrudException implements Exception {}

class NoSuchRecipeCoulmnCrudException implements Exception {}

class CouldNotUpdateRecipeCrudException implements Exception {}

// generic
class CrudException implements Exception {}
