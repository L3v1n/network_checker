import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'network_check_event.dart';
import 'network_check_state.dart';

class NetworkCheckBloc extends Bloc<NetworkCheckEvent, NetworkCheckState> {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  NetworkCheckBloc() : super(NetworkCheckState.initial) {
    on<CheckNetworkEvent>(_onCheckNetwork);
    on<RecheckNetworkEvent>(_onRecheckNetwork);
    on<NetworkChangedEvent>(_onNetworkChanged);
    on<CancelNetworkCheckEvent>(_onCancelNetworkCheck);

    add(CheckNetworkEvent());
  }

  Future<void> _onCheckNetwork(
    CheckNetworkEvent event, 
    Emitter<NetworkCheckState> emit
  ) async {
    emit(NetworkCheckState.initial);
    
    try {
      _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
        (List<ConnectivityResult> result) {
          add(NetworkChangedEvent(result));
        }
      );

      await Future.delayed(const Duration(seconds: 3));
      
      final List<ConnectivityResult> connectivityResult = await _connectivity.checkConnectivity();
      add(NetworkChangedEvent(connectivityResult));
    } catch (e) {
      emit(NetworkCheckState.noConnection);
    }
  }

  void _onNetworkChanged(
    NetworkChangedEvent event, 
    Emitter<NetworkCheckState> emit
  ) {
    final List<ConnectivityResult> result = event.connectionStatus;
    
    if (result.contains(ConnectivityResult.mobile)) {
      emit(NetworkCheckState.connectedMobile);
    } else if (result.contains(ConnectivityResult.wifi)) {
      emit(NetworkCheckState.connectedWifi);
    } else if (result.contains(ConnectivityResult.ethernet)) {
      emit(NetworkCheckState.internetAccessAvailable);
    } else if (result.contains(ConnectivityResult.vpn)) {
      emit(NetworkCheckState.internetAccessAvailable);
    } else if (result.contains(ConnectivityResult.none)) {
      emit(NetworkCheckState.noConnection);
    } else {
      emit(NetworkCheckState.noInternnetAccess);
    }
  }

  void _onRecheckNetwork(
    RecheckNetworkEvent event, 
    Emitter<NetworkCheckState> emit
  ) {
    emit(NetworkCheckState.initial);
    add(CheckNetworkEvent());
  }

  void _onCancelNetworkCheck(
    CancelNetworkCheckEvent event, 
    Emitter<NetworkCheckState> emit
  ) {
    _connectivitySubscription?.cancel();
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    return super.close();
  }
}