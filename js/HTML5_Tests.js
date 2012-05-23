/**
 * HTML5_Tests.js - basic functions for testing various HTML5 capabilites
 */

/* Basic function for testing if the browser has localStorage available*/
function Supports_HTML5_localStorage() {
  try {
    return 'localStorage' in window && window['localStorage'] !== null;
  } catch (e) {
    return false;
  }
}