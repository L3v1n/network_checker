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
                    children: [Center(child: _buildNetworkStatusWidget(state))],
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
  if (state is NetworkNoConnection || state is NetworkNoInternetAccess) {
    return const RetryButton();
  } else if (state is NetworkConnectedWifi ||
      state is NetworkConnectedMobile ||
      state is NetworkInternetAccessAvailable) {
    return Column(children: [RecheckButton(), BackButton()]);
  } else {
    return const CancelButton();
  }
}

Widget _buildNetworkStatusWidget(NetworkCheckState state) {
  if (state is NetworkInitial || state is NetworkChecking) {
    return const ProgressIndicator();
  }

  IconData iconData;
  Color color;
  String message;

  switch (state) {
    case NetworkConnectedWifi():
      iconData = Icons.wifi;
      message = "Connected to WiFi";
      color = Colors.green;
      break;
    case NetworkConnectedMobile():
      iconData = Icons.signal_cellular_alt_outlined;
      message = "Connected to Mobile Data";
      color = Colors.green;
      break;
    case NetworkInternetAccessAvailable():
      iconData = Icons.info_outline;
      message = "Internet Access Available";
      color = Colors.blue;
      break;
    case NetworkNoConnection():
      iconData = Icons.signal_wifi_off_outlined;
      message = "No Connection";
      color = Colors.grey;
      break;
    case NetworkNoInternetAccess():
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
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
      child: FilledButton(
        onPressed: () {
          context.read<NetworkCheckBloc>().add(CheckNetworkEvent());
        },
        style: FilledButton.styleFrom(backgroundColor: Colors.black),
        child: Text(retry, style: TextStyle(fontWeight: FontWeight.bold)),
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
      child: FilledButton(
        onPressed: () {
          context.read<NetworkCheckBloc>().add(RecheckNetworkEvent());
        },
        style: FilledButton.styleFrom(backgroundColor: Colors.green),
        child: Text(recheck, style: TextStyle(fontWeight: FontWeight.bold)),
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
          context.read<NetworkCheckBloc>().close();
          Navigator.pop(context);
        },
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Colors.red),
          foregroundColor: Colors.red,
        ),
        child: Text(cancel, style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}

class BackButton extends StatelessWidget {
  const BackButton({super.key});

  @override
  Widget build(BuildContext context) {
    final back = 'Go Back';
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () {
          context.read<NetworkCheckBloc>().close();
          Navigator.pop(context);
        },
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Colors.red),
          foregroundColor: Colors.red,
        ),
        child: Text(back, style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}
