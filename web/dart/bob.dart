/**
 * The Bob client. Helping recetionists do their work every day.
 */
import 'dart:async';
import 'configuration.dart';
import 'view.dart' as view;

Future<bool> longExpensiveSearch() {
  var completer = new Completer();

  // some stuff here to poll if the configuration is loaded.

  completer.complete(true);
  return completer.future;
}

/**
 * Instantiates all the view objects and gets Bob going.
 */
void main() {
  var result = longExpensiveSearch();

  print('before');

  result.then((success) {
    // The following code executes when the operation is complete.
    print('The item was found: $success');
  });

  print('after');

  final welcomeMessage = new view.WelcomeMessage();
  final agentInfo      = new view.AgentInfo();
  final companyInfo    = new view.CompanyInfo();
  final contactInfo    = new view.ContactInfo();
  final sendMessage    = new view.SendMessage();
  final globalQueue    = new view.GlobalQueue();
  final localQueue     = new view.LocalQueue();
  final overlay        = new view.Overlay();
  final navigation     = new view.Navigation(overlay);
}
