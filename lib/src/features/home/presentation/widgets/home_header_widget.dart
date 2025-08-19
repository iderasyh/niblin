import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../routing/app_router.dart';
import 'baby_status_widget.dart';
import 'personal_greeting_widget.dart';

class HomeHeaderWidget extends StatelessWidget {
  const HomeHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ResponsiveUtils.spacing20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left side - Greeting and baby status
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const PersonalGreetingWidget(),
                SizedBox(height: ResponsiveUtils.height8),
                const BabyStatusWidget(),
              ],
            ),
          ),

          // Right side - Settings icon
          IconButton(
            onPressed: () {
              context.push(AppRoute.settings.path);
            },
            icon: Icon(
              PhosphorIcons.gear(),
              color: AppColors.textSecondary,
            ),
            tooltip: AppLocalizations.of(context)?.settings,
          ),
        ],
      ),
    );
  }
}
