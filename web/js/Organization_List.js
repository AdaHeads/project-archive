"use strict";

AdaHeads.Organization_List = {};

AdaHeads.Organization_List.Data ={};
AdaHeads.Organization_List.Data['7001'] = {
  org_id : 1, 
  name : "Responsum"
};
// [{org_id : 0, name : "Dummy"},,{org_id : 7002, name : "AdaHeads"}];
/**
 * 
 */
AdaHeads.Organization_List.Fetch = function (org_id,callback) {
  // Dummy implementation.
  console.log (org_id);
  var obj = {
    org_id : 1, 
    name : "Responsum"
  };
  switch (org_id) {
    case 2:
      obj = {org_id : 2, 
        name : "AdaHeads"}
  }
  callback(obj);
}