import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tryiak/features/home/logic/home_cubit.dart';
import 'package:tryiak/features/home/ui/widgets/message_pharmacy_screen.dart';
import '../widgets/salomon_bottom_bar.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({required this.navigationShell, super.key});
  final StatefulNavigationShell navigationShell;

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  void _goBranch(int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = widget.navigationShell.currentIndex;

    return BlocProvider(
      create: (_) => HomeCubit()..initialize(),
      child: Builder(builder: (context) {
        return Scaffold(
          body: widget.navigationShell,
          bottomNavigationBar: CustomSalomonBottomBar(
            selectedIndex: currentIndex,
            onTabChange: (index) {
              _goBranch(index);
              setState(() {});
            },
          ),
          floatingActionButton: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF4A90E2),
                  const Color(0xFF2868A6),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF4A90E2).withOpacity(0.4),
                  blurRadius: 20,
                  spreadRadius: 2,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: FloatingActionButton(
              onPressed: () {
                final homeCubit = context.read<HomeCubit>();

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MessagePharmacyScreen(
                      initialLocation: homeCubit.selectedLocation,
                    ),
                  ),
                );
              },
              backgroundColor: Colors.transparent,
              elevation: 0,
              child: const Icon(
                Icons.upload_rounded,
                size: 28,
                color: Colors.white,
              ),
            ),
          ),
          floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        );
      }),
    );
  }
}
