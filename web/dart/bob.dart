/**
 * The Bob client. Helping receptionists do their work every day.
 */
import 'dart:async';
import 'dart:uri';
import 'dart:html';
import 'configuration.dart';
import 'view.dart';
import 'common.dart';


Future<bool> fetchConfig() {
  var completer = new Completer();

  // some stuff here to poll if the configuration is loaded.
  const int repeatTimeInMiliseconds = 5;
  int count = 0;
  new Timer.repeating(repeatTimeInMiliseconds, (t) {
    count += 1;
    if (configuration.loaded) {
      t.cancel();
      completer.complete(true);
    }
    if (count >= 3000/repeatTimeInMiliseconds){
      t.cancel();
      completer.completeError(new TimeoutException("Fetching configuration timedout"));
    }
  });

  return completer.future;
}

/**
 * Instantiates all the view objects and gets Bob going.
 */
void main() {
  var result = fetchConfig();
  result.then((success) {
    // The following code executes when the operation is complete.
    print('The item was found: $success');
    assert(configuration.loaded);

    final welcomeMessage = new WelcomeMessage();
    final agentInfo      = new AgentInfo();
    final companyInfo    = new CompanyInfo();
    final contactInfo    = new ContactInfo();
    final sendMessage    = new SendMessage();
    final globalQueue    = new GlobalQueue();
    final localQueue     = new LocalQueue();
    final overlay        = new Overlay();
    final navigation     = new Navigation(overlay);
  }).catchError((e) => print(e.toString()));
}
