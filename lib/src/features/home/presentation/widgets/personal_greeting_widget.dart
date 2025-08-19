import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../auth/data/firebase_auth_repository.dart';
import '../../../auth/domain/user.dart';

class PersonalGreetingWidget extends ConsumerWidget {
  const PersonalGreetingWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.read(authRepositoryProvider).currentUser;
    final greeting = getTimeAwareGreeting(context, user);

    return Text(greeting, style: Theme.of(context).textTheme.headlineSmall);
  }

  String getTimeAwareGreeting(BuildContext context, User? user) {
    final localization = AppLocalizations.of(context);

    String? name = user?.displayName?.split(' ')[0];

    final hour = DateTime.now().hour;

    if (hour < 12) {
      if (name != null) {
        return '${localization?.goodMorning}, $name!';
      } else {
        return '${localization?.goodMorning}!';
      }
    } else if (hour < 17) {
      if (name != null) {
        return '${localization?.goodAfternoon}, $name!';
      } else {
        return '${localization?.goodAfternoon}!';
      }
    } else if (hour < 20) {
      if (name != null) {
        return '${localization?.timeForDinner}, $name!';
      } else {
        return '${localization?.timeForDinner}!';
      }
    } else {
      if (name != null) {
        return '${localization?.goodEvening}, $name!';
      } else {
        return '${localization?.goodEvening}!';
      }
    }
  }
}
