/**
 * HTML5_Tests.js - basic functions for testing various HTML5 capabilites
 * This could actually be done by Modernizr (http://www.modernizr.com/)
 */

/* Basic function for testing if the browser has localStorage available*/
function Supports_HTML5_localStorage() {
  try {
    return 'localStorage' in window && window['localStorage'] !== null;
  } catch (e) {
    return false;
  }
  return false;
}


function Supports_HTML5_indexedDB() {
  // Handle the prefix of Chrome to IDBTransaction/IDBKeyRange.
  if ('webkitIndexedDB' in window) {
      return true;
  }
  return false;
}