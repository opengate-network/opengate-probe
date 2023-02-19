import 'package:flutter/material.dart';

import 'info_provider.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 20,
            child: Image.asset("assets/cropped_transparent-bleu.png"),
          ),
          StreamBuilder(
            stream: InfoProvider.interfacesAddresses(),
            builder: (context, snapshot) {
              return Text(
                  snapshot.data?.map((e) => "${e.address} ").toString() ?? "");
            },
          )
        ],
      ),
    );
  }
}
