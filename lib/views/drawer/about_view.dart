import 'package:flutter/material.dart';
import 'package:my_recipe_box/utils/dialogs/error_dialog.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class AboutView extends StatelessWidget {

   const AboutView({super.key});
   void _launchURL(Uri url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  void launchEmail(BuildContext context) async {
  final Uri emailUri = Uri(
    scheme: 'mailto', // Make sure to include this
    path: 'kalebtesfahun@gmail.com', // The email address
    queryParameters: {
      'subject': '',
      'body': ''
    },
  );

  if (await canLaunchUrl(emailUri)) {
    await launchUrl(emailUri);
  } else {
    if(context.mounted) await showErrorDialog(context: context, errorMessage: "Unable to launch email.");
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "About Meal Organizer",
          ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // App Logo & Name
              Center(
                child: Column(
                  children: [
                    Icon(Icons.food_bank, size: 60),
                    SizedBox(height: 10),
                    Text(
                      "Meal Organizer",
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
        
              // App Purpose
              Text(
                "This is the description of the app, Not done yet"
              ),
              SizedBox(height: 20),
        
              Divider(),
        
              // Developer Info
              ListTile(
                leading: Icon(Icons.person),
                title: Text("Developed by Kaleb Tesfahun"),
                subtitle: Text("Developer"),
              ),
        
              // Version Info
              ListTile(
                leading: Icon(Icons.info_outline),
                title: Text("Version"),
                subtitle: Text("1.0.0"),
              ),
        
              // TMDB Disclaimer
              SizedBox(height: 20),
              // External Links redirected when tapped using lanunch url
              Divider(),
              ListTile(
                leading: Icon(FontAwesomeIcons.github),
                title: Text("GitHub Repository"),
                onTap: () => _launchURL(Uri.parse("https://github.com/kalutm/MyRecipeBox.git")),
              ),
              ListTile(
                leading: Icon(Icons.email),
                title: Text("Contact Developer"),
                subtitle: Text("kalebtesfahun@gmail.com"),
                onTap: () => launchEmail(context),
              ),
              ListTile(
                leading: Icon(FontAwesomeIcons.telegram),
                title: Text("Contact Me Via Telegram"),
                onTap: () => _launchURL(Uri.parse('https://t.me/kalutm')),
              ),
            ],
          ),
        ),
      ),
    );
  }

}