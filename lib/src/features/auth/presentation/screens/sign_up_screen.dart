import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../core/utils/assets_manager.dart';
import '../../application/auth_service.dart';
import '../controllers/auth_controller.dart';
import '../../../../core/common_widgets.dart/loading_indicator.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../routing/app_router.dart';
import '../../../onboarding/application/onboarding_controller.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen>
    with TickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _passwordObscured = true;
  bool _showEmailForm = false;

  late AnimationController _animationController;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _toggleEmailForm() {
    FocusScope.of(context).unfocus();
    setState(() {
      _showEmailForm = !_showEmailForm;
    });

    if (_showEmailForm) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  Widget _buildBenefitItem(
    BuildContext context, {
    required Widget icon,
    required String text,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(ResponsiveUtils.spacing8),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(ResponsiveUtils.spacing8),
          ),
          child: icon,
        ),
        SizedBox(width: ResponsiveUtils.spacing12),
        Expanded(
          child: Text(
            text,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textPrimary),
          ),
        ),
      ],
    );
  }

  Widget _buildPrivacyStatement(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return Center(
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
          children: [
            TextSpan(text: localization.byContinuingYouAgreeToOur),
            TextSpan(
              text: localization.terms,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.primary),
              recognizer: TapGestureRecognizer()..onTap = () {},
            ),
            TextSpan(text: localization.and),
            TextSpan(
              text: localization.privacyPolicy,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.primary),
              recognizer: TapGestureRecognizer()..onTap = () {},
            ),
            const TextSpan(text: '.'),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefitsSection(
    BuildContext context,
    String babyName,
    bool hasName,
  ) {
    final localization = AppLocalizations.of(context)!;
    return Column(
      children: [
        Text(
          localization.withYourFreeNiblinAccount,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: ResponsiveUtils.spacing16),
        _buildBenefitItem(
          context,
          icon: Icon(
            PhosphorIcons.bowlFood(),
            color: AppColors.primary,
            size: ResponsiveUtils.iconSize20,
          ),
          text: hasName
              ? localization.access30StarterRecipesBaby(babyName)
              : localization.access30StarterRecipesGeneric,
        ),
        SizedBox(height: ResponsiveUtils.spacing12),
        _buildBenefitItem(
          context,
          icon: Icon(
            PhosphorIcons.checkSquare(),
            color: AppColors.primary,
            size: ResponsiveUtils.iconSize20,
          ),
          text: localization.niblinsBlog,
        ),
        SizedBox(height: ResponsiveUtils.spacing12),
        _buildBenefitItem(
          context,
          icon: Icon(
            PhosphorIcons.lightbulb(),
            color: AppColors.primary,
            size: ResponsiveUtils.iconSize20,
          ),
          text: localization.unlockFirstBitesGuide,
        ),
      ],
    );
  }

  Widget _buildSocialSignInButton({
    required BuildContext context,
    required Widget icon,
    required String label,
    required VoidCallback onPressed,
    Color? backgroundColor,
    Color? foregroundColor,
    BorderSide? side,
  }) {
    return FilledButton.icon(
      icon: icon,
      label: Text(
        label,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: foregroundColor,
        ),
      ),
      style: FilledButton.styleFrom(
        elevation: 0,
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        side: side,
        padding: EdgeInsets.symmetric(vertical: ResponsiveUtils.spacing16),
      ),
      onPressed: onPressed,
    );
  }

  Widget _buildEmailFormField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    required String? Function(String?) validator,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    bool obscureText = false,
    Widget? suffixIcon,
    TextCapitalization textCapitalization = TextCapitalization.none,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      textCapitalization: textCapitalization,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        suffixIcon: suffixIcon,
      ),
      validator: validator,
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final onboardingState = ref.watch(onboardingControllerProvider);
    final localization = AppLocalizations.of(context)!;

    // Get baby's name for personalization
    final babyName = onboardingState.babyProfile.babyName.trim();
    final hasName = babyName.isNotEmpty;

    ref.listen(authControllerProvider, (previous, next) {
      if (previous?.isLoading == true && next.hasError) {
        final errorMessage = localization.oopsSomethingWentWrongPleaseTryAgain;
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
                      SizedBox(height: ResponsiveUtils.spacing24),
                      // Dynamic headline based on baby's name
                      Text(
                        hasName
                            ? localization.saveBabysPlan(babyName)
                            : localization.saveYourPlan,
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: ResponsiveUtils.spacing12),
                      Text(
                        localization.justOneLastStep,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: ResponsiveUtils.spacing24),

                      // Benefits section
                      _buildBenefitsSection(context, babyName, hasName),
                      SizedBox(height: ResponsiveUtils.spacing32),

                      // Social Sign-in buttons with fade out animation
                      AnimatedBuilder(
                        animation: _expandAnimation,
                        builder: (context, child) {
                          return AnimatedOpacity(
                            opacity: _showEmailForm ? 0.0 : 1.0,
                            duration: const Duration(milliseconds: 200),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              height: _showEmailForm ? 0 : null,
                              child: _showEmailForm
                                  ? const SizedBox.shrink()
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        _buildSocialSignInButton(
                                          context: context,
                                          icon: Image.asset(
                                            AssetsManager.googleIcon,
                                            width: ResponsiveUtils.iconSize20,
                                            height: ResponsiveUtils.iconSize20,
                                          ),
                                          label:
                                              localization.continueWithGoogle,
                                          backgroundColor: Colors.white,
                                          foregroundColor:
                                              AppColors.textPrimary,
                                          side: BorderSide(
                                            color: AppColors.textSecondary
                                                .withValues(alpha: 0.3),
                                          ),
                                          onPressed: () async {
                                            await ref
                                                .read(
                                                  authControllerProvider
                                                      .notifier,
                                                )
                                                .googleSignIn();
                                          },
                                        ),
                                        if (Platform.isIOS) ...[
                                          SizedBox(
                                            height: ResponsiveUtils.spacing12,
                                          ),
                                          _buildSocialSignInButton(
                                            context: context,
                                            icon: Icon(
                                              Icons.apple,
                                              color: Colors.white,
                                              size: ResponsiveUtils.iconSize24,
                                            ),
                                            label:
                                                localization.continueWithApple,
                                            backgroundColor: Colors.black,
                                            foregroundColor: Colors.white,
                                            onPressed: () async {
                                              await ref
                                                  .read(
                                                    authControllerProvider
                                                        .notifier,
                                                  )
                                                  .appleSignIn();
                                            },
                                          ),
                                        ],
                                        SizedBox(
                                          height: ResponsiveUtils.spacing24,
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Divider(
                                                color: AppColors.textSecondary
                                                    .withValues(alpha: 0.3),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal:
                                                    ResponsiveUtils.spacing12,
                                              ),
                                              child: Text(
                                                localization.or,
                                                style: Theme.of(
                                                  context,
                                                ).textTheme.bodySmall,
                                              ),
                                            ),
                                            Expanded(
                                              child: Divider(
                                                color: AppColors.textSecondary
                                                    .withValues(alpha: 0.3),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: ResponsiveUtils.spacing16,
                                        ),
                                        OutlinedButton(
                                          onPressed: _toggleEmailForm,
                                          style: OutlinedButton.styleFrom(
                                            padding: EdgeInsets.symmetric(
                                              vertical:
                                                  ResponsiveUtils.spacing16,
                                            ),
                                          ),
                                          child: Text(
                                            localization.continueWithEmail,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                  color: AppColors.primary,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: ResponsiveUtils.spacing24,
                                        ),
                                        _buildPrivacyStatement(context),
                                      ],
                                    ),
                            ),
                          );
                        },
                      ),

                      // Email form with slide-in animation
                      AnimatedBuilder(
                        animation: _expandAnimation,
                        builder: (context, child) {
                          return SizeTransition(
                            sizeFactor: _expandAnimation,
                            axisAlignment: -1.0,
                            child: FadeTransition(
                              opacity: _expandAnimation,
                              child: SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(0, -0.3),
                                  end: Offset.zero,
                                ).animate(_expandAnimation),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    SizedBox(height: ResponsiveUtils.spacing16),
                                    Row(
                                      children: [
                                        IconButton(
                                          onPressed: _toggleEmailForm,
                                          icon: Icon(
                                            Icons.close,
                                            size: ResponsiveUtils.spacing20,
                                          ),
                                          tooltip: localization.close,
                                        ),
                                        Text(
                                          localization.signUpWithEmail,
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodyMedium,
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: ResponsiveUtils.spacing16),
                                    _buildEmailFormField(
                                      controller: _nameController,
                                      labelText: localization.fullName,
                                      hintText: localization.janeDoe,
                                      textInputAction: TextInputAction.next,
                                      textCapitalization: TextCapitalization.words,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return localization.nameIsRequired;
                                        }
                                        return null;
                                      },
                                    ),
                                    SizedBox(height: ResponsiveUtils.spacing16),
                                    _buildEmailFormField(
                                      controller: _emailController,
                                      labelText: localization.email,
                                      hintText: localization.youExampleCom,
                                      keyboardType: TextInputType.emailAddress,
                                      textInputAction: TextInputAction.next,
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
                                    SizedBox(height: ResponsiveUtils.spacing16),
                                    _buildEmailFormField(
                                      controller: _passwordController,
                                      labelText: localization.password,
                                      hintText: localization.minimum6Characters,
                                      textInputAction: TextInputAction.done,
                                      obscureText: _passwordObscured,
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _passwordObscured
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                        ),
                                        onPressed: () => setState(() {
                                          _passwordObscured =
                                              !_passwordObscured;
                                        }),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return localization
                                              .passwordIsRequired;
                                        }
                                        if (value.length < 6) {
                                          return localization
                                              .minimum6Characters;
                                        }
                                        return null;
                                      },
                                    ),
                                    SizedBox(height: ResponsiveUtils.spacing24),
                                    FilledButton(
                                      onPressed: isLoading
                                          ? null
                                          : () async {
                                              if (!(_formKey.currentState
                                                      ?.validate() ??
                                                  false)) {
                                                return;
                                              }
                                              await ref
                                                  .read(
                                                    authControllerProvider
                                                        .notifier,
                                                  )
                                                  .submit(
                                                    email: _emailController.text
                                                        .trim(),
                                                    password:
                                                        _passwordController
                                                            .text,
                                                    displayName: _nameController
                                                        .text
                                                        .trim(),
                                                    formType:
                                                        AuthenticationFormType
                                                            .register,
                                                  );
                                            },
                                      style: FilledButton.styleFrom(
                                        padding: EdgeInsets.symmetric(
                                          vertical: ResponsiveUtils.spacing16,
                                        ),
                                      ),
                                      child: Text(
                                        hasName
                                            ? localization
                                                  .saveBabysPlanAndGetStarted(
                                                    babyName,
                                                  )
                                            : localization
                                                  .saveMyPlanAndGetStarted,
                                      ),
                                    ),
                                    SizedBox(height: ResponsiveUtils.spacing16),
                                    _buildPrivacyStatement(context),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
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
                  child: Center(
                    child: LoadingIndicator(color: AppColors.background),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
