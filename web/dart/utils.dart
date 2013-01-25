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
