import 'package:flutter/material.dart';

import '../../../../core/common_widgets.dart/loading_indicator.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../domain/recipe_error.dart';

/// Widget for displaying recipe-specific errors with retry options
class RecipeErrorWidget extends StatelessWidget {
  const RecipeErrorWidget({
    super.key,
    required this.error,
    this.onRetry,
    this.onShowCached,
    this.showFullScreen = false,
  });

  final RecipeError error;
  final VoidCallback? onRetry;
  final VoidCallback? onShowCached;
  final bool showFullScreen;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    if (showFullScreen) {
      return _buildFullScreenError(context, l10n, theme);
    }

    return _buildInlineError(context, l10n, theme);
  }

  Widget _buildFullScreenError(
    BuildContext context,
    AppLocalizations l10n,
    ThemeData theme,
  ) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildErrorIcon(theme),
              const SizedBox(height: 24),
              _buildErrorTitle(context, theme),
              const SizedBox(height: 16),
              _buildErrorMessage(context, theme),
              const SizedBox(height: 32),
              _buildActionButtons(context, l10n),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInlineError(
    BuildContext context,
    AppLocalizations l10n,
    ThemeData theme,
  ) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.error.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(_getErrorIcon(), color: theme.colorScheme.error, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _getErrorTitle(context),
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            error.getMessage(Localizations.localeOf(context).languageCode),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
            ),
          ),
          if (onRetry != null || onShowCached != null) ...[
            const SizedBox(height: 16),
            _buildActionButtons(context, l10n),
          ],
        ],
      ),
    );
  }

  Widget _buildErrorIcon(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer.withValues(alpha: 0.2),
        shape: BoxShape.circle,
      ),
      child: Icon(_getErrorIcon(), size: 48, color: theme.colorScheme.error),
    );
  }

  Widget _buildErrorTitle(BuildContext context, ThemeData theme) {
    return Text(
      _getErrorTitle(context),
      style: theme.textTheme.headlineSmall?.copyWith(
        color: theme.colorScheme.onSurface,
        fontWeight: FontWeight.w600,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildErrorMessage(BuildContext context, ThemeData theme) {
    return Text(
      error.getMessage(Localizations.localeOf(context).languageCode),
      style: theme.textTheme.bodyLarge?.copyWith(
        color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildActionButtons(BuildContext context, AppLocalizations l10n) {
    final buttons = <Widget>[];

    if (onShowCached != null && error.shouldShowCachedData) {
      buttons.add(
        OutlinedButton.icon(
          onPressed: onShowCached,
          icon: const Icon(Icons.cached),
          label: Text(
            Localizations.localeOf(context).languageCode == 'sq'
                ? 'Shfaq të ruajturit'
                : 'Show Cached',
          ),
        ),
      );
    }

    if (onRetry != null && error.isRetryable) {
      buttons.add(
        ElevatedButton.icon(
          onPressed: onRetry,
          icon: const Icon(Icons.refresh),
          label: Text(l10n.retry),
        ),
      );
    }

    if (buttons.isEmpty) {
      return const SizedBox.shrink();
    }

    if (buttons.length == 1) {
      return buttons.first;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(child: buttons[0]),
        const SizedBox(width: 16),
        Expanded(child: buttons[1]),
      ],
    );
  }

  IconData _getErrorIcon() {
    switch (error) {
      case RecipeNetworkError _:
        return Icons.wifi_off;
      case RecipeNotFoundError _:
        return Icons.search_off;
      case RecipeValidationError _:
        return Icons.error_outline;
      case RecipePermissionError _:
        return Icons.lock_outline;
      case RecipeContentError _:
        return Icons.warning_amber;
      default:
        return Icons.error_outline;
    }
  }

  String _getErrorTitle(BuildContext context) {
    final languageCode = Localizations.localeOf(context).languageCode;

    switch (error) {
      case RecipeNetworkError _:
        return languageCode == 'sq' ? 'Gabim Rrjeti' : 'Network Error';
      case RecipeNotFoundError _:
        return languageCode == 'sq' ? 'Receta Nuk u Gjet' : 'Recipe Not Found';
      case RecipeValidationError _:
        return languageCode == 'sq' ? 'Gabim Validimi' : 'Validation Error';
      case RecipePermissionError _:
        return languageCode == 'sq' ? 'Gabim Lejes' : 'Permission Error';
      case RecipeContentError _:
        return languageCode == 'sq'
            ? 'Përmbajtje e Paplotë'
            : 'Incomplete Content';
      default:
        return languageCode == 'sq' ? 'Gabim' : 'Error';
    }
  }
}

/// Compact error widget for use in lists and cards
class RecipeErrorBanner extends StatelessWidget {
  const RecipeErrorBanner({
    super.key,
    required this.error,
    this.onRetry,
    this.onDismiss,
  });

  final RecipeError error;
  final VoidCallback? onRetry;
  final VoidCallback? onDismiss;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final languageCode = Localizations.localeOf(context).languageCode;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Material(
        color: theme.colorScheme.errorContainer.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Icon(
                Icons.error_outline,
                color: theme.colorScheme.error,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  error.getMessage(languageCode),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
              if (onRetry != null && error.isRetryable) ...[
                const SizedBox(width: 8),
                TextButton(
                  onPressed: onRetry,
                  child: Text(
                    languageCode == 'sq' ? 'Provo' : 'Retry',
                    style: TextStyle(color: theme.colorScheme.primary),
                  ),
                ),
              ],
              if (onDismiss != null) ...[
                const SizedBox(width: 4),
                IconButton(
                  onPressed: onDismiss,
                  icon: Icon(
                    Icons.close,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    size: 18,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 32,
                    minHeight: 32,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Loading state with error fallback
class RecipeLoadingWithError extends StatelessWidget {
  const RecipeLoadingWithError({
    super.key,
    required this.isLoading,
    this.error,
    this.onRetry,
    this.child,
    this.loadingMessage,
  });

  final bool isLoading;
  final RecipeError? error;
  final VoidCallback? onRetry;
  final Widget? child;
  final String? loadingMessage;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const LoadingIndicator(),
            if (loadingMessage != null) ...[
              const SizedBox(height: 16),
              Text(
                loadingMessage!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ],
        ),
      );
    }

    if (error != null) {
      return RecipeErrorWidget(
        error: error!,
        onRetry: onRetry,
        showFullScreen: child == null,
      );
    }

    return child ?? const SizedBox.shrink();
  }
}

/// Empty state with error handling
class RecipeEmptyState extends StatelessWidget {
  const RecipeEmptyState({
    super.key,
    required this.title,
    required this.message,
    this.icon = Icons.restaurant_menu,
    this.onAction,
    this.actionLabel,
  });

  final String title;
  final String message;
  final IconData icon;
  final VoidCallback? onAction;
  final String? actionLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.3,
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 48,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
              ),
              textAlign: TextAlign.center,
            ),
            if (onAction != null && actionLabel != null) ...[
              const SizedBox(height: 32),
              ElevatedButton(onPressed: onAction, child: Text(actionLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}
