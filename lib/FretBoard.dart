import 'dart:convert';
import 'dart:math';
import 'dart:ui';
import 'package:clg_project_gtr_raag/Theory.dart';
import 'package:clg_project_gtr_raag/intervals.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';

import 'package:clg_project_gtr_raag/inputPage.dart';
import 'package:clg_project_gtr_raag/HomePage.dart';

// import 'package:dart_melty_soundfont/dart_melty_soundfont.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main.dart';

bool shape= false;

class Raag_FretBoard extends StatefulWidget {
  Raag_FretBoard({super.key});

  @override
  State<Raag_FretBoard> createState() => _Raag_FretBoard();
}
class _Raag_FretBoard extends State<Raag_FretBoard> {


  @override
  Widget build(BuildContext context) {
    String output2 ='';
    var boxDecoration = BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.2),
          spreadRadius: 2,
          blurRadius: 5,
          offset: Offset(0, 5), // changes position of shadow
        ),
      ],
      border: Border.all( width: 0.5, color: Color.fromRGBO(46, 46,46, 1), ),
      borderRadius: BorderRadius.circular(10.0),
      color: Color.fromRGBO(241,243,244, 1), );


    var screen2_box_title =  TextStyle( color: Color.fromRGBO(11, 111, 244,1),fontSize: 20,fontFamily: 'NotoSansMid',);
    var screen2_box_text =   TextStyle( color: Colors.black, fontSize: 14, fontFamily: 'NotoSans',fontWeight: FontWeight.w500,);

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back,),
        //   onPressed: () {Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> HomeApp()));},),
        backgroundColor: Colors.white,
        title: Text('Raaga FretBoard',style: TextStyle(color: Color.fromRGBO(0, 0, 0, 1),fontFamily: 'NotoSansMid',fontSize: screenHeight*0.028),),
      ),

      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          children: [
            Container(margin: EdgeInsets.symmetric(vertical: 0),padding:EdgeInsets.symmetric(vertical: screenHeight*1/20,horizontal: screenWidth*1/10),
                child: ElevatedButton(child: Text('Shapes'),onPressed: (){setState(() {shape = !shape;});},
                )
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 0),
              padding:EdgeInsets.symmetric(vertical: screenHeight*1/20,horizontal: screenWidth*1/10),

              child: CustomPaint(
                size: Size(screenWidth,screenHeight),
                painter: PaintTest(),
              )
            ),

          ],
        ),

      ),


    );
  }
}


class PaintTest extends CustomPainter{




