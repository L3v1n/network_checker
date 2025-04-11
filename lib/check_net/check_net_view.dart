import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/check_net/bloc/network_check_event.dart';
import '/check_net/bloc/network_check_bloc.dart';
import '/check_net/bloc/network_check_state.dart';

class CheckNetView extends StatefulWidget {
  const CheckNetView({super.key});

  @override
  State<CheckNetView> createState() => _CheckNetViewState();
}

class _CheckNetViewState extends State<CheckNetView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<NetworkCheckBloc, NetworkCheckState>(
          builder: (context, state) {
            return Column(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: _buildNetworkStatusWidget(state)
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _buildActionButton(state, context),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

Widget _buildActionButton(NetworkCheckState state, BuildContext context) {
  if (state == NetworkCheckState.initial) {
    return CancelButton();
  } 
  else if (state == NetworkCheckState.noConnection) {
    return RetryButton();
  }
  else if (state == NetworkCheckState.connectedWifi || 
            state == NetworkCheckState.connectedMobile || 
            state == NetworkCheckState.internetAccessAvailable) {
    return RecheckButton();
  }
  else {
    return RetryButton();
  }
}

Widget _buildNetworkStatusWidget(NetworkCheckState state) {
  if (state == NetworkCheckState.initial) {
    return ProgressIndicator();
  }
  
  IconData iconData;
  String message;
  Color color;

  switch (state) {
    case NetworkCheckState.connectedWifi:
      iconData = Icons.wifi;
      message = "Connected to WiFi";
      color = Colors.green;
      break;
    case NetworkCheckState.connectedMobile:
      iconData = Icons.signal_cellular_alt_outlined;
      message = "Connected to Mobile Data";
      color = Colors.green;
      break;
    case NetworkCheckState.internetAccessAvailable:
      iconData = Icons.info_outline;
      message = "Internet Access Available";
      color = Colors.blue;
      break;
    case NetworkCheckState.noConnection:
      iconData = Icons.signal_wifi_off_outlined;
      message = "No Connection";
      color = Colors.grey;
      break;
    case NetworkCheckState.noInternnetAccess:
      iconData = Icons.signal_wifi_statusbar_connected_no_internet_4_outlined;
      message = "No Internet Access";
      color = Colors.orange;
      break;
    default:
      iconData = Icons.error_outline;
      message = "An error occurred";
      color = Colors.red;
      break;
  }

  return Column(
    children: [
      Icon(iconData, size: 80, color: color),
      const SizedBox(height: 16),
      Text(
        message,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    ],
  );
}

class ProgressIndicator extends StatelessWidget {
  const ProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final check = 'Checking network status...';
    return Column(
      children: [
        const CircularProgressIndicator(color: Colors.black),
        const SizedBox(height: 16),
        Text(
          check, 
          style: TextStyle(fontSize: 16,
          fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
class RetryButton extends StatelessWidget {
  const RetryButton({super.key});

  @override
  Widget build(BuildContext context) {
    final retry = 'Retry';
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () {
          context.read<NetworkCheckBloc>().add(CheckNetworkEvent());
        },
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Colors.grey),
          foregroundColor: Colors.grey,
        ),
        child: Text(
          retry,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class RecheckButton extends StatelessWidget {
  const RecheckButton({super.key});

  @override
  Widget build(BuildContext context) {
    final recheck = 'Recheck Connection';
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () {
          context.read<NetworkCheckBloc>().add(RecheckNetworkEvent());
        },
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Colors.green),
          foregroundColor: Colors.green,
        ),
        child: Text(
          recheck,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class CancelButton extends StatelessWidget {
  const CancelButton({super.key});

  @override
  Widget build(BuildContext context) {
    final cancel = 'Cancel';
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () {
          context.read<NetworkCheckBloc>().add(CancelNetworkCheckEvent());
          Navigator.pop(context);
        },
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Colors.red),
          foregroundColor: Colors.red,
        ),
        child: Text(
          cancel,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
