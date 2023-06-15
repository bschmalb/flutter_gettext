extension TryFind<T> on List<T> {
  T? tryFind(bool Function(T) condition) {
    for (final T element in this) {
      if (condition(element)) return element;
    }
    return null;
  }
}