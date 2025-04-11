import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/check_net/bloc/network_check_bloc.dart';
import '/check_net/check_net_view.dart';

class CheckNetPage extends StatelessWidget {
  const CheckNetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NetworkCheckBloc(),
      child: const CheckNetView(),
    );
  }
}
