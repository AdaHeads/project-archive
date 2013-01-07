part of widget;

// Return a valid CSS selector string.
String toSelector (String value) {
  assert(!value.isEmpty);

  return value.startsWith('#') ? value : '#${value}';
}