import 'dart:html';
import 'view.dart';

void main() {
  DivElement rootView = query('#rootView');

  rootView.style.height = '${(window.innerHeight - 20).toString()}px';
  window.on.resize.add((e) => rootView.style.height = '${(window.innerHeight - 20).toString()}px');

  final welcomeMessage = new WelcomeMessage();
  final agentInfo      = new AgentInfo();
  final companyInfo    = new CompanyInfo();
  final contactInfo    = new ContactInfo();
  final sendMessage    = new SendMessage();
  final globalQueue    = new GlobalQueue();
  final localQueue     = new LocalQueue();
  final overlay        = new Overlay();
  final navigation     = new Navigation(overlay);
}
