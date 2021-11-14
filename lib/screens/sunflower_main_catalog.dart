import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:innopolis_hack/models/sunflower_field.dart';
import 'package:innopolis_hack/models/sunflower_sample.dart';
import 'package:innopolis_hack/screens/create_sunflower_sample_screen.dart';
import 'package:innopolis_hack/widgets/add_new_field_dialog.dart';
import 'package:innopolis_hack/widgets/search_widget.dart';
import 'package:intl/intl.dart';

class SunflowerMainCatalog extends StatefulWidget {
  @override
  _SunflowerMainCatalogState createState() => _SunflowerMainCatalogState();
}

class _SunflowerMainCatalogState extends State<SunflowerMainCatalog> {
  bool isSearchMode = false;
  List<dynamic> sunflowerFields = [];
  List<dynamic> sunflowerSamples = [];
  String query = '';

  @override
  void initState() {
    /* sunflowerFields = await getFields();
    sunflowerSamples = await getSamples();*/
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isSearchMode
          ? searchSunflowerFieldAppBar()
          : sunflowerMainCardAppbar(),
      body: SafeArea(
        child: !isSearchMode
            ? FutureBuilder(
                future: getFields(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.none &&
                      snapshot.hasData == null) {
                    //print('project snapshot data is: ${projectSnap.data}');
                    return Container();
                  }

                  return ListView.builder(
                    itemCount: sunflowerFields.length,
                    itemBuilder: (context, index) {
                      final field = sunflowerFields[index];
                      return screenBodyNew(context, field);
                    },
                  );
                },
              )
            : ListView.builder(
                itemCount: sunflowerFields.length,
                itemBuilder: (context, index) {
                  final field = sunflowerFields[index];
                  return screenBodyNew(context, field);
                },
              ),
      ),
    );
  }

  AppBar sunflowerMainCardAppbar() {
    return AppBar(
      backgroundColor: Colors.white,
      title: Text(
        'Поля',
        style: TextStyle(
          color: Colors.black,
          fontFamily: 'Roboto',
          fontSize: 20.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            setState(() {
              isSearchMode = true;
            });
          },
          icon: iconsContainer(
            20.w,
            20.h,
            'assets/images/search_icon.png',
          ),
        ),
        IconButton(
          onPressed: getFields,
          icon: iconsContainer(
            16.w,
            16.h,
            'assets/images/filter_icon.png',
          ),
        ),
        IconButton(
          onPressed: addNewSunflowerField,
          icon: Icon(
            Icons.add_circle_outline_rounded,
            color: Colors.black,
          ),
        ),
        /*IconButton(
          onPressed: () {},
          icon: iconsContainer(
            4.w,
            14.h,
            'assets/images/menu.png',
          ),
        ),*/
      ],
    );
  }

  AppBar searchSunflowerFieldAppBar() {
    return AppBar(
      titleSpacing: 0,
      backgroundColor: Colors.white,
      title: buildSearch(),
    );
  }

  Widget buildSearch() {
    return SearchWidget(
      text: query,
      hintText: 'Введите название поля или района',
      onChanged: searchSunflowerField,
      onEdited: () {
        setState(() {
          isSearchMode = false;
        });
      },
    );
  }

  void searchSunflowerField(String fieldName) {
    final fields = sunflowerFields.where((field) {
      final searchFieldLower = fieldName.toLowerCase();
      final fieldLower = field['name'].toLowerCase();
      final areaLower = field['region'].toLowerCase();

      return (fieldLower.contains(searchFieldLower) ||
          areaLower.contains(searchFieldLower));
    }).toList();

    setState(() {
      this.query = fieldName;
      this.sunflowerFields = fields;
    });
  }

  Widget screenBody() {
    return ListView.builder(
      itemCount: sunflowerFields.length,
      itemBuilder: (context, index) {
        final field = sunflowerFields[index];
        return screenBodyNew(context, field);
      },
    );
  }

  Widget screenBodyNew(BuildContext context, dynamic sunflowerField) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(width: 2.w, color: Color(0xFFEEEEEE)),
          bottom: BorderSide(width: 2.w, color: Color(0xFFEEEEEE)),
        ),
      ),
      child: ExpansionTile(
        textColor: Color(0xFFB5B8C1),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            catalogTitle(sunflowerField['name']),
            SizedBox(
              height: 4.h,
            ),
            Row(
              children: [
                Container(
                  width: 15.w,
                  height: 10.h,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/geo_icon.png'),
                    ),
                  ),
                ),
                districtText(sunflowerField['region'].toString()),
                areaText(sunflowerField['area'].toString())
              ],
            ),
            SizedBox(
              height: 4.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                dateText(sunflowerField['created_at']),
                Row(
                  children: [
                    IconButton(
                      iconSize: 16,
                      constraints: BoxConstraints(
                        minWidth: 16.w,
                        minHeight: 16.w,
                      ),
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => CreateSunflowerSampleScreen(),
                          ),
                        );
                      },
                      icon: Container(
                        width: 16.w,
                        height: 16.w,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image:
                                AssetImage('assets/images/sunflower_icon.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 15.w,
                    ),
                    IconButton(
                      iconSize: 16,
                      constraints: BoxConstraints(
                        minWidth: 16.w,
                        minHeight: 16.w,
                      ),
                      padding: EdgeInsets.zero,
                      onPressed: () async {
                        await deleteField(sunflowerField);
                      },
                      icon: iconsContainer(
                          16.w, 16.w, 'assets/images/delete_icon.png'),
                    ),
                  ],
                )
              ],
            )
          ],
        ),
        children: getSamplesList(sunflowerField['probes']),
      ),
    );
  }

  List<Widget> getSamplesList(List<dynamic> samples) {
    List<Widget> _samples = [];
    for (dynamic _sample in samples) {
      _samples.add(
        Padding(
          padding: const EdgeInsets.only(left: 40),
          child: ExpansionItem(
            sample: _sample,
            onPressed: () {
              deleteSample(_sample);
            },
          ),
        ),
      );
    }
    return _samples;
  }

  Widget sunflowerCard(BuildContext context, SunflowerField sunflowerField) {
    return Container(
      margin: EdgeInsets.only(
        bottom: 12.h,
      ),
      padding: EdgeInsets.only(
        left: 18.w,
        top: 24.h,
        right: 11.w,
      ),
      height: 113.h,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //sunflowerImage(),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                left: 18.w,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  catalogTitle(sunflowerField.sunflowerFieldName),
                  Row(
                    children: [
                      Container(
                        width: 15.w,
                        height: 10.h,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/geo_icon.png'),
                          ),
                        ),
                      ),
                      areaText(sunflowerField.fieldArea),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget catalogTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontFamily: 'Roboto',
        fontSize: 16.sp,
        color: Color(0xFF56585C),
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget areaText(String area) {
    return Text(
      ' - ' + area + ' га',
      style: TextStyle(
        color: Color(0xFF9DA9C0),
        fontFamily: 'Roboto',
        fontSize: 12.sp,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget districtText(String district) {
    return Text(
      district,
      style: TextStyle(
        color: Color(0xFF9DA9C0),
        fontFamily: 'Roboto',
        fontSize: 12.sp,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget dateText(String date) {
    return Text(
      date,
      style: TextStyle(
        color: Color(0xFFB5B8C1),
        fontFamily: 'Roboto',
        fontSize: 12.sp,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget iconsContainer(double width, double height, String image) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(image),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  /*final allSunflowerFields = <SunflowerField>[
    SunflowerField(
      sunflowerFieldName: 'Sunflower 2',
      fieldArea: 'Арский район',
      date: '11/11',
      samples: samples,
    ),
    SunflowerField(
      sunflowerFieldName: 'Sunflower 1',
      fieldArea: 'Арский район',
      date: '11/11',
      samples: samples,
    ),
    SunflowerField(
      sunflowerFieldName: 'Sunflower 1',
      fieldArea: 'Арский район',
      date: '11/11',
      samples: samples,
    ),
    SunflowerField(
      sunflowerFieldName: 'Sunflower 1',
      fieldArea: 'Арский район',
      date: '11/11',
      samples: samples,
    ),
    SunflowerField(
      sunflowerFieldName: 'Sunflower 1',
      fieldArea: 'Советский район',
      date: '11/11',
      samples: samples,
    ),
  ];*/

  void addNewSunflowerField() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AddNewSunflowerFieldDialog();
        });
  }

  getFields() async {
    Dio dio = Dio();
    Response response = await dio.get(
        'http://ec2-18-192-114-24.eu-central-1.compute.amazonaws.com/api/field/');

    setState(() {
      sunflowerFields = response.data;
    });
  }

  getSamples() async {
    Dio dio = Dio();
    Response response = await dio.get(
        'http://ec2-18-192-114-24.eu-central-1.compute.amazonaws.com/api/samples/');
    setState(() {
      sunflowerSamples = response.data;
    });
  }

  deleteField(dynamic field) async {
    int fieldId = field['id'];

    print(fieldId);

    Dio dio = Dio();
    Response response = await dio.delete(
        'http://ec2-18-192-114-24.eu-central-1.compute.amazonaws.com/api/field/$fieldId');
    setState(() {
      sunflowerSamples = response.data;
    });
  }

  deleteSample(dynamic sample) async {
    int sampleId = sample['id'];

    print(sampleId);

    Dio dio = Dio();
    Response response = await dio.delete(
        'http://ec2-18-192-114-24.eu-central-1.compute.amazonaws.com/api/probe/$sampleId');
    setState(() {
      sunflowerSamples = response.data;
    });
  }
}

class ExpansionItem extends StatelessWidget {
  dynamic sample;
  VoidCallback onPressed;

  ExpansionItem({
    Key? key,
    required this.sample,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(sample['name']),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            sample['created_at'],
            style: TextStyle(
              color: Color(0xFFB5B8C1),
              fontFamily: 'Roboto',
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          Row(
            children: [
              IconButton(
                iconSize: 16,
                constraints: BoxConstraints(
                  minWidth: 16.w,
                  minHeight: 16.w,
                ),
                padding: EdgeInsets.zero,
                onPressed: () {},
                icon: iconsContainer(16.w, 16.w, 'assets/images/edit_icon.png'),
              ),
              SizedBox(
                width: 15.w,
              ),
              IconButton(
                iconSize: 16,
                constraints: BoxConstraints(
                  minWidth: 16.w,
                  minHeight: 16.w,
                ),
                padding: EdgeInsets.zero,
                onPressed: onPressed,
                icon:
                    iconsContainer(16.w, 16.w, 'assets/images/delete_icon.png'),
              ),
            ],
          )
        ],
      ),
      /*trailing: SampleMenu(
          sampleData: sample,
        ),*/
    );
  }

  Widget iconsContainer(double width, double height, String image) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(image),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
