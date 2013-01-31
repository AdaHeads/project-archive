/**
 * A collection of common typedefs for the Bob application.
 */
library Common;

/**
 * Used throughout Bob as the fingerprint for callbacks. Accepts a [json] map as
 * its sole parameter.
 */
typedef void Subscriber(Map json);

/**
 * Exception thrown when an operation times out.
 */
class TimeoutException implements Exception {
  final String message;

  const TimeoutException(this.message);

  String toString() => message;
}