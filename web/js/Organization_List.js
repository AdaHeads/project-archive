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
  AdaHeads.Alice.Get_Organization (org_id,
  {
    200 : callback,
    404 : function (data) {
      console.log ("AdaHeads.Alice.Get_Organization_List 404");
    },
    204 : function (data) {
      console.log ("AdaHeads.Alice.Get_Organization_List 204");
    },
    500 : function (data) {
      console.log ("AdaHeads.Alice.Get_Organization_List 500");
    }
  });

}