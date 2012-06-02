
var Log_Level = Object.freeze({
         Information: "INFO",
         Warning:     "WARN",
         Debug:       "DEBUG",
         Error:       "ERROR",
         Fatal:       "FATAL"
});

 /* Syslog-ish interface for various debugging messages */
 function AdaHeads_Log(level,msg) {
     if(Configuration.Debug_Enabled) {
         var callee = arguments.callee.caller.name;
         if(callee === "") {
             //TODO - maybe trace this one further
             callee = "callback";
         }
         console.log(level +" " +callee+": "+msg);
     }
 }