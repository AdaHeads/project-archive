/*                                Bob
                   Copyright (C) 2012-, AdaHeads K/S

  This is free software;  you can redistribute it and/or modify it
  under terms of the  GNU General Public License  as published by the
  Free Software  Foundation;  either version 3,  or (at your  option) any
  later version. This library is distributed in the hope that it will be
  useful, but WITHOUT ANY WARRANTY;  without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
  You should have received a copy of the GNU General Public License and
  a copy of the GCC Runtime Library Exception along with this program;
  see the files COPYING3 and COPYING.RUNTIME respectively.  If not, see
  <http://www.gnu.org/licenses/>.
*/
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