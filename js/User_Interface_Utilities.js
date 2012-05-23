/**
 * User_Interface_Utilities.js - Various utility functions for updating the UI
 *
 * Author: Kim Rostgaard Christensen
 */


function Filter_Contact_Entity_List() {
  //alert($("#Tags").value);
  //$('#debugfield').empty();
  // This function hides every element that does not match any search terms

  var json = JSON.parse(localStorage.getItem('Organization_Cache'));
  if (json  === null) {
      return;
  }
  
  if($("#Contact_Search_Field").val() === "") {
    AdaHeads_Log(Log_Level.Debug,"Search area cleared; showing all");
    $.each(json.contacts, function(i,contact){
      $("#ce_id_"+i).show();
    });
    return;
  }
  
  $.each(json.contacts, function(i,contact){
    var Matches = 0;
    var Number_Of_Keywords = -1;
    // Loop through every keyword in the search field
    var Keywords = $("#Contact_Search_Field").val().toLowerCase().split(" ");
    Number_Of_Keywords = Keywords.length;
    $.each(Keywords, function(j,keyword) {
      // The split returns an empty string when search string ends with a space
      if(keyword === "") {
        Number_Of_Keywords--;
        return;
      }
      // First, search the names
      if(contact.name.toLowerCase().indexOf(keyword) >= 0) {
        Matches++;
        AdaHeads_Log(Log_Level.Debug,contact.name.toLowerCase()+" matches on " + keyword + " keyword.length: "+ Keywords.length);
      }
          
    });  

    if(Matches === Number_Of_Keywords) {
      $("#ce_id_"+i).show();
    }
    else {
      $("#ce_id_"+i).hide();
      // if this is the selected element, we must find another to make active
      if ($("#ce_id_"+i).hasClass('activeitem')) {
        $("#ce_id_"+i).removeClass('activeitem');
        $('.Contact_Entity').filter(":visible").first().addClass('activeitem');
      }
    }
  });
 /*
  $('.Contact_Entity').each(function(index) {
    var match = false;

    // Split up the names, and search for a match in either
    var names = $(this).find('a').text().split(" ");
    jQuery.each(names, function(i,name) {
      if(name.toLowerCase().indexOf($("#Tags").val()) >= 0) {
        match = true;
      }
    });

    // Loop through every tag element, and see if we have a match
   //jQuery.each($(this).find(".Tag"), function(i,tag) {
   //   alert("hat" +tag.html());
   //   $('<p>').text(tag.hmtl()).appendTo($('#debugfield'));
   // });

    // If anything matches, we keep/unhide the element - otherwise hide it
    if(match) {
      $(this).show();
      //$('<p>').text($(this).find('a').text()).appendTo($('#debugfield'));
    }
    else {
      $(this).hide();
    }
  });
*/
}

function Clear_Search_Field() {
  AdaHeads_Log(Log_Level.Fatal,"Not implemented!");
}

function Hide_Search_Field() {
  $("#search").hide();
}

function Unhide_Search_Field() {
  $("#search").show();
  $("#Contact_Search_Field").focus();
}

/* */
function Hide_Call_List(){
  $("#Call_List_Low_Priority").hide();
  $("#Call_List_Normal_Priority").hide();
  $("#Call_List_High_Priority").hide();
}

function Unhide_Call_List(){
  $("#Call_List_Low_Priority").show();
  $("#Call_List_Normal_Priority").show();
  $("#Call_List_High_Priority").show();
}

function Unhide_Company_Info() {
  // There is no div box to fill the content into; create it!
  if ($("#Company_Information").length === 0) {
  	$("<div>").appendTo("#sideRight").attr("id","Company_Information");
  }

  $('#Company_Information').first().show();
  //$('#Company_Information').first().append();
  
  $("<h2>").text("Organisationsnavn").addClass("Organization_Name").appendTo("#Company_Information");
  $("<p>").text("Beskrivelse/").addClass("Company_Description").appendTo("#Company_Information");
  $("<p>").text("Address").addClass("Company_Address").appendTo("#Company_Information");
  $("<p>").text("Opening Hours").addClass("Company_Opening_Hours").appendTo("#Company_Information");
}

function Hide_Company_Info() {
  if ($("#Company_Information").length > 0) {
  	$('#Company_Information').first().hide();
  	$('#Company_Information').first().empty();
  }
}

function Set_Greeting(greeting) {
	$('#Greeting').text(greeting);
}

function Show_Contact(contact) {
  AdaHeads_Log(Log_Level.Debug, "nooo");
  $("#Contact_Entity_View").empty();
  $("#Contact_Entity_View").append();

  $("body").find(".lightbox_bg").remove();
  $("body").find(".Contact_Entity_View").remove();
  //add modal background
  $('<div />').addClass('lightbox_bg').appendTo('body').show();
  //add modal window
  $('<div />').text(contact.name).addClass('Contact_Entity_View').appendTo('body');
}

/* Updates the contactlist based on the id parameter */
function Populate_Contact_Entity_List(data) {
  	$("#contacts").empty();

  	if (data.contacts.length === 0 || data.contacts.length === undefined) { 
      $('<p>').text("No contacts found!").appendTo("#contacts");
  	  console.log("Populate_Contact_Entity_List: No contacts found!");
  	  return;
    };

    $.each(data.contacts, function(i,contact){
      var Current_Li = $("<li>").addClass("Contact_Entity").appendTo("#contacts");

      if(i === 0) {
        Current_Li.addClass("activeitem");
      	$("<a>").text(contact.name).attr("href","#").appendTo(Current_Li);

        $("<span>").text("Slackware").addClass("Tag").appendTo(Current_Li);
      }
      else {
        $("<a>").text(contact.name).attr("href","#").appendTo("#contacts").appendTo(Current_Li)	;
        $("<span>").text("Ada").addClass("Tag").appendTo(Current_Li);
      };
      // Every element has an id based on organization and iterator id;
      Current_Li.attr("id","ce_id_"+i);

      //TODO: Attach real tags

      // Attach a click handler
      Current_Li.click(function () {
        $("#contacts").find(".Contact_Entity").removeClass("activeitem");
        $(this).addClass("activeitem");
        AdaHeads_Get_Contact(contact.db_columns.ce_id);
        return;
      });
  })


  $("#contacts").show();
}

function Hide_Contact_Entity_List(){
  $("#contacts").hide();
}

function Update_Call_List(json) {
    /* Clear out old queue lists */
    $("#Call_List_Low_Priority").empty();
    $("#Call_List_Normal_Priority").empty();
    $("#Call_List_High_Priority").empty();

    //$("<ul>").appenddTo("#sideRight").attr("id","Call_List_High_Priority");

    $.each(json.high, function(i,item){
      $("<li>").text("Date: " +item.UTC_start_date+ " Caller: " + item.caller + " Callee: " + item.callee).appendTo("#Call_List_High_Priority");
    });
    
    $.each(json.normal, function(i,item){
      $("<li>").text("Date: " +item.UTC_start_date+ " Caller: " + item.caller + " Callee: " + item.callee).appendTo("#Call_List_Normal_Priority");
    });

    $.each(json.low, function(i,item){
      $("<li>").text("Date: " +item.UTC_start_date+ " Caller: " + item.caller + " Callee: " + item.callee).appendTo("#Call_List_Low_Priority");
    });
};


Array.prototype.last = function() {return this[this.length-1];}