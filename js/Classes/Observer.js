
function Observer_Class (Observer_ID,callback) {
  this.Observer_ID = Observer_ID || randString(16);
  
  this.callback = callback || function () {
    jQuery.error("No callback for Observer: "+Observer_ID);
  }
  
}

function randString(n)
{
  if(!n)
  {
    n = 5;
  }

  var text = '';
  var possible = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';

  for(var i=0; i < n; i++)
  {
    text += possible.charAt(Math.floor(Math.random() * possible.length));
  }

  return text;
}