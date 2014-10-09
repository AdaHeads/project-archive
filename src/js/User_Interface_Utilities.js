/**
 * User_Interface_Utilities.js - Various utility functions for updating the UI
 * 
 * Needs serious work.
 *
 * Author: Kim Rostgaard Christensen
 */

/**
 * Updates the Call Chain DOM node with the information supplied in the JSON
 * Object
 * @param Call_Chain_JSON The
 */
function Call_Chain_View_Update(Call_Chain_JSON,Call_Chain_DOM_Element){
    
}

// This function hides every element that does not match any search terms
function Filter_Contact_Entity_List() {
  // TODO: Change this to IndexedDB. This will remove the JSON.parse overhead
  //var json = JSON.parse(localStorage.getItem('Organization_Cache'));
  var json = $("#contacts").data("JSON");
  // Sanity checks
  if (json === null || json === undefined || jQuery.isEmptyObject(json)) {
    AdaHeads.Log(Log_Level.Error,"Empty JSON");
    return;
  }
  
  // Unhide every contact, if the search field is cleared
  if($("#Contact_Search_Field").val() === "") {
    AdaHeads.Log(Log_Level.Debug,"Search area cleared; showing all");
    $.each(json.contacts, function(i,contact){
      $("#ce_id_"+i).show();
    });
    return;
  }
  
  // Loop through every contact
  $.each(json.contacts, function(i,contact){
    var Matches = 0;
    var Number_Of_Keywords = -1;
    // Loop through every keyword in the search field
    var Keywords = $("#Contact_Search_Field").val().toLowerCase().split(" ");
    Number_Of_Keywords = Keywords.length;
    
    // Match each contact's name to each keyword
    $.each(Keywords, function(j,keyword) {
      /* The split returns an extra empty keyword when search string ends with 
         a space. This is compensation. */
      if(keyword === "") {
        Number_Of_Keywords--;
        return;
      }
      
      // If any part of their names matches, we're good.
      if(contact.name.toLowerCase().indexOf(keyword) >= 0) {
        Matches++;
        AdaHeads.Log(Log_Level.Debug,contact.name.toLowerCase()+" matches on " + keyword);
      }
      
      /* At this point we can break, if we have already found every match.
         We should also break if the contact has no tags */
      if(Matches >= Number_Of_Keywords || contact.attributes.tags === undefined) {
        return;
      }
    
      // Otherwise we do a full search on tags
      $.each(contact.attributes.tags, function(j,tag) {
        if(tag.toLowerCase().indexOf(keyword) >= 0) {
          Matches++;
          AdaHeads.Log(Log_Level.Debug,contact.name+"'s tag "+tag +" matches on " + keyword);
        }
      });
    });  

    if(Matches >= Number_Of_Keywords) {
      $("#ce_id_"+contact.db_columns.ce_id).show();
    }
    else {
      $("#ce_id_"+contact.db_columns.ce_id).hide();
      // if this is the selected element, we must find another to make active
      if ($("#ce_id_"+contact.db_columns.ce_id).hasClass('activeitem')) {
        $("#ce_id_"+contact.db_columns.ce_id).removeClass('activeitem');
        $('.Contact_Entity').filter(":visible").first().addClass('activeitem');
      }
    }
  });
}

function Clear_Search_Field() {
  AdaHeads.Log(Log_Level.Fatal,"Not implemented!");
}

function Search_Field_Hide() {
  $("#search").hide();
}

