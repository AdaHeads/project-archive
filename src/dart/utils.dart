/**
 * Library containing various utility methods.
 */
library utils;

/**
 * Prepend a # to [value] if the first character of [value] != #.
 */
String toSelector (String value) {
  assert(!value.isEmpty);

  return value.startsWith('#') ? value : '#${value}';
}

/**
 * Parses a String to a bool. Only needed until Dart gets updated.
 */
bool parseBool (String s, [bool ifInvalid]) {
  if(s == null || !(s == 'true' || s == 'false')) return ifInvalid;
  return s == 'true';
}