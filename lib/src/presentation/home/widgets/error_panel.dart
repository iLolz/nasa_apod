import 'package:flutter/material.dart';

class ErrorPanel extends StatelessWidget {
  const ErrorPanel({
    required this.message,
    required this.buttonLabel,
    required this.onPressed,
    this.title = 'Algo deu errado',
    this.compact = false,
    super.key,
  });

  final String title;
  final String message;
  final String buttonLabel;
  final VoidCallback onPressed;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final spacing = compact ? 12.0 : 20.0;
    final iconSize = compact ? 22.0 : 28.0;

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: colorScheme.errorContainer.withValues(alpha: 0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: colorScheme.error.withValues(alpha: 0.18),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(spacing),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment:
              compact ? CrossAxisAlignment.start : CrossAxisAlignment.center,
          children: [
            Container(
              height: compact ? 42 : 52,
              width: compact ? 42 : 52,
              decoration: BoxDecoration(
                color: colorScheme.error.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.warning_amber_rounded,
                size: iconSize,
                color: colorScheme.error,
              ),
            ),
            SizedBox(height: compact ? 10 : 14),
            Text(
              title,
              textAlign: compact ? TextAlign.start : TextAlign.center,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: compact ? TextAlign.start : TextAlign.center,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: compact ? 14 : 18),
            FilledButton.icon(
              onPressed: onPressed,
              icon: const Icon(Icons.refresh_rounded),
              label: Text(buttonLabel),
            ),
          ],
        ),
      ),
    );
  }
}
