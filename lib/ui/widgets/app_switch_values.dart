import 'package:flutter/material.dart';

class AppSwitchValues extends StatefulWidget {
  final List<String> values;
  final String selectedValue;
  final Color selectedColor;
  final Color unselectedColor;
  final Color selectedTextColor;
  final Color unselectedTextColor;
  final void Function(String value) onValueTapped;

  const AppSwitchValues(
      {Key key,
      this.selectedColor,
      this.unselectedColor,
      this.selectedTextColor,
      this.unselectedTextColor,
      this.selectedValue,
      this.values,
      this.onValueTapped})
      : super(key: key);

  @override
  _AppSwitchValuesState createState() => _AppSwitchValuesState();
}

class _AppSwitchValuesState extends State<AppSwitchValues>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  String _selected;

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 250));
    _selected = widget.values.first;
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      decoration: ShapeDecoration(
          color: widget.unselectedColor ?? Colors.grey.shade200,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))),
      child: Row(
        children: widget.values
            .map((s) => Expanded(
                    child: Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  decoration: ShapeDecoration(
                      color: _colorBg(s),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50))),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selected = s;
                        if (widget.onValueTapped != null)
                          widget.onValueTapped(s);
                      });
                    },
                    child: Text(
                      s,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: _colorText(s), fontWeight: _fontWeight(s)),
                    ),
                  ),
                )))
            .toList(),
      ),
    );
  }

  Color _colorText(String s) {
    if (s == _selected) return widget.selectedTextColor ?? Colors.white;
    return widget.unselectedTextColor;
  }

  Color _colorBg(String s) {
    if (s == _selected)
      return widget.selectedColor ?? Theme.of(context).primaryColor;
    return widget.unselectedColor ?? Colors.grey.shade200;
  }

  FontWeight _fontWeight(String s) {
    if (s == _selected) return FontWeight.bold;
    return FontWeight.normal;
  }
}
