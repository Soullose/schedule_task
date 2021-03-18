import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:schedule_task/common/icon/round_corner_Icon.dart';
import 'package:schedule_task/common/utils/sp_util.dart';
import 'package:schedule_task/common/widgets/narrow_app_bar.dart';

///入库 通过mqtt任务 查询items信息,校验matCode是否一致,出库入库一致
class InventoryInPage extends StatefulWidget {
  @override
  _InventoryInPageState createState() => _InventoryInPageState();
}

class _InventoryInPageState extends State<InventoryInPage>
    with TickerProviderStateMixin {
  String barcode = '';
  String errorMess = '';
  bool validate = true;
  bool checkValue = false;
  bool enableButton = false;
  SpUtil spUtil = SpUtil();

  ///物资编号Controller
  TextEditingController codeController = TextEditingController();

  ///物资类型Controller
  TextEditingController typeController = TextEditingController();

  ///库位编码Controller
  TextEditingController storageBinController = TextEditingController();

  ///库位X编码Controller
  TextEditingController storageBinXController = TextEditingController();

  ///库位Y编码Controller
  TextEditingController storageBinYController = TextEditingController();

  ///层 信息Controller
  TextEditingController storeyController = TextEditingController();

  ///动画控制器
  AnimationController inputAnimatController;

  Animation inputAnimation;

  ///抖动动画执行次数
  int inputAnimatNumber = 0;
  Future applyPermission() async {
    if (await Permission.camera.request().isGranted) {
      // 干你该干的事
      scan(codeController, '物资编号');
    }
  }

  scan(TextEditingController textEditingController, String name) async {
    // var options = ScanOptions(
    //     strings: {"cancel": "关闭", "flash_on": "打开闪光灯", "flash_off": "关闭闪光灯"});

    // ScanResult result = await BarcodeScanner.scan(options: options);
    // print(result.rawContent);
    // if (barcode != '123456789') {
    //   setState(() {
    //     validate = false;
    //     errorMess = '物资编号不一致！';
    //     inputAnimatController.forward();
    //   });
    // } else {
    //   setState(() {
    //     enableButton = true;
    //   });
    // }
  }

  @override
  void initState() {
    super.initState();

    inputAnimatController = AnimationController(
        duration: const Duration(milliseconds: 100), vsync: this);
    inputAnimation =
        new Tween(begin: 0.0, end: 10.0).animate(inputAnimatController);

    ///添加监听
    inputAnimatController.addListener(() {
      double value = inputAnimatController.value;
      print('变化比率：-----------------$value');
      setState(() {});
    });

    ///动画执行状态监听
    inputAnimatController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        print('正向执行完毕，调用forward方法动画执行完毕的回调');
        inputAnimatNumber++;

        ///反向执行动画
        inputAnimatController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        print('反向执行完毕，调用reverse方法动画执行完毕的回调');

        ///重置动画
        inputAnimatController.reset();

        ///记录动画执行次数
        ///执行2此可达到左右抖动的视觉效果
        if (inputAnimatNumber < 3) {
          //正向执行动画
          inputAnimatController.forward();
        } else {
          inputAnimatNumber = 0;
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
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
          '入库',
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
            Transform.translate(
              offset: Offset(inputAnimation.value, 0),
              child: TextField(
                controller: codeController,
                enableInteractiveSelection: false,
                onTap: () {
                  FocusScope.of(context).requestFocus(new FocusNode());
                },
                decoration: InputDecoration(
                  labelText: '物资编号',
                  border: InputBorder.none,
                  errorText: validate ? null : '$errorMess',
                  suffixIcon: IconButton(
                    icon: Icon(CupertinoIcons.qrcode_viewfinder),
                    onPressed: () {
                      //scan(codeController, '物资编号');
                      applyPermission();
                    },
                  ),
                ),
              ),
            ),
            TextField(
              //key: _newContentKey,
              controller: typeController,
              enableInteractiveSelection: false,
              onTap: () {
                FocusScope.of(context).requestFocus(new FocusNode());
              },
              decoration: InputDecoration(
                labelText: '物资类型',
                border: InputBorder.none,
              ),
            ),
            TextField(
              //key: _newContentKey,
              controller: storageBinController,
              enableInteractiveSelection: false,
              onTap: () {
                FocusScope.of(context).requestFocus(new FocusNode());
              },
              decoration: InputDecoration(
                labelText: '库位编号',
                border: InputBorder.none,
              ),
            ),
            // Row(
            //   children: [
            //     Expanded(
            //       child: TextField(
            //         //key: _newContentKey,
            //         controller: storageBinController,
            //         enableInteractiveSelection: false,
            //         onTap: () {
            //           FocusScope.of(context).requestFocus(new FocusNode());
            //         },
            //         decoration: InputDecoration(
            //           labelText: '库位编号',
            //           border: InputBorder.none,
            //         ),
            //       ),
            //     ),
            //     Checkbox(
            //         value: checkValue,
            //         onChanged: (val) {
            //           debugPrint('点击确认了222');
            //           setState(() {
            //             checkValue = val;
            //           });
            //         })
            //   ],
            // ),
            TextField(
              //key: _newContentKey,
              controller: storageBinXController,
              enableInteractiveSelection: false,
              onTap: () {
                FocusScope.of(context).requestFocus(new FocusNode());
              },
              decoration: InputDecoration(
                labelText: '库位X',
                border: InputBorder.none,
              ),
            ),
            TextField(
              //key: _newContentKey,
              controller: storageBinYController,
              enableInteractiveSelection: false,
              onTap: () {
                FocusScope.of(context).requestFocus(new FocusNode());
              },
              decoration: InputDecoration(
                labelText: '库位Y',
                border: InputBorder.none,
              ),
            ),
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
            Divider(
              height: 10.0,
            ),
            FlatButton(
              child: Text("提交"),
              onPressed: () async {
                log('入库');
                Navigator.pop(context, 'true');
              },
              disabledColor: enableButton ? null : Colors.black12,
              disabledTextColor: enableButton ? null : Colors.blueGrey,
              color: enableButton ? Colors.green : null,
              textColor: enableButton ? Colors.white : null,
            ),
          ],
        ),
      ),
    );
  }
}
