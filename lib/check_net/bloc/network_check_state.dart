sealed class NetworkCheckState {}

final class NetworkInitial extends NetworkCheckState {}

final class NetworkChecking extends NetworkCheckState {}

final class NetworkConnectedWifi extends NetworkCheckState {}

final class NetworkConnectedMobile extends NetworkCheckState {}

final class NetworkNoConnection extends NetworkCheckState {}

final class NetworkInternetAccessAvailable extends NetworkCheckState {}

final class NetworkNoInternetAccess extends NetworkCheckState {}
