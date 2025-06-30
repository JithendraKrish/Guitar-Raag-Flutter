import 'package:flutter/material.dart';
import 'main.dart';
import 'package:clg_project_gtr_raag/HomePage.dart';

import 'package:url_launcher/url_launcher.dart';

class About_US extends StatefulWidget {
  About_US({super.key});

  @override
  State<About_US> createState() => _About_US();
}

final Uri feed_Back_url = Uri.parse('https://forms.gle/BjwkbiELWSoanYQh6');

final Uri bugReport_url = Uri.parse('https://forms.gle/JDCBtwNdyY2pEA6r9');
final Uri roadMapURL = Uri.parse('https://sites.google.com/view/guitar-raag-feature-roadmap/home');

class _About_US extends State<About_US> {

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
    Color SwaraContainerBG = Color.fromRGBO(241, 243, 244, 1);
    var popupMainText = TextStyle(fontFamily: 'NotoSansRegular',
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Color.fromRGBO(11, 111, 244, 1));
    var popupMidText = TextStyle(fontFamily: 'NotoSansMid',
        fontSize: 15,
        color: Color.fromRGBO(11, 111, 244, 1),
        height: 2.5);
    var popupNormalText = TextStyle(
        fontFamily: 'NotoSansMid', fontSize: 15, height: 1.5);
    var popupNoteText = TextStyle(
        fontFamily: 'NotoSansRegular', fontSize: 12, fontWeight: FontWeight.w100 );
    var about_Cont_text= TextStyle( color: Colors.black,fontSize: 15,fontWeight: FontWeight.w300);
    var SwarasContainerDeco = BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.2),
          spreadRadius: 2,
          blurRadius: 5,
          offset: Offset(0, 5), // changes position of shadow
        ),
      ],
      border: Border.all(width: 0.5, color: Color.fromRGBO(46, 46, 46, 1),),
      borderRadius: BorderRadius.circular(10.0),
      color: SwaraContainerBG,);

    var screen2_box_title =  TextStyle( color: Color.fromRGBO(11, 111, 244,1),fontSize: 20,fontFamily: 'NotoSansMid',);
    var screen2_box_text =   TextStyle( color: Colors.black, fontSize: 14, fontFamily: 'NotoSans',fontWeight: FontWeight.w500,);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop:  () async {
        
        return true; // Prevent back navigation
      },
      child: Scaffold(
        appBar: AppBar(

          toolbarHeight: screenHeight*0.08,
          // leading: IconButton(
          //   icon: Icon(Icons.arrow_back,),
          //   onPressed: () {Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> HomeApp()));},),
          backgroundColor: Colors.white,
          title: Text('About the Application',style: TextStyle(color: Color.fromRGBO(0, 0, 0, 1),fontFamily: 'NotoSansMid',fontSize: screenHeight*0.03),),
        ),

        backgroundColor: Colors.white,
        body: Center(
          child: ListView(
            children: [
              Container(margin: EdgeInsets.symmetric(vertical: 5.0,horizontal: 5),),
              Container(
                alignment: Alignment.center,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    side: BorderSide(width: 0.5,color: Colors.black,),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0),),
                    foregroundColor: Color.fromRGBO(11, 111, 244, 1),
                    backgroundColor: Colors.white,
                  ),
                  onPressed: _launchUrl3,
                  child: Text('Future plans, Road Map',style: TextStyle(fontFamily: 'NotoSansRegular',fontWeight: FontWeight.bold,fontSize: screenHeight*0.02),),
                ),),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                children: [
                Container(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      side: BorderSide(width: 0.5,color: Colors.black,),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0),),
                      foregroundColor: Color.fromRGBO(11, 111, 244, 1),
                      backgroundColor: Colors.white,
                    ),
                    onPressed: _launchUrl1,
                    child: Text('Feedback Form',style: TextStyle(fontFamily: 'NotoSansRegular',fontWeight: FontWeight.bold,fontSize: screenHeight*0.02),),
                  ),),
                Container(

                  alignment: Alignment.center,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      side: BorderSide(width: 0.5,color: Colors.black,),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0),),
                      foregroundColor: Color.fromRGBO(11, 111, 244, 1),
                      backgroundColor: Colors.white,
                    ),
                    onPressed: _launchUrl2,
                    child: Text('Report an Bug',style: TextStyle(fontFamily: 'NotoSansRegular',fontWeight: FontWeight.bold,fontSize: screenHeight*0.02),),
                  ),),
              ],),
              Container(margin: EdgeInsets.symmetric(vertical: 5.0,horizontal: 5),),
              Container(
                        //margin: EdgeInsets.only(top:10),
                        padding:EdgeInsets.symmetric(vertical: screenHeight*1/100,horizontal: screenWidth*1/12),
                        child:RichText(text:TextSpan(
                          children: <TextSpan>[

                            TextSpan(text: 'Guitar Raag,',
                                style: popupMainText),

                            TextSpan(text: ' find chords, learn theory and play music.\n\nWelcome to Guitar Raag, the go-to resource for ',style: about_Cont_text),
                            TextSpan(text: 'learning and calculating ',style: about_Cont_text.copyWith(color: Color.fromRGBO(11, 111, 244, 1),fontWeight: FontWeight.w500)),
                            TextSpan(text:'Family of Chords. \n\nWhether you\'re writing, practicing, or simply wondering about how chords operate within Melakarta Raagas, this application will help you identify',style: about_Cont_text),
                            TextSpan(text: ' Family of chords for melakarta raagas',style: about_Cont_text.copyWith(color: Color.fromRGBO(11, 111, 244, 1),fontWeight: FontWeight.w500)),
                            TextSpan(text:' in seconds and learn the concepts behind it as well.',style: about_Cont_text,),
                            TextSpan(text:'\n\nThis app is free for everyone and it was created as an ',style: about_Cont_text,),
                            TextSpan(text: ' open-source project ',style: about_Cont_text.copyWith(color: Color.fromRGBO(11, 111, 244, 1),fontWeight: FontWeight.w500)),
                            TextSpan(text:'( the source code of the project is available for everyone at the GitHub repository); you are welcome to help improve it.'
                                ,style:  about_Cont_text),

                            TextSpan(
                                text: 'is primarily designed to ascertain the precise musical chords for any Heptatonic Musical Scale or Carnatic Melakarta Raagam using musical intervals. '
                                    '\n\nThe Family of chords feature enables users to accompany real-time songs, and'
                                    ' it facilitates song composition without incorporating accidental notes or swaras.',
                                style: about_Cont_text),
                            // TextSpan(text: ' expected to know',style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'NotoSansMid',fontSize: 15,color: Color.fromRGBO(11, 111, 244, 1))),
                            // TextSpan(text: ' concepts such as,\n\n\t\t\tWestern Music Theory\n\t\t\tCarnatic Music Theory\n\t\t\tIntervals\n\t\t\tChords',style: TextStyle(fontSize: 15, fontFamily: 'NotoSansMid'),),


                            TextSpan(text: '\n\nInspirations ', style: popupMainText.copyWith(height: 1)),
                            TextSpan(text: '\n\nWhile creating this app, I took ideas from several existing applications and Sites.'
                                'My goal was to make a solution which is easier, better or different, but these apps have already made a big impact in the music world. '
                                'Some of them are:',
                                style:about_Cont_text),
                            TextSpan(
                                text: '\n\t\t\tCarnatic Raaga\n\t\t\tIan Ring\n\t\t\tGuitar Tuna\n\t\t\tTambura Droid',
                                style: about_Cont_text.copyWith(fontWeight: FontWeight.w500,height: 2.5)),


                          ],),),
                      ),
              //
            ],
          ),

        ),


      ),
    );
  }

  Future<void> _launchUrl1() async {
    if (!await launchUrl(feed_Back_url)) {
      throw Exception('Could not launch $feed_Back_url');
    }
}
  Future<void> _launchUrl2() async {
    if (!await launchUrl(bugReport_url)) {
      throw Exception('Could not launch $bugReport_url');
    }
  }
  Future<void> _launchUrl3() async {
    if (!await launchUrl(roadMapURL)) {
      throw Exception('Could not launch $roadMapURL');
    }
  }

}


