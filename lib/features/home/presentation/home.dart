import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:oryzn/core/router/app_routes.dart';
import 'package:oryzn/core/theme/theme_provider.dart';

import 'package:oryzn/core/widgets/widgets.dart';
import 'package:oryzn/extensions/extensions.dart';
import 'package:oryzn/features/auth/riverpod/provider/auth_provider.dart';
import 'package:oryzn/gen/assets.gen.dart';

import '../../../core/utils/utils.dart';
import '../widgets/widgets.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  String selected = 'Year';
  int todayIndex = 0;
  int totalDays = 0;
  @override
  initState() {
    super.initState();
    final now = DateTime.now();
    final year = now.year;
    totalDays = TimeUtils.daysInYear(year);
    todayIndex = TimeUtils.dayOfYear(now);
  }

  @override
  Widget build(BuildContext context) {
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
                DateButton(
                  text: 'Year',
                  onTap: () {
                    setState(() {
                      selected = "Year";
                    });
                  },
                  isSelected: selected == "Year",
                ),
                DateButton(
                  text: 'Month',
                  onTap: () {
                    setState(() {
                      selected = "Month";
                    });
                  },
                  isSelected: selected == "Month",
                ),
                DateButton(
                  text: 'Day',
                  onTap: () {
                    setState(() {
                      selected = "Day";
                    });
                  },
                  isSelected: selected == "Day",
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: 20.horizontalPadding,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 16,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: 365,
              itemBuilder: (context, index) {
                final state = TimeUtils.getDayState(
                  index: index,
                  todayDayOfYear: todayIndex,
                );

                return CustomIcon(
                  size: 12,
                  asset: Assets.images.icon01,
                  color: TimeUtils.getColorForState(state, context, ref),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
