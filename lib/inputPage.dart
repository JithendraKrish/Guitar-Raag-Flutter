import 'dart:convert';

import 'dart:io';
import 'dart:async';
// import 'package:advanced_search/advanced_search.dart';
import 'package:advanced_search/advanced_search.dart';
import 'package:clg_project_gtr_raag/RaagDict.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:clg_project_gtr_raag/HomePage.dart';

import 'package:clg_project_gtr_raag/Chords.dart';

import 'package:flutter/material.dart';
// import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

void main() { runApp(InputBox()); }



bool tutorialInputVble = false;
void tutorialInputState(a){
  if (a){
    tutorialInputVble = a;
  }

}


class InputBox extends StatelessWidget {

  @override
  // Color overallBG = Color.fromRGBO(170, 192, 170, 1);
  // Color titleTxt = Colors.black;
  // Color backArrow = Color.fromRGBO(220, 238, 209, 1);
  Color overallBG = Color.fromRGBO(240, 240, 240, 1);
  Color titleTxt = Color.fromRGBO(11, 111, 244, 1);
  Color backArrow = Color.fromRGBO(48, 48, 48, 1);
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: overallBG,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back,color: backArrow,),
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> InputBox()));
              //Navigator.push(context,MaterialPageRoute(builder: (_) => const HomeApp()));
            },
          ),
          title: Text('Select the Swaras',style: TextStyle(color: titleTxt,fontSize: 26,fontFamily: 'NotoSansMid'),),
          backgroundColor:  overallBG,
        ),
        body: CheckboxGroup(),
      ),
    );
  }
}

List TotalList = [];



var western_swaras = {0:'A',1:'A#',2:'B',3:'C',
  4:'C#',5:'D',6:'D#',7:'E',8:'F',
  9:'F#',10:'G',11:'G#',12:'A^'};

class CheckboxGroup extends StatefulWidget {
  @override
  _CheckboxGroupState createState() => _CheckboxGroupState();
}

class _CheckboxGroupState extends State<CheckboxGroup> {

  // THESE are to be given inside the widget
  GlobalKey _SwarasInputSwaras = GlobalKey();
  GlobalKey _SwarasInputSearch = GlobalKey();
  GlobalKey _SwarasInputButton = GlobalKey();


  List <bool> _checkboxValues = [true, false, true, false, false, true, false, true, false, true, true, false, false, false, false, true, true];
  bool state = true;

  Future<void> writeToFile(List content) async {
    final filepath = '${(await getApplicationDocumentsDirectory()).path}/Scales.txt';
    final file = File(filepath);
    bool value = false;
    if (!await file.exists()) {await file.writeAsString('$content'+'\n');}
    else {
      List fileContent = file.readAsLinesSync(encoding: utf8);
      for(int i = 0; i<fileContent.length;i++){
        String a = '$content';
        // var h = utf8.decode(utf8.encode(fileContent[i]));
        // print(h.runtimeType);
        //
        // print(fileContent[i]+'File');
        // print(fileContent[i].runtimeType);
        // print(a);
        // print(a.runtimeType);
        if(fileContent[i] == a){value =( a == fileContent[i]);}
      }
      if(!value){await file.writeAsString('$content'+'\n', mode: FileMode.append);}
      else{print('Already There');}
    }
  }
  void myFileWriter(List a) async {await writeToFile(a);}

  var carnatic_swaras = {0:'S',1:'R1',2:'R2',3:'R3',
    4:'G1',5:'G2',6:'G3',7:'M1',8:'M2',
    9:'P',10:'D1',11:'D2',12:'D3',13:'N1',
    14:'N2',15:'N3',16:'S^'};
//Fumction1

  void setCarnatic(List a){
    String state2 = ' ';
    String state3 = ' ';
    String state9 = ' ';
    String state10 = ' ';
    if(a[2] == true){state2 = 'R2';}
    if(a[4] == true){state2 = 'G1';}
    if(a[3] == true){state3 = 'R3';}
    if(a[5] == true){state3 = 'G2';}
    if(a[11] == true){state9 = 'D2';}
    if(a[13] == true){state9 = 'N1';}
    if(a[12] == true){state10 = 'D3';}
    if(a[14] == true){state10 = 'N2';}

    if(state2==' '){state2 = 'R2';}
    if(state3==' '){state3 = 'G2';}
    if(state9==' '){state9 = 'D2';}
    if(state10==' '){state10 = 'N2';}




    var swar = {0:'S', 1:'R1', 2:state2, 3:state3, 4:'G3',
      5:'M1',6:'M2', 7:'P', 8:'D1',9:state9, 10:state10, 11:'N3',12:'S^'};
    setState(() {carnatic_swaras = swar; });
      }

  List<bool> nomenCletureList(List a){
    List <bool> returner = [a[0], a[1], false, false, a[6], a[7], a[8], a[9], a[10], false, false, a[15], a[16]];

    if(a[2] == true||a[4] == true){returner[2] = true;}
    if(a[3] == true||a[5] == true){returner[3] = true;}

    if(a[11] == true||a[13] == true){returner[9] = true;}
    if(a[12] == true||a[14] == true){returner[10] = true;}

    return returner;
  }

  Map inputToNotes(l,swaras){
    List a = [];
    List b = [];
    setCarnatic(l);
    if (l.runtimeType == List<bool>){
      List n12 = nomenCletureList(l);
      for(int i = 0;i<13;i++) {
        if (n12[i] == true) {
          a.add(i);
          b.add(swaras[i]);
        }//if
      }//for
    }
    else {
      for (int i = 0; i < l.length; i++) {
        a.add(l[i]);
        b.add(swaras[l[i]]);
      }
    }
     print('\n\nSWAR DICT');
     print(carnatic_swaras);
     print({'notes':a,'scale':b});
    return {'notes':a,'scale':b};
  }//Function end


  //Future<void> loadFiles() async {final appSupport = await getApplicationSupportDirectory(); final appDocuments = await getApplicationDocumentsDirectory();}


