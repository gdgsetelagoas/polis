import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTextFormField extends StatefulWidget {
  final String textLabel;
  final String textHint;
  final double fontSize;
  final Color textColor;
  final Color outlineColor;
  final Color shadowColor;
  final TextEditingController controller;
  final FocusNode focusNode;
  final FocusNode nextFocusNode;
  final bool obscureText;
  final ValueChanged<String> onFieldSubmitted;
  final FormFieldValidator<String> onChangeFocusValidate;
  final TextInputAction textInputAction;
  final TextInputType keyboardType;
  final String errorMsg;
  final TextCapitalization textCapitalization;
  final RegExp regexValidator;
  final String validatorMsgError;
  final Duration validateAfter;
  final List<TextInputFormatter> inputFormatters;
  final int maxLines;
  final int maxLength;
  final InputDecoration decoration;
  final Color cursorColor;

  AppTextFormField(
      {this.textLabel,
      this.fontSize = 14.0,
      this.textColor,
      controller,
      focusNode,
      this.obscureText = false,
      this.onFieldSubmitted,
      this.textInputAction = TextInputAction.next,
      this.keyboardType,
      this.nextFocusNode,
      this.onChangeFocusValidate,
      this.errorMsg,
      this.textCapitalization,
      this.regexValidator,
      this.validatorMsgError,
      validateAfter,
      this.textHint,
      this.inputFormatters,
      this.maxLines,
      this.maxLength,
      this.outlineColor,
      this.shadowColor,
      this.decoration,
      this.cursorColor})
      : focusNode = focusNode ?? FocusNode(),
        controller = controller ?? TextEditingController(),
        validateAfter = validateAfter ?? Duration();

  @override
  _AppTextFormFieldState createState() {
    return new _AppTextFormFieldState();
  }
}

class _AppTextFormFieldState extends State<AppTextFormField> {
  String _errorMsg;
  bool isFocused = false;

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_changeFocus);
    if (widget.regexValidator != null)
      widget.controller.addListener(_validateRegExp);
  }

  void _validateRegExp() {
    Future.delayed(widget.validateAfter, () {
      if (mounted)
        setState(() {
          if (!widget.regexValidator.hasMatch(widget.controller.text)) {
            _errorMsg = widget.validatorMsgError;
          } else {
            _errorMsg = null;
          }
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textAlign: TextAlign.right,
      controller: widget.controller,
      focusNode: widget.focusNode,
      obscureText: widget.obscureText,
      onFieldSubmitted: widget.onFieldSubmitted ?? _nextField,
      textInputAction: widget.textInputAction,
      keyboardType: widget.keyboardType,
      validator: widget.onChangeFocusValidate,
      maxLines: widget.maxLines,
      maxLength: widget.maxLength,
      cursorColor: widget.cursorColor,
      textCapitalization: widget.textCapitalization ?? TextCapitalization.none,
      style: TextStyle(
          fontSize: widget.fontSize,
          color: widget.textColor ?? Theme.of(context).primaryColor),
      decoration: (widget.decoration ??
              InputDecoration(
                  labelText: widget.textLabel,
                  labelStyle: TextStyle(
                      fontSize: widget.fontSize,
                      color:
                          widget.textColor ?? Theme.of(context).primaryColor),
                  hintText: widget.textHint,
                  hintStyle: TextStyle(
                      fontSize: widget.fontSize,
                      color:
                          widget.textColor ?? Theme.of(context).primaryColor),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: widget.outlineColor ??
                              Theme.of(context).primaryColor)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: widget.outlineColor ??
                              Theme.of(context).primaryColor)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: widget.outlineColor ??
                              Theme.of(context).primaryColorDark,
                          width: 3.0))))
          .copyWith(errorText: widget.errorMsg ?? _errorMsg ?? null),
      inputFormatters: widget.inputFormatters,
    );
  }

  void _nextField(String s) {
    if (widget.nextFocusNode != null) {
      widget.focusNode.unfocus();
      FocusScope.of(context).requestFocus(widget.nextFocusNode);
    }
  }

  void _changeFocus() {
    if (mounted)
      setState(() {
        isFocused = widget.focusNode.hasFocus;
        if (!widget.focusNode.hasFocus &&
            widget.onChangeFocusValidate != null) {
          _errorMsg =
              widget.onChangeFocusValidate(widget.controller.text) ?? null;
        }
      });
  }
}
