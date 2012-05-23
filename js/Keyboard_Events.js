var Shift_Pressed = false;
var Ctrl_Pressed  = false;
var Alt_Pressed   = false;
var AtlGr_Pressed = false;
var Super_Pressed = false;

$(window).load(function(){
$(function() {
  var contacsLeft  = 100;
  var currentVert  =   0;

  //TODO - update this, so it only finds elements that are not hidden
  var scrollVert = function() {
    var Contact_Entity = $("#contacts").find(".Contact_Entity").eq(currentVert);

    $("#contacts").find(".Contact_Entity").removeClass("activeitem");
    Contact_Entity.addClass("activeitem");
  };

  /* Keyboard keydown handler*/
    $(document).keydown(function(e) {
        switch (e.which) {

        // AltGr
        case 0:
          AtlGr_Pressed = true;
          break;

        // Enter
        case 13 :
          if (Current_State === "In_Call") {
            $("#contacts").find(".activeitem").click();
          };
          break;

        // Shift
        case 16:
          Shift_Pressed = true;
          break;

        // Ctrl
        case 17:
          Ctrl_Pressed = true;
          break;
        
        // Alt
        case 18:
          Alt_Pressed = true;
          break;
        
        // Escape
        case 27:
            $("body").find(".lightbox_bg").hide();
            $("body").find(".Contact_Entity_View").remove();
            break;
        // Left
        case 37: 
            break;

        // up
        case 38:
        //TODO Send this event to the ative tab
            if (currentVert === undefined) {
                currentVert = 0;
                break;
            }

            if (currentVert > 0) {
                currentVert--;
                scrollVert();
            }
            break;

        // right
        case 39:
            break;

        // down             
        case 40:
        //TODO Send this event to the ative tab
            if (currentVert === undefined) {
                currentVert = 0;
                break;
            }

            var maxVert = $("#contacts").find(".Contact_Entity").length - 1;

            if (currentVert < maxVert) {
                currentVert++;
                scrollVert();
            }
            break;

        //a
        case 65:
          if(Alt_Pressed) {
              $("#Take_Call_Button").click();
          };
          break;

        // s
        case 83:
          if(Alt_Pressed) {
            $("#End_Call_Button").click();
          };
          break;

        // t
        case 84:
 
          break;
        // Super
        case 91:
          Super_Pressed = true;
          break;            

        // +
        case 191:
          break;
          
          break;
        default:
          //alert(e.which);
          break;
        }
    });



  /* Keyboard keyup handler*/
    $(document).keyup(function(e) {
        switch (e.which) {
        // AltGr
        case 0:
          AtlGr_Pressed = false;
          break;

        // Shift
        case 16:
          Shift_Pressed = false;
          break;

        // Ctrl
        case 17:
          Ctrl_Pressed = false;
          break;
        
        // Alt
        case 18:
          Alt_Pressed = false;
          break;
        
        // Super
        case 91:
          Super_Pressed = false;
          break;

        default:
          //TODO Send this event to the ative tab
          Filter_Contact_Entity_List();
          //alert(e.which);
          break;
        }
    });

});
});