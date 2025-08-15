import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../core/common_widgets.dart/back_arrow.dart';
import '../controllers/auth_controller.dart';
import '../../../../core/common_widgets.dart/loading_indicator.dart';
import '../../../../core/utils/responsive_utils.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    final localization = AppLocalizations.of(context)!;

    ref.listen(authControllerProvider, (previous, next) {
      if (previous?.isLoading == true && next.hasError) {
        final errorMessage =
            next.error?.toString() ??
            localization.oopsSomethingWentWrongPleaseTryAgain;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(errorMessage)));
      }
      if (previous?.isLoading == true && next.hasValue) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(localization.passwordResetEmailSent)),
          );
          Navigator.of(context).maybePop();
        }
      }
    });

    final isLoading = authState.isLoading;

    return Scaffold(
      appBar: AppBar(
        title: Text(localization.forgotPassword),
        leading: BackArrow(),
      ),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveUtils.spacing24,
                vertical: ResponsiveUtils.spacing24,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: ResponsiveUtils.spacing12),
                    Text(
                      localization.enterYourEmailToReceiveAResetLink,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    SizedBox(height: ResponsiveUtils.spacing16),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        labelText: localization.email,
                        hintText: localization.youExampleCom,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return localization.emailIsRequired;
                        }
                        final emailRegex = RegExp(
                          r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                        );
                        if (!emailRegex.hasMatch(value)) {
                          return localization.enterAValidEmail;
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: ResponsiveUtils.spacing24),
                    FilledButton(
                      onPressed: isLoading
                          ? null
                          : () async {
                              if (!(_formKey.currentState?.validate() ??
                                  false)) {
                                return;
                              }
                              await ref
                                  .read(authControllerProvider.notifier)
                                  .sendPasswordResetEmail(
                                    _emailController.text.trim(),
                                  );
                            },
                      child: Text(localization.sendResetLink),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (isLoading)
            const AbsorbPointer(
              absorbing: true,
              child: ColoredBox(
                color: Color(0x55FFFFFF),
                child: Center(child: LoadingIndicator()),
              ),
            ),
        ],
      ),
    );
  }
}
