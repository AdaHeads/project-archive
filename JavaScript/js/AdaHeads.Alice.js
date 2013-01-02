/* 
 * Class for Alice - Takes care of the server communication via Callbacks
 */

AdaHeads.Alice = {}; // Namespace declatation.

/**
 * Pickup the next call in the queue, regardless of id.
 * @param handlers Object containing the handlers for different reponses.
 *                 The keys are status codes e.g. 200 and the values are
 *                 their corresponding callback.
 */
AdaHeads.Alice.Get_Next_Call = function(handlers) {
  url = Configuration.Alice_URI+AdaHeads.Protocol.Alice.Pickup_Call
    +'?agent_id='+Configuration.Agent_ID;
  console.log (url);
  $.ajax({
    type: 'GET',
    url: url,
    dataType: 'json',
    statusCode: handlers
  });
}

/**
 * Pickup a specific call from the queue based on call ID.
 * @param call_id the id to pickup.
 * @param handlers Object containing the handlers for different reponses.
 *                 The keys are status codes e.g. 200 and the values are
 *                 their corresponding callback.
 */
AdaHeads.Alice.Pickup_Call = function(call_id,handlers) {
  url = Configuration.Alice_URI+AdaHeads.Protocol.Alice.Pickup_Call
    +'?agent_id='+Configuration.Agent_ID+"&call_id="+call_id;
  console.log (url);
  $.ajax({
    type: 'GET',
    url: url,
    dataType: 'json',
    statusCode: handlers
  });
}

/**
 * Originate a call to the specified extension.
 * @param extension The extension to dial.
 * @param handlers Object containing the handlers for different reponses.
 *                 The keys are status codes e.g. 200 and the values are
 *                 their corresponding callback.
 */
AdaHeads.Alice.Originate = function(extension, handlers) {
  url = Configuration.Alice_URI+AdaHeads.Protocol.Alice.Originate_Call
    +'?agent_id='+Configuration.Agent_ID+"&extension="+extension;
  $.ajax({
    type: 'GET',
    url: url,
    dataType: 'json',
    statusCode: handlers
  });
}

/**
 * Hangup a specific call.
 * @param call_id  The ID of the call to hangup.
 * @param handlers Object containing the handlers for different reponses.
 *                 The keys are status codes e.g. 200 and the values are
 *                 their corresponding callback.
 */
AdaHeads.Alice.Hangup_Call = function (call_id, handlers) {
  url = Configuration.Alice_URI+AdaHeads.Protocol.Alice.Hangup_Call 
    +"?call_id="+call_id;

  $.ajax({
    type: 'GET',
    url: url,
    dataType: 'json',
    statusCode: handlers
  })
}

/**
 * Park a call.
 * @param call_id  The ID of the call to park.
 * @param handlers Object containing the handlers for different reponses.
 *                 The keys are status codes e.g. 200 and the values are
 *                 their corresponding callback.
 */
AdaHeads.Alice.Park_Call = function (call_id, handlers) {
  url = Configuration.Alice_URI+AdaHeads.Protocol.Alice.Park_Call
    +"?call_id="+call_id;

  $.ajax({
    type: 'GET',
    url: url,
    dataType: 'json',
    statusCode: handlers
  })
}

/**
 * Fetches the Contact_Entity object with the supplied ce_id.
 * @param ce_id    The ID of the contact entity.
 * @param handlers Object containing the handlers for different reponses.
 *                 The keys are status codes e.g. 200 and the values are
 *                 their corresponding callback.
 */
AdaHeads.Alice.Get_Contact_Full = function (ce_id, handlers) {
  url = Configuration.Alice_URI+AdaHeads.Protocol.Alice.Get_Contact_Full
    +'?ce_id='+ce_id;
  
  $.ajax({
    type: 'GET',
    url: url,
    dataType: 'json',
    statusCode: handlers
  });
}

/**
 * Fetches the contact entity objects assiciated with the organization with
 * the supplied ID.
 * @param org_id  The ID of the organization.
 * @param handlers Object containing the handlers for different reponses.
 *                 The keys are status codes e.g. 200 and the values are
 *                 their corresponding callback.
 */
AdaHeads.Alice.Get_Org_Contacts_Full = function (org_id, handlers) {
  url = Configuration.Alice_URI+AdaHeads.Protocol.Alice.Get_Org_Contacts_Full
    +"?org_id="+org_id;
  
  $.ajax({
    type: 'GET',
    url: url,
    dataType: 'json',
    statusCode: handlers
  });
}

/**
 * Fetches the current list of unanswered inbound calls.
 * @param handlers Object containing the handlers for different reponses.
 *                 The keys are status codes e.g. 200 and the values are
 *                 their corresponding callback.
 */
AdaHeads.Alice.Get_Queue = function (handlers) {
  url = Configuration.Alice_URI+AdaHeads.Protocol.Alice.Get_Queue;
  
  $.ajax({
    type: 'GET',
    url: url,
    dataType: 'json',
    statusCode: handlers
  });
}
  
/**
 * Fetches the contact entites associated with the organization with the
 * supplied ID.
 * @param org_id   The ID of the organization to fetch contacts for.
 * @param handlers Object containing the handlers for different reponses.
 *                 The keys are status codes e.g. 200 and the values are
 *                 their corresponding callback.
 */
AdaHeads.Alice.Get_Organization = function (org_id, handlers) {
  url = Configuration.Alice_URI+AdaHeads.Protocol.Alice.Get_Org_Contacts_Full
    +"?org_id="+org_id;
  $.ajax({
    type: 'GET',
    url: url,
    dataType: 'json',
    statusCode: handlers
  });
}