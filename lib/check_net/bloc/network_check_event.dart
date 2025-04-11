import 'package:connectivity_plus/connectivity_plus.dart';

sealed class NetworkCheckEvent {}

final class CheckNetworkEvent extends NetworkCheckEvent {}

final class RecheckNetworkEvent extends NetworkCheckEvent {}

final class NetworkChangedEvent extends NetworkCheckEvent {
  final List<ConnectivityResult> connectionStatus;

  NetworkChangedEvent(this.connectionStatus);
}

final class CancelNetworkCheckEvent extends NetworkCheckEvent {}
