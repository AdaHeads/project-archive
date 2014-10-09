
function Observer_Class (Observer_ID,callback) {
  this.Observer_ID = Observer_ID || AdaHeads.Random_String(16);
  
  this.callback = callback || function () {
    jQuery.error("No callback for Observer: "+Observer_ID);
  }
  
}