import 'package:flutter/material.dart';

class SearchButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const SearchButton(
      {super.key, required this.onPressed, this.label = "Button"});

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      label: Text(label),
      icon: const Icon(Icons.search),
      onPressed: onPressed,
      style: ButtonStyle(
        iconColor: WidgetStateProperty.all<Color>(
          Theme.of(context).colorScheme.onPrimaryContainer,
        ),
        backgroundColor: WidgetStateProperty.all<Color>(
          Theme.of(context).colorScheme.primaryContainer,
        ),
        shape: WidgetStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
