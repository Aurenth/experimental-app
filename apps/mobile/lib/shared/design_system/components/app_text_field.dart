import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../tokens/radii.dart';
import '../tokens/spacing.dart';

/// Muhurtam branded text field.
///
/// Wraps [TextFormField] with consistent saffron-focused border, rounded
/// corners, and optional leading / trailing widget slots.
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.onFieldSubmitted,
    this.validator,
    this.inputFormatters,
    this.enabled = true,
    this.maxLines = 1,
    this.minLines,
    this.autofocus = false,
    this.readOnly = false,
    this.onTap,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? label;
  final String? hint;
  final String? helperText;
  final String? errorText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final FormFieldValidator<String>? validator;
  final List<TextInputFormatter>? inputFormatters;
  final bool enabled;
  final int? maxLines;
  final int? minLines;
  final bool autofocus;
  final bool readOnly;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final border = OutlineInputBorder(
      borderRadius: AppRadii.smAll,
      borderSide: BorderSide(color: scheme.outline),
    );

    final focusedBorder = OutlineInputBorder(
      borderRadius: AppRadii.smAll,
      borderSide: BorderSide(color: scheme.primary, width: 2),
    );

    final errorBorder = OutlineInputBorder(
      borderRadius: AppRadii.smAll,
      borderSide: BorderSide(color: scheme.error, width: 2),
    );

    final disabledBorder = OutlineInputBorder(
      borderRadius: AppRadii.smAll,
      borderSide: BorderSide(color: scheme.outline.withOpacity(0.38)),
    );

    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      validator: validator,
      inputFormatters: inputFormatters,
      enabled: enabled,
      maxLines: maxLines,
      minLines: minLines,
      autofocus: autofocus,
      readOnly: readOnly,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        helperText: helperText,
        errorText: errorText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        filled: true,
        fillColor: enabled
            ? scheme.surfaceContainerLowest
            : scheme.surfaceContainerLow,
        border: border,
        enabledBorder: border,
        focusedBorder: focusedBorder,
        errorBorder: errorBorder,
        focusedErrorBorder: errorBorder,
        disabledBorder: disabledBorder,
      ),
    );
  }
}
