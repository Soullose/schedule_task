import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:schedule_task/common/icon/round_corner_Icon.dart';
import 'package:schedule_task/common/model/mat_code_model.dart';
import 'package:schedule_task/common/model/mat_qr_code_entity.dart';
import 'package:schedule_task/common/model/stock_info_model.dart';
import 'package:schedule_task/common/utils/sp_util.dart';
import 'package:schedule_task/common/widgets/narrow_app_bar.dart';

///盘点新增数据界面
class AddDataPage extends StatefulWidget {
  final String takid;
  final MatQrCodeEntity qrCodeModel;

  AddDataPage({Key key, this.takid, this.qrCodeModel}) : super(key: key);
  @override
  _AddDataPageState createState() => _AddDataPageState();
}

class _AddDataPageState extends State<AddDataPage> {
  SpUtil spUtil = SpUtil();
  Animation inputAnimation;

  ///物资编号Controller
  TextEditingController codeController = TextEditingController();

  ///物资编号Controller
  TextEditingController matCodeController = TextEditingController();

  ///分类编号Controller
  TextEditingController noController = TextEditingController();

  ///库位XController
  TextEditingController storageBinXController = TextEditingController();

  ///库位YController
  TextEditingController storageBinYController = TextEditingController();

  ///长度Controller
  TextEditingController lengthController = TextEditingController();

  ///层数Controller
  TextEditingController storeyController = TextEditingController();
  String name = '';
  String area = '';
  String positionCode = '';
  bool isShowDropDown = false;
  bool enableButton = false;
  @override
  void initState() {
    super.initState();
    print('-*-*${widget.qrCodeModel.matcode}-*-*');
    codeController.text = widget.qrCodeModel.matcode;
    getStockInfo(http.Client());
  }