function Search_Field_Unhide() {
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

function Update_Company_Info(company,unhide) {
  if(company === null || company === undefined) {
      AdaHeads.Log(Log_Level.Error, "company object is not set");
      return;
  }
  
  if(jQuery.isEmptyObject(company)) {
      AdaHeads.Log(Log_Level.Error, "company object empty");
      return;
  }
  //AdaHeads.Log(Log_Level.Debug, JSON.stringify(company));
  
  // There is no div box to fill the content into; create it!
  if ($("#Company_Information").length === 0) {
  	$("<div>").appendTo("#sideRight").attr("id","Company_Information");
  }

  $('#Company_Information').first().show();
  
  $("<h2>").text(company.name).addClass("Organization_Name").appendTo("#Company_Information");
  $("<p>").text(company.db_columns.identifier).addClass("Company_Description").appendTo("#Company_Information");
  $("<p>").text("Address").addClass("Company_Address").appendTo("#Company_Information");
  $("<p>").text("Opening Hours").addClass("Company_Opening_Hours").appendTo("#Company_Information");
  
  Set_Greeting(Configuration.Standard_Greeting + company.name);
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

function Contact_Card_Update(contact) {
  // Create the contact card DOM object, if it doesn't
  if($("#Contact_Entity_View").length === 0) {
    $('<div>').attr('id','Contact_Entity_View').appendTo('body');
  } else {
    $("#Contact_Entity_View").empty();
  }

  // Unhide the overlay
  if($('.lightbox_bg').length !== 0 ) {
    $('.lightbox_bg').first().show();
  } else {
    $('<div>').addClass('lightbox_bg').appendTo('body');
    $('.lightbox_bg').first().show();
  }
  
  // Fill out the contact card
  $('<h2>').text(contact.name).appendTo($("#Contact_Entity_View"));
  
  $('<h3>').text(contact.type).appendTo($("#Contact_Entity_View"));
  //$('<pre>').text(contact.attributes[0].email).appendTo($("#Contact_Entity_View"));
  
  $("#Contact_Entity_View").show();
}

function Contact_Card_Hide() {
    $("#Contact_Entity_View").hide();
}

/* Updates the contactlist based on the id parameter */
function Populate_Contact_Entity_List(jsondata) {
  $("#contacts").empty();

  $("#contacts").data("JSON", jsondata);
  if (jsondata.contacts.length === 0 || jsondata.contacts.length === undefined) { 
    $('<p>').text("No contacts found!").appendTo("#contacts");
    console.log("Populate_Contact_Entity_List: No contacts found!");
    return;
  };

  $.each(jsondata.contacts, function(i,contact){
    var Current_Li = $("<li>").addClass("Contact_Entity").appendTo("#contacts");

    if(i === 0) {
      Current_Li.addClass("activeitem");
      $("<a>").text(contact.name).attr("href","#").appendTo(Current_Li);
    }
    else {
      $("<a>").text(contact.name).attr("href","#").appendTo("#contacts").appendTo(Current_Li)	;
    };
    
    //AdaHeads.Log(Log_Level.Debug,JSON.stringify(contact));
    if(contact.attributes.tags !== undefined) {
      $.each(contact.attributes.tags, function(j,tag) {
        $("<span>").text(tag).addClass("Tag").appendTo(Current_Li); 
      });
    }
  
    // Every element has an id based on organization and iterator id;
    Current_Li.attr("id","ce_id_"+contact.db_columns.ce_id);
  
    // Add their type as a class
    Current_Li.addClass(contact.type);

     
    // Attach a click handler
    Current_Li.click(function () {
      $("#contacts").find(".Contact_Entity").removeClass("activeitem");
      $(this).addClass("activeitem");
      AdaHeads_Get_Contact(contact.db_columns.ce_id);
      return;
    });
  });
  
  // Set the visibility to true
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
  $.each(json.HIGH, function(i,call){
    $("<li>").text("Date: " +call.Arrived+ " Caller: " + call.CallerIDNum + " Uniqueid: " + call.Uniqueid).appendTo("#Call_List_High_Priority");
  });
    
  $.each(json.NORMAL, function(i,call){
    $("<li>").text("Date: " +call.Arrived+ " Caller: " + call.CallerIDNum + " Callee: " + call.Uniqueid).appendTo("#Call_List_Normal_Priority");
  });

  $.each(json.LOW, function(i,call){
    $("<li>").text("Date: " +call.Arrived+ " Caller: " + call.CallerIDNum + " Callee: " + call.Uniqueid).appendTo("#Call_List_Low_Priority");
  });
};

/**
 * Function definition that enables .last on jQuery Arrary objects.
 */
Array.prototype.last = function() {return this[this.length-1];};