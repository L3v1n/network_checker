import 'dart:async';
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

  Future<void> _onCheckNetwork(
    CheckNetworkEvent event,
    Emitter<NetworkCheckState> emit,
  ) async {
    emit(NetworkInitial());

    try {
      _connectivitySubscription = _connectivity.onConnectivityChanged.listen((
        List<ConnectivityResult> result,
      ) {
        add(NetworkChangedEvent(result));
      });

      await Future.delayed(const Duration(seconds: 3));

      final List<ConnectivityResult> connectivityResult =
          await _connectivity.checkConnectivity();
      add(NetworkChangedEvent(connectivityResult));
    } catch (e) {
      emit(NetworkNoConnection());
    }
  }

  void _onNetworkChanged(
    NetworkChangedEvent event,
    Emitter<NetworkCheckState> emit,
  ) {
    final List<ConnectivityResult> result = event.connectionStatus;

    if (result.contains(ConnectivityResult.mobile)) {
      emit(NetworkConnectedMobile());
    } else if (result.contains(ConnectivityResult.wifi)) {
      emit(NetworkConnectedWifi());
    } else if (result.contains(ConnectivityResult.ethernet)) {
      emit(NetworkInternetAccessAvailable());
    } else if (result.contains(ConnectivityResult.vpn)) {
      emit(NetworkInternetAccessAvailable());
    } else if (result.contains(ConnectivityResult.none)) {
      emit(NetworkNoConnection());
    } else {
      emit(NetworkNoInternetAccess());
    }
  }

  void _onRecheckNetwork(
    RecheckNetworkEvent event,
    Emitter<NetworkCheckState> emit,
  ) {
    emit(NetworkInitial());
    add(CheckNetworkEvent());
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