  Future getStockInfo(http.Client client) async {
    final response =
        await client.post('http://47.110.54.24:8080/PDA/stockInfo');
    print('963214785:${response.body}');
    final inventory = jsonDecode(response.body).cast<Map<String, dynamic>>();
    List<StockInfoModel> a = inventory
        .map<StockInfoModel>((json) => StockInfoModel.fromJson(json))
        .toList();
    a.forEach((element) {
      print('循环库位信息：${element.toJson()}');
    });
  }

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
          '新增物资',
          style: TextStyle(
            fontFamily: 'NotoSansSC',
            fontSize: 16.0,
            color: Colors.blue,
            fontWeight: FontWeight.w600,
            letterSpacing: 5,
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(
          vertical: 30,
          horizontal: 10,
        ),
        child: ListView(
          children: [
            TextField(
              //key: _newContentKey,
              controller: codeController,
              enableInteractiveSelection: false,
              onTap: () {
                FocusScope.of(context).requestFocus(new FocusNode());
              },
              decoration: InputDecoration(
                labelText: '物资类型',
                border: InputBorder.none,
              ),
            ),
            Divider(),
            DropdownSearch<MatCodeModel>(
              showSelectedItem: true,
              compareFn: (MatCodeModel i, MatCodeModel s) => i.isEqual(s),
              label: "物资分类",
              onFind: (String filter) => getData(filter),
              onChanged: (MatCodeModel data) {
                print('物资编号${data.no}');
                setState(() {
                  noController.text = data.no;
                  name = data.name;
                  isShowDropDown = true;
                });
              },
              dropdownBuilder: _customDropDownExample,
              popupItemBuilder: _customPopupItemBuilderExample2,
            ),
            Divider(),
            TextField(
              //key: _newContentKey,
              controller: noController,
              enableInteractiveSelection: false,
              onTap: () {
                FocusScope.of(context).requestFocus(new FocusNode());
              },
              decoration: InputDecoration(
                labelText: '分类编号',
                border: InputBorder.none,
              ),
            ),
            Divider(),
            DropdownSearch<StockInfoModel>(
              enabled: isShowDropDown,
              showSelectedItem: true,
              compareFn: (StockInfoModel i, StockInfoModel s) => i.isEqual(s),
              label: "区域",
              onFind: (String filter) => getStockInfoData(name),
              onChanged: (StockInfoModel data) {
                print('物资区域编号：${data.code}');
                print('物资区域：${data.area}');
                print('物资层数：${data.layer}');
                print('物资X：${data.x}');
                print('物资Y：${data.y}');
                print('物资length：${data.length}');
                setState(() {
                  storageBinXController.text = data.x.toString();
                  storageBinYController.text = data.y.toString();
                  lengthController.text = data.length.toString();
                  storeyController.text = data.layer.toString();
                  area = data.area;
                  positionCode = data.code;
                  enableButton = true;
                  //noController.text = data.no;
                });
              },
              dropdownBuilder: _customDropDownExampleStockInfo,
              popupItemBuilder: _customPopupItemBuilderExample2StockInfo,
            ),
            Divider(),
            TextField(
              //key: _newContentKey,
              controller: storeyController,
              enableInteractiveSelection: false,
              onTap: () {
                FocusScope.of(context).requestFocus(new FocusNode());
              },
              decoration: InputDecoration(
                labelText: '层数',
                border: InputBorder.none,
              ),
            ),
            Divider(),
            TextField(
              //key: _newContentKey,
              controller: storageBinXController,
              enableInteractiveSelection: false,
              onTap: () {
                FocusScope.of(context).requestFocus(new FocusNode());
              },
              decoration: InputDecoration(
                labelText: 'X',
                border: InputBorder.none,
              ),
            ),
            Divider(),
            TextField(
              //key: _newContentKey,
              controller: storageBinYController,
              enableInteractiveSelection: false,
              onTap: () {
                FocusScope.of(context).requestFocus(new FocusNode());
              },
              decoration: InputDecoration(
                labelText: 'Y',
                border: InputBorder.none,
              ),
            ),
            Divider(),
            TextField(
              //key: _newContentKey,
              controller: lengthController,
              enableInteractiveSelection: false,
              onTap: () {
                FocusScope.of(context).requestFocus(new FocusNode());
              },
              decoration: InputDecoration(
                labelText: '长度',
                border: InputBorder.none,
              ),
            ),
            Divider(),
            FlatButton(
              child: Text("提交"),
              onPressed: enableButton
                  ? () async {
                      print('taskid:${widget.takid}');
                      print('物资编号:${codeController.text}');
                      print('物资类型:$name');
                      print('类型编号:${noController.text}');
                      print('区域:$area');
                      print('层数:${storeyController.text}');
                      print('X:${storageBinXController.text}');
                      print('Y:${storageBinYController.text}');
                      print('长度:${lengthController.text}');
                      var ip = spUtil.getString('ip');
                      var port = spUtil.getString('javaport');
                      var response = await http.post(
                        'http://$ip:$port/PDA/addCheckData',
                        headers: {"Content-Type": "application/json"},
                        body: json.encode({
                          'taskID': '${widget.takid}',
                          'matCode': '${widget.qrCodeModel.matcode}',
                          'matType': '$name',
                          'typeCode': '${noController.text}',
                          'area': '$area',
                          'positionCode': '$positionCode',
                          'layer': '${storeyController.text}',
                          'x': '${storageBinXController.text}',
                          'y': '${storageBinYController.text}',
                          'unit': '箱',
                          'quantity': 1,
                          'mapSign': 2
                        }),
                      );
                      print('Response status: ${response.statusCode}');
                      print('Response body: ${response.body}');
                    }
                  : null,
              disabledColor: enableButton ? null : Colors.black12,
              disabledTextColor: enableButton ? null : Colors.blueGrey,
              color: enableButton ? Colors.green : null,
              textColor: enableButton ? Colors.white : null,
            )
          ],
        ),
      ),
    );
  }

  Widget _customDropDownExample(
      BuildContext context, MatCodeModel item, String itemDesignation) {
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
      BuildContext context, MatCodeModel item, bool isSelected) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
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

  Future<List<MatCodeModel>> getData(filter) async {
    String ip = spUtil.getString('ip');
    String javaport = spUtil.getString('javaport');
    print('$ip');
    print('$javaport');
    var response = await Dio().post(
      "http://47.110.54.24:8080/PDA/getMatCode",
      queryParameters: {"name": filter},
    );
    print('区域信息过滤结果集:${response.data}');
    var models = MatCodeModel.fromJsonList(response.data);
    return models;
  }

  Widget _customDropDownExampleStockInfo(
      BuildContext context, StockInfoModel item, String itemDesignation) {
    return Container(
      child: (item?.matType == null)
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
              title: Text(item.area),
              // subtitle: Text(
              //   item.name,
              // ),
            ),
    );
  }

  Widget _customPopupItemBuilderExample2StockInfo(
      BuildContext context, StockInfoModel item, bool isSelected) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: !isSelected
          ? null
          : BoxDecoration(
              border: Border.all(color: Theme.of(context).primaryColor),
              borderRadius: BorderRadius.circular(5),
              color: Colors.white,
            ),
      child: ListTile(
        selected: isSelected,
        title: Text(item.matType),
        subtitle: Row(
          children: [
            Text('区域:${item.area}'),
            Divider(),
            Text('层数:${item.layer.toString()}'),
            Divider(),
            Text('X:${item.x.toString()}'),
            Divider(),
            Text('Y:${item.x.toString()}'),
            Divider(),
          ],
        ),
        //subtitle: Text(item.area),
        // leading: CircleAvatar(
        //   backgroundImage: NetworkImage(item.avatar),
        // ),
      ),
    );
  }

  Future<List<StockInfoModel>> getStockInfoData(filter) async {
    print('测试123456789');
    String ip = spUtil.getString('ip');
    String javaport = spUtil.getString('javaport');
    print('$ip');
    print('$javaport');
    var response = await Dio().post(
      "http://47.110.54.24:8080/PDA/stockInfoByMatType",
      data: filter,
    );
    print('库位信息过滤结果集:${response.data}');
    var models = StockInfoModel.fromJsonList(response.data);
    return models;
  }

  Future showDialogAction(bool isSelect) async {
    isSelect = await showDialog<bool>(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('提示'),
          content: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                new Text('请先选择物资分类'),
              ],
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text('确定'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
