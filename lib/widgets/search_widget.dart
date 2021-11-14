import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchWidget extends StatefulWidget {
  final String text;
  final ValueChanged<String> onChanged;
  final String hintText;
  final VoidCallback onEdited;

  SearchWidget({
    required this.text,
    required this.hintText,
    required this.onChanged,
    required this.onEdited,
  });

  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final styleActive = TextStyle(
      color: Colors.black,
      fontSize: 15.sp,
    );
    final styleHint = TextStyle(
      color: Colors.black54,
      fontSize: 15.sp,
    );
    final style = widget.text.isEmpty ? styleHint : styleActive;

    return Container(
      height: 42.h,
      margin: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        color: Color(0xFFEEEEEE),
      ),
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          icon: Icon(Icons.search, color: style.color),
          suffixIcon: widget.text.isNotEmpty
              ? GestureDetector(
                  child: Icon(Icons.close, color: style.color),
                  onTap: () {
                    controller.clear();
                    widget.onChanged('');
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                )
              : null,
          hintText: widget.hintText,
          hintStyle: style,
          border: InputBorder.none,
        ),
        style: style,
        onChanged: widget.onChanged,
        onEditingComplete: widget.onEdited,
      ),
    );
  }
}
