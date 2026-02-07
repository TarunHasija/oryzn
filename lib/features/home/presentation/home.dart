import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:oryzn/core/router/app_routes.dart';
import 'package:oryzn/core/services/storage_service.dart';
import 'package:oryzn/core/widgets/widgets.dart';

import 'package:oryzn/features/auth/riverpod/provider/auth_provider.dart';
import 'package:oryzn/features/home/riverpod/provider/home_provider.dart';
import 'package:oryzn/features/home/riverpod/state/home_state.dart';
import 'package:oryzn/gen/assets.gen.dart';

import '../../../extensions/extensions.dart';
import '../widgets/widgets.dart';
import 'presentation.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  OverlayEntry? _hintOverlay;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    final initialTab = ref.read(homeProvider).selectedTab;
    _pageController = PageController(initialPage: initialTab.index);
    _showEditHintIfNeeded();
  }

  void _showEditHintIfNeeded() {
    if (StorageService.getHasSeenEditHint()) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _hintOverlay = OverlayEntry(
        builder: (context) => GestureDetector(
          onLongPress: () {
            _dismissHint();
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
          behavior: HitTestBehavior.opaque,
          child: Align(
            alignment: Alignment(0, 0.35),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 24,
                    ),
                    decoration: BoxDecoration(
                      color: ref.colors.surfaceSecondary.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomIcon(
                          asset: Assets.images.longPressIcon,
                          size: 32,
                          color: ref.colors.textIconPrimary,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Long press Anywhere to edit',
                          style: context.bodyMedium.copyWith(
                            color: ref.colors.textIconPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      Overlay.of(context).insert(_hintOverlay!);
    });
  }

  void _dismissHint() {
    _hintOverlay?.remove();
    _hintOverlay = null;
    StorageService.setHasSeenEditHint(true);
  }

  @override
  void dispose() {
    _hintOverlay?.remove();
    _hintOverlay = null;
    _pageController.dispose();
    super.dispose();
  }

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
          _dismissHint();
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
                    onTap: () {
                      homeNotifier.selectTab(HomeTab.year);
                      _pageController.animateToPage(
                        0,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    isSelected: selectedTab == HomeTab.year,
                  ),

                  /// [Month button]
                  ChipButton(
                    text: 'Month',
                    onTap: () {
                      homeNotifier.selectTab(HomeTab.month);
                      _pageController.animateToPage(
                        1,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    isSelected: selectedTab == HomeTab.month,
                  ),

                  /// [Day button]
                  ChipButton(
                    text: 'Day',
                    onTap: () {
                      homeNotifier.selectTab(HomeTab.day);
                      _pageController.animateToPage(
                        2,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    isSelected: selectedTab == HomeTab.day,
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  homeNotifier.selectTab(HomeTab.values[index]);
                },
                children: const [
                  YearView(key: ValueKey('year')),
                  MonthView(key: ValueKey('month')),
                  DayView(key: ValueKey('day')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}
