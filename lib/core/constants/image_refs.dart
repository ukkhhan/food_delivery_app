class ImageRefs {
  static const localPrefix = 'local://';

  static String localKey(String productId) => '$localPrefix$productId';

  static String? sqliteKeyFromRef(String? imageKey) {
    if (imageKey == null || imageKey.isEmpty) return null;
    if (imageKey.startsWith(localPrefix)) {
      return imageKey.substring(localPrefix.length);
    }
    return imageKey;
  }
}
