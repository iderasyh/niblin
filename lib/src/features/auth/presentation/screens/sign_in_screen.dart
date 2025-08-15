import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../core/common_widgets.dart/back_arrow.dart';
import '../../../../core/utils/assets_manager.dart';
import '../../application/auth_service.dart';
import '../controllers/auth_controller.dart';
import '../../../../core/common_widgets.dart/loading_indicator.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../routing/app_router.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _passwordObscured = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    final localizations = AppLocalizations.of(context)!;

    ref.listen(authControllerProvider, (previous, next) {
      if (previous?.isLoading == true && next.hasError) {
        final errorMessage = localizations.oopsSomethingWentWrongPleaseTryAgain;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(errorMessage)));
      }
    });

    final isLoading = authState.isLoading;

    return Scaffold(
      appBar: AppBar(
        leading: BackArrow(
          onPressed: () => context.goNamed(AppRoute.welcome.name),
        ),
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
                    SizedBox(height: ResponsiveUtils.spacing16),
                    Text(
                      localizations.welcomeBack,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    SizedBox(height: ResponsiveUtils.spacing8),
                    Text(
                      localizations.signInToContinueToNiblin,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    SizedBox(height: ResponsiveUtils.spacing24),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        labelText: localizations.email,
                        hintText: localizations.youExampleCom,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return localizations.emailIsRequired;
                        }
                        final emailRegex = RegExp(
                          r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                        );
                        if (!emailRegex.hasMatch(value)) {
                          return localizations.enterAValidEmail;
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: ResponsiveUtils.spacing16),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _passwordObscured,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        labelText: localizations.password,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _passwordObscured
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () => setState(() {
                            _passwordObscured = !_passwordObscured;
                          }),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return localizations.passwordIsRequired;
                        }
                        if (value.length < 6) {
                          return localizations.minimum6Characters;
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
                                  .submit(
                                    email: _emailController.text.trim(),
                                    password: _passwordController.text,
                                    formType: AuthenticationFormType.signIn,
                                  );
                            },
                      child: Text(
                        localizations.signIn,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.textOnButton,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(height: ResponsiveUtils.spacing12),
                    TextButton(
                      onPressed: isLoading
                          ? null
                          : () => context.goNamed(AppRoute.forgotPassword.name),
                      child: Text(
                        localizations.forgotPassword,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    SizedBox(height: 0.15.sh),
                    OutlinedButton.icon(
                      icon: Image.asset(
                        AssetsManager.googleIcon,
                        width: ResponsiveUtils.iconSize20,
                        height: ResponsiveUtils.iconSize20,
                      ),
                      label: Text(
                        localizations.continueWithGoogle,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onPressed: () async {
                        await ref
                            .read(authControllerProvider.notifier)
                            .googleSignIn();
                      },
                    ),
                    if (Platform.isIOS) ...[
                      SizedBox(height: ResponsiveUtils.spacing12),
                      OutlinedButton.icon(
                        icon: Icon(
                          Icons.apple,
                          color: AppColors.textPrimary,
                          size: ResponsiveUtils.iconSize24,
                        ),
                        label: Text(
                          localizations.continueWithApple,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        onPressed: () async {
                          await ref
                              .read(authControllerProvider.notifier)
                              .appleSignIn();
                        },
                      ),
                    ],
                    SizedBox(height: ResponsiveUtils.spacing12),
                    Center(
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: AppColors.textSecondary),
                          children: [
                            TextSpan(
                              text: localizations.bySigningInYouAgreeToOur,
                            ),
                            TextSpan(
                              text: localizations.terms,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: AppColors.primary),
                              recognizer: TapGestureRecognizer()..onTap = () {},
                            ),
                            TextSpan(text: localizations.and),
                            TextSpan(
                              text: localizations.privacyPolicy,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: AppColors.primary),
                              recognizer: TapGestureRecognizer()..onTap = () {},
                            ),
                            const TextSpan(text: '.'),
                          ],
                        ),
                      ),
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
