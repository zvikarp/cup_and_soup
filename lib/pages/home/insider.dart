import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:cup_and_soup/utils/transparentRoute.dart';
import 'package:cup_and_soup/dialogs/feadbackForm.dart';
import 'package:cup_and_soup/widgets/core/button.dart';
import 'package:cup_and_soup/widgets/core/divider.dart';
import 'package:cup_and_soup/widgets/core/page.dart';

class InsiderPage extends StatefulWidget {
  @override
  _InsiderPageState createState() => _InsiderPageState();
}

class _InsiderPageState extends State<InsiderPage> {
  @override
  Widget build(BuildContext context) {
    return PageWidget(
      title: "insider",
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: <Widget>[
            Text(
              "How to send bug reports?",
              style: Theme.of(context).textTheme.title,
            ),
            SizedBox(
              height: 24,
            ),
            Text(
                "Send a screenshot (with some text explaning what's the problem) by WhatsApp to Ruby Gross, he collects them and passes them on."),
            DividerWidget(),
            Text(
              "How to help translating the app?",
              style: Theme.of(context).textTheme.title,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Text(
                  "Click on the button bellow to go to the translation table. If you change a row (add hebrew translation or fix spelling/grammer issues in the english or hebrew, make sure that 'saved' is 'no'. If you have any questions, you can speak with Etamar Shuvin, Avi Cohen and Naor Boublil."),
            ),
            ButtonWidget(
              onPressed: () {
                launch(
                    "https://docs.google.com/spreadsheets/d/1eUU-AomW1PsNhwZ1acI154ePHIPQuXvd5fylNgXtbrA/edit?usp=sharing");
              },
              text: "TRANSLATION TABLE",
              primary: false,
            ),
            DividerWidget(),
            Text(
              "How to work on the apps UI?",
              style: Theme.of(context).textTheme.title,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Text(
                  "Send a screenshot (with some text explaning how the app should look) by WhatsApp to Zvi Karp."),
            ),
            DividerWidget(),
            Text(
              "Contact us",
              style: Theme.of(context).textTheme.title,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Text(
                  "Just what to say hi? send us a message through this form:"),
            ),
            ButtonWidget(
              onPressed: () {
                Navigator.of(context).push(
                  TransparentRoute(
                    builder: (BuildContext context) => FeadbackFormDialog(),
                  ),
                );
              },
              text: "CONTACT",
              primary: false,
            ),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
