/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

AdaHeads.Labels = {}; // Namespace declatation.

AdaHeads.Labels.Greeting = 
  ["Welcome, you are sure looking swell this day!", 
   "Welcome to wonderland!", 
   "Welcome - to the world of tomorrow!", 
   "Welcome. We hope you will enjoy our fancy application",
   "Welcome to ~22/7"];

AdaHeads.Labels.Initialize= function () {
  $('#agent_info_header').text("Agents");
  AdaHeads.Welcome_Panel.Message(AdaHeads.Labels.RandomGreeting);
  $('#company_info_header').text("Organization");
  $('#contact_info_header').text("Employees");
  $('#send_message_header').text("Messages (including debug)");
  $('#global_queue_header').text("Calls");
  $('#local_queue_header').text("Parking lot");
}

AdaHeads.Labels.RandomGreeting = function () {
  return AdaHeads.Labels.Greeting[Math.floor(Math.random() * AdaHeads.Labels.Greeting.length)];
}