class Directory {
  static Directory get systemTemp =>
      throw UnsupportedError('Directory is not available on web.');

  String get path =>
      throw UnsupportedError('Directory paths are not available on web.');
}

class Platform {
  static String get pathSeparator => '/';
}
