import 'dart:math';
import 'dart:html';
import 'dart:json';
import 'widget.dart' as widget;
import 'organization.dart';
import 'organizations_list.dart';
import 'view.welcomeMessage.dart';

void main() {
  DivElement         rootView = query('#rootView');

  Organization       org = new Organization();
  Organizations_List orgs_list = new Organizations_List();

  widget.Navigation  navigation;
  widget.Selector    companySelector;
  Map                windows = new Map<String, widget.Window>();

  final WelcomeMessage welcomeMessage = new WelcomeMessage();

  windows['agentInfo'] = new widget.Window('agentInfo', null)
    ..header = 'Agenter'
    ..body = 'agentInfo';

  windows['companyInfo'] = new widget.Window('companyInfo', (Map json)
    {
      query('#companyInfo_dump').text = json.toString();
      windows['companyInfo'].header = json['full_name'];
    })
      ..header = 'Virksomhed';
  org.registerSubscriber(windows['companyInfo']);

  windows['contactInfo'] = new widget.Window('contactInfo', null)
    ..header = 'Medarbejdere'
    ..body = 'contactInfo';

  windows['sendMessage'] = new widget.Window('sendMessage', null)
    ..header = 'Besked'
    ..body = 'sendMessage';

  windows['globalQueue'] = new widget.Window('globalQueue', null)
  ..header = 'Kald'
  ..body = 'globalQueue';

  windows['localQueue'] = new widget.Window('localQueue', null)
    ..header = 'Lokal kø'
    ..body = 'localQueue';

  windows['overlay'] = new widget.Window('overlay', null)
    ..header = 'Overlay'
    //..body = 'overlay'
    ..hide();

  navigation = new widget.Navigation ('navigation', null)
    ..contentWindow = windows['overlay']
    ..addButton(new widget.NavigationButton('button1'))
    ..addButton(new widget.NavigationButton('button2'))
    ..addButton(new widget.NavigationButton('button3'))
    ..addButton(new widget.NavigationButton('button4'));

  companySelector = new widget.Selector('companyInfo_select', (Map json)
      {
        json['organization_list'].forEach((v)
          {
            companySelector.addOption(v['organization_id'].toString(), v['full_name']);
          });
      });
  orgs_list.registerSubscriber(companySelector);
  query('#companyInfo_select').on.change.add((e) {
    SelectElement select = query('#companyInfo_select');
    org.fetch(parseInt(select.value));
  });

  // Set basic properties of the main view port div element.
  rootView.style.height = '${(window.innerHeight - 20).toString()}px';
  window.on.resize.add((e) => rootView.style.height = '${(window.innerHeight - 20).toString()}px');

}
