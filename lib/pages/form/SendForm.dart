import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:schedule_task/common/icon/round_corner_Icon.dart';
import 'package:schedule_task/common/model/get_task_modle.dart';
import 'package:schedule_task/common/model/quality_level_model.dart';
import 'package:schedule_task/common/utils/sp_util.dart';
import 'package:schedule_task/common/widgets/narrow_app_bar.dart';

class SendFormPage extends StatefulWidget {
  @override
  _SendFormPageState createState() => _SendFormPageState();
}

TextEditingController codeController = TextEditingController();
TextEditingController typeController = TextEditingController();
TextEditingController batchController = TextEditingController();
TextEditingController fuzeNameController = TextEditingController();
TextEditingController fuzeBatchController = TextEditingController();
TextEditingController fillingsController = TextEditingController();
TextEditingController cartridgeMaterialController = TextEditingController();
TextEditingController wzbhController = TextEditingController();
TextEditingController propellantBatchController = TextEditingController();
TextEditingController primerNameController = TextEditingController();
TextEditingController primerBatchController = TextEditingController();
TextEditingController remarkController = TextEditingController();
TextEditingController useDateController = TextEditingController();
TextEditingController effectiveDateController = TextEditingController();
TextEditingController qualityLevelController = TextEditingController();
TextEditingController boxNoController = TextEditingController();
TextEditingController unitController = TextEditingController();
TextEditingController quantityController = TextEditingController();
TextEditingController locationController = TextEditingController();
TextEditingController matStatusController = TextEditingController();

class FormList {
  String code;
  String name;
  Color color;
  String fontsize;
  Icon icon;
  String value;
  String type;
  TextEditingController textEditingController;
  FormList({
    this.code = '',
    this.name = '',
    this.color,
    this.fontsize = '',
    this.icon,
    this.value = '',
    this.type = '',
    this.textEditingController,
  });
}

class _SendFormPageState extends State<SendFormPage> {
  String qrCode = 'Unknown data ';
  String barcode = '';
  Uint8List bytes = Uint8List(0);
  //GlobalKey _newContentKey = new GlobalKey();
  String date = '';
  SpUtil spUtil = SpUtil();
  List<QualityLevelModel> val;
  List<GetTaskModleSchemeSchemeItems> items;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<FormList> _formList = <FormList>[
    FormList(
      code: 'code',
      name: '物资编号',
      color: Colors.black,
      fontsize: '14',
      icon: Icon(CupertinoIcons.qrcode_viewfinder),
      value: '',
      type: '1',
      textEditingController: codeController,
    ),
    FormList(
      code: 'type',
      name: '物资类型',
      color: Colors.black,
      fontsize: '14',
      icon: Icon(CupertinoIcons.qrcode_viewfinder),
      value: '',
      type: '1',
      textEditingController: typeController,
    ),
    FormList(
      code: 'batch',
      name: '全弹批年厂',
      color: Colors.black,
      fontsize: '14',
      icon: null,
      value: '',
      type: '2',
      textEditingController: batchController,
    ),
    FormList(
      code: 'fuzeName',
      name: '引信名称',
      color: Colors.black,
      fontsize: '14',
      icon: null,
      value: '',
      type: '2',
      textEditingController: fuzeNameController,
    ),
    FormList(
      code: 'fuzeBatch',
      name: '引信批年厂',
      color: Colors.black,
      fontsize: '14',
      icon: null,
      value: '',
      type: '2',
      textEditingController: fuzeBatchController,
    ),
    FormList(
      code: 'fillings',
      name: '弹丸装填物',
      color: Colors.black,
      fontsize: '14',
      icon: null,
      value: '',
      type: '2',
      textEditingController: fillingsController,
    ),
    FormList(
      code: 'cartridgeMaterial',
      name: '药筒材料',
      color: Colors.black,
      fontsize: '14',
      icon: null,
      value: '',
      type: '2',
      textEditingController: cartridgeMaterialController,
    ),
    FormList(
      code: 'propellantBatch',
      name: '发射药批年厂',
      color: Colors.black,
      fontsize: '14',
      icon: null,
      value: '',
      type: '2',
      textEditingController: propellantBatchController,
    ),
    FormList(
      code: 'primerName',
      name: '底火名称',
      color: Colors.black,
      fontsize: '14',
      icon: null,
      value: '',
      type: '2',
      textEditingController: primerNameController,
    ),
    FormList(
      code: 'primerBatch',
      name: '底火批年厂',
      color: Colors.black,
      fontsize: '14',
      icon: null,
      value: '',
      type: '2',
      textEditingController: primerBatchController,
    ),
    FormList(
      code: 'remark',
      name: '其他',
      color: Colors.black,
      fontsize: '14',
      icon: null,
      value: '',
      type: '2',
      textEditingController: remarkController,
    ),
    FormList(
      code: 'useDate',
      name: '生产日期',
      color: Colors.black,
      fontsize: '14',
      icon: Icon(Icons.date_range),
      value: '',
      type: '2',
      textEditingController: useDateController,
    ),
    FormList(
      code: 'effectiveDate',
      name: '有效日期',
      color: Colors.black,
      fontsize: '14',
      icon: Icon(Icons.date_range),
      value: '',
      type: '2',
      textEditingController: effectiveDateController,
    ),
    FormList(
      code: 'qualityLevel',
      name: '质量等级',
      color: Colors.black,
      fontsize: '14',
      icon: null,
      value: '',
      type: '2',
      textEditingController: qualityLevelController,
    ),
    FormList(
      code: 'boxNo',
      name: '箱体编号',
      color: Colors.black,
      fontsize: '14',
      icon: null,
      value: '',
      type: '2',
      textEditingController: boxNoController,
    ),
    FormList(
      code: 'location',
      name: '存放位置',
      color: Colors.black,
      fontsize: '14',
      icon: null,
      value: '',
      type: '2',
      textEditingController: locationController,
    ),
    FormList(
      code: 'unit',
      name: '计量单位',
      color: Colors.black,
      fontsize: '14',
      icon: null,
      value: '',
      type: '1',
      textEditingController: unitController,
    ),
    FormList(
      code: 'quantity',
      name: '数量',
      color: Colors.black,
      fontsize: '14',
      icon: null,
      value: '',
      type: '1',
      textEditingController: quantityController,
    ),
    FormList(
        code: 'matStatus',
        name: '物资状态',
        color: Colors.black,
        fontsize: '14',
        icon: null,
        value: '',
        type: '1',
        textEditingController: matStatusController),
  ];

