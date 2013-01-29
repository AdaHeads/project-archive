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

/**
 * Instantiates all the [view] objects and gets Bob going.
 */
void main() {
  final log            = new Log();
  var result = fetchConfig();
  result.then((success) {
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
    logger.info('Every thing is initialized');
  }).catchError((e) => logger.finest(e.toString()));

  Storage_Organization.instance.getOrganization(1, (o) => logger.info(o.toString()));
  Storage_Organization.instance.getOrganizationList((o) => logger.info(o.toString()));
}