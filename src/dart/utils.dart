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