import 'package:connectivity_plus/connectivity_plus.dart';

abstract class NetworkCheckEvent {}

class CheckNetworkEvent extends NetworkCheckEvent {}

class RecheckNetworkEvent extends NetworkCheckEvent {}

class NetworkChangedEvent extends NetworkCheckEvent {
  final List<ConnectivityResult> connectionStatus;

  NetworkChangedEvent(this.connectionStatus);
}

class CancelNetworkCheckEvent extends NetworkCheckEvent {}