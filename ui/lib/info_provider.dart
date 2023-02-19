import 'dart:async';
import 'dart:io';

class InfoProvider {
  static const ipAddressRefreshDelay = Duration(seconds: 30);



  static Stream<List<NetworkInterface>> interfacesInterfaces() {
    final controller = StreamController<List<NetworkInterface>>();

    _updateInterfaceList(controller);

    Timer.periodic(
      ipAddressRefreshDelay,
      (timer) => _updateInterfaceList(controller),
    );
    return controller.stream;
  }

  static _updateInterfaceList(
      StreamController<List<NetworkInterface>> controller) async {
    final interfaceList = await NetworkInterface.list();
    List<NetworkInterface> interfaces = [];

    for (final interface in interfaceList) {
      interfaces.add(interface);
    }

    controller.add(interfaces);
  }
}
