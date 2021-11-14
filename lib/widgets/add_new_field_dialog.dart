import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';

class AddNewSunflowerFieldDialog extends StatefulWidget {
  @override
  _AddNewSunflowerFieldDialogState createState() =>
      _AddNewSunflowerFieldDialogState();
}

class _AddNewSunflowerFieldDialogState
    extends State<AddNewSunflowerFieldDialog> {
  String fieldName = '';
  String fieldArea = '';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          margin: EdgeInsets.all(14.0),
          padding: EdgeInsets.only(
            left: 13.w,
            right: 13.w,
            top: 19.h,
          ),
          height: 200.h,
          decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0))),
          child: Column(
            children: [
              Text(
                'Добавить новое поле подсолнуха',
                style: TextStyle(
                  fontSize: 18.sp,
                  color: Color(0xFF56585C),
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Roboto',
                ),
              ),
              SizedBox(
                height: 17.h,
              ),
              addFieldName('Введите название'),
              SizedBox(
                height: 10.h,
              ),
              addFieldArea('Введите площадь, га'),
              SizedBox(
                height: 25.h,
              ),
              cancelSaveButtonsRow(),
            ],
          ),
        ),
      ),
    );
  }

  Widget addFieldName(String hintText) {
    final controller = TextEditingController();
    return Container(
      height: 27.h,
      decoration: BoxDecoration(
        color: Color(0xFFEEEFF4),
      ),
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 14.sp,
            color: Color(0xFFBABABC),
            fontWeight: FontWeight.w500,
            fontFamily: 'Roboto',
          ),
          border: InputBorder.none,
        ),
        onChanged: (value) {
          fieldName = value;
        },
      ),
    );
  }

  Widget addFieldArea(String hintText) {
    final controller = TextEditingController();
    return Container(
      height: 27.h,
      decoration: BoxDecoration(
        color: Color(0xFFEEEFF4),
      ),
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 14.sp,
            color: Color(0xFFBABABC),
            fontWeight: FontWeight.w500,
            fontFamily: 'Roboto',
          ),
          border: InputBorder.none,
        ),
        onChanged: (value) {
          fieldArea = value;
        },
      ),
    );
  }

  Widget cancelSaveButtonsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        cancelBtn(),
        saveBtn(),
      ],
    );
  }

  Widget cancelBtn() {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        primary: Color(0xFFBEBEBE),
        fixedSize: Size(
          120.w,
          24.h,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      ),
      child: Text(
        'Отмена',
        style: TextStyle(
          fontSize: 14.sp,
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontFamily: 'Roboto',
        ),
      ),
    );
  }

  Widget saveBtn() {
    return ElevatedButton(
      onPressed: saveField,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        primary: Color(0xFF1259C3),
        fixedSize: Size(
          120.w,
          24.h,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      ),
      child: Text(
        'Сохранить',
        style: TextStyle(
          fontSize: 14.sp,
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontFamily: 'Roboto',
        ),
      ),
    );
  }

  saveField() async {
    FormData formDataField = FormData.fromMap(
      {
        'name': fieldName,
        'area': fieldArea,
      },
    );

    Dio dio = Dio();
    Response responseSample = await dio.post(
        'http://ec2-18-192-114-24.eu-central-1.compute.amazonaws.com/api/field/',
        data: formDataField);
    print(responseSample.statusCode);

    Navigator.of(context).pop();
  }
}
