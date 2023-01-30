/* import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class ConnectivityProvider extends StatelessWidget {
  late bool _isOnline;
  bool get isOnline => _isOnline;

  ConnectivityProvider() {
    Connectivity _connectivity = Connectivity();

    _connectivity.onConnectivityChanged.listen((result) async {
      if (result == ConnectivityResult.none) {
        _isOnline = false;
        notifyListeners();
      }
    });
  }

  @override
  Widget build(BuildContext context) {}
}
 */