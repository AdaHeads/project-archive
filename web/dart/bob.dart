import 'view.dart' as view;

void main() {
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