  @override
  void paint(Canvas canvas, Size size) {
    List OneOctaveScale = [];
    List Fretter(List a){

      List Frets = [];
      Map GtrFretOpens = {'[6, 0]':'E','[5, 0]':'A','[4, 0]':'D','[3, 0]':'G','[2, 0]':'B','[1, 0]':'E'};
      Map WholeGTRmap = {};
      for(int j = 6;j>0;j--){
        List tmp = [];
        for (int i = 0;i<14;i++){tmp.add([j,i]);
        }
        Frets.add(tmp);
      }
      for(int j = 0;j<6;j++){//the 6 is Responsible for Number of Strings
        var OpenNote = GtrFretOpens[(Frets[j][0]).toString()];
        List Swaras=['A', 'A#', 'B', 'C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#'];
        int index = Swaras.indexOf(OpenNote);
        for(int i = 0;i<13;i++){WholeGTRmap[(Frets[j][i]).toString()]=Swaras[(index+i)%12];}
      }
      List keys = [];
      List positions=[];
      for(int i=0;i<a.length-1;i++){//length-1 coz of octave
        List tmp = [];
        List tmp2= [];
        //tmp.add(a[i]);
        WholeGTRmap.forEach((key, value) {
          if (value == a[i]){
            tmp.add(key);
            List<dynamic> list = jsonDecode(key); // Convert string to list
            // int Str = int.parse(key[1]);
            // int fre = int.parse(key[4]);
            tmp2.add(list);  }
        }
        );
        positions.add(tmp2);
        keys.add(tmp);
      }
      List dummy = [];
      List Root = [positions[0][0][0] ,positions[0][0][1]];
      int string = positions[0][0][0];
      int RootFret = positions[0][0][1];
      int e = (Root[0])%6;
      List octave =[];
      octave = positions[0][2];
      print(octave);

      for(int i = 0;i<positions.length;i++){
        List chumma =positions[i];

        for(int j = 0;j<chumma.length;j++){
          //&&chumma[j][0]<string
          if (chumma[j][1] - RootFret < 5&&chumma[j][1] - RootFret >=-2&&chumma[j][1]!=0){
            dummy.add(chumma[j]);
            break;
          }
        }
      }
      dummy.add(positions[0][2]);


      OneOctaveScale = dummy;
      return positions;
    }
    List input =  inputMap['scale'];
    var allFrets = Fretter(input);

    int fretCount = 13;
    int stringCount = 6;
    var stringgap = size.width/(stringCount-1);//count-1 due to the no of gaps between 6-5, 5,4,3,2, 2-1
    var fretgap = size.height/(fretCount-1);//13 due to the no of gaps between all the frets

    final Paint stringPaint = Paint()
      ..color = Colors.brown.withOpacity(0.6)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    //STRINGs
    var string06 = size.width-stringgap*0;
    var string05 = size.width-stringgap*1;
    var string04 = size.width-stringgap*2;
    var string03 = size.width-stringgap*3;
    var string02 = size.width-stringgap*4;
    var string01 = size.width-stringgap*5;
    canvas.drawLine(Offset(string06,-10), Offset(string06,size.height), stringPaint);
    canvas.drawLine(Offset(string05,-10), Offset(string05,size.height), stringPaint);
    canvas.drawLine(Offset(string04,-10), Offset(string04,size.height), stringPaint);
    canvas.drawLine(Offset(string03,-10), Offset(string03,size.height), stringPaint);
    canvas.drawLine(Offset(string02,-10), Offset(string02,size.height), stringPaint);
    canvas.drawLine(Offset(string01,-10), Offset(string01,size.height), stringPaint);

    drawBoard(st,fr){

      final Paint fretMarker = Paint()
        ..color = Colors.brown
        ..strokeWidth = 4
        ..style = PaintingStyle.fill;

      var stringNo = size.width-stringgap*(st-0.5);
      var fretNo = size.height-fretgap*(13-fr);

      canvas.drawCircle(Offset(stringNo,fretNo+fretgap*50/100), fretgap*20/100, fretMarker);
    }

    drawBoard(3,3);
    drawBoard(3,5);
    drawBoard(3,7);
    drawBoard(3,9);
    drawBoard(4,12);
    drawBoard(2,12);

    final Paint fretPaint = Paint()
      ..color = Colors.brown
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    //FRETs
    var fret01 = size.height-fretgap*0;
    var fret02 = size.height-fretgap*1;
    var fret03 = size.height-fretgap*2;
    var fret04 = size.height-fretgap*3;
    var fret05 = size.height-fretgap*4;
    var fret06 = size.height-fretgap*5;
    var fret07 = size.height-fretgap*6;
    var fret08 = size.height-fretgap*7;
    var fret09 = size.height-fretgap*8;
    var fret10 = size.height-fretgap*9;
    var fret11 = size.height-fretgap*10;
    var fret12 = size.height-fretgap*11;
    var fret13 = size.height-fretgap*12;
    //the Names are the only things messed, the order is perfect, ie the first line here results the 0th fret, tho it has name fret13 like that....!
    //Do NOt rename that, coz that'll mess above logic
    canvas.drawLine(Offset(0,fret13-10), Offset(size.width,fret13-10), fretPaint);
    canvas.drawLine(Offset(0,fret13), Offset(size.width,fret13), fretPaint);
    canvas.drawLine(Offset(0,fret12), Offset(size.width,fret12), fretPaint);
    canvas.drawLine(Offset(0,fret11), Offset(size.width,fret11), fretPaint);
    canvas.drawLine(Offset(0,fret10), Offset(size.width,fret10), fretPaint);
    canvas.drawLine(Offset(0,fret09), Offset(size.width,fret09), fretPaint);
    canvas.drawLine(Offset(0,fret08), Offset(size.width,fret08), fretPaint);
    canvas.drawLine(Offset(0,fret07), Offset(size.width,fret07), fretPaint);
    canvas.drawLine(Offset(0,fret06), Offset(size.width,fret06), fretPaint);
    canvas.drawLine(Offset(0,fret05), Offset(size.width,fret05), fretPaint);
    canvas.drawLine(Offset(0,fret04), Offset(size.width,fret04), fretPaint);
    canvas.drawLine(Offset(0,fret03), Offset(size.width,fret03), fretPaint);
    canvas.drawLine(Offset(0,fret02), Offset(size.width,fret02), fretPaint);
    canvas.drawLine(Offset(0,fret01), Offset(size.width,fret01), fretPaint);

    drawFrets(st, fr,note){
      if (fr == 0){fr=0.35;}
      var stringNo = size.width-stringgap*(stringCount-st);
      var fretNo = size.height-fretgap*(fretCount-fr);

      // Note	Degree	Shape	Fill Color	Outline	Outline Style
      // A	Root (1)	Circle	Solid Blue	Thick double outline (lighter blue)	Inner: Thin, Outer: Thick
      if (note==input[0]){


        final Paint paint = Paint()..color = Color.fromRGBO(11, 111, 244, 1)..strokeWidth = 3..style = PaintingStyle.stroke;
        final Paint paint2 = Paint()..color = Color.fromRGBO(11, 111, 244,.9)..strokeWidth = 1..style = PaintingStyle.fill;

        if (shape){
          canvas.drawCircle(Offset(stringNo,fretNo+fretgap*50/100),fretgap*25/100,paint..color = Color.fromRGBO(11, 111, 244, 1));
          canvas.drawCircle(Offset(stringNo,fretNo+fretgap*50/100),fretgap*24/100,paint2);
          TextPainter textPainter = TextPainter(
            text: TextSpan(
              text: note,
              style: TextStyle(fontFamily: 'NotoSansRegular',color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),),
            textAlign: TextAlign.center,textDirection: TextDirection.ltr,);
          textPainter.layout(minWidth: 10,maxWidth: double.infinity,);// Prepare TextPainter to draw text inside the circle
          double textY = fretNo+fretgap*50/100 - textPainter.height / 2;// Calculate position for the text (centered in the circle)
          double textX = stringNo - textPainter.width / 2;// Draw the text inside the circle
          textPainter.paint(canvas, Offset(textX, textY));

        }else{
          canvas.drawCircle(Offset(stringNo,fretNo+fretgap*50/100),fretgap*25/100,paint);
          canvas.drawCircle(Offset(stringNo,fretNo+fretgap*50/100),fretgap*17/100,paint..color = Color.fromRGBO(11, 111, 244, 1));
          canvas.drawCircle(Offset(stringNo,fretNo+fretgap*50/100),fretgap*15/100,paint2);
          TextPainter textPainter = TextPainter(
            text: TextSpan(
              text: note,
              style: TextStyle(fontFamily: 'NotoSansRegular',color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),),
            textAlign: TextAlign.center,textDirection: TextDirection.ltr,);
          textPainter.layout(minWidth: 10,maxWidth: double.infinity,);// Prepare TextPainter to draw text inside the circle
          double textY = fretNo+fretgap*50/100 - textPainter.height / 2;// Calculate position for the text (centered in the circle)
          double textX = stringNo - textPainter.width / 2;// Draw the text inside the circle
          textPainter.paint(canvas, Offset(textX, textY));

        }
          // Apply the rotation transformation to the text


      }


      // Note	Degree	Shape	Fill Color	Outline	Outline Style
      // B	Major 2nd	Triangle	Transparent	Medium outline (solid blue)	Single medium outline
      else if (note==input[1]){
        final Paint paint = Paint()..color = Color.fromRGBO(11, 111, 244, 1)..strokeWidth = 3..style = PaintingStyle.stroke;
        final Paint paint2 = Paint()..color = Colors.white..strokeWidth = 3..style = PaintingStyle.fill;

        if (shape){
          final Paint paint = Paint()..color = Color.fromRGBO(11, 111, 244, 1)..strokeWidth = 3..style = PaintingStyle.stroke;
          final Paint paint2 = Paint()..color = Color.fromRGBO(11, 111, 244,.85)..strokeWidth = 1..style = PaintingStyle.fill;

          canvas.drawCircle(Offset(stringNo,fretNo+fretgap*50/100),fretgap*20/100,paint..color = Color.fromRGBO(11, 111, 244, 1));
          canvas.drawCircle(Offset(stringNo,fretNo+fretgap*50/100),fretgap*18/100,paint2);
          TextPainter textPainter = TextPainter(
            text: TextSpan(
              text: note,
              style: TextStyle(fontFamily: 'NotoSansRegular',color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),),
            textAlign: TextAlign.center,textDirection: TextDirection.ltr,);
          textPainter.layout(minWidth: 10,maxWidth: double.infinity,);// Prepare TextPainter to draw text inside the circle
          double textY = fretNo+fretgap*50/100 - textPainter.height / 2;// Calculate position for the text (centered in the circle)
          double textX = stringNo - textPainter.width / 2;// Draw the text inside the circle
          textPainter.paint(canvas, Offset(textX, textY));

        }else{


        var path = Path();
        path.moveTo(stringNo-stringgap*-0/100, fretNo+fretgap*25/100);
        path.lineTo(stringNo-stringgap*20/100, fretNo+fretgap*65/100);
        path.lineTo(stringNo-stringgap*-20/100, fretNo+fretgap*65/100);
        path.close();
        canvas.drawPath(path, paint);


        var path2 = Path();
        path2.moveTo(stringNo-stringgap*-0/100, fretNo+fretgap*30/100);
        path2.lineTo(stringNo-stringgap*15/100, fretNo+fretgap*60/100);
        path2.lineTo(stringNo-stringgap*-15/100, fretNo+fretgap*60/100);
        path2.close();

        canvas.drawPath(path2, paint2);



        TextPainter textPainter = TextPainter(
          text: TextSpan(
            text: note,
            style: TextStyle(fontFamily: 'NotoSansRegular',color: Colors.black,fontSize: 14,fontWeight: FontWeight.bold),),
          textAlign: TextAlign.center,textDirection: TextDirection.ltr,);
        textPainter.layout(minWidth: 10,maxWidth: double.infinity,);// Prepare TextPainter to draw text inside the circle
        double textY = fretNo+fretgap*50/100 - textPainter.height / 2;// Calculate position for the text (centered in the circle)
        double textX = stringNo - textPainter.width / 2;// Draw the text inside the circle
        textPainter.paint(canvas, Offset(textX, textY)); }}

      // Note	Degree	Shape	Fill Color	Outline	Outline Style
      // C	Minor 3rd	Rectangle	Solid Blue	Medium outline (solid blue)	Single outline
      else if (note==input[2]){

        final Paint paint = Paint()..color = Color.fromRGBO(11, 111, 244, 1)..strokeWidth = 3..style = PaintingStyle.stroke;
        final Paint paint2 = Paint()..color = Colors.white..strokeWidth = 3..style = PaintingStyle.fill;
        // canvas.drawCircle(Offset(stringNo,fretNo+fretgap*50/100),fretgap*25/100,paint);
        // canvas.drawCircle(Offset(stringNo,fretNo+fretgap*50/100),fretgap*17/100,paint..color = Color.fromRGBO(11, 111, 244, 1));
        // canvas.drawCircle(Offset(stringNo,fretNo+fretgap*50/100),fretgap*15/100,paint2);
        if (shape){
          final Paint paint = Paint()..color = Color.fromRGBO(11, 111, 244, 1)..strokeWidth = 3..style = PaintingStyle.stroke;
          final Paint paint2 = Paint()..color = Color.fromRGBO(11, 111, 244,.8)..strokeWidth = 1..style = PaintingStyle.fill;

          canvas.drawCircle(Offset(stringNo,fretNo+fretgap*50/100),fretgap*20/100,paint..color = Color.fromRGBO(11, 111, 244, 1));
          canvas.drawCircle(Offset(stringNo,fretNo+fretgap*50/100),fretgap*18/100,paint2);
          TextPainter textPainter = TextPainter(
            text: TextSpan(
              text: note,
              style: TextStyle(fontFamily: 'NotoSansRegular',color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),),
            textAlign: TextAlign.center,textDirection: TextDirection.ltr,);
          textPainter.layout(minWidth: 10,maxWidth: double.infinity,);// Prepare TextPainter to draw text inside the circle
          double textY = fretNo+fretgap*50/100 - textPainter.height / 2;// Calculate position for the text (centered in the circle)
          double textX = stringNo - textPainter.width / 2;// Draw the text inside the circle
          textPainter.paint(canvas, Offset(textX, textY));

        }else{

        // The rectangle's starting point (top-left corner) and size
        double rectStartX = stringNo-stringgap*25/100;
        double rectStartY = fretNo+fretgap*35/100;
        double rectWidth = stringgap*50/100;
        double rectHeight = fretgap*30/100;
        Rect rectangle2 = Rect.fromLTWH(rectStartX, rectStartY, rectWidth, rectHeight);
        canvas.drawRect(rectangle2, paint);
        Rect rectangle3 = Rect.fromLTWH(rectStartX+2, rectStartY+2, rectWidth-5, rectHeight-5);
        canvas.drawRect(rectangle3, paint2);

        TextPainter textPainter = TextPainter(
          text: TextSpan(
            text: note,
            style: TextStyle(fontFamily: 'NotoSansRegular',color: Colors.black,fontSize: 14,fontWeight: FontWeight.bold),),
          textAlign: TextAlign.center,textDirection: TextDirection.ltr,);
        textPainter.layout(minWidth: 10,maxWidth: double.infinity,);// Prepare TextPainter to draw text inside the circle
        double textY = fretNo+fretgap*50/100 - textPainter.height / 2;// Calculate position for the text (centered in the circle)
        double textX = stringNo - textPainter.width / 2;// Draw the text inside the circle
        textPainter.paint(canvas, Offset(textX, textY)); }}

      // Note	Degree	Shape	Fill Color	Outline	Outline Style
      // D	Perfect 4th	Rounded Rectangle	Transparent	Double outline (solid blue, thick)	Thin inner + Thick outer
      else if (note==input[3]){

        final Paint paint = Paint()..color = Color.fromRGBO(11, 111, 244, 1)..strokeWidth = 3..style = PaintingStyle.stroke;
        final Paint paint2 = Paint()..color = Colors.white..strokeWidth = 3..style = PaintingStyle.fill;
        // canvas.drawCircle(Offset(stringNo,fretNo+fretgap*50/100),fretgap*25/100,paint);
        // canvas.drawCircle(Offset(stringNo,fretNo+fretgap*50/100),fretgap*17/100,paint..color = Color.fromRGBO(11, 111, 244, 1));
        // canvas.drawCircle(Offset(stringNo,fretNo+fretgap*50/100),fretgap*15/100,paint2);

        if (shape){
          final Paint paint = Paint()..color = Color.fromRGBO(11, 111, 244, 1)..strokeWidth = 3..style = PaintingStyle.stroke;
          final Paint paint2 = Paint()..color = Color.fromRGBO(11, 111, 244,.75)..strokeWidth = 1..style = PaintingStyle.fill;

          canvas.drawCircle(Offset(stringNo,fretNo+fretgap*50/100),fretgap*20/100,paint..color = Color.fromRGBO(11, 111, 244, 1));
          canvas.drawCircle(Offset(stringNo,fretNo+fretgap*50/100),fretgap*18/100,paint2);
          TextPainter textPainter = TextPainter(
            text: TextSpan(
              text: note,
              style: TextStyle(fontFamily: 'NotoSansRegular',color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),),
            textAlign: TextAlign.center,textDirection: TextDirection.ltr,);
          textPainter.layout(minWidth: 10,maxWidth: double.infinity,);// Prepare TextPainter to draw text inside the circle
          double textY = fretNo+fretgap*50/100 - textPainter.height / 2;// Calculate position for the text (centered in the circle)
          double textX = stringNo - textPainter.width / 2;// Draw the text inside the circle
          textPainter.paint(canvas, Offset(textX, textY));

        }else{
        // The rectangle's starting point (top-left corner) and size
        double rectStartX = stringNo-stringgap*20/100;
        double rectStartY = fretNo+fretgap*35/100;
        double rectWidth = stringgap*40/100;
        double rectHeight = fretgap*30/100;
        Rect rectangle2 = Rect.fromLTWH(rectStartX, rectStartY, rectWidth, rectHeight);
        RRect rrect2 = RRect.fromRectAndRadius(rectangle2, Radius.circular(5));
        canvas.drawRRect(rrect2, paint);
        Rect rectangle3 = Rect.fromLTWH(rectStartX+2, rectStartY+2, rectWidth-5, rectHeight-5);
        canvas.drawRect(rectangle3, paint2);






        TextPainter textPainter = TextPainter(
          text: TextSpan(
            text: note,
            style: TextStyle(fontFamily: 'NotoSansRegular',color: Colors.black,fontSize: 14,fontWeight: FontWeight.bold),),
          textAlign: TextAlign.center,textDirection: TextDirection.ltr,);
        textPainter.layout(minWidth: 10,maxWidth: double.infinity,);// Prepare TextPainter to draw text inside the circle
        double textY = fretNo+fretgap*50/100 - textPainter.height / 2;// Calculate position for the text (centered in the circle)
        double textX = stringNo - textPainter.width / 2;// Draw the text inside the circle
        textPainter.paint(canvas, Offset(textX, textY)); }}

      // Note	Degree	Shape	Fill Color	Outline	Outline Style
      // E	Perfect 5th	Circle	Solid Blue	Thin outline (lighter blue)	Single thin outline
      else if (note==input[4]){
        final Paint paint = Paint()..color = Color.fromRGBO(11, 111, 244, 1)..strokeWidth = 2..style = PaintingStyle.stroke;
        final Paint paint2 = Paint()..color = Colors.white..strokeWidth = 3..style = PaintingStyle.fill;
        if (shape){
          final Paint paint = Paint()..color = Color.fromRGBO(11, 111, 244, 1)..strokeWidth = 3..style = PaintingStyle.stroke;
          final Paint paint2 = Paint()..color = Color.fromRGBO(11, 111, 244,.7)..strokeWidth = 1..style = PaintingStyle.fill;

          canvas.drawCircle(Offset(stringNo,fretNo+fretgap*50/100),fretgap*20/100,paint..color = Color.fromRGBO(11, 111, 244, 1));
          canvas.drawCircle(Offset(stringNo,fretNo+fretgap*50/100),fretgap*18/100,paint2);
          TextPainter textPainter = TextPainter(
            text: TextSpan(
              text: note,
              style: TextStyle(fontFamily: 'NotoSansRegular',color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),),
            textAlign: TextAlign.center,textDirection: TextDirection.ltr,);
          textPainter.layout(minWidth: 10,maxWidth: double.infinity,);// Prepare TextPainter to draw text inside the circle
          double textY = fretNo+fretgap*50/100 - textPainter.height / 2;// Calculate position for the text (centered in the circle)
          double textX = stringNo - textPainter.width / 2;// Draw the text inside the circle
          textPainter.paint(canvas, Offset(textX, textY));

        }else{
        canvas.drawCircle(Offset(stringNo,fretNo+fretgap*50/100),fretgap*20/100,paint);
        canvas.drawCircle(Offset(stringNo,fretNo+fretgap*50/100),fretgap*15/100,paint..color = Color.fromRGBO(11, 111, 244, 1));
        canvas.drawCircle(Offset(stringNo,fretNo+fretgap*50/100),fretgap*12/100,paint2);

        TextPainter textPainter = TextPainter(
          text: TextSpan(
            text: note,
            style: TextStyle(fontFamily: 'NotoSansRegular',color: Colors.black,fontSize: 14,fontWeight: FontWeight.bold),),
          textAlign: TextAlign.center,textDirection: TextDirection.ltr,);
        textPainter.layout(minWidth: 10,maxWidth: double.infinity,);// Prepare TextPainter to draw text inside the circle
        double textY = fretNo+fretgap*50/100 - textPainter.height / 2;// Calculate position for the text (centered in the circle)
        double textX = stringNo - textPainter.width / 2;// Draw the text inside the circle
        textPainter.paint(canvas, Offset(textX, textY)); }}

      // Note	Degree	Shape	Fill Color	Outline	Outline Style
      // F	Minor 6th	Triangle	Solid Blue	Medium outline (lighter blue)	Single medium outline
      else if (note==input[5]){
        final Paint paint = Paint()..color = Color.fromRGBO(11, 111, 244, 0.8)..strokeWidth = 2..style = PaintingStyle.fill;
        final Paint paint2 = Paint()..color = Color.fromRGBO(11, 111, 244, 1)..strokeWidth = 3..style = PaintingStyle.stroke;
        if (shape){
          final Paint paint = Paint()..color = Color.fromRGBO(11, 111, 244, 1)..strokeWidth = 3..style = PaintingStyle.stroke;
          final Paint paint2 = Paint()..color = Color.fromRGBO(11, 111, 244,.65)..strokeWidth = 1..style = PaintingStyle.fill;

          canvas.drawCircle(Offset(stringNo,fretNo+fretgap*50/100),fretgap*20/100,paint..color = Color.fromRGBO(11, 111, 244, 1));
          canvas.drawCircle(Offset(stringNo,fretNo+fretgap*50/100),fretgap*18/100,paint2);
          TextPainter textPainter = TextPainter(
            text: TextSpan(
              text: note,
              style: TextStyle(fontFamily: 'NotoSansRegular',color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),),
            textAlign: TextAlign.center,textDirection: TextDirection.ltr,);
          textPainter.layout(minWidth: 10,maxWidth: double.infinity,);// Prepare TextPainter to draw text inside the circle
          double textY = fretNo+fretgap*50/100 - textPainter.height / 2;// Calculate position for the text (centered in the circle)
          double textX = stringNo - textPainter.width / 2;// Draw the text inside the circle
          textPainter.paint(canvas, Offset(textX, textY));

        }else{

        var path = Path();
        path.moveTo(stringNo-stringgap*-0/100, fretNo+fretgap*25/100);
        path.lineTo(stringNo-stringgap*20/100, fretNo+fretgap*65/100);
        path.lineTo(stringNo-stringgap*-20/100, fretNo+fretgap*65/100);
        path.close();
        canvas.drawPath(path, paint2);


        var path2 = Path();
        path2.moveTo(stringNo-stringgap*-0/100, fretNo+fretgap*30/100);
        path2.lineTo(stringNo-stringgap*20/100, fretNo+fretgap*65/100);
        path2.lineTo(stringNo-stringgap*-20/100, fretNo+fretgap*65/100);
        path2.close();

        canvas.drawPath(path2, paint);




        TextPainter textPainter = TextPainter(
          text: TextSpan(
            text: note,
            style: TextStyle(fontFamily: 'NotoSansRegular',color: Colors.white,fontSize: 14,fontWeight: FontWeight.bold),),
          textAlign: TextAlign.center,textDirection: TextDirection.ltr,);
        textPainter.layout(minWidth: 10,maxWidth: double.infinity,);// Prepare TextPainter to draw text inside the circle
        double textY = fretNo+fretgap*50/100 - textPainter.height / 2;// Calculate position for the text (centered in the circle)
        double textX = stringNo - textPainter.width / 2;// Draw the text inside the circle
        textPainter.paint(canvas, Offset(textX, textY)); }}

      // Note	Degree	Shape	Fill Color	Outline	Outline Style
      // G	Minor 7th	Rounded Rectangle	Transparent	Thick single outline (solid blue)	Single thick outline
      else if (note==input[6]){
        final Paint paint = Paint()..color = Color.fromRGBO(11, 111, 244, 0.8)..strokeWidth = 2..style = PaintingStyle.fill;
        final Paint paint2 = Paint()..color = Color.fromRGBO(11, 111, 244, 1)..strokeWidth = 3..style = PaintingStyle.stroke;
        if (shape){
          final Paint paint = Paint()..color = Color.fromRGBO(11, 111, 244, 1)..strokeWidth = 3..style = PaintingStyle.stroke;
          final Paint paint2 = Paint()..color = Color.fromRGBO(11, 111, 244,.63)..strokeWidth = 1..style = PaintingStyle.fill;

          canvas.drawCircle(Offset(stringNo,fretNo+fretgap*50/100),fretgap*20/100,paint..color = Color.fromRGBO(11, 111, 244, 1));
          canvas.drawCircle(Offset(stringNo,fretNo+fretgap*50/100),fretgap*18/100,paint2);
          TextPainter textPainter = TextPainter(
            text: TextSpan(
              text: note,
              style: TextStyle(fontFamily: 'NotoSansRegular',color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),),
            textAlign: TextAlign.center,textDirection: TextDirection.ltr,);
          textPainter.layout(minWidth: 10,maxWidth: double.infinity,);// Prepare TextPainter to draw text inside the circle
          double textY = fretNo+fretgap*50/100 - textPainter.height / 2;// Calculate position for the text (centered in the circle)
          double textX = stringNo - textPainter.width / 2;// Draw the text inside the circle
          textPainter.paint(canvas, Offset(textX, textY));

        }else{
        double rectStartX = stringNo-stringgap*20/100;
        double rectStartY = fretNo+fretgap*35/100;
        double rectWidth = stringgap*40/100;
        double rectHeight = fretgap*30/100;
        Rect rectangle2 = Rect.fromLTWH(rectStartX, rectStartY, rectWidth, rectHeight);
        RRect rrect2 = RRect.fromRectAndRadius(rectangle2, Radius.circular(5));
        canvas.drawRRect(rrect2, paint);
        Rect rectangle3 = Rect.fromLTWH(rectStartX+2, rectStartY+2, rectWidth-5, rectHeight-5);
        canvas.drawRect(rectangle3, paint2);
        //
        // var path = Path();
        // path.moveTo(stringNo-stringgap*-0/100, fretNo+fretgap*25/100);
        // path.lineTo(stringNo-stringgap*20/100, fretNo+fretgap*65/100);
        // path.lineTo(stringNo-stringgap*-20/100, fretNo+fretgap*65/100);
        // path.close();
        // canvas.drawPath(path, paint2);
        //
        //
        // var path2 = Path();
        // path2.moveTo(stringNo-stringgap*-0/100, fretNo+fretgap*30/100);
        // path2.lineTo(stringNo-stringgap*20/100, fretNo+fretgap*65/100);
        // path2.lineTo(stringNo-stringgap*-20/100, fretNo+fretgap*65/100);
        // path2.close();
        //
        // canvas.drawPath(path2, paint);




        TextPainter textPainter = TextPainter(
          text: TextSpan(
            text: note,
            style: TextStyle(fontFamily: 'NotoSansRegular',color: Colors.white,fontSize: 14,fontWeight: FontWeight.bold),),
          textAlign: TextAlign.center,textDirection: TextDirection.ltr,);
        textPainter.layout(minWidth: 10,maxWidth: double.infinity,);// Prepare TextPainter to draw text inside the circle
        double textY = fretNo+fretgap*50/100 - textPainter.height / 2;// Calculate position for the text (centered in the circle)
        double textX = stringNo - textPainter.width / 2;// Draw the text inside the circle
        textPainter.paint(canvas, Offset(textX, textY)); }}

    }

    for (int i =0;i<allFrets.length;i++){
      for (int j =0;j<allFrets[i].length;j++){
        // print(allFrets[i][j][0]);
        // print(allFrets[i][j][0].runtimeType);
        drawFrets(allFrets[i][j][0],allFrets[i][j][1],input[i]);

      }

    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
    // TODO: implement shouldRepaint
    throw UnimplementedError();
  }

}