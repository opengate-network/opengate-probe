import 'dart:async';
import 'dart:io';

class InfoProvider {
  static const ipAddressRefreshDelay = Duration(seconds: 30);

  static Stream<List<InternetAddress>> interfacesAddresses() {
    final controller = StreamController<List<InternetAddress>>();

    Timer.periodic(ipAddressRefreshDelay, (timer) async {
      final interfaceList = await NetworkInterface.list();
      List<InternetAddress> address = [];

      for (final interface in interfaceList) {
        address.addAll(interface.addresses);
      }

      controller.add(address);

    });
    return controller.stream;
  }
}
