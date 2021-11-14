import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:innopolis_hack/widgets/add_photo_from_gallery_btn.dart';
import 'package:intl/intl.dart';

class CreateSunflowerSampleScreen extends StatefulWidget {
  @override
  _CreateSunflowerSampleScreenState createState() =>
      _CreateSunflowerSampleScreenState();
}

class _CreateSunflowerSampleScreenState
    extends State<CreateSunflowerSampleScreen> {
  List<XFile>? imageFileList;
  final ImagePicker imagePicker = ImagePicker();
  String text = 'Result';
  String sampleName = '';
  String? selectedSort;
  int? selectedSortIndex;

  @override
  void initState() {
    imageFileList = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEEEFF4),
      appBar: screenAppbar(),
      body: SafeArea(
        child: screenBody(),
      ),
    );
  }

  AppBar screenAppbar() {
    return AppBar(
      backgroundColor: Colors.white,
      title: Text(
        'Создание пробы',
        style: TextStyle(
          color: Colors.black,
          fontFamily: 'Roboto',
          fontSize: 20.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
      automaticallyImplyLeading: false,
      leading: IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: Icon(
          Icons.arrow_back,
          color: Colors.black,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () async {
            for (var image in imageFileList ?? []) {
              await saveProbesImage(image);
            }
            await saveProbes();

            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.save,
            color: Colors.black,
          ),
        )
      ],
    );
  }

  saveProbesImage(XFile file) async {
    String fileName = file.path.split('/').last;
    FormData formDataImage = FormData.fromMap({
      'photo': await MultipartFile.fromFile(
        file.path,
        filename: fileName,
        contentType: new MediaType('image', 'jpeg'),
      ),
      'probe': 1
    });

    Dio dio = Dio();
    Response responseImage = await dio.post(
        'http://ec2-18-192-114-24.eu-central-1.compute.amazonaws.com/api/probe-photo/',
        data: formDataImage);
  }

  saveProbes() async {
    FormData formDataSample = FormData.fromMap(
      {
        'name': sampleName,
        'location': await getLocation(),
        'created_at': DateFormat('dd.MM.yyyy HH:mm').format(
          DateTime.now(),
        ),
        'square_meter_plants_amount': 10,
        'field': 10,
        'cultivar': 1,
      },
    );

    Dio dio = Dio();
    Response responseSample = await dio.post(
        'http://ec2-18-192-114-24.eu-central-1.compute.amazonaws.com/api/probe/',
        data: formDataSample);
    print(responseSample.statusCode);
  }

  saveCultivar() async {
    FormData formDataSample = FormData.fromMap(
      {
        'name': sampleName,
        'location': await getLocation(),
        'created_at': DateFormat('dd.MM.yyyy HH:mm').format(
          DateTime.now(),
        ),
        'square_meter_plants_amount': 10,
        'field': 1,
        'cultivar': selectedSortIndex,
      },
    );

    Dio dio = Dio();
    Response responseSample = await dio.post(
        'http://ec2-18-192-114-24.eu-central-1.compute.amazonaws.com/api/probe/',
        data: formDataSample);
    print(responseSample.statusCode);
  }

  Future<String> getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print(position);
    String latitude = position.latitude.toString();
    String longitude = position.longitude.toString();

    String positionString = '$latitude, $longitude';

    return positionString;
  }

  Widget screenBody() {
    return Column(
      children: [
        SizedBox(
          height: 16.h,
        ),
        createSampleTextField('Введите название снятой пробы'),
        SizedBox(
          height: 10.h,
        ),
        sortsDropDownItem(),
        SizedBox(
          height: 25.h,
        ),
        Expanded(
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 15.w,
                ),
                child: NotificationListener<OverscrollIndicatorNotification>(
                  onNotification: (OverscrollIndicatorNotification overscroll) {
                    overscroll.disallowGlow();
                    return true;
                  },
                  child: GridView.builder(
                    itemCount: imageFileList?.length ?? 0,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 6.w,
                      crossAxisSpacing: 6.w,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16.r),
                                image: DecorationImage(
                                  image: FileImage(
                                    File(imageFileList![index].path),
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    imageFileList!
                                        .remove(imageFileList![index]);
                                  });
                                },
                                child: Container(
                                  width: 24.w,
                                  height: 20.h,
                                  child: Stack(
                                    children: [
                                      Container(
                                        width: 24.w,
                                        height: 20.h,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(16.r),
                                          ),
                                          color: Colors.black45,
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.center,
                                        child: Icon(
                                          Icons.clear_rounded,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  margin: EdgeInsets.only(
                    right: 20.w,
                    bottom: 20.h,
                  ),
                  child: takePhotoBtns(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget createSampleTextField(String hintText) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 15.w,
      ),
      height: 41.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 8.w,
        vertical: 8.h,
      ),
      child: TextField(
        textAlignVertical: TextAlignVertical.center,
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
        onChanged: (val) {
          sampleName = val;
        },
      ),
    );
  }

  Widget takePhotoBtns() {
    return Container(
      width: 120.w,
      decoration: BoxDecoration(
        color: Color(0xFF1259C3),
        borderRadius: BorderRadius.all(
          Radius.circular(20.r),
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              child: AddPhotoBtn(
                onPressed: () async {
                  await _pickGallery();
                  setState(() {});
                },
                image: 'assets/images/directory_icon.png',
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                color: Color(0xFFA7A7A7),
              ),
              height: 40.h,
              width: 1.w,
            ),
            Expanded(
              child: AddPhotoBtn(
                onPressed: () async {
                  await _pickCamera();
                  setState(() {});
                },
                image: 'assets/images/camera_icon.png',
              ),
            ),
          ],
        ),
      ),
    );
  }

  _pickGallery() async {
    final List<XFile>? selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages!.isNotEmpty) {
      imageFileList!.addAll(selectedImages);
    }
    print("Image List Length:" + imageFileList!.length.toString());
  }

  _pickCamera() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);

    if (image == null) {
      return;
    }
    imageFileList!.add(image);
  }

  Widget sortsDropDownItem() {
    final sorts = [
      'ДЮРБАН',
      'ЛГ 5377',
      'ЛГ 50270',
      'ЛГ КАСПИАН',
      'ЕС Белла',
      'НК Роки',
      'ЕС Петуниа',
      'ЕС Савана',
      'МЕГАСАН',
      'ЛГ 5485',
      'ТУНКА',
      'ЛГ 5580',
      'НК Брио',
      'НК Конди',
      'СИ Фламенко',
      'ЛГ 5463 КЛ',
      'КОДИЗОЛЬ',
      'ИМЕРИЯ',
      'НК Фортими',
      'Тристан',
      'ЕС Новамис СЛ',
      'ЕС Амис СЛ',
      'ЕС Террамис СЛ РФ',
      'ФУШИЯ',
      'ЛГ 5543 КЛ',
      'ЛГ 5542 КЛ',
      'НК Неома',
      'СИ Эксперто',
      'ЕС Генезис СЛП',
      'ЕС Янис СЛП',
      'ЕС Каприс',
      'ЛГ 5555 КЛП',
      'ЛГ 50635 КЛП',
      'СИ Бакарди',
      'Си Неостар',
      'Сумико',
      'ЕС Аркадия'
    ];

    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(
          horizontal: 15.w,
        ),
        height: 41.h,
        padding: EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 4,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: selectedSort,
            menuMaxHeight: 400.h,
            hint: Text(
              'Выберите сорт подсолнечника',
              style: TextStyle(
                fontSize: 14.sp,
                color: Color(0xFFBABABC),
                fontWeight: FontWeight.w500,
                fontFamily: 'Roboto',
              ),
            ),
            iconSize: 36,
            icon: Icon(
              Icons.arrow_drop_down,
              color: Colors.black,
            ),
            items: sorts.map(buildSortItem).toList(),
            onChanged: (value) {
              setState(() {
                if (value != null) {
                  selectedSort = value;
                  selectedSortIndex = sorts.indexOf(value) + 1;
                  print(selectedSortIndex);
                }
              });
            },
          ),
        ),
      ),
    );
  }

  DropdownMenuItem<String> buildSortItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: TextStyle(
            fontSize: 14.sp,
            color: Color(0xFFBABABC),
            fontWeight: FontWeight.w500,
            fontFamily: 'Roboto',
          ),
        ),
      );
}
