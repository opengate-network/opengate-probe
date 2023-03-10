import 'dart:io';

import 'package:flutter/material.dart';
import 'package:opengate_probe/info_provider.dart';

class InterfaceInformationPage extends StatelessWidget {
  InterfaceInformationPage({super.key});

  final interfaceStream = InfoProvider.interfaces();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Interfaces Information"),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StreamBuilder(
                  stream: interfaceStream,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Text("Loading ...");
                    }

                    List<NetworkInterface> interfaces = snapshot.data ?? [];

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: interfaces
                          .map(
                            (interface) => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  interface.name,
                                  style: textTheme.titleSmall,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: interface.addresses
                                      .map((address) => Text(address.address))
                                      .toList(),
                                ),
                                const SizedBox(height: 10),
                              ],
                            ),
                          )
                          .toList(),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
