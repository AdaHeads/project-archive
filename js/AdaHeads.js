/* 
 * Top level file of the AdaHeads Bob "Framework"
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
