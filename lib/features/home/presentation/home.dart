import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:oryzn/core/router/app_routes.dart';

import 'package:oryzn/features/auth/riverpod/provider/auth_provider.dart';
import 'package:oryzn/features/home/riverpod/provider/home_provider.dart';
import 'package:oryzn/features/home/riverpod/state/home_state.dart';

import '../widgets/widgets.dart';
import 'presentation.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  void nextPage() {
    _pageController.nextPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.bounceIn,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// [home state]
    final homeState = ref.watch(homeProvider);

    /// [homeprovider]
    final homeNotifier = ref.watch(homeProvider.notifier);

    /// Auth check
    ref.listen(authProvider, (previous, next) {
      if (!next.isAuthenticated && !next.isLoading) {
        context.go(AppRoutes.login);
      }
    });

    return Scaffold(
      appBar: AppBar(title: MainAppBar(), actions: []),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 24, bottom: 32),
            child: Row(
              spacing: 16,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /// [Year button]
                DateButton(
                  text: 'Year',
                  onTap: () {
                    homeNotifier.selectTab(HomeTab.year);
                    _pageController.animateToPage(
                      0,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  isSelected: homeState.selectedTab == HomeTab.year,
                ),

                /// [Month button]
                DateButton(
                  text: 'Month',
                  onTap: () {
                    homeNotifier.selectTab(HomeTab.month);

                    _pageController.animateToPage(
                      1,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  isSelected: homeState.selectedTab == HomeTab.month,
                ),

                /// [Day button]
                DateButton(
                  text: 'Day',
                  onTap: () {
                    homeNotifier.selectTab(HomeTab.day);

                    _pageController.animateToPage(
                      2,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  isSelected: homeState.selectedTab == HomeTab.day,
                ),
              ],
            ),
          ),
          Expanded(
            child: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _pageController,
              onPageChanged: (value) {
                setState(() {
                  _currentPage = value;
                });
              },
              children: [YearView(), MonthView(), DayView()],
            ),
          ),
        ],
      ),
    );
  }
}
