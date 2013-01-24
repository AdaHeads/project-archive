/**
 * The Bob client. Helping recetionists do their work every day.
 */
import 'view.dart' as view;

/**
 * Instantiates all the view objects and gets Bob going.
 */
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
