import 'package:flutter/material.dart';
import 'package:opengate_probe/interface_information_page.dart';

import 'info_provider.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          HomeTitle(),
          HomeMenu(),
        ],
      ),
    );
  }
}

class HomeTitle extends StatelessWidget {
  const HomeTitle({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(left: 10, top: 10),
      child: Row(
        children: [
          SizedBox(
            height: 25,
            child: Image.asset("assets/cropped_transparent-bleu.png"),
          ),
          const SizedBox(width: 9),
          Text(
            "Probe",
            style: textTheme.titleLarge,
          ),
        ],
      ),
    );
  }
}

class HomeMenu extends StatelessWidget {
  const HomeMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
      child: Wrap(
        children: [
          HomeMenuButton(
            text: "Trigger a test",
            onTap: () {},
          ),
          HomeMenuButton(
            text: "Interfaces information",
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => InterfaceInformationPage(),
              ),
            ),
          ),
          HomeMenuButton(
            text: "Change password",
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class HomeMenuButton extends StatelessWidget {
  final String text;
  final Function() onTap;

  const HomeMenuButton({
    super.key,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: SizedBox(
          width: 100,
          height: 100,
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Center(
              child: Text(
                text,
                style: textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
