import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'network_check_event.dart';
import 'network_check_state.dart';

class NetworkCheckBloc extends Bloc<NetworkCheckEvent, NetworkCheckState> {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  NetworkCheckBloc() : super(NetworkInitial()) {
    on<CheckNetworkEvent>(_onCheckNetwork);
    on<RecheckNetworkEvent>(_onRecheckNetwork);
    on<NetworkChangedEvent>(_onNetworkChanged);
    on<CancelNetworkCheckEvent>(_onCancelNetworkCheck);

    add(CheckNetworkEvent());
  }

  Future<bool> _checkInternetAccess() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  Future<void> _onCheckNetwork(
    CheckNetworkEvent event,
    Emitter<NetworkCheckState> emit,
  ) async {
    await _connectivitySubscription?.cancel();

    emit(NetworkChecking());

    await Future.delayed(const Duration(seconds: 3));

    try {
      _connectivitySubscription = _connectivity.onConnectivityChanged.listen((
        List<ConnectivityResult> result,
      ) {
        add(NetworkChangedEvent(result));
      });

      final List<ConnectivityResult> connectivityResult =
          await _connectivity.checkConnectivity();
      add(NetworkChangedEvent(connectivityResult));
    } catch (e) {
      emit(NetworkNoConnection());
    }
  }

  Future<void> _onNetworkChanged(
    NetworkChangedEvent event,
    Emitter<NetworkCheckState> emit,
  ) async {
    final List<ConnectivityResult> result = event.connectionStatus;

    if (result.contains(ConnectivityResult.none)) {
      emit(NetworkNoConnection());
      return;
    }

    final hasInternet = await _checkInternetAccess();
    if (!hasInternet) {
      emit(NetworkNoInternetAccess());
      return;
    }

    if (result.contains(ConnectivityResult.mobile)) {
      emit(NetworkConnectedMobile());
    } else if (result.contains(ConnectivityResult.wifi)) {
      emit(NetworkConnectedWifi());
    } else if (result.contains(ConnectivityResult.ethernet) ||
        result.contains(ConnectivityResult.vpn)) {
      emit(NetworkInternetAccessAvailable());
    } else {
      emit(NetworkInternetAccessAvailable());
    }
  }

  Future<void> _onRecheckNetwork(
    RecheckNetworkEvent event,
    Emitter<NetworkCheckState> emit,
  ) async {
    emit(NetworkChecking());

    await Future.delayed(const Duration(seconds: 3));

    try {
      final result = await _connectivity.checkConnectivity();
      add(NetworkChangedEvent(result));
    } catch (_) {
      emit(NetworkNoConnection());
    }
  }

  void _onCancelNetworkCheck(
    CancelNetworkCheckEvent event,
    Emitter<NetworkCheckState> emit,
  ) {
    _connectivitySubscription?.cancel();
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    return super.close();
  }
}
