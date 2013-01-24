/* 
 * Organization-related views.
 */

AdaHeads.Organization = {};

AdaHeads.Organization.Select = {
  DOM_Element : "#company_info_select", 
  Type : "<select>"
};

/**
 * Populates the select with the data from organizations.
 * @param organizations A list of organizations.
 */
AdaHeads.Organization.Select.Content = function (organizations) {
  $.each (organizations.organization_list, function (i, item) {
    var option = new Option(item.full_name, item.organization_id);
    $("#company_info_select").append (option);
  });
}

AdaHeads.Organization.Display = function (organization) {
  console.log (organization);
  AdaHeads.Welcome_Panel.Message(organization.greeting);
  AdaHeads.Organization_Information_Panel.Display(organization);
  AdaHeads.Contact.List.Content (organization.contacts);
};
