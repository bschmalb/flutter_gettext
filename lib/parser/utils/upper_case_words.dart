/// Convert first letters after - to uppercase, other lowercase
String upperCaseWords(String str) {
  return str.toLowerCase().trim().replaceAllMapped(
      RegExp(r'^(MIME|POT?(?=-)|[a-z])|-[a-z]', caseSensitive: false), (Match match) => match.group(0)!.toUpperCase());
}
