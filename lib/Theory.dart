import 'dart:ui';
import 'package:clg_project_gtr_raag/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:clg_project_gtr_raag/HomePage.dart';




void main(){runApp(TheoryLearner());}
class TheoryLearner extends StatelessWidget {

  TheoryLearner({super.key});
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Learn Theory',
      home: TheoryContent(),

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black45),
        useMaterial3: true,
      ),

    );

  }
}

int PageCtrl = 0;
class TheoryContent extends StatefulWidget {
  TheoryContent({super.key});

  @override
  State<TheoryContent> createState() => _TheoryContent();
}

class _TheoryContent extends State<TheoryContent> {
  bool colVal = true;
  Color Easter = Colors.transparent;
  double EasterImage = 0.0;

  bool selected = true;
  List<bool> tapbox = [true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true];
  @override
  Widget build(BuildContext context) {

    var Theory_AppBar =  TextStyle(fontFamily: 'NotoSansRegular',fontWeight: FontWeight.bold,fontSize: 18,color: Color.fromRGBO(0, 0, 0, 1),);
    var Theory_para_box_margin = EdgeInsets.symmetric(horizontal: 10.0, vertical: 5);
    var Theory_para_box_padding = EdgeInsets.symmetric(horizontal: 10.0,vertical: 20);
    var Theorty_para_box_Text = TextStyle( color: Colors.black.withOpacity(0.8),fontSize: 14,fontWeight: FontWeight.w400,);
    var Theory_page_links = TextStyle( color: Colors.black,fontSize: 16,fontStyle: FontStyle.normal,fontWeight: FontWeight.w400,height: 1);
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

    Color SwaraContainerBG = Color.fromRGBO(241, 243, 244, 1);

    var HeadingTextStyle =  TextStyle(fontSize: 16,color: Colors.black,fontWeight: FontWeight.bold);
    var ImportantNormal = TextStyle(fontSize: 14,color: Color.fromRGBO(11, 111, 244, 1));
    var normalTextStyle = TextStyle(fontWeight: FontWeight.w400,fontSize: 14,color: Color.fromRGBO(120, 120, 120, 1));
    var readMoreTextStyle = TextStyle(fontWeight: FontWeight.w400,fontSize: 14,color: Color.fromRGBO(11, 111, 244, 0.4));
    var readMoreText = 'Tap here to read more';
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


    final screenControl = PageController(initialPage: PageCtrl);


    var theory_box_decoration = BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.2),
          spreadRadius: 2,
          blurRadius: 5,
          offset: Offset(0, 5), // changes position of shadow
        ),
      ],
      border: Border.all( width: 0.5, color: Color.fromRGBO(46, 46,46, 1), ),
      borderRadius: BorderRadius.circular(5.0),
      color: Color.fromRGBO(241,243,244, 1), );

    var theory_box_margin = EdgeInsets.all(10);
    var theory_box_padding = EdgeInsets.all(15);

    var theory_nobox_decoration = BoxDecoration(

      border: Border.all( width: 0.1, color: Color.fromRGBO(46, 46,46, 1), ),
      borderRadius: BorderRadius.circular(5.0),
      color: Colors.transparent, );

    var theory_nobox_margin = EdgeInsets.all(10);
    var theory_nobox_padding = EdgeInsets.all(10);

    var CrossFadeDuration= Duration(milliseconds: 1000);

    @override
    void dispose(){
      screenControl.dispose();
      super.dispose();
    }
    return WillPopScope(
        onWillPop:  () async {

          Navigator.pop(context, MaterialPageRoute(builder: (_)=> HomeApp()));
          return true; // Prevent back navigation
        },
      child: Scaffold(
        appBar: AppBar(
          // leading: IconButton(icon: Icon(Icons.arrow_back_rounded),onPressed: () {
          //   Navigator.pop(context, MaterialPageRoute(builder: (_)=> HomeApp()));},),
          backgroundColor: Colors.white,
          title: Text('Theory Content',style: TextStyle(color: Color.fromRGBO(0, 0, 0, 1),fontFamily: 'NotoSansMid',fontSize: 26),),
        ),
        backgroundColor: Color.fromRGBO(246, 246, 246,1),
        body: Center(
          child: PageView(
            controller: screenControl,
            children: [


              Container(
                child:  ListView(
                  children:[

                    Container(
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.all(10),
                        child: GestureDetector(
                          onTap: (){setState(() {

                            tapbox[0] = !tapbox[0];});},
                          child: AnimatedCrossFade(
                            duration: CrossFadeDuration,
                            firstChild: RichText(text:
                            TextSpan( children: <TextSpan>[
                              TextSpan(text: 'What is Guitar Raag..? ',style:HeadingTextStyle),
                              TextSpan(text: readMoreText,style:readMoreTextStyle),

                            ],),),
                            secondChild: RichText(
                              textAlign: TextAlign.justify,
                              text:
                            TextSpan( children: <TextSpan>[
                              TextSpan(text: 'What is Guitar Raag..? ',style:HeadingTextStyle),
                              TextSpan(text: ''
                                  'It is an Android Application that helps western music students or composers to Accompany or compose in Carnatic music. It can be used for learning or Finding the ',
                                  style: normalTextStyle),
                              TextSpan(text: 'Family of chords for melakarta Ragas.',
                                  style:ImportantNormal),
                              TextSpan(text:
                              '\n\nThis application works based on music theory, if you do not know any, or if you know some, no problem at all, cause this app also provides theory content, which you can use to learn how the music theory works and how this app works.'
                                  '\n\nMusic theory is an ocean where there is no limit of learning, this app provides theory materials that are limited. Sufficient enough to calculate the Family of chords for melakarta ragas on your own, even if you don’t know anything about music theory.'
                                  ,style: normalTextStyle),
                            ],),),
                            crossFadeState: tapbox[0] ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                          ),
                        )),
                    // tapbox[0]

                    Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.all(10),
                      child: RichText(
                        textAlign: TextAlign.justify,
                        text:TextSpan( children: <TextSpan>[
                          TextSpan(text: 'The Basics and Fundamentals of western music includes',style: normalTextStyle),
                        ],),),
                    ),

                    GestureDetector(onTap: () {screenControl.animateToPage(1,duration:Duration(milliseconds: 500), curve: Curves.easeIn);},
                        child: Container(alignment: Alignment.topLeft,padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Text('> An Overview of western music',style: Theory_page_links,))),

                    GestureDetector(onTap: () {screenControl.animateToPage(1,duration:Duration(milliseconds: 500), curve: Curves.easeIn);},
                        child: Container(alignment: Alignment.topLeft,padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Text('\n> Notes In Western Music',style: Theory_page_links,))),

                    GestureDetector(onTap: () {screenControl.animateToPage(2,duration:Duration(milliseconds: 500), curve: Curves.easeIn);},
                        child: Container(alignment: Alignment.topLeft,padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Text('\n> Scales',style: Theory_page_links,))),

                    GestureDetector(onTap: () {screenControl.animateToPage(3,duration:Duration(milliseconds: 500), curve: Curves.easeIn);},
                        child: Container(alignment: Alignment.topLeft,padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Text('\n> Chords',style: Theory_page_links,))),

                    Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.all(10),
                      child: RichText(
                        textAlign: TextAlign.justify,
                        text:TextSpan( children: <TextSpan>[
                          TextSpan(text: '\nThe complete music theory behind this application includes all the basics of western music and.!',style: normalTextStyle),
                        ],),),
                    ),

                    GestureDetector(onTap: () {screenControl.animateToPage(4,duration:Duration(milliseconds: 500), curve: Curves.easeIn);},
                      child: Container(alignment: Alignment.topLeft,padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text('> Intervals',style: Theory_page_links,)),),

                    GestureDetector(onTap: () {screenControl.animateToPage(5,duration:Duration(milliseconds: 500), curve: Curves.easeIn);},
                      child: Container(alignment: Alignment.topLeft,padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text('\n> Family of Chords\n',style: Theory_page_links,)),),

                    Divider(indent: 100,endIndent: 100,),

                    GestureDetector(onTap: () {screenControl.animateToPage(6,duration:Duration(milliseconds: 500), curve: Curves.easeIn);},
                      child: Container(alignment: Alignment.topLeft,padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text('\n> Introduction to Carnatic Music',style: Theory_page_links,)),),

                    GestureDetector(onTap: () {screenControl.animateToPage(6,duration:Duration(milliseconds: 500), curve: Curves.easeIn);},
                      child: Container(alignment: Alignment.topLeft,padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text('\n> Carnatic music Nomenclature',style: Theory_page_links,)),),

                    GestureDetector(onTap: () {screenControl.animateToPage(7,duration:Duration(milliseconds: 500), curve: Curves.easeIn);},
                      child: Container(alignment: Alignment.topLeft,padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text('\n> Introduction to Melakarta Raagas',style: Theory_page_links,)),),

                    GestureDetector(onTap: () {screenControl.animateToPage(8,duration:Duration(milliseconds: 500), curve: Curves.easeIn);},
                      child: Container(alignment: Alignment.topLeft,padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text('\n> System of Melakarta Raagas',style: Theory_page_links,)),),

                    GestureDetector(onTap: () {screenControl.animateToPage(9,duration:Duration(milliseconds: 500), curve: Curves.easeIn);},
                      child: Container(alignment: Alignment.topLeft,padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text('\n\n> How Guitar Raag works..?',style:HeadingTextStyle,)),),

                    GestureDetector(onTap: () {screenControl.animateToPage(10,duration:Duration(milliseconds: 500), curve: Curves.easeIn);},
                      child: Container(alignment: Alignment.topLeft,padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text('\n> Why Guitar Raag..?',style:HeadingTextStyle,)),),


                    // Container(margin: EdgeInsets.all(20),),
                    //
                    //
                    // ElevatedButton(onPressed: () {screenControl.nextPage(duration:Duration(milliseconds: 500), curve: Curves.easeIn);},
                    //     child:Text('Proceed',style: TextStyle(color: Color.fromRGBO(11, 111,244,1)),)),

                  ],),
              ),
              //screen 1

              //screen 2
              Container(
                child:  ListView(
                  children:[
                    AppBar(
                      title: Text('Fundamentals of western Music ',style:Theory_AppBar,),
                      backgroundColor: Colors.white,
                      actions: <Widget>[
                        IconButton(icon: Icon(Icons.chevron_left_outlined,size: 30,),
                          onPressed: () {screenControl.previousPage(duration:Duration(milliseconds: 500), curve: Curves.easeIn);},),
                        IconButton(icon: Icon(Icons.chevron_right_outlined,size: 30,),
                          onPressed: () {screenControl.nextPage(duration:Duration(milliseconds: 500), curve: Curves.easeIn);},),
                      ],),

                    Container(
                      decoration: theory_nobox_decoration,
                      padding:theory_nobox_padding,
                      margin: theory_nobox_margin,
                      child: RichText(
                        textAlign: TextAlign.justify,
                        text:
                        TextSpan( children: <TextSpan>[
                          TextSpan(
                              text: 'AN OVERVIEW OF WESTERN MUSIC\n',
                              style:HeadingTextStyle),
                          TextSpan(text: '\n'
                              'The musical traditions and genres that originated in Western cultures—mostly in Europe and then the Americas—are referred to as Western music. Every musical tradition has its own foundations and principles, and the people of that western region and their era (nearly the 1800s. ) have influenced and embraced the foundations of western music.',
                              style: normalTextStyle),


                        ],),),
                    ),
                    ////Overview

                    Container(
                        decoration: theory_box_decoration,
                        padding:theory_box_padding,
                        margin: theory_box_margin,
                        child: GestureDetector(
                          onTap: (){setState(() {
                            tapbox[1] = !tapbox[1];
                          });},
                          child: AnimatedCrossFade(
                            duration: CrossFadeDuration,
                            firstChild: RichText(text:
                            TextSpan( children: <TextSpan>[
                              TextSpan(text: 'Notes in western music ',style: HeadingTextStyle),
                              TextSpan(text: readMoreText,style:readMoreTextStyle),

                            ],),),
                            secondChild: RichText(
                              textAlign: TextAlign.justify,
                              text:
                              TextSpan( children: <TextSpan>[
                                TextSpan(text: 'Notes in western music ',style: HeadingTextStyle),
                                TextSpan(text: '\n\nThe most fundamental building blocks of all music are notes, which are discrete and isolatable sounds. The letters A, B, C, D, E, F, and G are used to name these notes, which are repeated in a cycle.In other words, the A appears again after the G.',style:normalTextStyle),

                              ],),),
                            crossFadeState: tapbox[1] ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                          ),
                        )),
                    ////Notes TapBox 1

                    Container(
                      decoration: theory_nobox_decoration,
                      padding:theory_nobox_padding,
                      margin: theory_nobox_margin,
                      child: RichText(
                        textAlign: TextAlign.center,
                        text:
                        TextSpan( children: <TextSpan>[
                          TextSpan(text: 'C -> C# -> D -> D# -> E - F - F# G - G# - A - A# - B - C',style:normalTextStyle.copyWith(color: Colors.black)),
                          TextSpan(text: '\nThe Cycle of notes',style: ImportantNormal)



                        ],),),
                    ),
                    ////Cycle of Notes

                    Container(
                        decoration: theory_box_decoration,
                        padding:theory_box_padding,
                        margin: theory_box_margin,
                        child: GestureDetector(
                          onTap: (){setState(() {
                            tapbox[2] = !tapbox[2];
                          });},
                          child: AnimatedCrossFade(
                            duration: CrossFadeDuration,
                            firstChild: RichText(text:
                            TextSpan( children: <TextSpan>[
                              TextSpan(text: 'Semitone ',style: HeadingTextStyle),
                              TextSpan(text: readMoreText,style:readMoreTextStyle),

                            ],),),
                            secondChild: RichText(
                              textAlign: TextAlign.justify,
                              text:
                              TextSpan( children: <TextSpan>[
                                TextSpan(text: 'Semitone ',style: HeadingTextStyle),
                                TextSpan(text: '\n\nEach of the arrows represents one semitone, in western music this Semitone plays a major role, which will be explained in the upcoming chapters.! To summarize 1 arrow = 1 semitone, 2 semitone = 1 Tone',style:normalTextStyle),

                              ],),),
                            crossFadeState: tapbox[2] ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                          ),
                        )),
                    ////Semitone TapBox 2

                    Container(
                        decoration: theory_box_decoration,
                        padding:theory_box_padding,
                        margin: theory_box_margin,
                        child: GestureDetector(
                          onTap: (){setState(() {
                            tapbox[3] = !tapbox[3];
                          });},
                          child: AnimatedCrossFade(
                            duration: CrossFadeDuration,
                            firstChild: RichText(text:
                            TextSpan( children: <TextSpan>[
                              TextSpan(text: 'Symbols ',style: HeadingTextStyle),
                              TextSpan(text: readMoreText,style:readMoreTextStyle),

                            ],),),
                            secondChild: RichText(
                              textAlign: TextAlign.justify,
                              text:
                              TextSpan( children: <TextSpan>[
                                TextSpan(text: 'Symbols ',style: HeadingTextStyle),
                                TextSpan(text: '\n\nWe know that the cycle of notes, contains 12 unique notes, these notes are classified in to three categories, they are',style:normalTextStyle),

                                TextSpan(text: '\n\nSharp (♯)',style: HeadingTextStyle.copyWith(fontSize: 14,color: Color.fromRGBO(11, 111, 244, 1))),
                                TextSpan(text: '\n\nThe # symbol is termed as Sharp. A#, C#, D#, F#, and G# are examples of notes that are one semitone next to the specified alphabet. For example, C# is one semitone next to C rather than D; it falls between the notes C and D. Only the given notes A, C, D, F, and G have sharp values; there are a total of 5 sharp notes in western music,',style:normalTextStyle),

                                TextSpan(text: '\n\nFlat (♭)',style: HeadingTextStyle.copyWith(fontSize: 14,color: Color.fromRGBO(11, 111, 244, 1))),
                                TextSpan(text: '\n\nIn a similar way, the b symbol denotes flat notes. The note that is one semitone below the specified alphabet, i.e Gb = F#, which falls between G and F. There are 5 flat notes in A, B, D, E, and G. These sharp and flat notes are enharmonic, i.e. they denote the same note, with different names and symbols and so 5 flat / sharp notes are unique in western music.',style:normalTextStyle),

                                TextSpan(text: '\n\nNatural note (♮)',style: HeadingTextStyle.copyWith(fontSize: 14,color: Color.fromRGBO(11, 111, 244, 1))),
                                TextSpan(text: '\n\nThere are seven natural notes, which are the standard A, B, C, D, E, F, and G. Twelve distinct tones are produced by combining them.',style:normalTextStyle),



                              ],),),
                            crossFadeState: tapbox[3] ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                          ),
                        )),
                    ////Symbols TapBox 3

                    // Container(
                    //     decoration: theory_box_decoration,
                    //     padding:theory_box_padding,
                    //     margin: theory_box_margin,
                    //     child: GestureDetector(
                    //       onTap: (){setState(() {
                    //         tapbox[4] = !tapbox[4];
                    //       });},
                    //       child: AnimatedCrossFade(
                    //         duration: CrossFadeDuration,
                    //         firstChild: RichText(text:
                    //         TextSpan( children: <TextSpan>[
                    //           TextSpan(text: 'Sharp ',style: HeadingTextStyle),
                    //           TextSpan(text: readMoreText,style:readMoreTextStyle),
                    //
                    //         ],),),
                    //         secondChild: RichText(
                    //           textAlign: TextAlign.justify,
                    //           text:
                    //           TextSpan( children: <TextSpan>[
                    //             TextSpan(text: 'Sharp ',style: HeadingTextStyle),
                    //             TextSpan(text: '\n\nThe # symbol is termed as Sharp. A#, C#, D#, F#, and G# are examples of notes that are one semitone next to the specified alphabet. For example, C# is one semitone next to C rather than D; it falls between the notes C and D. Only the given notes A, C, D, F, and G have sharp values; there are a total of 5 sharp notes in western music,',style:normalTextStyle),
                    //
                    //           ],),),
                    //         crossFadeState: tapbox[4] ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                    //       ),
                    //     )),
                    // ////Sharp
                    //
                    // Container(
                    //     decoration: theory_box_decoration,
                    //     padding:theory_box_padding,
                    //     margin: theory_box_margin,
                    //     child: GestureDetector(
                    //       onTap: (){setState(() {
                    //         tapbox[5] = !tapbox[5];
                    //       });},
                    //       child: AnimatedCrossFade(
                    //         duration: CrossFadeDuration,
                    //         firstChild: RichText(text:
                    //         TextSpan( children: <TextSpan>[
                    //           TextSpan(text: 'Flat ',style: HeadingTextStyle),
                    //           TextSpan(text: readMoreText,style:readMoreTextStyle),
                    //
                    //         ],),),
                    //         secondChild: RichText(
                    //           textAlign: TextAlign.justify,
                    //           text:
                    //           TextSpan( children: <TextSpan>[
                    //             TextSpan(text: 'Flat',style: HeadingTextStyle),
                    //             TextSpan(text: '\n\nIn a similar way, the b symbol denotes flat notes. The note that is one semitone below the specified alphabet, i.e Gb = F#, which falls between G and F. There are 5 flat notes in A, B, D, E, and G. These sharp and flat notes are enharmonic, i.e. they denote the same note, with different names and symbols and so 5 flat / sharp notes are unique in western music.',style:normalTextStyle),
                    //
                    //           ],),),
                    //         crossFadeState: tapbox[5] ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                    //       ),
                    //     )),
                    // ////Flat
                    //
                    // Container(
                    //     decoration: theory_box_decoration,
                    //     padding:theory_box_padding,
                    //     margin: theory_box_margin,
                    //     child: GestureDetector(
                    //       onTap: (){setState(() {
                    //         tapbox[6] = !tapbox[6];
                    //       });},
                    //       child: AnimatedCrossFade(
                    //         duration: CrossFadeDuration,
                    //         firstChild: RichText(text:
                    //         TextSpan( children: <TextSpan>[
                    //           TextSpan(text: 'Natural note ',style: HeadingTextStyle),
                    //           TextSpan(text: readMoreText,style:readMoreTextStyle),
                    //
                    //         ],),),
                    //         secondChild: RichText(
                    //           textAlign: TextAlign.justify,
                    //           text:
                    //           TextSpan( children: <TextSpan>[
                    //             TextSpan(text: 'Natural note',style: HeadingTextStyle),
                    //             TextSpan(text: '\n\nThere are seven natural notes, which are the standard A, B, C, D, E, F, and G. Twelve distinct tones are produced by combining them.',style:normalTextStyle),
                    //
                    //           ],),),
                    //         crossFadeState: tapbox[6] ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                    //       ),
                    //     )),
                    // ////Natural Note

                    Container(
                        decoration: theory_box_decoration,
                        padding:theory_box_padding,
                        margin: theory_box_margin,
                        child: GestureDetector(
                          onTap: (){setState(() {
                            tapbox[4] = !tapbox[4];
                          });},
                          child: AnimatedCrossFade(
                            duration: CrossFadeDuration,
                            firstChild: RichText(text:
                            TextSpan( children: <TextSpan>[
                              TextSpan(text: 'Creating own Cycle of notes ',style: HeadingTextStyle),
                              TextSpan(text: readMoreText,style:readMoreTextStyle),

                            ],),),
                            secondChild: RichText(
                              textAlign: TextAlign.justify,
                              text:
                              TextSpan( children: <TextSpan>[
                                TextSpan(text: 'Creating own Cycle of notes',style: HeadingTextStyle),
                                TextSpan(text:'\n\nThere is no order in the Cycle of notes, This order is commonly used everywhere, although it may be used to create a variety of cycles, such as a cycle starting from B',style:normalTextStyle),
                                TextSpan(text:'\n\n B -> C C#. B',style:ImportantNormal),
                                TextSpan(text:'\n\nis also the same. You can simply use this cycle or create your own based on your needs, while making a convenient order of notes ensure that there are five flat or sharp notes, seven natural notes, and a total of twelve notes.',style:normalTextStyle),

                              ],),),
                            crossFadeState: tapbox[4] ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                          ),
                        )),
                    ////Creating own Cycle of notes TapBox 4

                    Container(
                        decoration: theory_box_decoration,
                        padding:theory_box_padding,
                        margin: theory_box_margin,
                        child: GestureDetector(
                          onTap: (){setState(() {
                            tapbox[5] = !tapbox[5];
                          });},
                          child: AnimatedCrossFade(
                            duration: CrossFadeDuration,
                            firstChild: RichText(text:
                            TextSpan( children: <TextSpan>[
                              TextSpan(text: 'Octave ',style: HeadingTextStyle),
                              TextSpan(text: readMoreText,style:readMoreTextStyle),

                            ],),),
                            secondChild: RichText(
                              textAlign: TextAlign.justify,
                              text:
                              TextSpan( children: <TextSpan>[
                                TextSpan(text: 'Octave',style: HeadingTextStyle),
                                TextSpan(text:'\n\nYou might have noticed that the starting note of a cycle of notes and the ending note of the cycle are the same, this is called the Octave of a note. In Western music, an octave spans eight notes (mostly natural) in the cycle, thus they called it Octave.'
                                    '\n\nDespite the difference in pitch (sound frequency), the two notes sound similar, giving the octave its unique sound quality. Also the Octave of a note, can either be 7 notes behind or after it..! i.e, for the note C the higher C is the one that comes after C -> D -> E -> F -> G -> A -> B -> C, Likewise the lower C is the other direction C…->...E -> D -> C.',style:normalTextStyle),
                              ],),),
                            crossFadeState: tapbox[5] ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                          ),
                        )),
                    ////Octave tapBox 5


                    Container(margin: EdgeInsets.all(50),)

                  ],),
              ),
              //PAGE, Screen 2 overview, NOTES IN WESTERN nOTES tapBox 1 - 5

              //screen 3
              Container(
                child:  ListView(
                  children:[
                    AppBar(
                      title: Text('Scales in Music ',style:Theory_AppBar,),
                      backgroundColor: Colors.white,
                      actions: <Widget>[
                        IconButton(icon: Icon(Icons.chevron_left_outlined,size: 30,),
                          onPressed: () {screenControl.previousPage(duration:Duration(milliseconds: 500), curve: Curves.easeIn);},),
                        IconButton(icon: Icon(Icons.chevron_right_outlined,size: 30,),
                          onPressed: () {screenControl.nextPage(duration:Duration(milliseconds: 500), curve: Curves.easeIn);},),
                      ],),

                    Container(
                      decoration: theory_nobox_decoration,
                      padding:theory_nobox_padding,
                      margin: theory_nobox_margin,
                      child: RichText(
                        textAlign: TextAlign.justify,
                        text:
                        TextSpan( children: <TextSpan>[
                          TextSpan(
                              text: 'AN OVERVIEW OF SCALES IN MUSIC \n',
                              style:HeadingTextStyle),
                          TextSpan(text: '\n'
                              'A scale is an arrangement of notes in either ascending or descending order that creates a progression between a note and its octave. The collection of notes that can be employed in melodies and harmonies is defined as scales, which serve as the basis for music. Every scale has a distinct sound due to its particular interval (step) pattern.',
                              style: normalTextStyle),


                        ],),),
                    ),
                    ////Overview

                    Container(
                        decoration: theory_box_decoration,
                        padding:theory_box_padding,
                        margin: theory_box_margin,
                        child: GestureDetector(
                          onTap: (){setState(() {
                            tapbox[6] = !tapbox[6];
                          });},
                          child: AnimatedCrossFade(
                            duration: CrossFadeDuration,
                            firstChild: RichText(text:
                            TextSpan( children: <TextSpan>[
                              TextSpan(text: 'Interval Pattern for scale ',style: HeadingTextStyle),
                              TextSpan(text: readMoreText,style:readMoreTextStyle),

                            ],),),
                            secondChild: RichText(
                              textAlign: TextAlign.justify,
                              text:
                              TextSpan( children: <TextSpan>[
                                TextSpan(text: 'Interval Pattern for scale',style: HeadingTextStyle),
                                TextSpan(text: '\n\nInterval Patterns in Scales represent the pattern of semitone distances in between the consecutive notes. In early western music 2 semitones are called Whole note and 1 semitone is called as half note, it is common to see these terms in short form as Whole and half when writing interval patterns.',style:normalTextStyle),

                                TextSpan(text: '\n\nExample ',style: HeadingTextStyle),
                                TextSpan(text: '\n\nAssume the scale as C D E F G A B C, the semitone distance calculated from the cycle of notes are as follows'
                                    '\n\nC - D = Whole note, D - E = Whole note, E - F = Half note, and so on, in this way we have to find the distance until we reach the higher C again and when we mark the distances alone we get.',style:normalTextStyle),

                                TextSpan(text: '\n\nWhole, Whole, Half, Whole, Whole, Whole, Half.',style: ImportantNormal),

                                TextSpan(text: '\n\nThis is the interval pattern of the Major Scale, applying this interval pattern on any note will give you the major scale on that note. In other words, this is the formula of Major scale. Similarly every scale has its own Interval pattern.',style:normalTextStyle),
                              ],),),
                            crossFadeState: tapbox[6] ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                          ),
                        )),
                    ////Interval Pattern TapBox 6

                    Container(
                        decoration: theory_box_decoration,
                        padding:theory_box_padding,
                        margin: theory_box_margin,
                        child: GestureDetector(
                          onTap: (){setState(() {
                            tapbox[7] = !tapbox[7];
                          });},
                          child: AnimatedCrossFade(
                            duration: CrossFadeDuration,
                            firstChild: RichText(text:
                            TextSpan( children: <TextSpan>[
                              TextSpan(text: 'Basic Types of Scales ',style: HeadingTextStyle),
                              TextSpan(text: readMoreText,style:readMoreTextStyle),

                            ],),),
                            secondChild: RichText(
                              textAlign: TextAlign.justify,
                              text:
                              TextSpan( children: <TextSpan>[
                                TextSpan(text: 'Basic Types of Scales ',style: HeadingTextStyle),
                                TextSpan(text: '\n\nThere are various types of scales in western music, some of the scales that are easy to understand, and commonly used are as follows',style:normalTextStyle),

                                TextSpan(text: '\n\n1. Chromatic Scale:' ,style: ImportantNormal.copyWith(fontWeight: FontWeight.bold)),
                                TextSpan(text: ' A scale with all 12 notes of the western music, each note is only half a step apart.',style:normalTextStyle),

                                TextSpan(text: '\n\n2. Major Scale:' ,style: ImportantNormal.copyWith(fontWeight: FontWeight.bold)),
                                TextSpan(text: '  A bright and happy-sounding scale. ',style:normalTextStyle),
                                TextSpan(text: '\n\nInterval Pattern:',style: ImportantNormal.copyWith(color: Colors.black)),
                                TextSpan(text: '  Whole, Whole, Half, Whole, Whole, Whole, Half. ',style:normalTextStyle),
                                TextSpan(text: '\n\nExample: ',style:ImportantNormal.copyWith(color: Colors.black)),
                                TextSpan(text: ' G Major (G, A, B, C, D, E, F#, G).',style:normalTextStyle),

                                TextSpan(text: '\n\n3. Minor Scale::' ,style: ImportantNormal.copyWith(fontWeight: FontWeight.bold)),
                                TextSpan(text: ' A scale with all 12 notes of the western music, each note is only half a step apart.',style:normalTextStyle),
                                TextSpan(text: '\n\nNatural Minor Interval Pattern:',style: ImportantNormal.copyWith(color: Colors.black)),
                                TextSpan(text: '  Whole, Half, Whole, Whole, Half, Whole, Whole.',style:normalTextStyle),
                                TextSpan(text: '\n\nExample: ',style:ImportantNormal.copyWith(color: Colors.black)),
                                TextSpan(text: ' A Minor (A, B, C, D, E, F, G, A).',style:normalTextStyle),

                                TextSpan(text: '\n\n4. Major Pentatonic Scale:' ,style: ImportantNormal.copyWith(fontWeight: FontWeight.bold)),
                                TextSpan(text: ' A simple five-note scale found in many musical traditions.',style:normalTextStyle),
                                TextSpan(text: '\n\nExample: ',style:ImportantNormal.copyWith(color: Colors.black)),
                                TextSpan(text: 'C Major Pentatonic (C, D, E, G, A).',style:normalTextStyle),



                              ],),),
                            crossFadeState: tapbox[7] ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                          ),
                        )),
                    ////Types of Scales TapBox 7

                    Container(margin: EdgeInsets.all(50),)
                  ],),
              ),
              //PAGE, Screen 3 Scales TapBox 6, 7

              //screen 4
              Container(
                child:  ListView(
                  children:[
                    AppBar(
                      title: Text('Chords in Music ',style:Theory_AppBar,),
                      backgroundColor: Colors.white,
                      actions: <Widget>[
                        IconButton(icon: Icon(Icons.chevron_left_outlined,size: 30,),
                          onPressed: () {screenControl.previousPage(duration:Duration(milliseconds: 500), curve: Curves.easeIn);},),
                        IconButton(icon: Icon(Icons.chevron_right_outlined,size: 30,),
                          onPressed: () {screenControl.nextPage(duration:Duration(milliseconds: 500), curve: Curves.easeIn);},),
                      ],),

                    Container(
                      decoration: theory_nobox_decoration,
                      padding:theory_nobox_padding,
                      margin: theory_nobox_margin,
                      child: RichText(
                        textAlign: TextAlign.justify,
                        text:
                        TextSpan( children: <TextSpan>[
                          TextSpan(
                              text: 'AN OVERVIEW OF CHORDS IN MUSIC \n',
                              style:HeadingTextStyle),
                          TextSpan(text: '\n'
                              'A chord is a combination of two or more notes played together to create harmonious music. Chords are essential in music because they provide depth and support to melodies. Most commonly, chords are built from three notes, called triads, but they can also include more notes for richer sounds.',
                              style: normalTextStyle),


                        ],),),
                    ),
                    ////Overview

                    Container(
                        decoration: theory_box_decoration,
                        padding:theory_box_padding,
                        margin: theory_box_margin,
                        child: GestureDetector(
                          onTap: (){setState(() {
                            tapbox[8] = !tapbox[8];
                          });},
                          child: AnimatedCrossFade(
                            duration: CrossFadeDuration,
                            firstChild: RichText(text:
                            TextSpan( children: <TextSpan>[
                              TextSpan(text: 'Basic Types of Chords ',style: HeadingTextStyle),
                              TextSpan(text: readMoreText,style:readMoreTextStyle),

                            ],),),
                            secondChild: RichText(
                              textAlign: TextAlign.justify,
                              text:
                              TextSpan( children: <TextSpan>[
                                TextSpan(text: 'Basic Types of Chords',style: HeadingTextStyle),
                                TextSpan(text: '\n\nThere are various types of chords, this is not only based on the number of notes that the chord has, but based on the feel that chord creates to the listener. Based on the feeling and emotions there are multiple types of chords, some of the popular chord types are as follows,',style:normalTextStyle),

                                 TextSpan(text: '\n\n1. Major Chord: ' ,style: ImportantNormal.copyWith(fontWeight: FontWeight.bold)),
                                TextSpan(text: 'Bright and happy-sounding',style:normalTextStyle),

                                TextSpan(text: '\n\n2. Minor Chord: ' ,style: ImportantNormal.copyWith(fontWeight: FontWeight.bold)),
                                TextSpan(text: 'Darker and more emotional.',style:normalTextStyle),

                                TextSpan(text: '\n\n3. Diminished Chord: ' ,style: ImportantNormal.copyWith(fontWeight: FontWeight.bold)),
                                TextSpan(text: 'Tense',style:normalTextStyle),

                                TextSpan(text: '\n\n4. Augmented Chord: ' ,style: ImportantNormal.copyWith(fontWeight: FontWeight.bold)),
                                TextSpan(text: 'Dreamy or suspenseful.',style:normalTextStyle),

                                TextSpan(text: '\n\n5. 7th Chord: ' , style: ImportantNormal.copyWith(fontWeight: FontWeight.bold)),
                                TextSpan(text: 'Complex, unresolved has 4 notes.',style:normalTextStyle),

                                TextSpan(text: '\n\nTo form these chords on your own, you can use the formulas.',style:normalTextStyle),

                                TextSpan(text: '\n\nExample ',style: HeadingTextStyle),

                                TextSpan(text: '\n\nMajor =  Root + 4 + 3 (Formula of Major Chord)'
                                    '\n\nThe Root note denotes the starting note, i.e in C Major chord C is the Root, the basic given note is the root. That 4 and 3 are the number of semitones to be taken. Example, we find chords for F Major. For this the Root note = F, +4 semitone = A, + 3 semitones from A = C, and so we get'
                                    ' \"F A C (F Major Chord)\", similarly using formulas we can find any chord for any note.'
                                    ,style:normalTextStyle),

                              ],),),
                            crossFadeState: tapbox[8] ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                          ),
                        )),
                    ////Chord Types TapBox 8

                    Container(
                        decoration: theory_box_decoration,
                        padding:theory_box_padding,
                        margin: theory_box_margin,
                        child: GestureDetector(
                          onTap: (){setState(() {
                            tapbox[9] = !tapbox[9];
                          });},
                          child: AnimatedCrossFade(
                            duration: CrossFadeDuration,
                            firstChild: RichText(text:
                            TextSpan( children: <TextSpan>[
                              TextSpan(text: 'Formulas for chord types ',style: HeadingTextStyle),
                              TextSpan(text: readMoreText,style:readMoreTextStyle),

                            ],),),
                            secondChild: RichText(
                              textAlign: TextAlign.justify,
                              text:
                              TextSpan( children: <TextSpan>[
                                TextSpan(text: 'Formulas for chord types ',style: HeadingTextStyle),

                                TextSpan(text: '\n\n1. Major Chord: ' ,style: normalTextStyle),
                                TextSpan(text: 'R+4+3.',style:ImportantNormal.copyWith(fontWeight: FontWeight.bold)),

                                TextSpan(text: '\n\n2. Minor Chord: ' ,style: normalTextStyle),
                                TextSpan(text: 'R+3+4.',style:ImportantNormal.copyWith(fontWeight: FontWeight.bold)),

                                TextSpan(text: '\n\n3. Diminished Chord: ' ,style: normalTextStyle),
                                TextSpan(text: 'R+3+3.',style:ImportantNormal.copyWith(fontWeight: FontWeight.bold)),

                                TextSpan(text: '\n\n4. Augmented Chord: ' ,style: normalTextStyle),
                                TextSpan(text: 'R+4+4.',style:ImportantNormal.copyWith(fontWeight: FontWeight.bold)),

                                TextSpan(text: '\n\n5. 7th Chord: ' , style: normalTextStyle),
                                TextSpan(text: 'R+4+3+3.',style:ImportantNormal.copyWith(fontWeight: FontWeight.bold)),

                              ],),),
                            crossFadeState: tapbox[9] ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                          ),
                        )),
                    ////Chord Formulas of Scales TapBox 9

                    Container(margin: EdgeInsets.all(50),)
                  ],),
              ),
              //PAGE, Screen 4 chords TaoBox 8, 9

              //screen 5
              Container(
                child:  ListView(
                  children:[
                    AppBar(
                      title: Text('Intervals ',style:Theory_AppBar,),
                      backgroundColor: Colors.white,
                      actions: <Widget>[
                        IconButton(icon: Icon(Icons.chevron_left_outlined,size: 30,),
                          onPressed: () {screenControl.previousPage(duration:Duration(milliseconds: 500), curve: Curves.easeIn);},),
                        IconButton(icon: Icon(Icons.chevron_right_outlined,size: 30,),
                          onPressed: () {screenControl.nextPage(duration:Duration(milliseconds: 500), curve: Curves.easeIn);},),
                      ],),

                    Container(
                      decoration: theory_nobox_decoration,
                      padding:theory_nobox_padding,
                      margin: theory_nobox_margin,
                      child: RichText(
                        textAlign: TextAlign.justify,
                        text:
                        TextSpan( children: <TextSpan>[
                          TextSpan(text:'An interval in music is the distance between two notes. Intervals are measured by counting the steps in between the two given notes, from the lowest pitch to highest Pitch. In other words, based on the number of arrows given in between 2 notes in the cycle of notes in western notes we classify the distance.',style: normalTextStyle),
                        ],),),
                    ),
                    ////Overview

                    Container(
                        decoration: theory_box_decoration,
                        padding:theory_box_padding,
                        margin: theory_box_margin,
                        child: GestureDetector(
                          onTap: (){setState(() {
                            tapbox[10] = !tapbox[10];
                          });},
                          child: AnimatedCrossFade(
                            duration: CrossFadeDuration,
                            firstChild: RichText(text:
                            TextSpan( children: <TextSpan>[
                              TextSpan(text: 'Types of Intervals ',style: HeadingTextStyle),
                              TextSpan(text: readMoreText,style:readMoreTextStyle),

                            ],),),
                            secondChild: RichText(
                              textAlign: TextAlign.justify,
                              text:
                              TextSpan( children: <TextSpan>[
                                TextSpan(text: 'Types of Intervals ',style: HeadingTextStyle),

                                TextSpan(text:'\n\nIn Western Music there is an interval name for each interval measure, that is if the distance is 4 Steps it is called Major 3, If the distance is 2 Steps it is called Major 2, likewise for every possible step there is an unique interval.', style: normalTextStyle),
                                TextSpan(text:'\n\nThe intervals are classified into 5 Types ',style: normalTextStyle),
                                TextSpan(text:' Major, Minor, Perfect, Diminished, Augmented.', style: ImportantNormal),

                                TextSpan(text: '\n\nMajor Intervals ',style: HeadingTextStyle),
                                TextSpan(text: '\n\nMajor 2 = 2 semitones, \nMajor 3 = 4 semitones, \nMajor 6 = 9 semitones, \nMajor 7 = 11 semitones,',style:normalTextStyle),

                                TextSpan(text: '\n\nMinor  Intervals ',style: HeadingTextStyle),
                                TextSpan(text: '\n\nminor 2 = 1 semitones, \nminor 3 = 3 semitones, \nminor 6 = 8 semitones, \nminor 7 = 10 semitones,',style:normalTextStyle),

                                TextSpan(text: '\n\nPefect  Intervals ',style: HeadingTextStyle),
                                TextSpan(text: '\n\nUnison = 0 semitones, \nPerfect 4 = 5 semitones, \nPerfect 5 = 7 semitones , \nOctave = 12 semitones ,',style:normalTextStyle),

                                TextSpan(text: '\n\nAugmented Intervals ',style: HeadingTextStyle),
                                TextSpan(text: '\n\nThe Augmented is a type of interval which is derived when adding 1 semitone to the Major or Perfect interval. ',style:normalTextStyle),

                                TextSpan(text: '\n\nDiminshed Intervals ',style: HeadingTextStyle),
                                TextSpan(text: '\n\nThe Diminished is a type of interval that is derived when we reduce 1 semitone from minor or perfect interval',style:normalTextStyle),

                              ],),),
                            crossFadeState: tapbox[10] ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                          ),
                        )),
                    ////Interval Types TapBox 10

                    Container(
                        decoration: theory_box_decoration,
                        padding:theory_box_padding,
                        margin: theory_box_margin,
                        child: GestureDetector(
                          onTap: (){setState(() {
                            tapbox[11] = !tapbox[11];
                          });},
                          child: AnimatedCrossFade(
                            duration: CrossFadeDuration,
                            firstChild: RichText(text:
                            TextSpan( children: <TextSpan>[
                              TextSpan(text: 'Table of Intervals ',style: HeadingTextStyle),
                              TextSpan(text: readMoreText,style:readMoreTextStyle),

                            ],),),
                            secondChild: Image(image: AssetImage('assets/images/Interval_Table.png'),),

                            crossFadeState: tapbox[11] ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                          ),
                        )),
                    ////Interval TableTapBox 11
                    Container(margin: EdgeInsets.all(50),)
                  ],),
              ),
              //PAGE, Screen 5 Intervals TapBox 10, 11

              //screen 6
              Container(
                child:  ListView(
                  children:[
                    AppBar(
                      title: Text('Family of Chords ',style:Theory_AppBar,),
                      backgroundColor: Colors.white,
                      actions: <Widget>[
                        IconButton(icon: Icon(Icons.chevron_left_outlined,size: 30,),
                          onPressed: () {screenControl.previousPage(duration:Duration(milliseconds: 500), curve: Curves.easeIn);},),
                        IconButton(icon: Icon(Icons.chevron_right_outlined,size: 30,),
                          onPressed: () {screenControl.nextPage(duration:Duration(milliseconds: 500), curve: Curves.easeIn);},),
                      ],),

                    Container(
                      decoration: theory_nobox_decoration,
                      padding:theory_nobox_padding,
                      margin: theory_nobox_margin,
                      child: RichText(
                        textAlign: TextAlign.justify,
                        text:
                        TextSpan( children: <TextSpan>[
                          TextSpan(text:'The Family of chords is a group of chords that sound different when listened, separately but they belong to the same scale and they are built from the same scale. This helps musicians bring various flavours to music from a single given scale, without including notes that are not in the scale.'
                              '\n\nTo find chords in a scale, you build them by stacking the alternative notes of the scale, starting from each note of the scale. This process gives you a family of chords that belong to the scale.',style: normalTextStyle),
                        ],),),
                    ),
                    ////Overview

                    Container(
                        decoration: theory_box_decoration,
                        padding:theory_box_padding,
                        margin: theory_box_margin,
                        child: GestureDetector(
                          onTap: (){setState(() {
                            tapbox[12] = !tapbox[12];
                          });},
                          child: AnimatedCrossFade(
                            duration: CrossFadeDuration,
                            firstChild: RichText(text:
                            TextSpan( children: <TextSpan>[
                              TextSpan(text: 'Steps to Find Chords ',style: HeadingTextStyle),
                              TextSpan(text: readMoreText,style:readMoreTextStyle),

                            ],),),
                            secondChild: RichText(
                              textAlign: TextAlign.justify,
                              text:
                              TextSpan( children: <TextSpan>[
                                TextSpan(text: 'Steps to Find Chords ',style: HeadingTextStyle),

                                TextSpan(text:'\n\n1. List the Scale Notes', style: ImportantNormal),
                                TextSpan(text:'\n\nFor example, the C Major scale has the notes C, D, E, F, G, A, and B.', style: normalTextStyle),

                                TextSpan(text:'\n\n2. Start with Each Note', style: ImportantNormal),
                                TextSpan(text:'\n\nBegin with the first note (root) and take every other note to form a triad. For C: C (root), E (third), G (fifth) → C Major.', style: normalTextStyle),

                                TextSpan(text:'\n\n3. Repeat for Each Note', style: ImportantNormal),
                                TextSpan(text:'\n\nContinue this process for each scale note', style: normalTextStyle),
                                TextSpan(text:'\n\nD: D, F, A → D Minor. \nE: E, G, B → E Minor. \nF: F, A, C → F Major. \nG: G, B, D → G Major. \nA: A, C, E → A Minor. \nB: B, D, F → B Diminished.', style: normalTextStyle),


                                TextSpan(text:'\n\nResulting Chords ',style: HeadingTextStyle),

                                TextSpan(text: '\n\nThe chords in the C Major scale are: C Major, D Minor, E Minor, F Major, G Major, A Minor, B Diminished.'
                                    '\n\nThis family includes all the chords that naturally fit within the scale, making them harmonically compatible. That is the chords C Major, D Minor, E Minor, F Major, G Major, A Minor, and B Diminished form the family of chords in the C Major scale. This term emphasizes the close relationship between these chords and the scale they belong to.'
                                    '\n\nEach chord in the family has its own role: some sound strong and stable (called Major Chords), while others sound gentle or more emotional (called Minor Chords). There’s also a special chord called the Diminished Chord, which adds a little tension or mystery. Together, these chords work like puzzle pieces to create the harmony of a song.'
                                    '\n\nBy knowing the family of chords, you can understand how music moves and feels, even if you’re just starting to explore!'
                                    ,style:normalTextStyle),

                              ],),),
                            crossFadeState: tapbox[12] ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                          ),
                        )
                    ),
                    ////steps Types TapBox 12


                    Container(margin: EdgeInsets.all(50),)
                  ],),
              ),
              //PAGE, Screen 6 Family of Chords TapBox 12

              //screen 7
              Container(
                child:  ListView(
                  children:[
                    AppBar(
                      title: Text('Introduction to Carnatic Music ',style:Theory_AppBar,),
                      backgroundColor: Colors.white,
                      actions: <Widget>[
                        IconButton(icon: Icon(Icons.chevron_left_outlined,size: 30,),
                          onPressed: () {screenControl.previousPage(duration:Duration(milliseconds: 500), curve: Curves.easeIn);},),
                        IconButton(icon: Icon(Icons.chevron_right_outlined,size: 30,),
                          onPressed: () {screenControl.nextPage(duration:Duration(milliseconds: 500), curve: Curves.easeIn);},),
                      ],),

                    Container(
                      decoration: theory_nobox_decoration,
                      padding:theory_nobox_padding,
                      margin: theory_nobox_margin,
                      child: RichText(
                        textAlign: TextAlign.justify,
                        text:
                        TextSpan( children: <TextSpan>[
                          TextSpan(text:''
                              'Carnatic music is a classical music tradition from South India, known for its rich and intricate melodies. It revolves around ragas (melodic frameworks) and talas (rhythmic cycles) that create its unique identity. Improvisation is a key feature, allowing artists to explore and expand the raga\'s mood. Lyrics, often devotional, play an important role, blending spirituality with musical artistry. It is a deeply structured and highly emotive art form, preserving centuries-old traditions.'
                          '\n\nIt is a common misconception that raagas and Scales are the same, but in reality Raagas are completely based on emotions and feelings, A raaga uses a set of notes, if ordered and calculated it becomes a scale.',style: normalTextStyle),
                        ],),),
                    ),
                    ////Overview

                    Container(
                        decoration: theory_box_decoration,
                        padding:theory_box_padding,
                        margin: theory_box_margin,
                        child: GestureDetector(
                          onTap: (){setState(() {
                            tapbox[13] = !tapbox[13];
                          });},
                          child: AnimatedCrossFade(
                            duration: CrossFadeDuration,
                            firstChild: RichText(text:
                            TextSpan( children: <TextSpan>[
                              TextSpan(text: 'Carnatic Music Nomenclature ',style: HeadingTextStyle),
                              TextSpan(text: readMoreText,style:readMoreTextStyle),

                            ],),),
                            secondChild: RichText(
                              textAlign: TextAlign.justify,
                              text:
                              TextSpan( children: <TextSpan>[
                                TextSpan(text: 'Carnatic Music Nomenclature ',style: HeadingTextStyle),

                                TextSpan(text:'\n\nThere are seven swaras in Carnatic music, namely, Shadjam (Sa), Rishabam (Ri), Gandharam (Ga), Madhyamam (Ma), Panchamam (Pa), Dhaivatham (Da) and Nishadam (Ni). The seven swaras are mythologically associated with the sounds produced by certain animals and Nature and the names of the swaras are related to the names of these animals.', style: normalTextStyle),
                                TextSpan(text:'\n\nThe name Madhyamam appears to be related to the central or madhya location in the seven notes and Panchamam is most probably derived from the number five, denoting the position of the note. ',style: normalTextStyle),
                                TextSpan(text: '\n\nThe Shadja and Panchama swaras are like the foundations upon which the rest of the melody is constructed. So, these occupy fixed sthanas.This is denoted by naming these swaras as Prakruthi swaras. All the other swaras are grouped under Vikruthi swaras (Rishabam, Gandharam, Deivatam, Nishadham).',style: normalTextStyle),
                                TextSpan(text: '\n\nThe seven basic swaras (Sapta-Swaras) occupy various swara sthanas and produce a total of sixteen swaras that form the basis of the carnatic music nomenclature.',style: normalTextStyle),
                                TextSpan(text: '\n\nIn order to identify the sthanas of the various swaras, let us number the twelve sthanas. The names of the swaras and the swara sthanas they occupy are given in the following table.',style: normalTextStyle),
                              ],),),
                            crossFadeState: tapbox[13] ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                          ),
                        )),
                    ////Nomenclature Types TapBox 13

                    Container(
                        decoration: theory_box_decoration,
                        padding:theory_box_padding,
                        margin: theory_box_margin,
                        child: GestureDetector(
                          onTap: (){setState(() {
                            tapbox[14] = !tapbox[14];
                          });},
                          child: AnimatedCrossFade(
                            duration: CrossFadeDuration,
                            firstChild: RichText(text:
                            TextSpan( children: <TextSpan>[
                              TextSpan(text: 'Table of Carnatic Swaras ',style: HeadingTextStyle),
                              TextSpan(text: readMoreText,style:readMoreTextStyle),

                            ],),),
                            secondChild: Image(image: AssetImage('assets/images/Swara_table.png'),),

                            crossFadeState: tapbox[14] ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                          ),
                        )),
                    ////Interval TableTapBox 14
                    Container(margin: EdgeInsets.all(50),)
                  ],),
              ),
              //PAGE, Screen 7 Introduction to Carnatic Music, Carnatic Music Nomenclature TapBox 13, 14

              //screen 8
              Container(
                child:  ListView(
                  children:[
                    AppBar(
                      title: Text('Melakarta Ragas ',style:Theory_AppBar,),
                      backgroundColor: Colors.white,
                      actions: <Widget>[
                        IconButton(icon: Icon(Icons.chevron_left_outlined,size: 30,),
                          onPressed: () {screenControl.previousPage(duration:Duration(milliseconds: 500), curve: Curves.easeIn);},),
                        IconButton(icon: Icon(Icons.chevron_right_outlined,size: 30,),
                          onPressed: () {screenControl.nextPage(duration:Duration(milliseconds: 500), curve: Curves.easeIn);},),
                      ],),

                    Container(
                      decoration: theory_nobox_decoration,
                      padding:theory_nobox_padding,
                      margin: theory_nobox_margin,
                      child: RichText(
                        textAlign: TextAlign.justify,
                        text:
                        TextSpan( children: <TextSpan>[
                          TextSpan(text:'Melakarta ragas are the foundational set of ragas in Carnatic music. There are 72 Melakartas, each following a strict structure'
                              '\n\nContemporary Carnatic music is based on a system of 72 melakarta ragas. These Melakarta Ragas are also called \'creator\' ragas, janaka ragas and thai (mother) ragas.'
                              '',style: normalTextStyle),
                        ],),),
                    ),
                    ////Overview

                    Container(
                        decoration: theory_box_decoration,
                        padding:theory_box_padding,
                        margin: theory_box_margin,
                        child: GestureDetector(
                          onTap: (){setState(() {
                            tapbox[15] = !tapbox[15];
                          });},
                          child: AnimatedCrossFade(
                            duration: CrossFadeDuration,
                            firstChild: RichText(text:
                            TextSpan( children: <TextSpan>[
                              TextSpan(text: 'Rules of melakarta ragas ',style: HeadingTextStyle),
                              TextSpan(text: readMoreText,style:readMoreTextStyle),

                            ],),),
                            secondChild: RichText(
                              textAlign: TextAlign.justify,
                              text:
                              TextSpan( children: <TextSpan>[
                                TextSpan(text: 'Rules of melakarta ragas ',style: HeadingTextStyle),

                                TextSpan(text:'\n\nThe Carnatic music contains various ragas. A raga is said to be melakarta only if the raaga satisfy these rules, ', style: normalTextStyle),
                                TextSpan(text:' \n\n1. Includes only one variant of all the 7 Swaras (Sampoornam. \n\n2. No Abha Swara,  \n\n3. Aarahonam and avarohanam should be the same..!  \n\n4. The 8th swara should be the higher S. \n\n5. The seven notes must be arranged in a specific order: Sa, Ri, Ga, Ma, Pa, Da, Ni. ',style: normalTextStyle),
                              ],),),
                            crossFadeState: tapbox[15] ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                          ),
                        )),
                    ////Mela Rules Types TapBox 15

                    Container(
                      decoration: theory_nobox_decoration,
                      padding:theory_nobox_padding,
                      margin: theory_nobox_margin,
                      child: RichText(
                        textAlign: TextAlign.justify,
                        text:
                        TextSpan( children: <TextSpan>[
                          TextSpan(text:'These ragas cover all possible combinations of notes within this framework (Nomenclature), ensuring each one is unique. Melakartas serve as a parent system, from which other ragas, called janya ragas, are derived. They are essential for learning and understanding the vast world of Carnatic music.'
                              '\n\nThe current system can be traced to the works of Venkatamakhi, who appears to be the first to use 72 melakartas.'
                              '\n\nIn the 16th century, many of Venkatamakhi\'s melakartas were unknown and were not assigned names.'
                              '\n\nLater, all 72 were given names, and this system is sometimes referred to as the Kanakaambari - Phenadhyuthi system after the names of the first two melakartas in it.'
                              '\n\nGovindacharya later devised the system in the 18th Century which led to a more elegant mathematical system.'
                              ,style: normalTextStyle),
                        ],),),
                    ),

                    Container(margin: EdgeInsets.all(50),)
                  ],),
              ),
              //PAGE, Screen 8 Melakarta, TopBox 15

              //screen 9
              Container(
                child:  ListView(
                  children:[
                    AppBar(
                      title: Text('Mathematical System of Melakarta Raagas ',style:Theory_AppBar,),
                      backgroundColor: Colors.white,
                      actions: <Widget>[
                        IconButton(icon: Icon(Icons.chevron_left_outlined,size: 30,),
                          onPressed: () {screenControl.previousPage(duration:Duration(milliseconds: 500), curve: Curves.easeIn);},),
                        IconButton(icon: Icon(Icons.chevron_right_outlined,size: 30,),
                          onPressed: () {screenControl.nextPage(duration:Duration(milliseconds: 500), curve: Curves.easeIn);},),
                      ],),

                    Container(
                      decoration: theory_nobox_decoration,
                      padding:theory_nobox_padding,
                      margin: theory_nobox_margin,
                      child: RichText(
                        textAlign: TextAlign.justify,
                        text:
                        TextSpan( children: <TextSpan>[
                          TextSpan(text:'We know that carnatic music has 12 distinct pitches and the 12 is derived from the 16 note nomenclature, And Melakarta Raagas must use all 7 swaras, the sapta swaras in them..! This yields 72 Melakarta Raagas.'
                              '\n\nThe 72 Mēḷakarta ragas are split into 12 groups called chakrās, each containing 6 ragas.'
                              '\n\nThe combinations of the D and N swara which are 6 in number, gives Six possible combinations when the rules are followed.. ie,'
                              '\n\nD1 N1 \nD1 N2 \nD1 N3 \nD2 N2 \nD2 N3 \nD3 N3'
                              '\n\nD2 AND N1  are the same frequency similarly D3 and N2 are the same frequency.Every chakra has 6 raagas, and all these chakras follow this combinatorial pattern , ie the first raaga in a chakra uses the D1 and N1, the second raaga in any chakra has D1 and N2,'
                          '\n\nSimilarly each chakra is differentiated by the R and G combinations ie..!  '
                              '\n\nR1 G1 \nR1 G2 \nR1 G3 \nR2 G2 \nR2 G3 \nR3 G3'
                              '\n\nAll the Raagas in Chakra 1 has R1 and G1 and all the Raagas in Chakra 2 has R1 and G2, but in this way one might think only 6 chakras are possible, here’s when the variants of M comes into calculation, the first 6 Chakras (6 Raaga per chakra = 36 Raagas) have M1 in them, and the remaining 6 chakras use m2, and so the 1st Raaga in 1st Chakra will be '
                              '\n\nS R1 G1 M1 P D1 N1 S^  '
                              '\n\nThe first raaga in the 7th chakra will be '
                              '\nS R1 G1 M2 P D1 N1 S^ '
                              '\n\nThere will be the only difference of M, all the other swaras are the same as to their M1 counterpart. By doing this 36 Raagas have M1 and the next 36 Raagas have M2 in them.!'
                              '\n\nIn other words the first 6 chakras and the second 6 chakras use the same R G D N (Vikruthi) combos the only difference being the change in M. S and P are the Same in all the raagas.! '
                              '\n\nThe beauty of the Chakras is that, The name of each of the 12 chakras suggest their ordinal number as well.'
                          ,style: normalTextStyle),
                        ],),),
                    ),
                    ////Overview

                    Container(
                        decoration: theory_box_decoration,
                        padding:theory_box_padding,
                        margin: theory_box_margin,
                        child: GestureDetector(
                          onTap: (){setState(() {
                            tapbox[16] = !tapbox[16];
                          });},
                          child: AnimatedCrossFade(
                            duration: CrossFadeDuration,
                            firstChild: RichText(text:
                            TextSpan( children: <TextSpan>[
                              TextSpan(text: 'Chakras ',style: HeadingTextStyle),
                              TextSpan(text: readMoreText,style:readMoreTextStyle),

                            ],),),
                            secondChild: RichText(
                              textAlign: TextAlign.justify,
                              text:
                              TextSpan( children: <TextSpan>[
                                TextSpan(text: 'Chakras ',style: HeadingTextStyle),

                                TextSpan(text:'\n\n1. Indu (Moon): ', style: ImportantNormal.copyWith(fontWeight: FontWeight.bold)),
                                TextSpan(text:'Represents the first chakra, as there is only one moon.', style: normalTextStyle),

                                TextSpan(text:'\n\n2. Nētra (Eyes): ', style: ImportantNormal.copyWith(fontWeight: FontWeight.bold)),
                                TextSpan(text:'Represents the second chakra, corresponding to the two eyes.', style: normalTextStyle),

                                TextSpan(text:' \n\n3. Agni (Fire): ', style: ImportantNormal.copyWith(fontWeight: FontWeight.bold)),
                                TextSpan(text:'Represents the third chakra, symbolizing the three types of Agni: Dakshina, Ahavaniyam, and Gārhapatyam.', style: normalTextStyle),

                                TextSpan(text:' \n\n4. Vēda (Vedas): ', style: ImportantNormal.copyWith(fontWeight: FontWeight.bold)),
                                TextSpan(text:'Represents the fourth chakra, denoting the four Vedas.', style: normalTextStyle),

                                TextSpan(text:' \n\n5. Bāṇa (Arrows): ', style: ImportantNormal.copyWith(fontWeight: FontWeight.bold)),
                                TextSpan(text:'Represents the fifth chakra, signifying the five arrows of Manmatha (mango, lotus, blue lily, jasmine, and ashoka). These arrows symbolize causing intense emotions in those struck by them..', style: normalTextStyle),

                                TextSpan(text:' \n\n6. Rutu (Seasons): ', style: ImportantNormal.copyWith(fontWeight: FontWeight.bold)),
                                TextSpan(text:' Represents the sixth chakra, corresponding to the six Hindu seasons: Vasanta, Greeshma, Varsha, Sharad, Hemanta, and Shishira', style: normalTextStyle),

                                TextSpan(text:' \n\n7. Rishi (Sages): ', style: ImportantNormal.copyWith(fontWeight: FontWeight.bold)),
                                TextSpan(text:' Represents the seventh chakra, symbolizing the seven sages (Sapta Rishis).', style: normalTextStyle),

                                TextSpan(text:' \n\n8. Vasu (Elements): ', style: ImportantNormal.copyWith(fontWeight: FontWeight.bold)),
                                TextSpan(text:'Represents the eighth chakra, denoting the eight Vasus of Hinduism.', style: normalTextStyle),

                                TextSpan(text:' \n\n9. Brahma: ', style: ImportantNormal.copyWith(fontWeight: FontWeight.bold)),
                                TextSpan(text:'Represents the ninth chakra, corresponding to the nine forms of Brahma.', style: normalTextStyle),

                                TextSpan(text:' \n\n10. Disi (Directions): ', style: ImportantNormal.copyWith(fontWeight: FontWeight.bold)),
                                TextSpan(text:'RRepresents the tenth chakra, symbolizing the ten directions (East, West, North, South, Northeast, Northwest, Southeast, Southwest, Above, and Below).', style: normalTextStyle),

                                TextSpan(text:' \n\n11. Rudra: ', style: ImportantNormal.copyWith(fontWeight: FontWeight.bold)),
                                TextSpan(text:'Represents the eleventh chakra, signifying the eleven forms of Rudra.', style: normalTextStyle),

                                TextSpan(text:' \n\n12. Ādityas:  ', style: ImportantNormal.copyWith(fontWeight: FontWeight.bold)),
                                TextSpan(text:'Represents the twelfth chakra, corresponding to the twelve Ādityas. These 12 chakras were also established by Venkatamakhi.', style: normalTextStyle),
                              ],),),
                            crossFadeState: tapbox[16] ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                          ),
                        )),
                    ////Interval Types TapBox 16

                    Container(margin: EdgeInsets.all(50),)
                  ],),
              ),
              //PAGE, Screen 9 Mathematical System of Melakarta Raagas:

              //screen 10
              Container(
                child:  ListView(
                  children:[
                    AppBar(
                      title: Text('How the App works ',style:Theory_AppBar,),
                      backgroundColor: Colors.white,
                      actions: <Widget>[
                        IconButton(icon: Icon(Icons.chevron_left_outlined,size: 30,),
                          onPressed: () {screenControl.previousPage(duration:Duration(milliseconds: 500), curve: Curves.easeIn);},),
                        IconButton(icon: Icon(Icons.chevron_right_outlined,size: 30,),
                          onPressed: () {screenControl.nextPage(duration:Duration(milliseconds: 500), curve: Curves.easeIn);},),
                      ],),

                    Container(
                      decoration: theory_nobox_decoration,
                      padding:theory_nobox_padding,
                      margin: theory_nobox_margin,
                      child: RichText(
                        textAlign: TextAlign.justify,
                        text:
                        TextSpan( children: <TextSpan>[
                          TextSpan(text:'The idea is to find the Family of chords for melakarta Raagas, and so we first find the melakarta Raagas and convert them into western notes. And then we find the family of chords.!'
                              ,style: normalTextStyle),
                        ],),),
                    ),
                    ////Overview

                    Container(
                        decoration: theory_box_decoration,
                        padding:theory_box_padding,
                        margin: theory_box_margin,
                        child: GestureDetector(
                          onTap: (){setState(() {
                            tapbox[17] = !tapbox[17];
                          });},
                          child: AnimatedCrossFade(
                            duration: CrossFadeDuration,
                            firstChild: RichText(text:
                            TextSpan( children: <TextSpan>[
                              TextSpan(text: 'Raaga and Scale Conversion ',style: HeadingTextStyle),
                              TextSpan(text: readMoreText,style:readMoreTextStyle),

                            ],),),
                            secondChild: RichText(
                              textAlign: TextAlign.justify,
                              text:
                              TextSpan( children: <TextSpan>[
                                TextSpan(text: 'Raaga and Scale Conversion ',style: HeadingTextStyle),

                                TextSpan(text:'\n\n'
                                    'Converting the Carnatic to western or vice versa is very simple..! '
                                    '\n\nWe know that Western music has 12 unique notes namely A, A#...G# (or) A, Bb, B…..Ab. Here the Ab and G# denotes the same note, they are called enharmonic. '
                                    '\n\nSimilarly in carnatic music there are 16 notes S, R1, R2…N3 S and 12 unique pitches/notes . Where the Swaras '
                                    '\n\nR2 - G1, \nR3 - G2, \nD2 - N1, \nD3 - N2  are enharmonic…!', style: normalTextStyle),


                                TextSpan(text: '\n\nWestern Scales to Carnatic',style: HeadingTextStyle),
                                TextSpan(text: '\n\nStep 1: ',style: ImportantNormal),
                                TextSpan(text: 'Find the Interval Pattern of the Scale, mark it..!',style: normalTextStyle),

                                TextSpan(text: '\n\nStep 2: ',style: ImportantNormal),
                                TextSpan(text: 'Start from Sa, and measure each respective interval from the pattern that we identified and find the Consecutive swaras,',style: normalTextStyle),


                                TextSpan(text: '\n\nCarnatic Raagas to Scales',style: HeadingTextStyle),
                                TextSpan(text: '\n\nStep 1: ',style: ImportantNormal),
                                TextSpan(text: 'Write Down the Nomenclature, and swaras Separately..!',style:normalTextStyle),

                                TextSpan(text: '\n\nStep 2: ',style: ImportantNormal),
                                TextSpan(text: 'Start from Sa, and measure each distance to the next note, ie find how many steps to be taken from one swara to the next ex: S -> R2 is 2 Steps from Sa',style:normalTextStyle),

                                TextSpan(text: '\n\nStep 3: ',style: ImportantNormal),
                                TextSpan(text: 'In this way find the interval pattern till you reach the higher Sa, and write down the interval pattern.',style:normalTextStyle),

                                TextSpan(text: '\n\nStep 4: ',style: ImportantNormal),
                                TextSpan(text: 'Write down the cycle of music notes, with your convenient start note..!',style:normalTextStyle),

                                TextSpan(text: '\n\nStep 5: ',style: ImportantNormal),
                                TextSpan(text: 'Using the Interval pattern, traverse the cycle of notes and find the scale notes.',style:normalTextStyle),


                                TextSpan(text: '\n\nExample',style: HeadingTextStyle),
                                TextSpan(text: '\n\nConsider C as the Starting Pitch and the Distance sequence being 1 3 1 2 1 3 1 ie S - R1 = 1 .. N3 - S^  = 1, From C take 1 step, it’s C#, note it down..! Then take 3 steps from C# that gives E, then 1 step will give F.. So on until you reach C Again..! = C C# E F G G# B C^ This is the MayaMalawa Gowla Raaga in pitch C.. Similarly if you want yous Sa to be in pitch E, Start counting from E, that would give E F G# A B C D# E^'
                                    '\n\nLikewise the app automatically finds the Western and its equal Carnatic Swaras using Interval Pattern..!',style:normalTextStyle),

                              ],),),
                            crossFadeState: tapbox[17] ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                          ),
                        )),
                    ////Interval Types TapBox 17

                    Container(margin: EdgeInsets.all(50),)
                  ],),
              ),
              //PAGE, Screen 10 How the App / Concept behind the app works..?

              //screen 11
              Container(
                child:  ListView(
                  children:[
                    AppBar(
                      title: Text('Why Guitar Raag..? ',style:Theory_AppBar,),
                      backgroundColor: Colors.white,
                      actions: <Widget>[
                        IconButton(icon: Icon(Icons.chevron_left_outlined,size: 30,),
                          onPressed: () {screenControl.previousPage(duration:Duration(milliseconds: 500), curve: Curves.easeIn);},),
                        IconButton(icon: Icon(Icons.chevron_right_outlined,size: 30,),
                          onPressed: () {screenControl.nextPage(duration:Duration(milliseconds: 500), curve: Curves.easeIn);},),
                      ],),

                    Container(
                      decoration: theory_nobox_decoration,
                      padding:theory_nobox_padding,
                      margin: theory_nobox_margin,
                      child: RichText(
                        textAlign: TextAlign.justify,
                        text:
                        TextSpan( children: <TextSpan>[
                          TextSpan(text:''
                              'The guitar Raag App helps musicians to find the Family of chords for Raagas, which helps both the music traditions to communicate theoretically, very easily. In other words this app strives to act like a bridge between both the worlds..!'
                              '\n\nAlso carnatic music is rich in scales. Carnatic melakarta Raagas have a collection of all music flavours (emotions). Various exotic music scales are arranged in a structure. '
                              '\n\nWestern Music has only less classifications in scales.'
                              '\n\nIn Carnatic music, Every Raaga has their own emotions and feelings, for example: , a song like Varaaha Roopam is composed on Kanakaangi Raaga (1st Raaga in 72 melakartas). The Aasai Nooru Vagai is composed on Vakulabharanam (14th melakarta).'
                              '\n\nThe point is that carnatic music allows musicians to create these emotions easily since carnatic music has suitable names and is neatly structured.'
                              '\n\nWestern Music considers both of these scales as minor scales. Western Music lacks here. Western Music’s actual advantage is orchestration, Western music offers various orchestration standards, separate tracks for Chords, bass, the secondary backing lead track etc., are available in Western music, Chords play as a fundamental component in these orchestrations.'
                              '\n\nStudents in western music are taught chords in very basic levels itself. Playing the proper family of chords is important. The app eases that process for students.'
                              ,style: normalTextStyle),
                        ],),),
                    ),
                    ////Overview


                    Container(margin: EdgeInsets.all(50),)
                  ],),
              ),
              //PAGE, Screen 11 How the App / Concept behind the app works..?

              Container(
                decoration: theory_box_decoration,
                margin: EdgeInsets.symmetric(horizontal: 70,vertical: 300),
                //width: 0,
                //height: 800,
                child: Container(

                  //margin:  Theory_para_box_margin,
                  padding: Theory_para_box_padding,
                  child: Column(
                    children: [
                      Container( margin: EdgeInsets.only(top:0.0,bottom: 0),
                        padding: EdgeInsets.only(left: 10.0,right: 10.0),

                        child: Text('You have seen all the theory materials, tap the button to reach Home Page',
                          style: Theorty_para_box_Text,),
                      ),
                      Container(
                        height: 50,
                        //width: 60,

                        margin: EdgeInsets.only(top: 20.0,bottom: 0),
                        //decoration: BoxDecoration( border: Border.all( width: 5, color: Colors.white, ), ),//DEBUGGING
                        padding: EdgeInsets.only(left: 60.0,right: 60.0,),

                        //decoration: BoxDecoration(border: Border.all(color: CupertinoColors.systemYellow,width: 2.0,),borderRadius: BorderRadius.circular(30.0),),
                        child:OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Color.fromRGBO(241, 243, 244,1), // Set border color here
                              width: 1.1, // Set border width here
                            ),

                            backgroundColor: Color.fromRGBO(11, 111, 241, 1),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),// Adjust the border radius as needed
                            ),
                          ),
                          onPressed: () { Navigator.pop(context, MaterialPageRoute(builder: (_)=> HomeApp())); },
                          child: Text('Home',style: TextStyle(fontSize: 20, fontFamily: 'NotoSansNormal'),),
                        ), ),
                    ],
                  ),
                ),
              ),
              //Last


            ],
          ),
        ),


      ),
    );
  }
}
