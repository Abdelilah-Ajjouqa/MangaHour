import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'error_widget.dart';

class BlocContentBuilder<B extends BlocBase<S>, S> extends StatelessWidget {
  final bool Function(S state) isLoading;
  final bool Function(S state) isError;
  final String Function(S state)? errorMessage;
  final bool Function(S state)? isEmpty;
  final String? emptyMessage;
  final VoidCallback? onRetry;
  final Widget Function(BuildContext context, S state) builder;
  final Widget? loadingWidget;

  const BlocContentBuilder({
    super.key,
    required this.isLoading,
    required this.isError,
    required this.builder,
    this.errorMessage,
    this.isEmpty,
    this.emptyMessage,
    this.onRetry,
    this.loadingWidget,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<B, S>(
      builder: (context, state) {
        if (isLoading(state)) {
          return loadingWidget ??
              Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.primary,
                ),
              );
        }

        if (isError(state)) {
          final msg = errorMessage != null ? errorMessage!(state) : 'An error occurred';
          return AppErrorWidget(
            message: msg,
            onRetry: onRetry,
          );
        }

        if (isEmpty != null && isEmpty!(state)) {
          return Center(
            child: Text(
              emptyMessage ?? 'No data available',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
            ),
          );
        }

        return builder(context, state);
      },
    );
  }
}