  Future<Map<String, dynamic>> getTaskData() async {
    String ip = spUtil.getString('ip');
    String javaport = spUtil.getString('javaport');
    var response = await http.post("http://$ip:$javaport/PDA/getTaskData",
        body: "5aafd721-c8cd-4d6d-a96c-05aff4a18d80");
    print('库位信息过滤结果集:${response.body}');
    Map inventoryMap = jsonDecode(response.body);
    print('結果集:$inventoryMap');
    var responses = await Dio().post(
      "http://$ip:$javaport/PDA/getTaskData",
      data: "5aafd721-c8cd-4d6d-a96c-05aff4a18d80",
    );
    print('结果集:${responses.data}');
    // var models = GetTaskModle.fromJsonList(response.body);
    // models.forEach((element) {
    //   print('${element.toJson}');
    // });
    var scheme = GetTaskModle.fromJson(responses.data).scheme;
    items = scheme.schemeItems;
    String timestamp;
    for (var i = 0; i < 1; i++) {
      print('---------------------${items[0].productionDate}');
      var date =
          new DateTime.fromMillisecondsSinceEpoch(items[0].productionDate);
      timestamp =
          "${date.year.toString()}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
      print('时间:-------$timestamp');
    }
    setState(() {
      useDateController.text = timestamp;
      effectiveDateController.text = timestamp;
    });
    // items.forEach((e) {
    //   print('循环结果集:${e.toJson()}');
    //   var d = e.productionDate;
    //   try {
    //     var date = new DateTime.fromMillisecondsSinceEpoch(d);
    //     String timestamp =
    //         "${date.year.toString()}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    //     print('时间:-------$timestamp');
    //   } catch (e) {}
    // });

    return responses.data;
  }

  @override
  void initState() {
    super.initState();
    getQualityLevelModel();
    getTaskData();
    debugPrint('-------------------------------${_formList.length.toString()}');
    unitController.text = '箱';
    quantityController.text = '1';
    matStatusController.text = '待入库';
  }

  Future applyPermission(
      TextEditingController textEditingController, String name) async {
    if (await Permission.camera.request().isGranted) {
      // 干你该干的事
      scan(textEditingController, name);
    }
  }

