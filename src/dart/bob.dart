/**
 * The Bob client. Helping receptionists do their work every day.
 */
import 'dart:async';
import 'dart:uri';
import 'dart:html';
import 'configuration.dart';
import 'view.dart';
import 'common.dart';
import 'logger.dart';
import 'storage.dart';
import 'environment.dart';
import 'model.dart';
import 'notification.dart' as notifi;

/**
 * Instantiates all the [view] objects and gets Bob going.
 */
void main() {
  final log = new Log();
  logger.info('Hello Bob');

  var result = fetchConfig();
  result.then((success) {
    assert(configuration.loaded);
    logger.fine("Got configuration");

    final notification   = new notifi.Notification();
    final welcomeMessage = new WelcomeMessage();
    final agentInfo      = new AgentInfo();
    final companyInfo    = new CompanyInfo();
    final contactInfo    = new ContactInfo();
    final sendMessage    = new SendMessage();
    final globalQueue    = new GlobalQueue();
    final localQueue     = new LocalQueue();
    final overlay        = new Overlay();
    final navigation     = new Navigation(overlay);

  }).catchError((e) => logger.finest(e.toString()));
}