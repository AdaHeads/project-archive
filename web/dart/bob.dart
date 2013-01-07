import 'dart:math';
import 'dart:html';
import 'dart:json';
import 'widget.dart' as widget;
import 'organization.dart';
import 'organizations_list.dart';

void main() {
  final String       id = '#rootView';
  Organization       org = new Organization();
  Organizations_List orgs_list = new Organizations_List();
  Map                widgets = new Map<String, widget.UIWidget>();

  widgets['welcomeMessage'] = new widget.Window('welcomeMessage', (String json)
    {
      widgets['welcomeMessage'].body = json;
    })
      ..position = 'absolute'
      ..top = '0%'
      ..left = '6%'
      ..height = '15%'
      ..width = '70%'
      ..body = 'velkomst...';
  org.registerGreetingSubscriber(widgets['welcomeMessage']);

  widgets['agentInfo'] = new widget.Window('agentInfo', null)
    ..position = 'absolute'
    ..top = '0%'
    ..left = '77%'
    ..height = '15%'
    ..width = '23%'
    ..header = 'Agenter'
    ..body = 'agentInfo';

  widgets['companyInfo'] = new widget.Window('companyInfo', (String json)
    {
      query('#companyInfo_name').text = json;
      widgets['companyInfo'].header = JSON.parse(json)['full_name'];
    })
      ..position = 'absolute'
      ..top = '17%'
      ..left = '6%'
      ..height = '45%'
      ..width = '94%'
      ..header = 'Virksomhed';
  org.registerSubscriber(widgets['companyInfo']);

  widgets['companyInfo_select'] = new widget.Selector('companyInfo_select', (String json)
    {
      JSON.parse(json)['organization_list'].forEach((v)
        {
          widgets['companyInfo_select'].addOption(v['organization_id'].toString(), v['full_name']);
        });
    });
  orgs_list.registerSubscriber(widgets['companyInfo_select']);
  query('#companyInfo_select').on.change.add((e) {
    SelectElement select = query('#companyInfo_select');
    org.fetch(parseInt(select.value));
  });

  widgets['contactInfo'] = new widget.Window('contactInfo', null)
    ..position = 'absolute'
    ..top = '64%'
    ..left = '6%'
    ..height = '36%'
    ..width = '35%'
    ..header = 'Medarbejdere'
    ..body = 'contactInfo';

  widgets['sendMessage'] = new widget.Window('sendMessage', null)
    ..position = 'absolute'
    ..top = '64%'
    ..left = '42%'
    ..height = '36%'
    ..width = '35%'
    ..header = 'Besked'
    ..body = 'sendMessage';

  widgets['globalQueue'] = new widget.Window('globalQueue', null)
  ..position = 'absolute'
  ..top = '64%'
  ..left = '78%'
  ..height = '20%'
  ..width = '22%'
  ..header = 'Kald'
  ..body = 'globalQueue';

  widgets['localQueue'] = new widget.Window('localQueue', null)
    ..position = 'absolute'
    ..top = '86%'
    ..left = '78%'
    ..height = '14%'
    ..width = '22%'
    ..header = 'Lokal kø'
    ..body = 'localQueue';

  widgets['overlay'] = new widget.Window('overlay', null)
    ..position = 'absolute'
    ..top = '0%'
    ..left = '6%'
    ..height = '100%'
    ..width = '94%'
    ..header = 'Overlay'
    //..body = 'overlay'
    ..hide();

  widgets['navigation'] = new widget.Navigation ('navigation', null)
    ..contentWindow = widgets['overlay']
    ..position = 'absolute'
    ..top = '0%'
    ..left = '0%'
    ..height = '100%'
    ..width = '5%'
    ..addButton(new widget.NavigationButton('button1'))
    ..addButton(new widget.NavigationButton('button2'))
    ..addButton(new widget.NavigationButton('button3'))
    ..addButton(new widget.NavigationButton('button4'));

  // Set basic properties of the main view port div element.
  query(id).style.height = '${(window.innerHeight - 20).toString()}px';
  window.on.resize.add((e) => query(id).style.height = '${(window.innerHeight - 20).toString()}px');

  // Make it all visible
  query(id).style.display = 'block';
}
