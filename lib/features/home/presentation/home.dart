import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:oryzn/core/router/app_routes.dart';

import 'package:oryzn/features/auth/riverpod/provider/auth_provider.dart';
import 'package:oryzn/features/home/riverpod/provider/home_provider.dart';
import 'package:oryzn/features/home/riverpod/state/home_state.dart';

import '../../../extensions/extensions.dart';
import '../widgets/widgets.dart';
import 'presentation.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  @override
  Widget build(BuildContext context) {
    final selectedTab = ref.watch(homeProvider.select((s) => s.selectedTab));
    final homeNotifier = ref.read(homeProvider.notifier);

    /// Auth check
    ref.listen(authProvider, (previous, next) {
      if (!next.isAuthenticated && !next.isLoading) {
        context.go(AppRoutes.login);
      }
    });

    return Scaffold(
      appBar: AppBar(title: MainAppBar(), actions: []),
      body: GestureDetector(
        onLongPress: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            showDragHandle: true,
            backgroundColor: ref.colors.surfaceSecondary,
            shape: RoundedRectangleBorder(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              side: BorderSide(color: ref.colors.strokeNeutral),
            ),
            builder: (context) {
              return CustomizeBottomSheet();
            },
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 24, bottom: 8),
              child: Row(
                spacing: 16,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /// [Year button]
                  ChipButton(
                    text: 'Year',
                    onTap: () => homeNotifier.selectTab(HomeTab.year),
                    isSelected: selectedTab == HomeTab.year,
                  ),

                  /// [Month button]
                  ChipButton(
                    text: 'Month',
                    onTap: () => homeNotifier.selectTab(HomeTab.month),
                    isSelected: selectedTab == HomeTab.month,
                  ),

                  /// [Day button]
                  ChipButton(
                    text: 'Day',
                    onTap: () => homeNotifier.selectTab(HomeTab.day),
                    isSelected: selectedTab == HomeTab.day,
                  ),
                ],
              ),
            ),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: _buildView(selectedTab),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildView(HomeTab tab) {
    switch (tab) {
      case HomeTab.year:
        return const YearView(key: ValueKey('year'));
      case HomeTab.month:
        return const MonthView(key: ValueKey('month'));
      case HomeTab.day:
        return const DayView(key: ValueKey('day'));
    }
  }
}