  @override
  Widget build(BuildContext context) {
//some Colors are above this area, mainly OverallBG
//     Color txtY = Colors.white;
//     Color txtW = CupertinoColors.systemYellow;
//     const TextStyle S_P_SText = TextStyle(fontFamily: 'NotoSansRegular',fontSize: 28,fontWeight: FontWeight.bold);
//     final S_P_STiles = ElevatedButton.styleFrom(
//       backgroundColor: Color.fromRGBO(115, 99, 114, 1),
//       foregroundColor: Color.fromRGBO(220, 238, 209, 1),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0),),
//       alignment: Alignment.center,
//       fixedSize: Size(120, 50),  );
//
//     Color ButtonBackON=Color.fromRGBO(115, 99, 114, 1);
//     Color ButtonBackOFF=Color.fromRGBO(122, 145, 141, 1);
//     Color ButtonForeON=Color.fromRGBO(220, 238, 209, 1);
//     Color ButtonForeOFF= Colors.white;//Color.fromRGBO(122, 145, 141, 1)
//     final BtnTxtON = TextStyle(fontSize: 20,fontWeight: FontWeight.bold);
//     final BtnTxtOFF = TextStyle(fontSize: 18,fontStyle: FontStyle.italic);
//
//     Border ButtonBorder = Border.all( width: 2, color: Color.fromRGBO(220, 238, 209, 1), );
//
//     ButtonStyle finalButtons = ElevatedButton.styleFrom(
//         textStyle: const TextStyle(
//           fontSize: 20,fontWeight: FontWeight.bold,
//           fontFamily:'NotoSansRegular',color: Colors.white,),
//         padding: EdgeInsets.all(15),
//         foregroundColor: Color.fromRGBO(220, 238, 209, 1),
//         backgroundColor: Color.fromRGBO(161, 130, 118, 1));
//
//     final AlertModalBG = Colors.amber[200];
//     final AlertModalCheckWord = Colors.red;
//     final AlertModalOtherColors = Colors.black;
//
//     final ConfirmModalBG = Color.fromRGBO(220, 238, 209, 1);
//     final ConfirmModalMainWords = Colors.black;
//     final ConfirmModalOtherColors = Color.fromRGBO(115, 99, 114, 1);
//     final ConfirmModalLineColor = Color.fromRGBO(161, 130, 118, 1);
//     final ConfirmModalBTN = ElevatedButton.styleFrom(
//       backgroundColor: Color.fromRGBO(122, 145, 141, 1),
//       foregroundColor: Color.fromRGBO(220, 238, 209, 1),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0),),
//       alignment: Alignment.center,
//       fixedSize: Size(220, 50),  );


    Color txtY = Colors.white;
    Color txtW = CupertinoColors.systemYellow;
    const TextStyle S_P_SText = TextStyle(fontFamily: 'NotoSansRegular',fontSize: 28,fontWeight: FontWeight.bold);
    var S_P_STiles = ElevatedButton.styleFrom(
      foregroundColor: Color.fromRGBO(0, 0, 0, 1),
      backgroundColor: Color.fromRGBO(255, 255, 255, 1),
      shape: RoundedRectangleBorder(
        side: BorderSide(width: 2, color: Colors.black),


        borderRadius: BorderRadius.circular(6.0),),
      alignment: Alignment.center,
      //fixedSize: Size(87, 53),
    );
    Color ButtonBackON=Color.fromRGBO(255, 255, 255, 1);
    Color ButtonBackOFF=Color.fromRGBO(230,230,230, 1);
    Color ButtonForeON=Color.fromRGBO(11, 111, 244, 1);
    Color ButtonForeOFF= Colors.black;//Color.fromRGBO(122, 145, 141, 1)
    var BtnTxtON = TextStyle(fontSize: 20,fontWeight: FontWeight.bold,fontFamily: 'NotoSansRegular');
    var BtnTxtOFF = TextStyle(fontSize: 18,fontStyle: FontStyle.italic,fontFamily: 'NotoSansRegular');

    Border ButtonBorder = Border.all( width: 0.1, color: Color.fromRGBO(0, 0, 0, 1), );

    var S_P_STilesDeco =BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.2),
          spreadRadius: 6,
          blurRadius: 8,
          offset: Offset(0, 8), // changes position of shadow
        ),
      ],
      border: ButtonBorder,borderRadius: BorderRadius.circular(8.0),
      color: Colors.black,);

    ButtonStyle finalButtons = ElevatedButton.styleFrom(
        textStyle: const TextStyle(
          fontSize: 20,fontWeight: FontWeight.bold,
          fontFamily:'NotoSansRegular',color: Colors.white,),
        padding: EdgeInsets.all(15),
        backgroundColor: Color.fromRGBO(11, 111, 244, 1).withOpacity(0.8),
        foregroundColor: Color.fromRGBO(244, 244, 244, 1)

    );

    Color shadowClrOn = Colors.grey.withOpacity(0.7);
    var shadowClrOff = null;
    double EleLvlOn = 25;
    var EleLvlOff = null;


    final AlertModalBG = Colors.amber[200];
    final AlertModalCheckWord = Colors.red;
    final AlertModalOtherColors = Colors.black;

    final ConfirmModalBG = Color.fromRGBO(240, 240, 240, 1);
    final ConfirmModalMainWords = Colors.black;
    final ConfirmModalOtherColors = Color.fromRGBO(111, 111, 111, 1);
    final ConfirmModalLineColor = Color.fromRGBO(78, 78, 78, 1);
    final ConfirmModalBTN = ElevatedButton.styleFrom(
      backgroundColor: Color.fromRGBO(11, 111, 244, 1),
      foregroundColor: Color.fromRGBO(255, 255, 255, 1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0),),
      alignment: Alignment.center,
      fixedSize: Size(220, 50),  );


    // if (tutorialInputVble){
    //   _createTutorial_InputScreen();}


    List <String >RaagaList = RaagaLib.keys.cast<String>().toList();



    return WillPopScope(
      onWillPop:  () async {
        if(_checkboxValues[1]==false&&_checkboxValues[2]==false&&_checkboxValues[3]==false||_checkboxValues[4]==false&&_checkboxValues[5]==false&&_checkboxValues[6]==false
            ||_checkboxValues[7]==false&&_checkboxValues[8]==false
            ||_checkboxValues[10]==false&&_checkboxValues[11]==false&&_checkboxValues[12]==false||_checkboxValues[13]==false&&_checkboxValues[14]==false&&_checkboxValues[15]==false)
        { Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> InputBox()));
          return true;        }
        else{
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> InputBox()));
          return true;}




         // Prevent back navigation
      },
      child: ListView(

          children: [


            Container(
              key: _SwarasInputSearch,
              decoration: BoxDecoration(border: Border.all( width: 0.5, color: Color.fromRGBO(0, 0, 0, 1), ),borderRadius: BorderRadius.circular(10.0),color: Colors.grey.shade300),
              margin: EdgeInsets.symmetric(vertical: 10.0,horizontal: 20),
              padding: EdgeInsets.only(left: 0,top: 0,bottom: 0,right: 0),
              child: AdvancedSearch(
                searchItems: RaagaList,
                maxElementsToDisplay: 3,
                singleItemHeight: 40,
                borderColor: Colors.black,
                hintText: 'Search using Raagams Names',
                hintTextColor: Colors.black.withOpacity(0.5),
                cursorColor: Colors.black,
                focusedBorderColor: Colors.black,
                verticalPadding: 5,
                unSelectedTextColor: Colors.black.withOpacity(0.4),
                selectedTextColor: Color.fromRGBO(11,111,244, 1),
                inputTextFieldBgColor: Color.fromRGBO(210, 210, 210, 1),
                searchResultsBgColor: Color.fromRGBO(210, 210, 210, 1),
                onItemTap: (int index, String value) {
                  _checkboxValues = RaagaLib[RaagaList[index]];
                 setState(() {swaraInput = _checkboxValues;});
                  inputMap = inputToNotes(_checkboxValues, western_swaras);

                  List doopKey = RaagaLib.keys.toList();
                  List doopVal = RaagaLib.values.toList();
                  String SelectedRaagaName = '';

                  for(int i = 0;i<doopKey.length;i++){
                    if(doopVal[i].toString()==_checkboxValues.toString()){
                      SelectedRaagaName = doopKey[i];
                    }
                  }
                  setState(() {RaagamName = SelectedRaagaName;});
                  // myFileWriter(inputMap['notes']);
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (inputMap) => const FamilyChds()));
                },
              ),
            ),
            Container(
              margin: EdgeInsets.only(top:0,bottom: 10),
              padding: EdgeInsets.symmetric(horizontal: 50),
              alignment: Alignment.center,
              child:
              Text('NOTE: If a raaga is not shown in search results please try other Spellings for the Raaga Use SankaraBharanam, instead of S\'h\'ankaraBharanam',
                style: TextStyle(fontSize: 9),),
            ),

            Divider(height: 15,
              thickness: 1.0,
              indent: 20,
              endIndent: 20,
              color: Colors.grey.shade400,),



            Container(
              // decoration: S_P_STilesDeco,
              width: 60,
              height: 50,
              padding: EdgeInsets.all(1),
              alignment: Alignment.center,
              child: ElevatedButton(

                style:S_P_STiles,
                child: const Text('S',style:S_P_SText,),
                onPressed: () {setState(() {
                  bool value =_checkboxValues[0];
                  _checkboxValues[0] = true;});},
              ),
            ),

            Container(margin: EdgeInsets.all(8.0),),
            Container(
              margin: EdgeInsets.all(5.0),
              child:
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(child:Container(
                    key: _SwarasInputSwaras,
                    decoration: BoxDecoration(border: ButtonBorder,borderRadius: BorderRadius.circular(30.0),),
                    //margin: EdgeInsets.symmetric(horizontal: 140.0),
                    padding: _checkboxValues[1]?EdgeInsets.all(2):EdgeInsets.all(8),
                    width: 100,
                    height: 50,
                    //alignment: Alignment.center,
                    child: ElevatedButton(
                      style: ButtonStyle(

                        //fixedSize: MaterialStateProperty.all(Size(90,50)), // Set the size of the button
                        backgroundColor: _checkboxValues[1]? MaterialStateProperty.all<Color>(ButtonBackON): MaterialStateProperty.all<Color>(ButtonBackOFF),
                        foregroundColor: _checkboxValues[1]? MaterialStateProperty.all<Color>(ButtonForeON): MaterialStateProperty.all<Color>(ButtonForeOFF),
                        textStyle: _checkboxValues[1]? MaterialStateProperty.all(BtnTxtON):MaterialStateProperty.all(BtnTxtOFF), // Set the text style of the button
                        shadowColor: _checkboxValues[1]? MaterialStateProperty.all(shadowClrOn):MaterialStateProperty.all(shadowClrOff),
                        elevation: _checkboxValues[1]? MaterialStateProperty.all(EleLvlOn):MaterialStateProperty.all(EleLvlOff),

                      ), child: const Text('R1'),
                      onPressed: () {setState(() {
                        bool value =_checkboxValues[1];
                        _checkboxValues[1] = !value;
                        _checkboxValues[2] = false;
                        _checkboxValues[3] = false;

                      });},
                    ),
                  ),
                  ),
                  Flexible(child:Container(
                    decoration: BoxDecoration(border: ButtonBorder,borderRadius: BorderRadius.circular(30.0),),
                    //margin: EdgeInsets.symmetric(horizontal: 140.0),
                    padding: _checkboxValues[2]?EdgeInsets.all(2):EdgeInsets.all(8),
                    width: 100,
                    height: 50,
                    //alignment: Alignment.center,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        //fixedSize: MaterialStateProperty.all(Size(90, 50)), // Set the size of the button
                        backgroundColor: _checkboxValues[2]? MaterialStateProperty.all<Color>(ButtonBackON): MaterialStateProperty.all<Color>(ButtonBackOFF),
                        foregroundColor: _checkboxValues[2]? MaterialStateProperty.all<Color>(ButtonForeON): MaterialStateProperty.all<Color>(ButtonForeOFF),
                        textStyle: _checkboxValues[2]? MaterialStateProperty.all(BtnTxtON):MaterialStateProperty.all(BtnTxtOFF), // Set the text style of the button
                        shadowColor: _checkboxValues[2]? MaterialStateProperty.all(shadowClrOn):MaterialStateProperty.all(shadowClrOff),
                        elevation: _checkboxValues[2]? MaterialStateProperty.all(EleLvlOn):MaterialStateProperty.all(EleLvlOff),
                      ),

                      child: const Text('R2'),
                      onPressed: () {setState(() {
                        _checkboxValues[1] = false;
                        bool value =_checkboxValues[2];
                        _checkboxValues[2] = !value;
                        _checkboxValues[3] = false;
                        _checkboxValues[4] = false;
                        _checkboxValues[6] = false;
                        _checkboxValues[5] = !value;

                      });},
                    ),
                  ),
                  ),
                  Flexible(child:Container(

                    decoration: BoxDecoration(border: ButtonBorder ,borderRadius: BorderRadius.circular(30.0),),
                    //margin: EdgeInsets.symmetric(horizontal: 140.0),
                    padding: _checkboxValues[3]?EdgeInsets.all(2):EdgeInsets.all(8),
                    width: 100,
                    height: 50,
                    //alignment: Alignment.center,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        //fixedSize: MaterialStateProperty.all(Size(90, 50)), // Set the size of the button
                        backgroundColor: _checkboxValues[3]? MaterialStateProperty.all<Color>(ButtonBackON): MaterialStateProperty.all<Color>(ButtonBackOFF),
                        foregroundColor: _checkboxValues[3]? MaterialStateProperty.all<Color>(ButtonForeON): MaterialStateProperty.all<Color>(ButtonForeOFF),
                        textStyle: _checkboxValues[3]? MaterialStateProperty.all(BtnTxtON):MaterialStateProperty.all(BtnTxtOFF), // Set the text style of the button
                        shadowColor: _checkboxValues[3]? MaterialStateProperty.all(shadowClrOn):MaterialStateProperty.all(shadowClrOff),
                        elevation: _checkboxValues[3]? MaterialStateProperty.all(EleLvlOn):MaterialStateProperty.all(EleLvlOff),

                      ),
                      child: const Text('R3'),
                      onPressed: () {setState(() {
                        _checkboxValues[1] = false;
                        _checkboxValues[2] = false;
                        bool value =_checkboxValues[3];
                        _checkboxValues[3] = !value;
                        _checkboxValues[4] = false;
                        _checkboxValues[5] = false;
                        _checkboxValues[6] = !value;
                      });},
                    ),
                  ),
                  ),
                ],),
            ),

            Container(margin: EdgeInsets.all(2.0),),
            Container(
              margin: EdgeInsets.all(5.0),
              child:
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(child:Container(
                    decoration: BoxDecoration(border:ButtonBorder,borderRadius: BorderRadius.circular(30.0),),
                    //margin: EdgeInsets.symmetric(horizontal: 140.0),
                    padding: _checkboxValues[4]?EdgeInsets.all(2):EdgeInsets.all(8),
                    width: 100,
                    height: 60,
                    //alignment: Alignment.center,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        //fixedSize: MaterialStateProperty.all(Size(90, 50)), // Set the size of the button
                        backgroundColor: _checkboxValues[4]? MaterialStateProperty.all<Color>(ButtonBackON): MaterialStateProperty.all<Color>(ButtonBackOFF),
                        foregroundColor: _checkboxValues[4]? MaterialStateProperty.all<Color>(ButtonForeON): MaterialStateProperty.all<Color>(ButtonForeOFF),
                        textStyle: _checkboxValues[4]? MaterialStateProperty.all(BtnTxtON):MaterialStateProperty.all(BtnTxtOFF),// Set the text style of the button
                        shadowColor: _checkboxValues[4]? MaterialStateProperty.all(shadowClrOn):MaterialStateProperty.all(shadowClrOff),
                        elevation: _checkboxValues[4]? MaterialStateProperty.all(EleLvlOn):MaterialStateProperty.all(EleLvlOff),

                      ),
                      child: const Text('G1'),
                      onPressed: () {setState(() {
                        bool value =_checkboxValues[4];
                        _checkboxValues[4] = !value;
                        _checkboxValues[5] = false;
                        _checkboxValues[6] = false;
                        _checkboxValues[2] = false;
                        _checkboxValues[3] = false;
                        _checkboxValues[1] = true;

                      });},
                    ),
                  ),
                  ),
                  Flexible(child:Container(
                    decoration: BoxDecoration(border: ButtonBorder,borderRadius: BorderRadius.circular(30.0),),
                    //margin: EdgeInsets.symmetric(horizontal: 140.0),
                    padding: _checkboxValues[5]?EdgeInsets.all(2):EdgeInsets.all(8),
                    width: 100,
                    height: 50,
                    //alignment: Alignment.center,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        //fixedSize: MaterialStateProperty.all(Size(90, 50)), // Set the size of the button
                        backgroundColor: _checkboxValues[5]? MaterialStateProperty.all<Color>(ButtonBackON): MaterialStateProperty.all<Color>(ButtonBackOFF),
                        foregroundColor: _checkboxValues[5]? MaterialStateProperty.all<Color>(ButtonForeON): MaterialStateProperty.all<Color>(ButtonForeOFF),
                        textStyle: _checkboxValues[5]? MaterialStateProperty.all(BtnTxtON):MaterialStateProperty.all(BtnTxtOFF),// Set the text style of the button
                        shadowColor: _checkboxValues[5]? MaterialStateProperty.all(shadowClrOn):MaterialStateProperty.all(shadowClrOff),
                        elevation: _checkboxValues[5]? MaterialStateProperty.all(EleLvlOn):MaterialStateProperty.all(EleLvlOff),

                      ),
                      child: const Text('G2'),
                      onPressed: () {setState(() {
                        _checkboxValues[4] = false;
                        bool value =_checkboxValues[5];
                        _checkboxValues[5] = !value;
                        _checkboxValues[6] = false;
                        _checkboxValues[3] = false;
                        _checkboxValues[2] = false;

                      });},
                    ),
                  ),
                  ),
                  Flexible(child:Container(
                    decoration: BoxDecoration(border: ButtonBorder,borderRadius: BorderRadius.circular(30.0),),
                    //margin: EdgeInsets.symmetric(horizontal: 140.0),
                    padding: _checkboxValues[6]?EdgeInsets.all(2):EdgeInsets.all(8),
                    width: 100,
                    height: 50,
                    //alignment: Alignment.center,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        //fixedSize: MaterialStateProperty.all(Size(90, 50)), // Set the size of the button
                        backgroundColor: _checkboxValues[6]? MaterialStateProperty.all<Color>(ButtonBackON): MaterialStateProperty.all<Color>(ButtonBackOFF),
                        foregroundColor: _checkboxValues[6]? MaterialStateProperty.all<Color>(ButtonForeON): MaterialStateProperty.all<Color>(ButtonForeOFF),
                        textStyle: _checkboxValues[6]? MaterialStateProperty.all(BtnTxtON):MaterialStateProperty.all(BtnTxtOFF),// Set the text style of the button // Set the text style of the button
                        shadowColor: _checkboxValues[6]? MaterialStateProperty.all(shadowClrOn):MaterialStateProperty.all(shadowClrOff),
                        elevation: _checkboxValues[6]? MaterialStateProperty.all(EleLvlOn):MaterialStateProperty.all(EleLvlOff),

                      ),
                      child: const Text('G3'),
                      onPressed: () {setState(() {
                        _checkboxValues[4] = false;
                        _checkboxValues[5] = false;
                        bool value =_checkboxValues[6];
                        _checkboxValues[6] = !value;

                      });},
                    ),
                  ),
                  ),

                ],),
            ),

            Container(margin: EdgeInsets.all(2.0),),
            Container(
              margin: EdgeInsets.symmetric(vertical:4.0),
              child:
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(child:Container(
                    decoration: BoxDecoration(border: ButtonBorder,borderRadius: BorderRadius.circular(30.0),),
                    //margin: EdgeInsets.symmetric(horizontal: 140.0),
                    padding: _checkboxValues[7]?EdgeInsets.all(2):EdgeInsets.all(8),
                    width: 100,
                    height: 60,
                    //alignment: Alignment.center,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        //fixedSize: MaterialStateProperty.all(Size(90, 50)), // Set the size of the button
                        backgroundColor: _checkboxValues[7]? MaterialStateProperty.all<Color>(ButtonBackON): MaterialStateProperty.all<Color>(ButtonBackOFF),
                        foregroundColor: _checkboxValues[7]? MaterialStateProperty.all<Color>(ButtonForeON): MaterialStateProperty.all<Color>(ButtonForeOFF),
                        textStyle: _checkboxValues[7]? MaterialStateProperty.all(BtnTxtON):MaterialStateProperty.all(BtnTxtOFF),// Set the text style of the button
                        shadowColor: _checkboxValues[7]? MaterialStateProperty.all(shadowClrOn):MaterialStateProperty.all(shadowClrOff),
                        elevation: _checkboxValues[7]? MaterialStateProperty.all(EleLvlOn):MaterialStateProperty.all(EleLvlOff),

                      ),
                      child: const Text('M1'),
                      onPressed: () {setState(() {
                        bool value =_checkboxValues[7];
                        _checkboxValues[7] = !value;
                        _checkboxValues[8] = false;

                      });},
                    ),
                  ),
                  ),
                  Flexible(child:Container(
                    decoration: BoxDecoration(border: ButtonBorder,borderRadius: BorderRadius.circular(30.0),),
                    //margin: EdgeInsets.symmetric(horizontal: 140.0),
                    padding: _checkboxValues[8]?EdgeInsets.all(2):EdgeInsets.all(8),
                    width: 100,
                    height: 60,
                    //alignment: Alignment.center,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        // fixedSize: MaterialStateProperty.all(Size(90, 50)), // Set the size of the button
                        backgroundColor: _checkboxValues[8]? MaterialStateProperty.all<Color>(ButtonBackON): MaterialStateProperty.all<Color>(ButtonBackOFF),
                        foregroundColor: _checkboxValues[8]? MaterialStateProperty.all<Color>(ButtonForeON): MaterialStateProperty.all<Color>(ButtonForeOFF),
                        textStyle: _checkboxValues[8]? MaterialStateProperty.all(BtnTxtON):MaterialStateProperty.all(BtnTxtOFF),// Set the text style of the button
                        shadowColor: _checkboxValues[8]? MaterialStateProperty.all(shadowClrOn):MaterialStateProperty.all(shadowClrOff),
                        elevation: _checkboxValues[8]? MaterialStateProperty.all(EleLvlOn):MaterialStateProperty.all(EleLvlOff),


                      ),
                      child: const Text('M2'),
                      onPressed: () {setState(() {
                        _checkboxValues[7] = false;
                        bool value =_checkboxValues[8];
                        _checkboxValues[8] = !value;
                      });},
                    ),
                  ),
                  ),


                ],),
            ),

            Container(margin: EdgeInsets.all(5.0),),
            Container(
              width: 60,
              // margin: EdgeInsets.symmetric(horizontal: 100.0),
              height: 50,
              padding: EdgeInsets.all(1),
              alignment: Alignment.center,
              child: ElevatedButton(
                style: S_P_STiles,
                child: const Text('P',style: S_P_SText,),
                onPressed: () {setState(() {
                  bool value =_checkboxValues[9];
                  _checkboxValues[9] = true;});},
              ),
            ),

            Container(margin: EdgeInsets.all(5.0),),
            Container(
              margin: EdgeInsets.all(5.0),
              child:
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(child:Container(
                    decoration: BoxDecoration(border: ButtonBorder,borderRadius: BorderRadius.circular(30.0),),
                    //margin: EdgeInsets.symmetric(horizontal: 140.0),
                    padding: _checkboxValues[10]?EdgeInsets.all(2):EdgeInsets.all(8),
                    width: 100,
                    height: 50,
                    //alignment: Alignment.center,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        //fixedSize: MaterialStateProperty.all(Size(90, 50)), // Set the size of the button
                        backgroundColor: _checkboxValues[10]? MaterialStateProperty.all<Color>(ButtonBackON): MaterialStateProperty.all<Color>(ButtonBackOFF),
                        foregroundColor: _checkboxValues[10]? MaterialStateProperty.all<Color>(ButtonForeON): MaterialStateProperty.all<Color>(ButtonForeOFF),
                        textStyle: _checkboxValues[10]? MaterialStateProperty.all(BtnTxtON):MaterialStateProperty.all(BtnTxtOFF),// Set the text style of the button
                        shadowColor: _checkboxValues[10]? MaterialStateProperty.all(shadowClrOn):MaterialStateProperty.all(shadowClrOff),
                        elevation: _checkboxValues[10]? MaterialStateProperty.all(EleLvlOn):MaterialStateProperty.all(EleLvlOff),

                      ),
                      child: const Text('D1'),
                      onPressed: () {setState(() {
                        bool value =_checkboxValues[10];
                        _checkboxValues[10] = !value;
                        _checkboxValues[11] = false;
                        _checkboxValues[12] = false;

                      });},
                    ),
                  ),
                  ),
                  Flexible(child:Container(
                    decoration: BoxDecoration(border: ButtonBorder,borderRadius: BorderRadius.circular(30.0),),
                    //margin: EdgeInsets.symmetric(horizontal: 140.0),
                    padding: _checkboxValues[11]?EdgeInsets.all(2):EdgeInsets.all(8),
                    width: 100,
                    height: 50,
                    //alignment: Alignment.center,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        //fixedSize: MaterialStateProperty.all(Size(90, 50)), // Set the size of the button
                        backgroundColor: _checkboxValues[11]? MaterialStateProperty.all<Color>(ButtonBackON): MaterialStateProperty.all<Color>(ButtonBackOFF),
                        foregroundColor: _checkboxValues[11]? MaterialStateProperty.all<Color>(ButtonForeON): MaterialStateProperty.all<Color>(ButtonForeOFF),
                        textStyle: _checkboxValues[11]? MaterialStateProperty.all(BtnTxtON):MaterialStateProperty.all(BtnTxtOFF),// Set the text style of the button
                        shadowColor: _checkboxValues[11]? MaterialStateProperty.all(shadowClrOn):MaterialStateProperty.all(shadowClrOff),
                        elevation: _checkboxValues[11]? MaterialStateProperty.all(EleLvlOn):MaterialStateProperty.all(EleLvlOff),

                      ),
                      child: const Text('D2',),
                      onPressed: () {setState(() {
                        _checkboxValues[10] = false;
                        bool value =_checkboxValues[11];
                        _checkboxValues[11] = !value;
                        _checkboxValues[12] = false;
                        _checkboxValues[13] = false;
                        _checkboxValues[14] = !value;
                        _checkboxValues[15] = false;

                      });},
                    ),
                  ),
                  ),
                  Flexible(child:Container(
                    decoration: BoxDecoration(border: ButtonBorder,borderRadius: BorderRadius.circular(30.0),),
                    //margin: EdgeInsets.symmetric(horizontal: 140.0),
                    padding: _checkboxValues[12]?EdgeInsets.all(2):EdgeInsets.all(8),
                    width: 100,
                    height: 50,
                    //alignment: Alignment.center,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        //fixedSize: MaterialStateProperty.all(Size(90, 50)), // Set the size of the button
                        backgroundColor: _checkboxValues[12]? MaterialStateProperty.all<Color>(ButtonBackON): MaterialStateProperty.all<Color>(ButtonBackOFF),
                        foregroundColor: _checkboxValues[12]? MaterialStateProperty.all<Color>(ButtonForeON): MaterialStateProperty.all<Color>(ButtonForeOFF),
                        textStyle: _checkboxValues[12]? MaterialStateProperty.all(BtnTxtON):MaterialStateProperty.all(BtnTxtOFF),// Set the text style of the button
                        shadowColor: _checkboxValues[12]? MaterialStateProperty.all(shadowClrOn):MaterialStateProperty.all(shadowClrOff),
                        elevation: _checkboxValues[12]? MaterialStateProperty.all(EleLvlOn):MaterialStateProperty.all(EleLvlOff),

                      ),
                      child: const Text('D3'),
                      onPressed: () {setState(() {
                        _checkboxValues[10] = false;
                        _checkboxValues[11] = false;
                        bool value =_checkboxValues[12];
                        _checkboxValues[12] = !value;
                        _checkboxValues[13] = false;
                        _checkboxValues[14] = false;
                        _checkboxValues[15] = !value;

                      });},
                    ),
                  ),
                  ),

                ],),
            ),

            Container(margin: EdgeInsets.all(2.0),),
            Container(              margin: EdgeInsets.all(5.0),
              child:
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(child:Container(
                    decoration: BoxDecoration(border: ButtonBorder,borderRadius: BorderRadius.circular(30.0),),
                    //margin: EdgeInsets.symmetric(horizontal: 140.0),
                    padding: _checkboxValues[13]?EdgeInsets.all(2):EdgeInsets.all(8),
                    width: 100,
                    height: 50,
                    //alignment: Alignment.center,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        //fixedSize: MaterialStateProperty.all(Size(90, 50)), // Set the size of the button
                        backgroundColor: _checkboxValues[13]? MaterialStateProperty.all<Color>(ButtonBackON): MaterialStateProperty.all<Color>(ButtonBackOFF),
                        foregroundColor: _checkboxValues[13]? MaterialStateProperty.all<Color>(ButtonForeON): MaterialStateProperty.all<Color>(ButtonForeOFF),
                        textStyle: _checkboxValues[13]? MaterialStateProperty.all(BtnTxtON):MaterialStateProperty.all(BtnTxtOFF),// Set the text style of the button
                        shadowColor: _checkboxValues[13]? MaterialStateProperty.all(shadowClrOn):MaterialStateProperty.all(shadowClrOff),
                        elevation: _checkboxValues[13]? MaterialStateProperty.all(EleLvlOn):MaterialStateProperty.all(EleLvlOff),

                      ),
                      child: const Text('N1'),
                      onPressed: () {setState(() {
                        _checkboxValues[10] = true;
                        _checkboxValues[11] = false;
                        _checkboxValues[12] = false;
                        bool value =_checkboxValues[13];
                        _checkboxValues[13] = !value;
                        _checkboxValues[14] = false;
                        _checkboxValues[15] = false;


                      });},
                    ),
                  ),
                  ),
                  Flexible(child:Container(
                    decoration: BoxDecoration(border: ButtonBorder,borderRadius: BorderRadius.circular(30.0),),
                    //margin: EdgeInsets.symmetric(horizontal: 140.0),
                    padding: _checkboxValues[14]?EdgeInsets.all(2):EdgeInsets.all(8),
                    width: 100,
                    height: 50,
                    //alignment: Alignment.center,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        //fixedSize: MaterialStateProperty.all(Size(90, 50)), // Set the size of the button
                        backgroundColor: _checkboxValues[14]? MaterialStateProperty.all<Color>(ButtonBackON): MaterialStateProperty.all<Color>(ButtonBackOFF),
                        foregroundColor: _checkboxValues[14]? MaterialStateProperty.all<Color>(ButtonForeON): MaterialStateProperty.all<Color>(ButtonForeOFF),
                        textStyle: _checkboxValues[14]? MaterialStateProperty.all(BtnTxtON):MaterialStateProperty.all(BtnTxtOFF),// Set the text style of the button
                        shadowColor: _checkboxValues[14]? MaterialStateProperty.all(shadowClrOn):MaterialStateProperty.all(shadowClrOff),
                        elevation: _checkboxValues[14]? MaterialStateProperty.all(EleLvlOn):MaterialStateProperty.all(EleLvlOff),

                      ),
                      child: const Text('N2'),
                      onPressed: () {setState(() {
                        _checkboxValues[13] = false;
                        bool value =_checkboxValues[14];
                        _checkboxValues[14] = !value;
                        _checkboxValues[15] = false;
                        _checkboxValues[11] = false;
                        _checkboxValues[12] = false;


                      });},
                    ),
                  ),
                  ),
                  Flexible(child:Container(
                    decoration: BoxDecoration(border: ButtonBorder,borderRadius: BorderRadius.circular(40.0),),
                    //margin: EdgeInsets.symmetric(horizontal: 140.0),
                    padding: _checkboxValues[15]?EdgeInsets.all(2):EdgeInsets.all(8),
                    width: 100,
                    height: 50,
                    //alignment: Alignment.center,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        //fixedSize: MaterialStateProperty.all(Size(90, 50)), // Set the size of the button
                        backgroundColor: _checkboxValues[15]? MaterialStateProperty.all<Color>(ButtonBackON): MaterialStateProperty.all<Color>(ButtonBackOFF),
                        foregroundColor: _checkboxValues[15]? MaterialStateProperty.all<Color>(ButtonForeON): MaterialStateProperty.all<Color>(ButtonForeOFF),
                        textStyle: _checkboxValues[15]? MaterialStateProperty.all(BtnTxtON):MaterialStateProperty.all(BtnTxtOFF),// Set the text style of the button
                        shadowColor: _checkboxValues[15]? MaterialStateProperty.all(shadowClrOn):MaterialStateProperty.all(shadowClrOff),
                        elevation: _checkboxValues[15]? MaterialStateProperty.all(EleLvlOn):MaterialStateProperty.all(EleLvlOff),

                      ),
                      child: const Text('N3'),
                      onPressed: () {setState(() {
                        _checkboxValues[13] = false;
                        _checkboxValues[14] = false;
                        bool value =_checkboxValues[15];
                        _checkboxValues[15] = !value;

                      });},
                    ),
                  ),
                  ),

                ],),
            ),

            Container(margin: EdgeInsets.all(5.0),),
            Container(
              width: 60,
              // margin: EdgeInsets.symmetric(horizontal: 100.0),
              height: 50,
              padding: EdgeInsets.all(1),
              alignment: Alignment.center,
              child: ElevatedButton(
                style: S_P_STiles,
                child: const Text('S^',style: S_P_SText,),
                onPressed: () {setState(() {
                  bool value =_checkboxValues[16];
                  _checkboxValues[16] = true;});},
              ),
            ),

            Container(margin: EdgeInsets.all(10.0),),

            Row(
            key: _SwarasInputButton,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  decoration: BoxDecoration(border: Border.all( width: 1, color: CupertinoColors.white, ),borderRadius: BorderRadius.circular(30.0),color: Colors.grey.withOpacity(0.3), ),
                  height: 60,
                  //width: 120,


                  child: ElevatedButton(
                    style: finalButtons,
                    onPressed: () {
                      if(_checkboxValues[1]==false&&_checkboxValues[2]==false&&_checkboxValues[3]==false||_checkboxValues[4]==false&&_checkboxValues[5]==false&&_checkboxValues[6]==false
                          ||_checkboxValues[7]==false&&_checkboxValues[8]==false
                          ||_checkboxValues[10]==false&&_checkboxValues[11]==false&&_checkboxValues[12]==false||_checkboxValues[13]==false&&_checkboxValues[14]==false&&_checkboxValues[15]==false){
                        String misser = '';
                        if(_checkboxValues[10]==false&&_checkboxValues[11]==false&&_checkboxValues[12]==false){ misser = 'D';}
                        if(_checkboxValues[13]==false&&_checkboxValues[14]==false&&_checkboxValues[15]==false){ misser = 'N';}
                        if(_checkboxValues[10]==false&&_checkboxValues[11]==false&&_checkboxValues[12]==false&&_checkboxValues[13]==false&&_checkboxValues[14]==false&&_checkboxValues[15]==false){misser = 'D && N';}
                        if(_checkboxValues[7]==false&&_checkboxValues[8]==false){misser = 'M';}
                        if(_checkboxValues[1]==false&&_checkboxValues[2]==false&&_checkboxValues[3]==false){misser = 'R';}
                        if(_checkboxValues[4]==false&&_checkboxValues[5]==false&&_checkboxValues[6]==false){misser = 'G';}
                        if(_checkboxValues[1]==false&&_checkboxValues[2]==false&&_checkboxValues[3]==false&&_checkboxValues[4]==false&&_checkboxValues[5]==false&&_checkboxValues[6]==false){misser = 'R && G';}

                        showModalBottomSheet<void>(context: context,builder: (BuildContext context) {
                          return Container(height: 300,
                            alignment: Alignment.center,
                            color: AlertModalBG,
                            padding: EdgeInsets.all(20.0),
                            child: Center(child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                RichText(text: TextSpan(text: '',style: DefaultTextStyle.of(context).style,
                                  children: <TextSpan>[
                                    TextSpan(text: 'Check! ', style: TextStyle(color: AlertModalCheckWord, fontWeight: FontWeight.bold,fontSize: 30)),
                                    //TextSpan(text: 'weather the given Swaras are Proper!',style: TextStyle(fontSize: 20) ),
                                    TextSpan(text: 'Some swaras are Missing',style: TextStyle(fontSize: 20,color: AlertModalOtherColors) ),
                                  ],),),
                                Divider(height: 30,thickness: 2.0,color: AlertModalOtherColors,),
                                Text('Enter $misser variants properly',style: TextStyle(fontSize: 22,color: AlertModalOtherColors),),
                                Divider(height: 30,thickness: 2.0,color: AlertModalOtherColors),
                                // ElevatedButton(style: style,child: const Text('Calculate'),onPressed: () {   Navigator.push(context, MaterialPageRoute(builder: (inputMap) => const HomeApp()));}, ),

                              ],
                            ),),);
                        });//showModalBottomSheet
                      }
                      //
                      // List a = inputMap['notes'];
                      // for(int i = 0;i<a.length;i++){
                      //   myFileWriter(a[i]);
                      // }
                      else {
                        setState(() {swaraInput = _checkboxValues;});
                        inputMap = inputToNotes(_checkboxValues, western_swaras);


                        List doopKey = RaagaLib.keys.toList();
                        List doopVal = RaagaLib.values.toList();
                        String SelectedRaagaName = '';

                        for(int i = 0;i<doopKey.length;i++){
                          if(doopVal[i].toString()==_checkboxValues.toString()){
                            SelectedRaagaName = doopKey[i];
                          }
                        }
                        setState(() {RaagamName = SelectedRaagaName;});




                      // myFileWriter(inputMap['notes']);
                        String input = '${inputMap['scale']}';


                        showModalBottomSheet<void>(
                            context: context, builder: (BuildContext context) {
                          return Container(height: 300,
                            color:ConfirmModalBG,
                            padding: EdgeInsets.all(20.0),
                            child: Center(child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                RichText(text: TextSpan(text: '',style: DefaultTextStyle.of(context).style,
                                  children: <TextSpan>[
                                    TextSpan(text: 'Verify ', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30,color: ConfirmModalMainWords)),
                                    TextSpan(text: 'weather the entered notes are Proper!',style: TextStyle(fontSize: 20,fontFamily: 'NotoSans',fontWeight: FontWeight.bold,color: ConfirmModalOtherColors) ),],),),
                                Container(child: Text('$SelectedRaagaName',style: TextStyle(fontSize: 20,fontFamily: 'NotoSansMid',fontWeight: FontWeight.bold,color:ButtonForeON,)),),
                                Divider(height: 20,thickness: 2.0,color: ConfirmModalLineColor,indent: 50,endIndent: 50,),
                                Text(input.substring(1,(input.length-1)),style: TextStyle(fontSize: 20,color: ConfirmModalMainWords),),
                                Divider(height: 30,thickness: 2.0,color: ConfirmModalLineColor),
                                ElevatedButton(
                                  style: ConfirmModalBTN,
                                  child: const Text('Calculate',style: TextStyle(fontSize: 20),),
                                  onPressed: () {
                                    Navigator.pushReplacement(context, MaterialPageRoute(
                                        builder: (inputMap) => const FamilyChds()));
                                  },),

                              ],
                            ),),);
                        }); //showModalBottomSheet
                      }
                    },
                    child: Text('Western',),
                  ),),
                Container(
                  decoration: BoxDecoration(border: Border.all( width: 1, color: CupertinoColors.white, ),borderRadius: BorderRadius.circular(30.0),color: Colors.grey.withOpacity(0.3), ),
                  height: 60,
                  //width: 120,
                  child: ElevatedButton(
                    style: finalButtons,
                    onPressed: () {
                      if(_checkboxValues[1]==false&&_checkboxValues[2]==false&&_checkboxValues[3]==false||_checkboxValues[4]==false&&_checkboxValues[5]==false&&_checkboxValues[6]==false
                          ||_checkboxValues[7]==false&&_checkboxValues[8]==false
                          ||_checkboxValues[10]==false&&_checkboxValues[11]==false&&_checkboxValues[12]==false||_checkboxValues[13]==false&&_checkboxValues[14]==false&&_checkboxValues[15]==false){
                        String misser = '';
                        if(_checkboxValues[10]==false&&_checkboxValues[11]==false&&_checkboxValues[12]==false){ misser = 'D';}
                        if(_checkboxValues[13]==false&&_checkboxValues[14]==false&&_checkboxValues[15]==false){ misser = 'N';}
                        if(_checkboxValues[10]==false&&_checkboxValues[11]==false&&_checkboxValues[12]==false&&_checkboxValues[13]==false&&_checkboxValues[14]==false&&_checkboxValues[15]==false){misser = 'D && N';}
                        if(_checkboxValues[7]==false&&_checkboxValues[8]==false){misser = 'M';}
                        if(_checkboxValues[1]==false&&_checkboxValues[2]==false&&_checkboxValues[3]==false){misser = 'R';}
                        if(_checkboxValues[4]==false&&_checkboxValues[5]==false&&_checkboxValues[6]==false){misser = 'G';}
                        if(_checkboxValues[1]==false&&_checkboxValues[2]==false&&_checkboxValues[3]==false&&_checkboxValues[4]==false&&_checkboxValues[5]==false&&_checkboxValues[6]==false){misser = 'R && G';}

                        showModalBottomSheet<void>(context: context,builder: (BuildContext context) {
                          return Container(height: 300,
                            alignment: Alignment.center,
                            color: AlertModalBG,
                            padding: EdgeInsets.all(20.0),
                            child: Center(child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                RichText(text: TextSpan(text: '',style: DefaultTextStyle.of(context).style,
                                  children: <TextSpan>[
                                    TextSpan(text: 'Check! ', style: TextStyle(color: AlertModalCheckWord, fontWeight: FontWeight.bold,fontSize: 30)),
                                    //TextSpan(text: 'weather the given Swaras are Proper!',style: TextStyle(fontSize: 20) ),
                                    TextSpan(text: 'Some swaras are Missing',style: TextStyle(fontSize: 20,color: AlertModalOtherColors) ),
                                  ],),),
                                Divider(height: 30,thickness: 2.0,color: AlertModalOtherColors,),
                                Text('Enter $misser variants properly',style: TextStyle(fontSize: 22,color: AlertModalOtherColors),),
                                Divider(height: 30,thickness: 2.0,color: AlertModalOtherColors),
                                // ElevatedButton(style: style,child: const Text('Calculate'),onPressed: () {   Navigator.push(context, MaterialPageRoute(builder: (inputMap) => const HomeApp()));}, ),

                              ],
                            ),),);
                        });//showModalBottomSheet
                      }

                      else{
                        setState(() {swaraInput = _checkboxValues;});

                        inputMap = inputToNotes(_checkboxValues,carnatic_swaras);
                        inputMap = inputToNotes(_checkboxValues,carnatic_swaras);
                        //Dont Remove the second one, coz it kinda works, But i don't know how, and so dont remove it


                        List doopKey = RaagaLib.keys.toList();
                        List doopVal = RaagaLib.values.toList();
                        String SelectedRaagaName = '';

                        for(int i = 0;i<doopKey.length;i++){
                          if(doopVal[i].toString()==_checkboxValues.toString()){
                            SelectedRaagaName = doopKey[i];
                          }
                        }

                        setState(() {RaagamName = SelectedRaagaName;});

                      // myFileWriter(inputMap['notes']);
                        String input = '${inputMap['scale']}';
                        showModalBottomSheet<void>(context: context,builder: (BuildContext context) {
                          return Container(height: 300,
                            color:ConfirmModalBG,
                            padding: EdgeInsets.all(20.0),
                            child: Center(child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                RichText(text: TextSpan(text: '',style: DefaultTextStyle.of(context).style,
                                  children: <TextSpan>[
                                    TextSpan(text: 'Verify ', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30,color: ConfirmModalMainWords)),
                                    TextSpan(text: 'weather the entered notes are Proper!',style: TextStyle(fontSize: 20,fontFamily: 'NotoSans',fontWeight: FontWeight.bold,color: ConfirmModalOtherColors) ),
                                  ],),),
                                Container(child: Text('$SelectedRaagaName',style: TextStyle(fontSize: 20,fontFamily: 'NotoSansMid',fontWeight: FontWeight.bold,color:ButtonForeON,)),),


                                Divider(height: 20,thickness: 2.0,color: ConfirmModalLineColor,indent: 50,endIndent: 50,),
                                Text(input.substring(1,(input.length-1)),style: TextStyle(fontSize: 20,color: ConfirmModalMainWords),),
                                Divider(height: 30,thickness: 2.0,color: ConfirmModalLineColor),
                                ElevatedButton(
                                  style: ConfirmModalBTN,
                                  child: const Text('Calculate',style: TextStyle(fontSize: 20),),
                                  onPressed: () {
                                    Navigator.pushReplacement(context, MaterialPageRoute(
                                        builder: (inputMap) => const FamilyChds()));
                                  },),

                              ],
                            ),),);
                        });//showModalBottomSheet
                      }
                    }, child: Text('Carnatic'),
                  ),),
              ],
            ),
            Container(margin: EdgeInsets.all(50),),
          ],//list
        ),

    );
  }


  // void _createTutorial_InputScreen() {
  //   var HeadingTextStyle =  TextStyle(fontSize: 28,fontFamily: 'NotoSansRegular',color: Colors.white,fontWeight: FontWeight.bold);
  //   var ImportantNormal = TextStyle(fontFamily: 'NotoSansMid',fontSize: 16,color: Color.fromRGBO(255, 255, 255, 1));
  //   var normalTextStyle = TextStyle(fontWeight: FontWeight.w200,fontFamily: 'NotoSansMid',fontSize: 16,color: Color.fromRGBO(180, 180, 180, 1));
  //   var padding_TargetContainer = EdgeInsets.symmetric(horizontal: 10,vertical: 10);
  //
  //   var boxDecoration_TargetContainer =  BoxDecoration(border: Border.all(color: Color.fromRGBO(11, 111, 244, 1), width: 2.0),);
  //   double rad = 20;
  //
  //   final targets = [
  //     TargetFocus(
  //       radius: rad,
  //       enableTargetTab: true,
  //       enableOverlayTab: true,
  //       identify: 'Raaga Input Search ',
  //       keyTarget: _SwarasInputSearch,
  //       //alignSkip: Alignment.bottomCenter,
  //       shape: ShapeLightFocus.RRect,
  //       contents: [
  //         TargetContent(
  //             align:ContentAlign.bottom,
  //             builder:(context,controller)=>
  //                 Container(
  //                   padding: padding_TargetContainer,
  //                   decoration: boxDecoration_TargetContainer,
  //                   child: RichText(text:
  //                   TextSpan(text: 'Search bar',style: HeadingTextStyle,children: <TextSpan>[
  //                     TextSpan(text: '\n\nUsing this search bar you can search the',style:normalTextStyle),
  //                     TextSpan(text: ' Melakarta Raaga\'s Name',style: ImportantNormal),
  //                     TextSpan(text: '\n\nIf a raaga is not displayed, even if it is Melakarta Raaga, please try other spellings.',style:normalTextStyle),
  //
  //
  //                   ],),),
  //                 )
  //         ),
  //       ],
  //     ),
  //     //Raag Input Screen 1
  //     TargetFocus(
  //       radius: rad,
  //       enableTargetTab: true,
  //       enableOverlayTab: true,
  //       identify: 'Raaga Input Screen',
  //       keyTarget: _SwarasInputSwaras,
  //       //alignSkip: Alignment.bottomCenter,
  //       shape: ShapeLightFocus.RRect,
  //       contents: [
  //         TargetContent(
  //             align:ContentAlign.bottom,
  //             builder:(context,controller)=>
  //                 Container(
  //                   padding: padding_TargetContainer,
  //                   decoration: boxDecoration_TargetContainer,
  //                   child: RichText(text:
  //                   TextSpan(text: 'Swaras',style: HeadingTextStyle,children: <TextSpan>[
  //                     TextSpan(text: '\n\nThis page contains 16 of these buttons,..!\n\nSelect the Raga using appropriate Swaras..!\n\nThese work on the basis of 16 Note Nomencleture from Carnatic Music..!',style:normalTextStyle),
  //
  //                   ],),),
  //                 )
  //         ),
  //       ],
  //     ),
  //
  //
  //     TargetFocus(
  //       radius: rad,
  //       enableTargetTab: true,
  //       enableOverlayTab: true,
  //       identify: 'Swara Input',
  //       keyTarget: _SwarasInputButton,
  //       //alignSkip: Alignment.bottomCenter,
  //       shape: ShapeLightFocus.RRect,
  //       contents: [
  //         TargetContent(
  //             align:ContentAlign.top,
  //             builder:(context,controller)=>
  //                 Container(
  //                   decoration: boxDecoration_TargetContainer,
  //                   padding: padding_TargetContainer,
  //                   child: RichText(text:
  //                   TextSpan(text: 'Main Buttons of the Page..!',style: HeadingTextStyle,children: <TextSpan>[
  //                     TextSpan(text: '\n\nThese Buttons acts as in input confirmation as well as a Display of Raaga that is Selected..!',style:normalTextStyle),
  //                     TextSpan(text: '\nTapping any of the button ',style: ImportantNormal),
  //                     TextSpan(text:'will display a small pop up screen, Which tells you the raaga Name and Swaras that you have selected..!',style:normalTextStyle),
  //
  //                   ],),),
  //                 )
  //
  //
  //         ),
  //       ],
  //     ),
  //     //Raag Input Screen 2
  //
  //
  //   ];
  //   final tutorial = TutorialCoachMark(
  //     targets: targets,
  //     hideSkip: false,
  //     opacityShadow: 0.93,
  //
  //     paddingFocus: 10,
  //     focusAnimationDuration: Duration(milliseconds: 300),
  //     unFocusAnimationDuration: Duration(milliseconds: 300),
  //     pulseAnimationDuration: Duration(milliseconds: 300),
  //   );
  //   Future.delayed(const Duration(milliseconds: 500),(){
  //     tutorial.show(context: context);});
  //   tutorialInputVble = false;
  // }


Widget searchWidget(String text) {

  return ListTile(
    title: Text(
      // text.length > 3 ? text.substring(0, 3) :
      text,
      style: TextStyle(
          // fontWeight: FontWeight.bold,
          fontSize: 14,
          color: Colors.black),
    ),
    // subtitle: Text(
    //   text,
    //   maxLines: 1,
    //   overflow: TextOverflow.ellipsis,
    //   style: TextStyle(
    //     fontWeight: FontWeight.normal,
    //     fontSize: 12,
    //     color: Colors.black26,
    //   ),
    // ),
  );
}
}