  scan(TextEditingController textEditingController, String name) async {
    // var options = ScanOptions(
    //     strings: {"cancel": "关闭", "flash_on": "打开闪光灯", "flash_off": "关闭闪光灯"});

    // ScanResult result = await BarcodeScanner.scan(options: options);
    // print(result.rawContent);
    // setState(() {
    //   barcode = result.rawContent;
    //   if (name == '物资编号') {
    //     codeController.text = barcode;
    //   } else if (name == '物资类型') {
    //     typeController.text = barcode;
    //   }
    // });
  }

  Future<List<QualityLevelModel>> getQualityLevelModel() async {
    String ip = spUtil.getString('ip');
    String javaport = spUtil.getString('javaport');
    var responses = await Dio().post(
      "http://$ip:$javaport/PDA/getQualityLevel",
    );
    print('获取质量等级:${responses.data}');
    var valu = responses.data;
    print('--------------------------$valu');
    final inventory = valu.cast<Map<String, dynamic>>();
    print('--------------------$inventory');
    List<QualityLevelModel> a = inventory
        .map<QualityLevelModel>((json) => QualityLevelModel.fromJson(json))
        .toList();
    a.forEach((e) {
      print('${e.toJson()}');
    });
    val = a;
    //List<QualityLevelModel> c =
    return a;
  }

  List<QualityLevelModel> setValue() {
    return val;
  }

