import 'dart:io';

import 'package:at_gauges/at_gauges.dart';
import 'package:flutter/material.dart';
import 'package:opengate_probe/info_provider.dart';

class SpeedtestPage extends StatelessWidget {
  final speedtestResults = InfoProvider.speedtestResults();

  SpeedtestPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Speedtest results"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: StreamBuilder(
            stream: speedtestResults,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Text("Speedtest results are loading...");
              }
              List<ResultModel> results = snapshot.data ?? [];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  results.isEmpty
                      ? const Text("No speedtest data")
                      : Text("Last speedtest : ${results[0].date}"),
                  ...results
                      .map((e) => Column(
                            children: [
                              Text(
                                e.type,
                                style: textTheme.titleLarge,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SpeedtestResultGauge(
                                      value: e.upload, title: "Upload"),
                                  SpeedtestResultGauge(
                                      value: e.download, title: "Download"),
                                ],
                              ),
                              Text(
                                "${e.ping} ms",
                                style: const TextStyle(fontSize: 20),
                              ),
                              const SizedBox(height: 20),
                            ],
                          ))
                      .toList(),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton(
                      onPressed: () {
                        Process.run(
                          'sudo',
                          ['python3', '/home/pi/opengate-probe/probe/main.py'],
                        );
                      },
                      child: const Text('Trigger a test'),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class SpeedtestResultGauge extends StatelessWidget {
  final int value;
  final String title;

  static const _maxVal = 150.0;

  const SpeedtestResultGauge({
    super.key,
    required this.value,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return ScaleRadialGauge(
      maxValue: value >= _maxVal ? value.toDouble() : _maxVal,
      actualValue: value > 0 ? value.toDouble() : 0,
      minValue: 0,
      size: 190,
      title: Text(title),
      titlePosition: TitlePosition.top,
      pointerColor: Colors.blue,
      needleColor: Colors.blue,
      decimalPlaces: 0,
      isAnimate: false,
      unit: const TextSpan(text: 'Mbps', style: TextStyle(fontSize: 15)),
    );
  }
}
