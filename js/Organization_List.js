"use strict";

AdaHeads.Organization_List = {};

AdaHeads.Organization_List.Data ={};
AdaHeads.Organization_List.Data['7001'] = {org_id : 1, name : "Responsum"};
// [{org_id : 0, name : "Dummy"},,{org_id : 7002, name : "AdaHeads"}];
/**
 * 
 */
AdaHeads.Organization_List.Fetch = function (org_id,callback) {

  //callback(AdaHeads.Organization_List.Data[org_id]);
  callback({org_id : 1, name : "Responsum"});
}