  var tt;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: NarrowAppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: RoundCornerIcon(
            ///小图标
            iconData: CupertinoIcons.arrow_left,

            ///线性渐变的背景
            gradient: LinearGradient(
              ///颜色过渡
              colors: [
                Colors.redAccent,
                Colors.orange,
              ],

              ///颜色过渡的开始位置  左上角
              begin: Alignment.topLeft,

              ///颜色过渡的结束位置  右下角
              end: Alignment.bottomRight,
            ),
          ),
        ),
        trailing: Text(
          '获取数据',
          style: TextStyle(
            fontFamily: 'NotoSansSC',
            fontSize: 16.0,
            color: Colors.blue,
            fontWeight: FontWeight.w600,
            letterSpacing: 5,
          ),
        ),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Form(
              key: _formKey,
              child: ListView.builder(
                //shrinkWrap: true,
                itemCount: _formList.length,
                itemBuilder: (context, index) {
                  return _formList[index].type == '1'
                      ? Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 8.0),
                          child: TextFormField(
                            validator: (value) {
                              if (value.isEmpty) {
                                return '不允许为空';
                              }
                              return null;
                            },
                            enabled:
                                _formList[index].icon == null ? false : true,
                            enableInteractiveSelection: false,
                            onTap: () {
                              FocusScope.of(context)
                                  .requestFocus(new FocusNode());
                            },
                            controller: _formList[index].textEditingController,
                            decoration: InputDecoration(
                              labelText: '${_formList[index].name}',
                              // border: OutlineInputBorder(
                              //   borderRadius: BorderRadius.circular(20.0),
                              // ),
                              suffixIcon: _formList[index].icon != null
                                  ? IconButton(
                                      icon: Icon(
                                          CupertinoIcons.qrcode_viewfinder),
                                      onPressed: () {
                                        if (_formList[index].name == '物资编号' ||
                                            _formList[index].name == '物资类型') {
                                          applyPermission(
                                              _formList[index]
                                                  .textEditingController,
                                              _formList[index].name);
                                          // scan(_formList[index].textEditingController,
                                          //     _formList[index].name);
                                          setState(() {
                                            _formList[index]
                                                .textEditingController
                                                .text = '';
                                          });
                                        } else {}
                                      },
                                    )
                                  : SizedBox.shrink(),
                            ),
                          ),
                        )
                      : (_formList[index].icon != null
                          ? Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12.0, vertical: 8.0),
                              child: TextFormField(
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return '不允许为空';
                                  }
                                  return null;
                                },
                                enabled: _formList[index].icon == null
                                    ? false
                                    : true,
                                enableInteractiveSelection: false,
                                onTap: () {
                                  FocusScope.of(context)
                                      .requestFocus(new FocusNode());
                                },
                                //key: _newContentKey,
                                controller:
                                    _formList[index].textEditingController,
                                decoration: InputDecoration(
                                  labelText: '${_formList[index].name}',
                                  suffixIcon: IconButton(
                                    icon: _formList[index].icon,
                                    onPressed: () {
                                      selectDate(
                                          context,
                                          _formList[index]
                                              .textEditingController);
                                    },
                                  ),
                                ),
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12.0, vertical: 8.0),
                              child: _formList[index].name != '质量等级'
                                  ? TextFormField(
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return '不允许为空';
                                        }
                                        return null;
                                      },
                                      //key: _newContentKey,
                                      controller: _formList[index]
                                          .textEditingController,
                                      decoration: InputDecoration(
                                        labelText: '${_formList[index].name}',
                                        hintText: '需填写',
                                        hintStyle: TextStyle(
                                          fontFamily: "NotoSansSC",
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.w300,
                                        ),
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
                                      ),
                                    )
                                  : DropdownSearch<QualityLevelModel>(
                                      showSelectedItem: true,
                                      compareFn: (QualityLevelModel i,
                                              QualityLevelModel s) =>
                                          i.isEqual(s),
                                      label: "质量等级",
                                      onFind: (String name) =>
                                          getQualityLevelModel(),
                                      onChanged: (QualityLevelModel data) {
                                        print('物资编号${data.name}');
                                        setState(() {
                                          // noController.text = data.no;
                                          // name = data.name;
                                          // isShowDropDown = true;
                                        });
                                      },
                                      dropdownBuilder: _customDropDownExample,
                                      popupItemBuilder:
                                          _customPopupItemBuilderExample2,
                                    ),
                            ));
                },
              ),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Divider(
            height: 10.0,
          ),
          Builder(
            builder: (BuildContext context) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                child: new FloatingActionButton.extended(
                  onPressed: () async {
                    print('button click');
                    if (_formKey.currentState.validate()) {
                      final Map<String, dynamic> data = Map<String, dynamic>();
                      _formList.forEach((element) {
                        var value = element.textEditingController.text;
                        var code = element.code;
                        if (code == 'quantity') {
                          data['$code'] = int.parse(value);
                        } else if (code == 'matStatus') {
                          if (value == '待入库') {
                            data['$code'] = '0';
                          }
                        } else {
                          data['$code'] = value;
                        }
                      });
                      print('获取的数据：*-*-*-*-*-*-$data');
                      String ip = spUtil.getString('mqttip');
                      String javaport = spUtil.getString('javaport');
                      String url = "http://$ip:$javaport/";
                      print('地址:$url');
                      var responses = await Dio().post(
                        "$url",
                      );
                      print('Http返回状态值:${responses.statusCode}');
                      Scaffold.of(context).showSnackBar(
                        SnackBar(
                          //print('获取的数据：*-*-*-*-*-*-$data'),
                          content: Text('提交成功...'),
                        ),
                      );
                    }
                  },
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,
                  label: new Text('提交', maxLines: 1),
                ),
              );
            },
          ),
          SizedBox(
            height: 10.0,
          ),
        ],
      ),
    );
  }

  Widget _customDropDownExample(
      BuildContext context, QualityLevelModel item, String itemDesignation) {
    return Container(
      child: (item?.name == null)
          ? ListTile(
              contentPadding: EdgeInsets.all(0),
              //leading: CircleAvatar(),
              title: Text("请选择"),
            )
          : ListTile(
              contentPadding: EdgeInsets.all(0),
              // leading: CircleAvatar(
              //   backgroundImage: NetworkImage(item.avatar),
              // ),
              title: Text(item.name),
              // subtitle: Text(
              //   item.name,
              // ),
            ),
    );
  }

  Widget _customPopupItemBuilderExample2(
      BuildContext context, QualityLevelModel item, bool isSelected) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      decoration: !isSelected
          ? null
          : BoxDecoration(
              border: Border.all(color: Theme.of(context).primaryColor),
              borderRadius: BorderRadius.circular(5),
              color: Colors.white,
            ),
      child: ListTile(
        selected: isSelected,
        title: Text(item.name),
        // subtitle: Text(item.name),
        // leading: CircleAvatar(
        //   backgroundImage: NetworkImage(item.avatar),
        // ),
      ),
    );
  }

  Future<Null> selectDate(BuildContext buildContext,
      TextEditingController textEditingController) async {
    Locale myLocale = Localizations.localeOf(context);
    final DateTime _picked = await showDatePicker(
      locale: myLocale,
      context: buildContext,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (_picked != null) {
      debugPrint('--------------------------${_picked.toString()}');
      setState(() {
        date = _picked.year.toString() +
            '-' +
            _picked.month.toString() +
            '-' +
            _picked.day.toString();

        textEditingController.text = date;
      });
    }
  }
}
