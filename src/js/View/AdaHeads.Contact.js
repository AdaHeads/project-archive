/* 
 * Organization-related views.
 */

AdaHeads.Contact = {};

AdaHeads.Contact.List = {
  DOM_Element : "#contact_info_list", 
  Type : "<ul>"
};

/**
 * Populates the select with the data from organizations.
 * @param organizations A list of organizations.
 */
AdaHeads.Contact.List.Content = function (contacts) {
  $(AdaHeads.Contact.List.DOM_Element).empty();
  $.each (contacts, function (i, item) {
    var li = $("<li>").text(item.full_name).attr("id", item.contact_id);
    $(AdaHeads.Contact.List.DOM_Element).append (li);
  });
}
