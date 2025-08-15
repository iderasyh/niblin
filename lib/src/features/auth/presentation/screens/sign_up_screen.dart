import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../core/utils/assets_manager.dart';
import '../../application/auth_service.dart';
import '../controllers/auth_controller.dart';
import '../../../../core/common_widgets.dart/loading_indicator.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../routing/app_router.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _passwordObscured = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
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
          context.goNamed(AppRoute.onboarding.name);
        }
      }
    });

    final isLoading = authState.isLoading;

    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
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
                        'Let’s get you started',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      SizedBox(height: ResponsiveUtils.spacing8),
                      Text(
                        'Create your Niblin account in seconds',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      SizedBox(height: ResponsiveUtils.spacing24),
                      TextFormField(
                        controller: _nameController,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: 'Full Name',
                          hintText: 'Jane Doe',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Name is required';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: ResponsiveUtils.spacing16),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          hintText: 'you@example.com',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email is required';
                          }
                          final emailRegex = RegExp(
                            r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                          );
                          if (!emailRegex.hasMatch(value)) {
                            return 'Enter a valid email';
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
                          labelText: 'Password',
                          hintText: 'Minimum 6 characters',
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
                            return 'Password is required';
                          }
                          if (value.length < 6) return 'Minimum 6 characters';
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
                                      displayName: _nameController.text.trim(),
                                      formType: AuthenticationFormType.register,
                                    );
                              },
                        child: const Text('Create Account'),
                      ),
                      SizedBox(height: ResponsiveUtils.spacing16),
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: AppColors.textSecondary.withValues(
                                alpha: 0.3,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: ResponsiveUtils.spacing12,
                            ),
                            child: Text(
                              'or',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: AppColors.textSecondary.withValues(
                                alpha: 0.3,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: ResponsiveUtils.spacing16),
                      OutlinedButton.icon(
                        icon: Image.asset(
                          AssetsManager.googleIcon,
                          width: ResponsiveUtils.iconSize20,
                          height: ResponsiveUtils.iconSize20,
                        ),
                        label: Text(
                          localization.continueWithGoogle,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
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
                            localization.continueWithApple,
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
                      SizedBox(height: ResponsiveUtils.spacing24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account?',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          TextButton(
                            onPressed: isLoading
                                ? null
                                : () => context.goNamed(AppRoute.signIn.name),
                            child: const Text('Sign in'),
                          ),
                        ],
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
      ),
    );
  }
}
