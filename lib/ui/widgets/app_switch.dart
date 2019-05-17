import 'package:flutter/material.dart';

class AppSwitch extends StatefulWidget {
  final String firstValue;
  final String secondValue;
  final String selectedValue;
  final Null Function(String) onChange;
  final Color selectedColor;
  final Color unselectedColor;
  final Color selectedTextColor;
  final Color unselectedTextColor;

  const AppSwitch(
      {Key key,
      this.firstValue,
      this.secondValue,
      this.onChange,
      this.selectedColor,
      this.unselectedColor,
      this.selectedTextColor,
      this.unselectedTextColor,
      this.selectedValue})
      : super(key: key);

  @override
  _AppSwitchState createState() => _AppSwitchState();
}

class _AppSwitchState extends State<AppSwitch>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  bool _first = true;

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 250));
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (mounted)
          setState(() {
            _first = !_first;
            if (widget.onChange != null) widget.onChange(_selectedValue());
          });
      },
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            decoration: ShapeDecoration(
                color: widget.unselectedColor ?? Colors.grey.shade200,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50))),
            child: Row(
              children: <Widget>[
                Text(
                  widget.firstValue ?? "ON",
                  style: TextStyle(color: widget.unselectedTextColor),
                ),
                Padding(padding: EdgeInsets.only(left: 24.0)),
                Text(
                  widget.secondValue ?? "OFF",
                  style: TextStyle(color: widget.unselectedTextColor),
                )
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: _first ? 0.0 : null,
            right: _first ? null : 0.0,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              decoration: ShapeDecoration(
                  color: widget.selectedColor ?? Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50))),
              child: Text(
                _selectedValue(),
                style: TextStyle(
                    color: widget.selectedTextColor,
                    fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );
  }

  String _selectedValue() {
    return _first ? widget.firstValue ?? "ON" : widget.secondValue ?? "OFF";
  }
}
