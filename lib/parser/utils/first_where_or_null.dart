/// Returns the first element that satisfies the given condition or `null` if there are no elements.
///
/// Implemented to avoid the `collection` package dependency.
/// Works just like Iterable.firstWhereOrNull() from the `collection` package.
///
extension TryFind<T> on List<T> {
  T? tryFind(bool Function(T) condition) {
    for (final T element in this) {
      if (condition(element)) return element;
    }
    return null;
  }
}
