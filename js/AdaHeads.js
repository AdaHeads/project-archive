/* 
 * Top level file of the AdaHeads Bob "Framework"
 * Contains various utility functions.
 * 
 * Dependencies: jQuery 1.6 or higher
 * 
 */

var AdaHeads = {}; // Namespace declaration 

/**
 * Loads an external script file asynchronously, but skips it if is 
 * already loaded.
 * 
 * @param file The script file to load
 */
AdaHeads.require_script = function (file){
  $.ajax({
    url: file, 
    async: false,  
    dataType: "script",
    error: function (e) {
      jQuery.error(e);
    }
  });
}

/**
 * Generates a random String of length n. Defaults to a length of 8 chars.
 * 
 * @param n Lenght of random string to generate.
 * 
 * @return A randomly generated string of length n
 */
AdaHeads.Random_String = function (n)
{
  if(!n || typeof n != "number") {
    n = 8;
  }

  var text = '';
  var range = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';

  for(var i=0; i < n; i++)  {
    text += range.charAt(Math.floor(Math.random() * range.length));
  }

  return text;
}