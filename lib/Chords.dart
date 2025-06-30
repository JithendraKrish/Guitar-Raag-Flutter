import 'dart:convert';
import 'dart:math';
import 'package:circular_menu/circular_menu.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_midi/flutter_midi.dart';
import 'package:advanced_search/advanced_search.dart';
import 'package:bottom_bar_matu/bottom_bar/bottom_bar_bubble.dart';
import 'package:bottom_bar_matu/bottom_bar_item.dart';
import 'package:bottom_bar_matu/bottom_bar_label_slide/bottom_bar_label_slide.dart';
import 'package:bottom_bar_matu/bottom_bar_matu.dart';
import 'package:clg_project_gtr_raag/HomePage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:clg_project_gtr_raag/main.dart';
import 'package:clg_project_gtr_raag/ChordsDict.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';

// import 'package:dart_melty_soundfont/dart_melty_soundfont.dart';
// import 'package:flutter_sound/public/flutter_sound_player.dart';
// import 'package:flutter_sound/public/tau.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:wheel_slider/wheel_slider.dart';

import 'RaagDict.dart';
import 'Theory.dart';
import 'intervals.dart';
//import 'package:flutter_guitar_tabs/flutter_guitar_tabs.dart';

void main() {
  runApp(const FamilyChds());
} //main

class FamilyChds extends StatefulWidget {
  const FamilyChds({super.key});

  @override
  State<FamilyChds> createState() => _FamilyChdsState();
}

class _FamilyChdsState extends State<FamilyChds> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          // colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
          // useMaterial3: true,
          ),
      home: const Families(title: 'Family Chords'),
    );
  }
}

//CHANGING THE FUNCTIONS TO RESPECTIVE LOCATIONS, its not over yet
// 1. Global Vble
// 2. initState() APIs
// 3. business LOGICS
// 4. Build()

//every state calls Build()


List<bool> setNotes(r) {
  List<bool> a = RaagaLib[r];
  return a;
}

bool star = true;
List swaraInput = [];
int CHORD_SIZE = 3;
List FamChdList = [];



String RaagamName = 'MechaKalyani';


Map inputMap = {
  'notes': setNotes(RaagamName),
  'scale': ['A', 'B', 'C', 'D', 'E', 'F', 'G#', 'A^']
};

var carnatic_swaras = {
  0: 'S',
  1: 'R1',
  2: 'R2',
  3: 'R3',
  4: 'G1',
  5: 'G2',
  6: 'G3',
  7: 'M1',
  8: 'M2',
  9: 'P',
  10: 'D1',
  11: 'D2',
  12: 'D3',
  13: 'N1',
  14: 'N2',
  15: 'N3',
  16: 'S^'
};
Map western_swaras = {
  0: 'A',
  1: 'A#',
  2: 'B',
  3: 'C',
  4: 'C#',
  5: 'D',
  6: 'D#',
  7: 'E',
  8: 'F',
  9: 'F#',
  10: 'G',
  11: 'G#',
  12: 'A^'
};
Map MidiNum = {
  'A': 57,
  'S': 57,
  'A#': 58,
  'R1': 58,
  'B': 59,
  'R2 | G1': 59,
  'C': 60,
  'R3 | G2': 60,
  'C#': 61,
  'G3': 61,
  'D': 62,
  'M1': 62,
  'D#': 63,
  'M2': 63,
  'E': 64,
  'P': 64,
  'F': 65,
  'D1': 65,
  'F#': 66,
  'D2 | N1': 66,
  'G': 67,
  'D3 | N2': 67,
  'G#': 68,
  'N3': 68,
};
var res = Fretter(input);
var allFrets = [];
List<String> RaagaList = RaagaLib.keys.cast<String>().toList();

var TotalList = IntervalCalculator(inputMap); //TOTALLIST DECLARATION

bool tutorialChordState = false;
void tutorialChordVbleState(a) {
  if (a) {
    tutorialChordState = a;
  }
}


String currentPitch = "C";
List doopKey = RaagaLib.keys.toList();
List doopVal = RaagaLib.values.toList();
List mainOut =[];


class Families extends StatefulWidget {
  const Families({super.key, required this.title});
  final String title;

  @override
  State<Families> createState() => _FamiliesState();
}

class _FamiliesState extends State<Families> {
  // THESE are to be given inside the widget
  final GlobalKey <CircularMenuState>  _AllChordPlay = GlobalKey();
  final GlobalKey _CurrentRaag = GlobalKey();
  final GlobalKey _CurrentSwaras = GlobalKey();
  final GlobalKey _ChordTiles = GlobalKey();
  final GlobalKey _PitchSelector = GlobalKey();
  final GlobalKey _SwarasInputSearch = GlobalKey();

  String msg = '';

  final _flutterMidi = FlutterMidi();
  // final _flutterMidi2 = FlutterMidi();

  final audioPlayer = AudioPlayer();
  Future<void> load() async {
    ByteData _byte = await rootBundle.load('assets/audios/Guitar1.sf2');
    _flutterMidi.prepare(sf2: _byte);

    // ByteData _byte2 = await rootBundle.load('assets/audios/Guitar3.sf2');
    // _flutterMidi2.prepare(sf2: _byte2);
  }
  late TextEditingController _searchController;

  late FixedExtentScrollController scrollController;
  var scrollController2 = PageController();
  //important for Search, without this it was a 3 Day Bug

  int RaagaNum = 65;

  @override
  void initState() {
    super.initState();
    load();



    _searchController = TextEditingController();
    scrollController =  FixedExtentScrollController();


    setPitch(currentPitch);
    setRaagam(RaagaLib[RaagamName],carnatic_swaras);
    western_swaras = myMapper(currentPitch);
    msg = '';


  }



//   Future<void> initSynth() async {
//     // Load SoundFont from assets
//     ByteData sfData =await rootBundle.load('assets/audios/Guitar1.sf2');
//     final synth = Synthesizer.loadByteData(sfData, SynthesizerSettings(
//       sampleRate: 44100,
//       maximumPolyphony: 64,
//       enableReverbAndChorus: true,
//     ));
//
//
// // turn on some notes
//     synth.noteOn(channel: 0, key: 72, velocity: 120);
//     synth.noteOn(channel: 0, key: 76, velocity: 120);
//     synth.noteOn(channel: 0, key: 79, velocity: 120);
//     synth.noteOn(channel: 0, key: 82, velocity: 120);
//
// // create a pcm buffer
//     ArrayInt16 buf16 = ArrayInt16.zeros(numShorts: 44100 * 3);
//
// // render the waveform (1 second)
//     synth.renderMonoInt16(buf16);
//
// // turn off a note
//     synth.noteOff(channel: 0, key: 72);
//
//   }

  //Don't know why these Exists
  // List <bool> _checkboxValues = [true, false, true, false, false, true, false, true, false, true, true, false, false, false, false, true, true];
  // bool state = true;
  // String ins = '';

//these too serve no use inside initState()
  // inputMap = inputToNotes(RaagaLib[RaagamName], western_swaras);
  //there is some lead here, right now, all raagas are swarad keeravani
  // search works like butter
  // inputMap = inputToNotes(RaagaLib['Keeravani'], western_swaras);
  List IntervalCalculator(inputMap) {
    List n = inputMap['scale'];
    List l = inputMap['notes'];
    List TotalIntervalList = [];
    List PatternList = [];
    List PairList = [];
    Map intr = {
      0: 'Unison',
      1: 'minor 2nd',
      2: 'Major 2nd',
      3: 'minor 3rd',
      4: 'Major 3rd',
      5: 'Perfect 4th',
      6: 'Tritone',
      7: 'Perfect 5th',
      8: 'minor 6th',
      9: 'Major 6th',
      10: 'minor 7th',
      11: 'Major 7th',
      12: 'Octave'
    };
    List tmp2 = [];
    for (int i = 0; i < l.length; i++) {
      for (int j = 0; j < l.length; j++) {
        int diff = (l[i] - l[j]).abs();
        List tmp = [];
        tmp.add([n[i], n[j], '=', intr[diff], diff]);
//      print(tmp);
        tmp2.add(tmp);
        if (i - j == -1) {
          PatternList.add(tmp);
        }
        if (i == 0) {
          PairList.add(tmp);
        }
      }
      TotalIntervalList.add(tmp2);
      tmp2 = [];
    }
    //print(TotalIntervalList[0][2]);
    tmp2 = [TotalIntervalList, l.length, PatternList, PairList, n, l];

    return tmp2;
  }
  List FamChordCalculator(chd_size) {
// print('INPUT MAP FROM CHORDS FN');
// print(inputMap);
    List Tl = IntervalCalculator(inputMap);
    List chordList = [];
    List tmp = [];
    List tmp2 = [];
    // List IntrCombo = [];
    // List NoteCombo = [];
    int l = Tl[1];
    List input = Tl[4];
    String Last_char = input[l - 1];
    //if (input[l - 1] == 'S^' || Last_char.substring((Last_char.length)-1) == '^') {
    if (Last_char.substring((Last_char.length) - 1) == '^') {
      List dummy = [];
      for (int o = 0; o < l - 1; o++) {
        dummy.add(input[o]);
      }
      l = l - 1;
      input = dummy;
    }

//returns One Chord At a time
    List NoteFinder(chd_size, swara_idx) {
      int counter = 0;
      tmp2 = [];
      for (int j = swara_idx; counter < chd_size; j += 2) {
        if (counter == chd_size) {
          break;
        }
        //print('NOTEFINDER()'+'$j'+'$swara_idx'+'$counter');
        j = j % l;
        tmp.add(input[j]);
        tmp2.add(j);
        counter++;
      }

      return [tmp, tmp2];
    }

//Returns The Interval from TotalList
    List IntrFinder(List one_single_chd_idx) {
      List b = one_single_chd_idx;
      List temp = [];
      String mapKey = '';
      List temp2 = [];
      for (int k = 0; k < b.length; k++) {
        int a = b[k];
        int c = (k + 1) % b.length;
        int d = b[c];
        //int tempu = b[0];
        if (d == 0) {
          d = (l);
        }
        // temp.add(a);//optionn1 for debugging
        // temp.add(d);//option 1 //THat if line below is the actual option
        if (a! <= 8 || c! <= 8) {
          temp = [Tl[0][a][d][0][4]];
        }
        if (d < a) {
          temp = [(12 - temp[0]).abs()];
        }
        int dumb = temp[0];
        mapKey += '$dumb';
        temp2.add(temp);
        temp = [];
      }
      temp2.add([mapKey]);

      return temp2;
    }

    if (l! >= 5) {
      List a = [];
      List b = [];
      for (int i = 0; i < l; i++) {
        if (i == l) {
          break;
        }
        tmp = NoteFinder(
            chd_size, i); //1st Arg, chd_size, 2nd Arguement is swara Idx
        a = tmp[0];
        b = IntrFinder(tmp[1]);
        tmp = [];
        tmp.add(a);
        tmp.add(b);
        // NoteCombo.add(a);
        // IntrCombo.add(b);
        chordList.add(tmp);
        a = [];
        b = [];
        tmp = [];
      }
    } else {
      chordList = ['Kindly Enter the Raaga That has More than 4 Swaras'];
    }

    return chordList;
  }
  myMapper(String a) {
    Map<int, String> op = {};
    List Swaras = [
      'A',
      'A#',
      'B',
      'C',
      'C#',
      'D',
      'D#',
      'E',
      'F',
      'F#',
      'G',
      'G#'
    ];
    int index = Swaras.indexOf(a);
    for (int i = 0; i < 12; i++) {
      op[i] = Swaras[(index + i) % 12];
    }
    op[12] = a + '^';
    return op;
  }
  Map myMidiMapper(String a) {
    List Pitches = [
      'A',
      'A#',
      'B',
      'C',
      'C#',
      'D',
      'D#',
      'E',
      'F',
      'F#',
      'G',
      'G#'
    ];
    Map MidiVals = {
      'A': 57,
      'S': 57,
      'A#': 58,
      'R1': 58,
      'B': 59,
      'R2 | G1': 59,
      'C': 60,
      'R3 | G2': 60,
      'C#': 61,
      'G3': 61,
      'D': 62,
      'M1': 62,
      'D#': 63,
      'M2': 63,
      'E': 64,
      'P': 64,
      'F': 65,
      'D1': 65,
      'F#': 66,
      'D2 | N1': 66,
      'G': 67,
      'D3 | N2': 67,
      'G#': 68,
      'N3': 68,
    };
    Map midiDict = {};
    int index = Pitches.indexOf(a);
    for (int i = 0; i < 12; i++) {
      midiDict[Pitches[(index + i) % 12]] = ((MidiVals[a]) + i);
      midiDict[carnatic_swaras[i]] = ((MidiVals[a]) + i);
    }
    // print(midiDict);
    return midiDict;
  }
  List Scale = [];











  List Fretter(List a) {
    List Frets = [];
    Map GtrFretOpens = {
      '[6, 0]': 'E',
      '[5, 0]': 'A',
      '[4, 0]': 'D',
      '[3, 0]': 'G',
      '[2, 0]': 'B',
      '[1, 0]': 'E'
    };
    Map WholeGTRmap = {};
    for (int j = 6; j > 0; j--) {
      List tmp = [];
      for (int i = 0; i < 13; i++) {
        tmp.add([j, i]);
      }
      Frets.add(tmp);
    }

    for (int j = 0; j < 6; j++) {
      //the 6 is Responsible for Number of Strings
      var OpenNote = GtrFretOpens[(Frets[j][0]).toString()];
      List Swaras = [
        'A',
        'A#',
        'B',
        'C',
        'C#',
        'D',
        'D#',
        'E',
        'F',
        'F#',
        'G',
        'G#'
      ];
      int index = Swaras.indexOf(OpenNote);
      for (int i = 0; i < 12; i++) {
        WholeGTRmap[(Frets[j][i]).toString()] = Swaras[(index + i) % 12];
      }
    }
    List keys = [];
    List positions = [];

    for (int i = 0; i < a.length - 1; i++) {
      //length-1 coz of octave
      List tmp = [];
      List tmp2 = [];
      //tmp.add(a[i]);
      WholeGTRmap.forEach((key, value) {
        if (value == a[i]) {
          tmp.add(key);
          List<dynamic> list = jsonDecode(key); // Convert string to list
          // int Str = int.parse(key[1]);
          // int fre = int.parse(key[4]);
          tmp2.add(list);
        }
      });
      positions.add(tmp2);
      keys.add(tmp);
    }

    List dummy = [];
    List Root = [positions[0][0][0], positions[0][0][1]];
    int string = positions[0][0][0];
    int RootFret = positions[0][0][1];
    int e = (Root[0]) % 6;
    List octave = [];
    octave = positions[0][2];
    // print(octave);

    for (int i = 0; i < positions.length; i++) {
      List chumma = positions[i];

      for (int j = 0; j < chumma.length; j++) {
//&&chumma[j][0]<string
        if (chumma[j][1] - RootFret < 5 &&
            chumma[j][1] - RootFret >= -2 &&
            chumma[j][1] != 0) {
          dummy.add(chumma[j]);
          break;
        }
      }
    }
    dummy.add(positions[0][2]);

    Scale = dummy;
    return positions;
  }
  List input = inputMap['scale'];
  Map inputToNotes(l, swaras) {
    // print('INPUT TEST');
    // print(l);
    List a = [];
    List b = [];
    if (l.runtimeType == List<bool>) {
      setCarnatic(l);
      List n12 = nomenCletureList(l);
      //print(n12);
      for (int i = 0; i < 13; i++) {
        if (n12[i] == true) {
          a.add(i);
          b.add(swaras[i]);
        } //if
      } //for
    } else {
      for (int i = 0; i < l.length; i++) {
        a.add(l[i]);
        b.add(swaras[l[i]]);
      }
    }
    // print('\n\nSWAR DICT');
    // print(carnatic_swaras);
    // print({'notes':a,'scale':b});
    return {'notes': a, 'scale': b};
  }
  //Function end
  void setCarnatic(List a) {
    String state2 = ' ';
    String state3 = ' ';
    String state9 = ' ';
    String state10 = ' ';
    if (a[2] == true) {
      state2 = 'R2';
    }
    if (a[4] == true) {
      state2 = 'G1';
    }
    if (a[3] == true) {
      state3 = 'R3';
    }
    if (a[5] == true) {
      state3 = 'G2';
    }
    if (a[11] == true) {
      state9 = 'D2';
    }
    if (a[13] == true) {
      state9 = 'N1';
    }
    if (a[12] == true) {
      state10 = 'D3';
    }
    if (a[14] == true) {
      state10 = 'N2';
    }

    if (state2 == ' ') {
      state2 = 'R2';
    }
    if (state3 == ' ') {
      state3 = 'G2';
    }
    if (state9 == ' ') {
      state9 = 'D2';
    }
    if (state10 == ' ') {
      state10 = 'N2';
    }

    var swar = {
      0: 'S',
      1: 'R1',
      2: state2,
      3: state3,
      4: 'G3',
      5: 'M1',
      6: 'M2',
      7: 'P',
      8: 'D1',
      9: state9,
      10: state10,
      11: 'N3',
      12: 'S^'
    };
    setState(() {
      carnatic_swaras = swar;
    });
  }
  List<bool> nomenCletureList(List a) {
    List<bool> returner = [
      a[0],
      a[1],
      false,
      false,
      a[6],
      a[7],
      a[8],
      a[9],
      a[10],
      false,
      false,
      a[15],
      a[16]
    ];
    //print(a);
    if (a[2] == true || a[4] == true) {
      returner[2] = true;
    }
    if (a[3] == true || a[5] == true) {
      returner[3] = true;
    }

    if (a[11] == true || a[13] == true) {
      returner[9] = true;
    }
    if (a[12] == true || a[14] == true) {
      returner[10] = true;
    }

    //print(returner);
    return returner;
  }
  //Fumction1

  int ChordStyle = 0;
  bool Resonance = false;
  List notesData = [];

  bool y = true;


  play(List a) async {
    final stopwatch = Stopwatch()..start();
    int note1 = MidiNum[a[0]];
    int note2 = (MidiNum[a[1]]);
    if (note2 < note1) {
      note2 = note2 + 12;
    }
    int note3 = (MidiNum[a[2]]);
    if (note3 < note2) {
      note3 = note3 + 12;
    }


    _flutterMidi.playMidiNote(midi: note1);
    _flutterMidi.playMidiNote(midi: note2);
    _flutterMidi.playMidiNote(midi: note3);

    stopwatch.stop();
    print('Key press handled in PLAY: ${stopwatch.elapsedMicroseconds} µs');



    // Future.delayed(const Duration(milliseconds: 600), () async{
    //   _flutterMidi.stopMidiNote(midi: note1);
    //   _flutterMidi.stopMidiNote(midi: note2);
    //   _flutterMidi.stopMidiNote(midi: note3);
    // });

    // String a1 = a[0];
    // String a2 = a[1];
    // String a3 = a[2];


    //
    // if (ChordStyle == 0) {
    //    _flutterMidi.playMidiNote(midi: note1);
    //    _flutterMidi.playMidiNote(midi: note2);
    //    _flutterMidi.playMidiNote(midi: note3);
    //   if (!y) {
    //
    //      _flutterMidi.stopMidiNote(midi: note1);
    //      _flutterMidi.stopMidiNote(midi: note2);
    //      _flutterMidi.stopMidiNote(midi: note3);
    //   }
    //   if (!Resonance) {
    //     Future.delayed(const Duration(milliseconds: 600), () async{
    //        _flutterMidi.stopMidiNote(midi: note1);
    //        _flutterMidi.stopMidiNote(midi: note2);
    //        _flutterMidi.stopMidiNote(midi: note3);
    //     });
    //   }
    // }
    //
    // if (ChordStyle == 1) {
    //   Future.delayed(const Duration(milliseconds: 0), () {
    //     _flutterMidi.playMidiNote(midi: note1);
    //     Future.delayed(const Duration(milliseconds: 200), () {
    //       _flutterMidi.playMidiNote(midi: note2);
    //       Future.delayed(const Duration(milliseconds: 200), () {
    //         _flutterMidi.playMidiNote(midi: note3);
    //         if (!y) {
    //           _flutterMidi.stopMidiNote(midi: note1);
    //           _flutterMidi.stopMidiNote(midi: note2);
    //           _flutterMidi.stopMidiNote(midi: note3);
    //         }
    //         if (!Resonance) {
    //           Future.delayed(const Duration(milliseconds: 200), () {
    //             _flutterMidi.stopMidiNote(midi: note1);
    //             _flutterMidi.stopMidiNote(midi: note2);
    //             _flutterMidi.stopMidiNote(midi: note3);
    //           });
    //         }
    //       });
    //     });
    //   });
    // }
    //
    //
    //
    //
  }




  // Future<void> playinLoop() async {
  //   for(int k = 0; k<mainOut.length;k++){await play(FamChdList[k][0]);  await Future.delayed(Duration(milliseconds: 500));  }
  // }

  int _Bottomindex = 0;
  List OneOctaveScale = [];


  var western_swaras = {
    0: 'A',
    1: 'A#',
    2: 'B',
    3: 'C',
    4: 'C#',
    5: 'D',
    6: 'D#',
    7: 'E',
    8: 'F',
    9: 'F#',
    10: 'G',
    11: 'G#',
    12: 'A^'
  };
  List Pitches = [
    'A',
    'A#',
    'B',
    'C',
    'C#',
    'D',
    'D#',
    'E',
    'F',
    'F#',
    'G',
    'G#'
  ];
  void setPitch(String a) {
    setState(() {
      western_swaras = myMapper(a);
      MidiNum = myMidiMapper(a);
    });
  }

  void setRaagam(List a, swaras) {
    setState(() {
      inputMap = inputToNotes(a, swaras);
    });



  }
  void setRaagamforSwaras(List a, swaras) {
    setRiVal();
    int RaagaNumCalc = 0;
    if(RiVal == 1){
      if(GaVal == 1){RaagaNumCalc = 0; }
      if(GaVal == 2){RaagaNumCalc = 6; }
      if(GaVal == 3){RaagaNumCalc = 12;}}
    if(RiVal == 2){
      if(GaVal == 2){RaagaNumCalc = 18;}
      if(GaVal == 3){RaagaNumCalc = 24;}}
    if(RiVal == 3){
      if(GaVal == 3){RaagaNumCalc = 30;}}

    if(DaVal == 1){
      if(NiVal == 1){RaagaNumCalc = RaagaNumCalc;}
      if(NiVal == 2){RaagaNumCalc = RaagaNumCalc+1;}
      if(NiVal == 3){RaagaNumCalc = RaagaNumCalc+2;}}
    if(DaVal == 2){
      if(NiVal == 2){RaagaNumCalc = RaagaNumCalc+3;}
      if(NiVal == 3){RaagaNumCalc = RaagaNumCalc+4;}}
    if(DaVal == 3){
      if(NiVal == 3){RaagaNumCalc = RaagaNumCalc+5;}}

    if(SwaraMa == false){RaagaNumCalc=RaagaNumCalc+36;}

    setState(() {
      RaagaNum = RaagaNumCalc+1;
      RaagamName = RaagaList[RaagaNumCalc];
      inputMap = inputToNotes(a, swaras);
    });

  }
  List ChordsOutput(crdlist) {
    List outputList = [];
    String temp2 = '';
    String chdResult = '';
    if (crdlist.length == 1) {
      chdResult = '$crdlist';
      temp2 = '$crdlist';
      outputList.add(temp2);
      return outputList;
    }
    List tmp = []; //notesData
    for (int i = 0; i < crdlist.length; i++) {
      List a = crdlist[i][0];
      List n = crdlist[i][1][CHORD_SIZE];
      int intSum = int.parse(n[0]);
      List temp = crdlist[i][0];
      var b = ChrdLib[intSum];
      var c = a[0];
      String inv = 'Not inverted';
      if (b == null) {
        String input = n[0];
        String Final = '$input';
        temp = [intSum];

        for (int j = 0; j < CHORD_SIZE; j++) {
          String gol = '';
          if (b != null) {
            break;
          }
          List test = [];
          String dummy = '';
          for (int p = 0; p < CHORD_SIZE; p++) {
            dummy = Final[p];
            test.add(dummy);
            temp = test;
          }
          for (int y = 1; y < test.length + 1; y++) {
            gol += test[(y % test.length)];
          }
          Final = '$gol';
          intSum = int.parse(Final);
          b = ChrdLib[intSum];
          inv = '\n Invertion : ' + '$j';
        }
      }
      temp2 = '';
      chdResult += '$c' + '\t - \t' + '$b' + '\t -- \t' + '$inv' + '\n\n';
      temp2 = '$c' + '\t - \t' + '$b' + '\n\n';

      if (b == null) {
        setState(() {
          msg ='If the app shows chords types as NULL, please share the screenshot of the chords screen (with the Raagam) to the developer';
        });


        // temp2 += '$temp\n\n';
        //THIS IS REMOVED FOR The Widget Balancing, in the ChordTiles

        chdResult += '$temp\n\n';
      }

      outputList.add(temp2);
      tmp.add('$a');
    }
    notesData = tmp;

    return outputList;
  }
  void setRaagamName(String a) {
    setState(() {
      RaagamName = a;
    });
  }
  List whole_Scale_Fretter(List a) {
    // this Functions gets the fret board, of the Scale,
    // All positions of say A, A#, B, C upto A^
    // Whole Scale is Covered with this Function
    // The First 12 Frets is considered in this Function.
    List Frets = [];
    Map GtrFretOpens = {
      '[6, 0]': 'E',
      '[5, 0]': 'A',
      '[4, 0]': 'D',
      '[3, 0]': 'G',
      '[2, 0]': 'B',
      '[1, 0]': 'E'
    };
    Map WholeGTRmap = {};
    for (int j = 6; j > 0; j--) {
      List tmp = [];
      for (int i = 0; i < 14; i++) {
        tmp.add([j, i]);
      }
      Frets.add(tmp);
    }

    for (int j = 0; j < 6; j++) {
      //the 6 is Responsible for Number of Strings
      var OpenNote = GtrFretOpens[(Frets[j][0]).toString()];
      List Swaras = [
        'A',
        'A#',
        'B',
        'C',
        'C#',
        'D',
        'D#',
        'E',
        'F',
        'F#',
        'G',
        'G#'
      ];
      int index = Swaras.indexOf(OpenNote);
      for (int i = 0; i < 13; i++) {
        WholeGTRmap[(Frets[j][i]).toString()] = Swaras[(index + i) % 12];
      }
    }
    List keys = [];
    List positions = [];

    for (int i = 0; i < a.length - 1; i++) {
      //length-1 coz of octave
      List tmp = [];
      List tmp2 = [];
      //tmp.add(a[i]);
      WholeGTRmap.forEach((key, value) {
        if (value == a[i]) {
          tmp.add(key);
          List<dynamic> list = jsonDecode(key); // Convert string to list
          // int Str = int.parse(key[1]);
          // int fre = int.parse(key[4]);
          tmp2.add(list);
        }
      });
      positions.add(tmp2);
      keys.add(tmp);
    }

    List dummy = [];

    List Root = [positions[0][0][0], positions[0][0][1]];
    int string = positions[0][0][0];
    int RootFret = positions[0][0][1];
    int e = (Root[0]) % 6;
    List octave = [];
    octave = positions[0][2];

    for (int i = 0; i < positions.length; i++) {
      List chumma = positions[i];

      for (int j = 0; j < chumma.length; j++) {
        //&&chumma[j][0]<string
        if (chumma[j][1] - RootFret < 5 &&
            chumma[j][1] - RootFret >= -2 &&
            chumma[j][1] != 0) {
          dummy.add(chumma[j]);
          break;
        }
      }
    }
    dummy.add(positions[0][2]);

    OneOctaveScale = dummy;
    return positions;
  }
  void setChords(){
    setState(() {
      FamChdList = FamChordCalculator(CHORD_SIZE);
      mainOut = ChordsOutput(FamChdList);

      List scale_notes_input = inputMap['scale'];
      allFrets = whole_Scale_Fretter(scale_notes_input);

    });
  }
  List final_chords(){
    List outs = [];

    Map alternative_chord_possiblities = {
      '\tminor\n\n': 2,
      '\tmajor\n\n': 2,
      '\tdiminished\n\n': 1,
      '\taugmented\n\n': 1,
      '\tinverted': 1,
      '\tmajor3': 1,
      '\tdom7omit5': 1,

    };
    for(int i =0; i< mainOut.length;i++){
      List <Widget> tmp = [];
      var valu = mainOut[i].split(' ');
      var chordType = valu[2].toLowerCase();

      if (!chordType.contains('null')){
        for (int j = 0; j< alternative_chord_possiblities[chordType];j++){
          if (j == 0){tmp.add(CustomPaint(
            size: Size(320, 300),
            painter: PaintChord(
                Fret_positions: allFrets,
                valu: mainOut[i]
                    .split(' '),
                chordNote_Index: i),
          )); }
          //right now only the Major Chord and Minor chord take use of this
          if (j == 1) {tmp.add(CustomPaint(
            size: Size(320, 300),
            painter: PaintChord2(
                Fret_positions: allFrets,
                valu: mainOut[i]
                    .split(' '),
                chordNote_Index: i),
          )); }
        }
    }


      if (chordType.contains('null')){
        tmp.add(CustomPaint(
          size: Size(200, 200),
          painter: PaintChord(
              Fret_positions: allFrets,
              valu: mainOut[i]
                  .split(' '),
              chordNote_Index: i),
        ));

      }

      outs.add(tmp);
    }
    return outs;
  }
  List <String>extractedRaagas = [];
  bool didYouMean = false;

  bool AnimatedContainerInput = false;
  bool SwaraRi = false;
  int RiVal = 1;
  bool SwaraGa = false;
  int GaVal = 1;
  bool SwaraDa = false;
  int DaVal = 1;
  bool SwaraNi = false;
  int NiVal = 1;
  bool SwaraMa = false;
  int raagRangeStart = 1;
  int raagRangeEnd = 72;


  setRiVal(){
    var tmp = RaagaLib[RaagamName];
  if(tmp[1] == true){RiVal = 1;}if(tmp[2] == true){RiVal = 2;} if(tmp[3] == true){RiVal = 3;}

  if(tmp[4] == true){GaVal = 1;}if(tmp[5] == true){GaVal= 2;} if(tmp[6] == true){GaVal = 3;}

  if(tmp[7] == true){SwaraMa = true;}if(tmp[8] == true){SwaraMa = false;}

  if(tmp[10] == true){DaVal = 1;}if(tmp[11] == true){DaVal = 2;} if(tmp[12] == true){DaVal = 3;}

  if(tmp[13] == true){NiVal = 1;}if(tmp[14] == true){NiVal = 2;} if(tmp[15] == true){NiVal = 3;}
  }



  Future<void> initialPlay(bool boolSRG) async {
    List tmp = inputMap['scale'];
    List tmp2 =inputMap['notes'];
    int len = tmp2.length;
    int time = 200;
    if(boolSRG == true){
      len = 3;
      time = 100;
    }
      for(int k = 0; k<len;k++){
        _flutterMidi.playMidiNote(midi: MidiNum[currentPitch]+tmp2[k]);
        await Future.delayed(Duration(milliseconds: time));
        // print(MidiNum);
        // print(MidiNum[currentPitch]+tmp2[k]);
        // print(MidiNum[tmp2[k]+MidiNum[currentPitch]]);
        // print(tmp[k]);
        // // _flutterMidi.playMidiNote(midi: MidiNum[tmp[k]]);


      }
  }
  playScroll() async {
    _flutterMidi.playMidiNote(midi: 60);
    // for(int k = 0; k<len;k++){
    //   _flutterMidi.playMidiNote(midi: MidiNum[tmp[k]]);
    //   await Future.delayed(Duration(milliseconds: time));
    //   if (k == 6){
    //     _flutterMidi.playMidiNote(midi: MidiNum[tmp[0]]+12);
    //   }
    // }
  }

  @override
  Widget build(BuildContext context) {
    print("\n");
    print("BUILDER VAL");
    print(RaagamName);
    print(RaagaNum);
    print("\n");

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    //FUNCTIONS list Dynammic
    //Input to NOTES or MAIN input must be list of BOOLS
    Map input2 = inputToNotes(inputMap['notes'], carnatic_swaras);
    String ragam2 = '${input2['scale']}';
    if (swaraInput.length != 0) {
      setRaagam(swaraInput, carnatic_swaras);
      swaraInput = [];
    }
    inputMap = inputToNotes(inputMap['notes'], western_swaras);
    TotalList = IntervalCalculator(inputMap);//This is also Must
    setChords();//This is also Must
    List allChord_maps = final_chords();








    // Color subText = Color.fromRGBO(220, 238, 209, 1);
    // Color notesBoxText = Color.fromRGBO(220, 238, 209, 1);
    //
    // Color OverallBG = Color.fromRGBO(122, 145, 141, 1);
    // Color backArrow = Color.fromRGBO(220, 238, 209, 1);
    // final notesBox =  BoxDecoration(border: Border.all( width: 0.5, color: Colors.white, ),borderRadius: BorderRadius.circular(10.0),color: Color.fromRGBO(115, 99, 114, 1), );
    // final chordTileCNT = BoxDecoration(border: Border.all( width: 2, color: Color.fromRGBO(161, 130, 118, 1), ),borderRadius: BorderRadius.circular(10.0));
    // final chordTileBTN = ElevatedButton.styleFrom(
    //   foregroundColor: Color.fromRGBO(115, 99, 114, 1),
    //   backgroundColor: Color.fromRGBO(220, 238, 209, 1),
    //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0),),
    //   padding: EdgeInsets.symmetric(vertical: 10.0),
    //   alignment: Alignment.center,
    //   fixedSize: Size(400, 60),
    // );

    Color subText = Color.fromRGBO(111, 111, 111, 1);
    Color txtTitle = Color.fromRGBO(0, 0, 0, 1);
    // Color OverallBG = Color.fromRGBO(248, 248, 255, 1);
    // Color.fromRGBO(245, 255, 255, 1);
    // Color.fromRGBO(137, 142, 186, 1),
    Color OverallBG = Color.fromRGBO(255, 255, 255, 1);
    Color backArrow = Color.fromRGBO(46, 46, 46, 1);
    final notesBox = BoxDecoration(
      border: Border.all(
        width: 0,
        color: Color.fromRGBO(72, 72, 72, 1),
      ),
      borderRadius: BorderRadius.circular(5.0),
      color: Colors.transparent
    );
    var notesBoxTextstyl = TextStyle(

        color: Colors.black, fontFamily: 'NotoSansRegular', fontSize: 21);
    final chordTileCNT = BoxDecoration(
        color: Color.fromRGBO(255, 255, 255, 1),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 5,
            blurRadius: 10,
            offset: Offset(0, 10), // changes position of shadow
          ),
        ],
        border: Border.all(
          width: 0.5,
          color: Color.fromRGBO(111, 111, 111, 1),
        ),
        borderRadius: BorderRadius.circular(5.0));
    double CT_heigh = MediaQuery.of(context).size.height * 0.05;
    double CT_Fheigh = CT_heigh / 2.8;
    final currentRaagButton = ElevatedButton.styleFrom(
      foregroundColor: Color.fromRGBO(11, 111,244, 1),
      backgroundColor: Color.fromRGBO(255, 255, 255, 1),
      elevation: .5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: BorderSide(
          color: Colors.grey, // Border color
          width: .8,
        ),
      ),
      alignment: Alignment.center,
    );
    var PitchSlider = ElevatedButton.styleFrom(
      padding: EdgeInsets.symmetric(horizontal: 0, vertical: CT_Fheigh / 2),
      foregroundColor: Color.fromRGBO(0, 0, 0, 1),
      backgroundColor: Color.fromRGBO(255, 255, 255, 1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
    );
    var PitchSliderDeco = BoxDecoration(
      border: Border.all(
        color: Color.fromRGBO(0, 0, 0, 1),
        width: 0.3,
      ),
      borderRadius: BorderRadius.circular(10.0),
    );
    var chordTiletxtStyl = TextStyle(
        color: Color.fromRGBO(11, 111, 244, 1),
        fontSize: 17,
        fontFamily: 'NotoSans');
    Color SwaraContainerBG = Color.fromRGBO(241, 243, 244, 1);
    Color SwarasContainerText = Color.fromRGBO(100, 100, 100, 1);
    var popupMainText = TextStyle(
        fontFamily: 'NotoSansRegular',
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Color.fromRGBO(11, 111, 244, 1));
    var popupMidText = TextStyle(
        fontFamily: 'NotoSansMid',
        fontSize: 15,
        color: Color.fromRGBO(11, 111, 244, 1),
        height: 2.5);
    var popupNormalText = TextStyle(fontFamily: 'NotoSans', fontSize: 15, height: 1.5);
    var popupNoteText = TextStyle(color: Colors.black.withOpacity(.6),
        fontFamily: 'NotoSansRegular',
        fontSize: 12,
        );
    Color lineColor = Color.fromRGBO(230, 230, 230, 1);
    var mainTxt = TextStyle(
        fontSize: CT_heigh / 2.5,
        color: SwarasContainerText,
        fontWeight: FontWeight.w400);


    var SwarasContainerDeco = BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.2),
          spreadRadius: 2,
          blurRadius: 5,
          offset: Offset(0, 5), // changes position of shadow
        ),
      ],
      border: Border.all(
        width: 0.5,
        color: Color.fromRGBO(46, 46, 46, 1),
      ),
      borderRadius: BorderRadius.circular(10.0),
      color: SwaraContainerBG,
    );

    if (tutorialChordState) {
      _createTutorialChord();
    }

    // List doopKey = RaagaLib.keys.toList();
    // List doopVal = RaagaLib.values.toList();

    // @override
    // void initState() {
    //   super.initState();
    //   _createTutorialChord();
    // }
    //
    // void updateSwaras_raaga(String RaagaName){
    //
    //   setState(() {swaraInput = RaagaLib[RaagaName];});
    //   inputMap = inputToNotes(RaagaLib[RaagaName], western_swaras);
    //   setState(() {RaagamName = RaagaName;});
    //
    //
    // }






    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => FamilyChds()));
        return true; // Prevent back navigation
      },
      child: Scaffold(
        backgroundColor: OverallBG,
        appBar: AppBar(
          toolbarHeight: screenHeight * 0.08,
          // leading: IconButton(
          //   icon: Icon(Icons.home_outlined,color: backArrow),
          //   onPressed: () {
          //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> HomeApp()));
          //   },
          // ),
          backgroundColor: OverallBG,
          title: Text(
            'Family of Chords',
            style: TextStyle(
                color: txtTitle,
                fontSize: screenHeight * 0.03,
                fontFamily: 'NotoSansMid'),
          ),

          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.chrome_reader_mode_outlined,
                        size: screenHeight * 0.035,
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              backgroundColor: Color.fromRGBO(240, 255, 255, 1),
                              content: Container(
                                //decoration: BoxDecoration(border: Border.all( width: 2.5, color: Color.fromRGBO(161, 130, 118, 1), ),borderRadius: BorderRadius.circular(10.0), color: Color.fromRGBO(220, 238, 209, 1), ),
                                padding: EdgeInsets.all(10),
                                child: RichText(
                                  text: TextSpan(
                                    text: ' ',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: 'NotoSansMid',
                                        color: Colors.black),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: 'Family of Chords\n',
                                          style: popupMainText),
                                      TextSpan(
                                        text: ''
                                            '\nFamily of chords is a group of chords that sound like they belong together because all these chords are derived from the same scale.'
                                            '\n\nTo find chords in a scale, write all the scale notes and write the alternative notes, for every note, and find their type of chord.'
                                            '\n\nThis process gives you a family of chords that belong to the scale. '
                                            'In this screen the triads are shown with the respective chord type.',
                                        style: popupNormalText,
                                      ),
                                      TextSpan(
                                          text:
                                              '\n\nTo learn how this works select the \'Learn More\' option given below,',
                                          style: popupNoteText)
                                    ],
                                  ),
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Close', style: popupMidText),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color.fromRGBO(
                                        255, 255, 255, 1), // background color
                                  ),
                                  onPressed: () {
                                    PageCtrl = 5;
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => TheoryContent()));
                                  },
                                  child:
                                      Text('Learn more', style: popupMidText),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      padding: EdgeInsets.symmetric(horizontal: 0.0),
                      child: Text(
                        'Learn',
                        style: TextStyle(fontSize: screenHeight * 0.012),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.explore_outlined,
                        size: screenHeight * 0.035,
                        color: Color.fromRGBO(0, 0, 0, 1),
                      ),
                      onPressed: () {
                        tutorialChordVbleState(true);
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (_) => FamilyChds()));
                      },
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10.0),
                      padding: EdgeInsets.symmetric(horizontal: 0.0),
                      child: Text(
                        'Walkthrough',
                        style: TextStyle(fontSize: screenHeight * 0.012),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        body: Center(
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: const EdgeInsets.symmetric(horizontal: 0.0),
            children: [
              Container(margin: EdgeInsets.all(0.0),),

              // Container(
              //   margin: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
              //   decoration: SwarasContainerDeco,
              //   padding: EdgeInsets.only(top: 5.0, left: 10.0, right: 10),
              //   alignment: Alignment.center,
              //   child: Column(
              //       children: [
              //         Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //           children: [
              //
              //             trans_info,
              //             Text('Western Notes', style: TextStyle(
              //                 fontFamily: 'NotoSansRegular',
              //                 color: SwaraContainersubText,
              //                 fontSize: 12,
              //                 fontWeight: FontWeight.normal),),
              //             coloured_info,
              //           ],
              //         ),
              //         //Container(margin: EdgeInsets.only(top:5.0),),
              //         Container(
              //           //decoration: BoxDecoration(border: Border.all( width: 2, color: Colors.black, ),),
              //           alignment: Alignment.center,
              //           margin:  EdgeInsets.symmetric(vertical: 5.0),
              //           // child: Text(ragam.substring(1, (ragam.length - 1)),
              //           child: Text(ragam2.substring(1, (ragam2.length - 1)),
              //             style: TextStyle(fontFamily: 'NotoSansRegular',
              //                 fontSize: 16,
              //                 color: SwarasContainerText,
              //                 fontWeight: FontWeight.bold),),),
              //       ]),),

              // Container(
              //   decoration: SwarasContainerDeco,
              //   margin: const EdgeInsets.only(top: 20.0,left: 50,right: 50),
              //   padding: EdgeInsets.only(top: 10.0),
              //   child: CustomPaint(
              //     size: Size(0,220),
              //     painter: PaintChord(valu: 'Tyep 1',chordNote_Index: 0),
              //   ),),

              // Container(
              //   margin: EdgeInsets.symmetric(horizontal: 0,vertical: 0),
              //   height: 310.0, // Adjust the height as needed
              //
              //   child: ListView.builder(
              //     scrollDirection: Axis.horizontal,
              //     itemCount: mainOut.length,
              //     itemBuilder: (BuildContext context, int index) {
              //       return  Container(
              //         width: 280,
              //         // margin: EdgeInsets.symmetric(vertical: 6.0,horizontal: 6),
              //         //padding: EdgeInsets.all(8.0),
              //         child: Container(
              //           decoration: SwarasContainerDeco,
              //           margin: const EdgeInsets.only(top: 10.0,left: 20,right: 20,bottom: 10),
              //           padding: EdgeInsets.only(top: 15.0,bottom: 0,left: 8),
              //           child: CustomPaint(size: Size(220,220),
              //             painter: PaintChord(
              //
              //                 valu: mainOut[index].split(' '),
              //                 chordNote_Index: index
              //
              //             ),
              //           ),),
              //
              //       );
              //     },
              //   ),
              // ),

              // Container(
              //   key: _SwarasInputSearch,
              //   child: Builder(
              //     builder: (context) {
              //       return AdvancedSearch(
              //         textEditingController: _searchController,
              //         searchItems: RaagaList,
              //         clearSearchEnabled: true,
              //         itemsShownAtStart: 10,
              //
              //         onItemTap: (int index, String value) {
              //
              //            setState(() {
              //
              //              RaagamName = value;
              //              inputMap = inputToNotes(RaagaLib[value], carnatic_swaras);
              //            });
              //         },
              //       );
              //     }
              //   ),
              // ),

              Container(),

              Container(
                key: _SwarasInputSearch,
                //decoration: BoxDecoration(border: Border.all( width: 0.5, color: Color.fromRGBO(0, 0, 0, 1), ),borderRadius: BorderRadius.circular(10.0),color: Colors.grey.shade300),
                margin: EdgeInsets.only(top: 0.0,bottom: 5,left: 60,right: 60),
                padding: EdgeInsets.only(left: 0,top: 0,bottom: 0,right: 0),
                child: AdvancedSearch(
                  searchItems: RaagaList,
                  textEditingController: _searchController,
                  maxElementsToDisplay: 3,
                  singleItemHeight: 40,
                  fontSize:16,
                  showListOfResults : true, // should a list of results be displayed to the user, or shall you just get what he searches for and you will do your things by your own
                  hideHintOnTextInputFocus:  false, // an option to hide the hin t text once the TextField get focused
                  clearSearchEnabled: true,
                  borderRadius: 5.0,
                  borderColor: Colors.black,
                  hintText: 'Search Raagam\'s Names',
                  hintTextColor: Colors.black.withOpacity(0.6),
                  cursorColor: Colors.black,
                  focusedBorderColor: Colors.black,
                  verticalPadding: 0,
                  unSelectedTextColor: Colors.black,
                  selectedTextColor: Color.fromRGBO(11,111,244, 1),
                  inputTextFieldBgColor: Color.fromRGBO(240,240,240, 1),
                  searchResultsBgColor:  Color.fromRGBO(240,240,240, 1),
                  searchMode: SearchMode.CONTAINS,
                  onItemTap: (int index, String value) {
                    setState(() {
                      didYouMean = false;
                      RaagamName = value;
                      inputMap = inputToNotes(RaagaLib[value], carnatic_swaras);
                      initialPlay(false);
                      RaagaNum = index+1;
                      AnimatedContainerInput = false;
                    });

                     // myFileWriter(inputMap['notes']);
                    // Navigator.pushReplacement(context, MaterialPageRoute(builder: (inputMap) => const FamilyChds()));
                  },

                    onEditingProgress: (searchText, listOfResults) {
                      // print("TextEdited: " + searchText);
                      // print("LENGTH: " + listOfResults.length.toString());
                      //While Length is 0, that means search keyword is bad, So
                      //then we could suggest the Raagas
                      //Sucessfully made it that way
                      List tmp = extractTop(query: searchText,choices: RaagaList,cutoff: 50,limit: 4);
                      List <String> temp2 = [];
                      for(int i = 0;i<tmp.length;i++){
                        String a = (tmp[i]).toString();
                        String b = a.split(' ')[1];
                        temp2.add(b.substring(0,b.length-1));
                      }
                      if(searchText.length>1 && listOfResults.length<1){
                        setState(() {
                          didYouMean = true;
                          extractedRaagas = temp2;
                        });
                      }
                    }

                ),
              ),

              if(didYouMean)
              Container(
                margin: EdgeInsets.symmetric(horizontal: 60,vertical: 5),
                child: Column(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(255, 255, 255, 1),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                        side: BorderSide(color: Colors.black),
                        elevation: 3,
                        shadowColor: Colors.black,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        minimumSize: Size(0, 30),
                      ),
                      onPressed: (){
                        showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor:Color.fromRGBO(240, 255, 255, 1),
                            content: SizedBox(height: 250,width: 400,
                              child:ListView(
                                children: [
                                  Container(
                                      child: Text("This is a list of possible raagas. Make sure to scroll all the way through!\n",style: popupMainText.copyWith(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 16),)),
                                  for(int i =0;i<extractedRaagas.length;i++)
                                    ListTile(
                                      title: Text(extractedRaagas[i],),
                                      onTap:(){
                                        RaagamName = extractedRaagas[i];
                                        inputMap = inputToNotes(RaagaLib[extractedRaagas[i]], carnatic_swaras);
                                        didYouMean = false;
                                        initialPlay(false);

                                        },),
                                  Container(
                                      padding:EdgeInsets.symmetric(horizontal: 20),
                                      child: Text("\nIf you still can't find the raaga, try typing its full name in the search bar.",style: popupNoteText.copyWith(fontSize: 12,color: Colors.black),)),

                                ],
                              ),
                            ),
                          );
                        },
                      );},

                        child: Text("Did You Mean?",style:popupMainText.copyWith(fontSize: 16,color: Colors.black.withOpacity(0.8),fontWeight: FontWeight.w400)),),
                    Text('Sorry for the trouble. You may find the raaga you were looking for here. Tap ‘Did you mean’.',style: popupNoteText,textAlign: TextAlign.center,),
                  ],
                ),
              ),

              Container(
                margin: EdgeInsets.only(top: didYouMean?  0 : 0, bottom: 0),
                // margin: EdgeInsets.only(top: didYouMean?  0 : 20, bottom: 0),
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Container(
                      key: _CurrentRaag,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(icon: Icon(Icons.arrow_drop_down),onPressed: (){},color: Colors.transparent,),
                           Flexible(
                             child: Text(RaagamName,
                                style: mainTxt.copyWith(
                                    fontFamily: 'NotoSansRegular',
                                    fontSize: CT_heigh / 1.5,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromRGBO(11, 111, 244, 1))),
                           ),
                          IconButton(icon: Icon(Icons.arrow_drop_down),onPressed: (){
                            setState(() {
                              AnimatedContainerInput = !AnimatedContainerInput;
                            });
                          },),
                        ],
                      ),
                    ),
                      AnimatedContainer(
                        curve: Curves.easeIn,
                          duration: Duration(milliseconds: 300),
                          width: AnimatedContainerInput?330: 0,
                          height: AnimatedContainerInput?300:0,
                          onEnd: (){scrollController.animateToItem(RaagaNum-1, duration: Duration(milliseconds: 10* RaagaNum), curve: Curves.easeInExpo);},
                          child:
                          AnimatedContainerInput? Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey,
                                  spreadRadius: 1,
                                  blurRadius: 15,
                                  offset: Offset(0,0), // changes position of shadow
                                ),
                              ],
                              border: Border.all(
                                width: 0.1,
                                color: Color.fromRGBO(46, 46, 46, 1),
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.grey.shade50,
                            ),
                            margin: EdgeInsets.only(top: 10),
                            padding: EdgeInsets.all(3),
                            child: Scaffold(
                              bottomSheet: SmoothPageIndicator(
                                  onDotClicked: (index){
                                    scrollController2.animateToPage(index, duration:Duration(milliseconds: 600), curve: Curves.slowMiddle);
                                  },
                                  effect:  WormEffect(
                                      type: WormType.thinUnderground,
                                      // jumpScale: .5,
                                      // verticalOffset: 15,
                                      spacing:  30.0,
                                      radius:  4.0,
                                      dotWidth:  30,
                                      dotHeight:  10.0,
                                      paintStyle:  PaintingStyle.stroke,
                                      strokeWidth:  1.5,
                                      dotColor:  Colors.grey,
                                      activeDotColor:  Colors.indigo
                                  ),
                                  controller: scrollController2,
                                  count: 2),
                              body: Container(

                                child: PageView(
                                  controller: scrollController2,
                                  children: [
                                    CupertinoScrollbar(
                                      controller: scrollController,
                                      thumbVisibility: true,
                                      // trackVisibility: true,
                                      thickness: 15,
                                      radius: Radius.circular(10),
                                      radiusWhileDragging: Radius.circular(25),
                                      // interactive: true,
                                      child:ListWheelScrollView.useDelegate(
                                        itemExtent: 60,
                                        controller: scrollController,
                                        perspective: 0.002,
                                        diameterRatio: 1.01,
                                        physics: FixedExtentScrollPhysics(),
                                        childDelegate: ListWheelChildBuilderDelegate(builder: (context,index){
                                          return GestureDetector(
                                            onTap: (){
                                              setState(() {
                                                RaagamName = RaagaList[index];
                                                inputMap = inputToNotes(RaagaLib[RaagaList[index]], carnatic_swaras);
                                                initialPlay(false);
                                                AnimatedContainerInput = !AnimatedContainerInput;
                                                RaagaNum = index+1;
                                              });
                                            },
                                            child: Container(
                                                margin: EdgeInsets.only(right: 10,left: 10),
                                                alignment: Alignment.center,
                                                decoration: SwarasContainerDeco,
                                                child: Text(RaagaList[index],style: popupMainText,)),
                                          );
                                        },
                                          childCount: RaagaList.length,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(bottom: 10),
                                      child:Column(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.symmetric(vertical: 10),
                                            height: 200,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                    Container(child: Text('S',style: notesBoxTextstyl,)),
                                                    Container(
                                                      decoration: PitchSliderDeco,
                                                      width: 100,
                                                      height: 50,
                                                      child: ElevatedButton(
                                                          style: PitchSlider,
                                                          onPressed: (){
                                                            print(raagRangeStart);
                                                            print(raagRangeEnd);
                                                            print(RaagaLib[RaagamName]);

                                                            setState(() {
                                                              SwaraRi = !SwaraRi;
                                                              SwaraGa = false;
                                                              SwaraDa = false;
                                                              SwaraNi = false;
                                                            });
                                                          }, child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          // Text("R"),
                                                          Text("R"+RiVal.toString()),
                                                          Icon(SwaraRi? Icons.arrow_drop_down:Icons.arrow_drop_up),
                                                        ],
                                                      )),
                                                    ),
                                                    AnimatedContainer(
                                                      duration: Duration(milliseconds: 300),
                                                      curve: Curves.linear,
                                                      margin: SwaraRi? EdgeInsets.all(5):EdgeInsets.all(0),
                                                      width:  SwaraRi? 200:0,
                                                      height: SwaraRi? 60:0,
                                                      child:  SwaraRi? Container(
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                          children: [
                                                            Flexible(
                                                              child: Container(
                                                                  width:40,
                                                                  child: ElevatedButton(
                                                                      style: PitchSlider,
                                                                      onPressed: (){
                                                                        List tmp = RaagaLib[RaagamName];
                                                                        tmp[1] = true;
                                                                        tmp[2] = false;
                                                                        tmp[3] = false;
                                                                        setRaagamforSwaras(tmp, carnatic_swaras);

                                                                        setState(() {
                                                                          RiVal = 1;
                                                                        });

                                                                        },
                                                                      child: Text('R1'))),
                                                            ),
                                                            Flexible(
                                                              child: Container(
                                                                  width:40,
                                                                  child: ElevatedButton(
                                                                      style: PitchSlider,
                                                                      onPressed: (){
                                                                        List tmp = RaagaLib[RaagamName];
                                                                        tmp[1] = false;
                                                                        tmp[2] = true;
                                                                        tmp[3] = false;
                                                                        if(tmp[4] == true){
                                                                          tmp[4] = false;
                                                                          tmp[5] = true;
                                                                        }
                                                                        setRaagamforSwaras(tmp, carnatic_swaras);
                                                                        setState(() {
                                                                          RiVal = 2;
                                                                        });

                                                                        },

                                                                      child: Text('R2'))),
                                                            ),
                                                            Flexible(
                                                              child: Container(
                                                                  width:40,
                                                                  child: ElevatedButton(
                                                                      style: PitchSlider,
                                                                      onPressed: (){
                                                                        List tmp = RaagaLib[RaagamName];
                                                                        tmp[1] = false;
                                                                        tmp[2] = false;
                                                                        tmp[3] = true;
                                                                        tmp[4] = false;
                                                                        tmp[5] = false;
                                                                        tmp[6] = true;
                                                                        setRaagamforSwaras(tmp, carnatic_swaras);

                                                                        setState(() {
                                                                          RiVal = 3;
                                                                        });
                                                                        },
                                                                      child: Text('R3',))),
                                                            ),
                                                          ],),
                                                      ):
                                                      Container(),
                                                    ),

                                                    Container(
                                                      decoration: PitchSliderDeco,
                                                      width: 100,
                                                      height: 50,
                                                      child: ElevatedButton(
                                                          style: PitchSlider,
                                                          onPressed: (){
                                                            setState(() {
                                                              SwaraRi = false;
                                                              SwaraGa = !SwaraGa;
                                                              SwaraDa = false;
                                                              SwaraNi = false;
                                                            });
                                                          }, child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          // Text("G"),
                                                          Text("G"+GaVal.toString()),
                                                          Icon(SwaraRi? Icons.arrow_drop_down:Icons.arrow_drop_up),
                                                        ],
                                                      )),
                                                    ),
                                                    AnimatedContainer(
                                                      duration: Duration(milliseconds: 300),
                                                      curve: Curves.linear,
                                                      margin: SwaraGa? EdgeInsets.all(5):EdgeInsets.all(0),
                                                      width:  SwaraGa? 200:0,
                                                      height: SwaraGa? 60:0,
                                                      child:  SwaraGa? Container(
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                          children: [
                                                            Flexible(
                                                              child: Container(
                                                                  width:40,
                                                                  child: ElevatedButton(
                                                                      style: PitchSlider,
                                                                      onPressed: (){
                                                                        List tmp = RaagaLib[RaagamName];
                                                                        tmp[1] = true;
                                                                        tmp[2] = false;
                                                                        tmp[3] = false;
                                                                        tmp[4] = true;
                                                                        tmp[5] = false;
                                                                        tmp[6] = false;
                                                                        setRaagamforSwaras(tmp, carnatic_swaras);
                                                                        setState(() {GaVal = 1; });
                                                                        },
                                                                      child: Text('G1'))),
                                                            ),
                                                            Flexible(
                                                              child: Container(
                                                                  width:40,
                                                                  child: ElevatedButton(
                                                                      style: PitchSlider,
                                                                      onPressed: (){
                                                                        List tmp = RaagaLib[RaagamName];
                                                                        if(tmp[3]){
                                                                          tmp[2] = true;
                                                                          tmp[3] = false;
                                                                        }
                                                                        tmp[4] = false;
                                                                        tmp[5] = true;
                                                                        tmp[6] = false;
                                                                        setRaagamforSwaras(tmp, carnatic_swaras);
                                                                        setState(() {GaVal = 2; });
                                                                        },
                                                                      child: Text('G2'))),
                                                            ),
                                                            Flexible(
                                                              child: Container(
                                                                  width:40,
                                                                  child: ElevatedButton(
                                                                      style: PitchSlider,
                                                                      onPressed: (){
                                                                        List tmp = RaagaLib[RaagamName];
                                                                        tmp[4] = false;
                                                                        tmp[5] = false;
                                                                        tmp[6] = true;
                                                                        setRaagamforSwaras(tmp, carnatic_swaras);
                                                                        setState(() {GaVal = 3; });
                                                                        },
                                                                      child: Text('G3'))),
                                                            ),


                                                          ],),
                                                      ):
                                                      Container(decoration: SwarasContainerDeco,),
                                                    ),
                                                  ],),
                                                Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                    Container(
                                                      child: Text('P',style: notesBoxTextstyl,),
                                                    ),
                                                    Container(
                                                      decoration: PitchSliderDeco,
                                                      width:100,
                                                      height: 50,
                                                      child: ElevatedButton(
                                                          style: PitchSlider,
                                                          onPressed: (){
                                                            setState(() {
                                                              SwaraRi = false;
                                                              SwaraGa = false;
                                                              SwaraDa = !SwaraDa;
                                                              SwaraNi = false;
                                                            });
                                                          }, child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          // Text("D"),
                                                          Text("D"+DaVal.toString()),
                                                          Icon(SwaraRi? Icons.arrow_drop_down:Icons.arrow_drop_up),
                                                        ],
                                                      )),
                                                    ),
                                                    AnimatedContainer(
                                                      duration: Duration(milliseconds: 300),
                                                      curve: Curves.linear,
                                                      margin: SwaraDa? EdgeInsets.all(5):EdgeInsets.all(0),
                                                      width:  SwaraDa? 200:0,
                                                      height: SwaraDa? 60:0,
                                                      child:  SwaraDa? Container(
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                          children: [
                                                            Flexible(
                                                              child: Container(
                                                                  width:40,
                                                                  child: ElevatedButton(
                                                                      style: PitchSlider,
                                                                      onPressed: (){
                                                                        List tmp = RaagaLib[RaagamName];
                                                                        tmp[10] = true;
                                                                        tmp[11] = false;
                                                                        tmp[12] = false;
                                                                        setRaagamforSwaras(tmp, carnatic_swaras);
                                                                        setState(() {DaVal = 1; });
                                                                        },
                                                                      child: Text('D1'))),
                                                            ),
                                                            Flexible(
                                                              child: Container(
                                                                  width:40,
                                                                  child: ElevatedButton(
                                                                      style: PitchSlider,
                                                                      onPressed: (){
                                                                        List tmp = RaagaLib[RaagamName];
                                                                        tmp[10] = false;
                                                                        tmp[11] = true;
                                                                        tmp[12] = false;
                                                                        if(tmp[13]){
                                                                          tmp[13] = false;
                                                                          tmp[14] = true;
                                                                        }
                                                                        setState(() {DaVal = 2; });
                                                                        setRaagamforSwaras(tmp, carnatic_swaras); },
                                                                      child: Text('D2'))),
                                                            ),
                                                            Flexible(
                                                              child: Container(
                                                                  width:40,
                                                                  child: ElevatedButton(
                                                                      style: PitchSlider,
                                                                      onPressed: (){
                                                                        List tmp = RaagaLib[RaagamName];
                                                                        tmp[10] = false;
                                                                        tmp[11] = false;
                                                                        tmp[12] = true;
                                                                        tmp[13] = false;
                                                                        tmp[14] = false;
                                                                        tmp[15] = true;
                                                                        setState(() {DaVal = 3; });
                                                                        setRaagamforSwaras(tmp, carnatic_swaras); },
                                                                      child: Text('D3'))),
                                                            ),


                                                          ],),
                                                      ):
                                                      Container(),
                                                    ),

                                                    Container(
                                                      width: 100,
                                                      height: 50,
                                                      decoration: PitchSliderDeco,
                                                      child: ElevatedButton(
                                                          style: PitchSlider,
                                                          onPressed: (){
                                                            setState(() {
                                                              SwaraRi = false;
                                                              SwaraGa = false;
                                                              SwaraDa = false;
                                                              SwaraNi = !SwaraNi;
                                                            });
                                                          }, child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Text("N"+NiVal.toString()),
                                                          // Text("N"),
                                                          Icon(SwaraRi? Icons.arrow_drop_down:Icons.arrow_drop_up),
                                                        ],
                                                      )),
                                                    ),
                                                    AnimatedContainer(
                                                      duration: Duration(milliseconds: 300),
                                                      curve: Curves.linear,
                                                      margin: SwaraNi? EdgeInsets.all(5):EdgeInsets.all(0),
                                                      width:  SwaraNi? 200:0,
                                                      height: SwaraNi? 60:0,
                                                      child:  SwaraNi? Container(
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                          children: [
                                                            Flexible(
                                                              child: Container(
                                                                  width:40,
                                                                  child: ElevatedButton(
                                                                      style: PitchSlider,
                                                                      onPressed: (){
                                                                        List tmp = RaagaLib[RaagamName];
                                                                        tmp[10] = true;
                                                                        tmp[11] = false;
                                                                        tmp[12] = false;
                                                                        tmp[13] = true;
                                                                        tmp[14] = false;
                                                                        tmp[15] = false;
                                                                        setState(() {NiVal = 1; });
                                                                        setRaagamforSwaras(tmp, carnatic_swaras); },
                                                                      child: Text('N1'))),
                                                            ),
                                                            Flexible(
                                                              child: Container(
                                                                  width:40,
                                                                  child: ElevatedButton(
                                                                      style: PitchSlider,
                                                                      onPressed: (){
                                                                        List tmp = RaagaLib[RaagamName];
                                                                        if(tmp[12]){
                                                                          tmp[11] = true;
                                                                          tmp[12] = false;
                                                                        }
                                                                        tmp[13] = false;
                                                                        tmp[14] = true;
                                                                        tmp[15] = false;
                                                                        setState(() {NiVal = 2; });
                                                                        setRaagamforSwaras(tmp, carnatic_swaras); },
                                                                      child: Text('N2'))),
                                                            ),
                                                            Flexible(
                                                              child: Container(
                                                                  width:40,
                                                                  child: ElevatedButton(
                                                                      style: PitchSlider,
                                                                      onPressed: (){
                                                                        List tmp = RaagaLib[RaagamName];
                                                                        tmp[13] = false;
                                                                        tmp[14] = false;
                                                                        tmp[15] = true;
                                                                        setState(() {NiVal = 3; });
                                                                        setRaagamforSwaras(tmp, carnatic_swaras); },
                                                                      child: Text('N3'))),
                                                            ),


                                                          ],),
                                                      ):
                                                      Container(),
                                                    ),
                                                  ],),
                                              ],),
                                          ),

                                          GestureDetector(
                                            onTap: (){
                                              setState(() {SwaraMa = !SwaraMa;});

                                              List tmp = RaagaLib[RaagamName];
                                              //[true, true, false, false, false, false, true, false, true, true, false, true, false, false, false, true, true]
                                              if(SwaraMa){
                                                tmp[7] = true;
                                                tmp[8] = false;
                                              } else{
                                                tmp[7] = false;
                                                tmp[8] = true;
                                              }
                                              setRaagamforSwaras(tmp, carnatic_swaras);
                                            },

                                            child: Container(
                                              decoration: SwarasContainerDeco.copyWith(color: Colors.white),
                                              height: 40,
                                              width: 150 ,
                                              child: Row(
                                                mainAxisAlignment: SwaraMa? MainAxisAlignment.start:MainAxisAlignment.end,
                                                children: [
                                                  AnimatedContainer(duration: Duration(milliseconds: 300),
                                                    child:Text("M1",style: SwaraMa?chordTiletxtStyl:null,),
                                                    width: SwaraMa? 100:40,
                                                    alignment: Alignment.center,
                                                    decoration: SwaraMa?SwarasContainerDeco:SwarasContainerDeco.copyWith(boxShadow: [
                                                      BoxShadow(color: Colors.transparent),],
                                                      border: Border.all(width: 0,color: Colors.transparent,),
                                                      color: Colors.white,),

                                                  ),
                                                  AnimatedContainer(duration: Duration(milliseconds: 300),
                                                    child:Text("M2",style: SwaraMa?null:chordTiletxtStyl,),
                                                    width: SwaraMa? 40: 100,
                                                    alignment: Alignment.center,
                                                    decoration: SwaraMa?SwarasContainerDeco.copyWith(boxShadow: [
                                                      BoxShadow(color: Colors.transparent),],
                                                      border: Border.all(width: 0,color: Colors.transparent,),
                                                      color: Colors.white,):SwarasContainerDeco,

                                                  ),
                                                  // ElevatedButton(
                                                  //   style: ElevatedButton.styleFrom(
                                                  //     foregroundColor: SwaraMa?Colors.red:Colors.blue,
                                                  //     backgroundColor: SwaraMa?Colors.blue:Colors.red,
                                                  //   ),
                                                  //   onPressed: (){
                                                  //     setState(() {
                                                  //       SwaraMa = !SwaraMa;
                                                  //     });
                                                  //   },
                                                  //   child: SwaraMa? Text('M1'):Text('M2'),
                                                  // ),
                                                  // ElevatedButton(
                                                  //   style: ElevatedButton.styleFrom(
                                                  //     foregroundColor: SwaraMa?Colors.red:Colors.blue,
                                                  //     backgroundColor: SwaraMa?Colors.blue:Colors.red,
                                                  //   ),
                                                  //   onPressed: (){
                                                  //     setState(() {
                                                  //       SwaraMa = !SwaraMa;
                                                  //     });
                                                  //   },
                                                  //   child: SwaraMa? Text('M1'):Text('M2'),
                                                  // ),
                                                ],
                                              ),
                                            ),
                                          ),

                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ):
                          Container(decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                spreadRadius: 1,
                                blurRadius: 15,
                                offset: Offset(0,0), // changes position of shadow
                              ),
                            ],
                            border: Border.all(
                              width: 0.1,
                              color: Color.fromRGBO(46, 46, 46, 1),
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.grey.shade50,
                          ),),
                      ),







                    // Container(
                    //   decoration: SwarasContainerDeco,
                    //   height: 500,
                    //   child: ListWheelScrollView(
                    //     children: [
                    //       for(int i = 0;i<72;i++)
                    //         GestureDetector(
                    //             onTap: (){
                    //               setState(() {
                    //                 RaagamName = RaagaList[i];
                    //                 inputMap = inputToNotes(RaagaLib[RaagaList[i]], carnatic_swaras);
                    //                 initialPlay(false);
                    //               });
                    //
                    //             },
                    //             child: Container(
                    //                 padding: EdgeInsets.symmetric(horizontal: 40,vertical: 15),
                    //                 decoration: SwarasContainerDeco,
                    //                 child: Text(RaagaList[i]))),
                    //     ],
                    //     controller: scrollController,
                    //     perspective: 0.001,
                    //     itemExtent: 50,
                    //     diameterRatio: 1,
                    //   ),
                    // ),

                    Container(),

                    // Text('\t\tswaras',style: TextStyle(fontSize: 14,fontWeight: FontWeight.w300,color: subText,)),

                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //   children: [
                    //     Column(
                    //       children: [
                    //         Container(alignment: Alignment.centerRight ,width:180, child: Text(ragam.substring(1, (ragam.length - 1)),style: mainTxt)),
                    //         Container(alignment: Alignment.centerRight ,width:180, child: Text('Western\t\t',style: TextStyle(fontSize: 14,fontWeight: FontWeight.w300,color: subText,))),
                    //       ],
                    //     ),
                    //     Container(alignment: Alignment.center ,width: 1, child: Text('|')),
                    //     Column(
                    //       children: [
                    //         Container(alignment: Alignment.topLeft ,width:180, child: Text(ragam2.substring(1, (ragam2.length - 1)),style:mainTxt)),
                    //         Container(alignment: Alignment.topLeft ,width:180, child: Text('\t\tCarnatic',style: TextStyle(fontSize: 14,fontWeight: FontWeight.w300,color: subText,))),
                    //       ],
                    //     ),],),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(onPressed: ()async{
                          List tmp = inputMap['scale'];
                          for(int k = 0; k<tmp.length-1;k++){
                            _flutterMidi.playMidiNote(midi: MidiNum[tmp[k]]);
                            await Future.delayed(Duration(milliseconds: 250));
                            if (k == 6){
                              _flutterMidi.playMidiNote(midi: MidiNum[tmp[0]]+12);
                            }
                          }
                          }, icon: Icon(Icons.swipe_right,size: 20,color: Colors.grey,)),
                        Flexible(
                          child: Container(
                            key:_CurrentSwaras,
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            child: GestureDetector(
                                onHorizontalDragStart: (details)async{
                                  if (details.localPosition.dx<screenWidth/4){
                                    List tmp = inputMap['scale'];
                                    for(int k = 0; k<tmp.length-1;k++){
                                      _flutterMidi.playMidiNote(midi: MidiNum[tmp[k]]);
                                      await Future.delayed(Duration(milliseconds: 250));
                                      if (k == 6){
                                        _flutterMidi.playMidiNote(midi: MidiNum[tmp[0]]+12);
                                      }
                                    }


                                  }
                                  if (details.localPosition.dx>screenWidth/4){
                                    List tmp = inputMap['scale'];

                                    for(int k = tmp.length-1; k>=0;k--){

                                      if (k == 7){
                                        _flutterMidi.playMidiNote(midi: MidiNum[tmp[0]]+12);
                                        await Future.delayed(Duration(milliseconds: 250));
                                      }
                                      else{
                                        _flutterMidi.playMidiNote(midi: MidiNum[tmp[k]]);
                                        await Future.delayed(Duration(milliseconds: 250));
                                      }
                                    }

                                  }

                                },
                                onTap: ()async{
                                  List tmp = inputMap['scale'];
                                  for(int k = 0; k<tmp.length-1;k++){
                                    _flutterMidi.playMidiNote(midi: MidiNum[tmp[k]]);
                                    await Future.delayed(Duration(milliseconds: 250));
                                    if (k == 6){
                                      _flutterMidi.playMidiNote(midi: MidiNum[tmp[0]]+12);

                                    }
                                  }

                                  await Future.delayed(Duration(milliseconds: 500));
                                  for(int k = tmp.length-1; k>=0;k--){

                                    if (k == 7){
                                      _flutterMidi.playMidiNote(midi: MidiNum[tmp[0]]+12);
                                      await Future.delayed(Duration(milliseconds: 250));
                                    }
                                    else{
                                      _flutterMidi.playMidiNote(midi: MidiNum[tmp[k]]);
                                      await Future.delayed(Duration(milliseconds: 250));
                                    }
                                  }

                                },
                                child: Text(ragam2.substring(1, (ragam2.length - 1)),style: mainTxt,textAlign: TextAlign.center,)),
                          ),
                        ),
                        IconButton(onPressed: ()async{
                          List tmp = inputMap['scale'];
                          for(int k = tmp.length-1; k>=0;k--){
                            if (k == 7){
                              _flutterMidi.playMidiNote(midi: MidiNum[tmp[0]]+12);
                              await Future.delayed(Duration(milliseconds: 250));
                            }
                            else{
                              _flutterMidi.playMidiNote(midi: MidiNum[tmp[k]]);
                              await Future.delayed(Duration(milliseconds: 250));
                            }

                          }

                        }, icon: Icon(Icons.swipe_left,size: 20,color: Colors.grey)),
                      ],
                    ),


                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //   children: [
                    //     ElevatedButton(
                    //       style:chordTileBTN,
                    //         onPressed: ()async{
                    //           List tmp = inputMap['scale'];
                    //           for(int k = 0; k<tmp.length-1;k++){
                    //             _flutterMidi.playMidiNote(midi: MidiNum[tmp[k]]);
                    //             await Future.delayed(Duration(milliseconds: 250));
                    //             if (k == 6){
                    //               _flutterMidi.playMidiNote(midi: MidiNum[tmp[0]]+12);
                    //             }
                    //           }
                    //         },
                    //         child:Icon(Icons.keyboard_arrow_right)),
                    //
                    //
                    //     ElevatedButton(
                    //       style: chordTileBTN,
                    //         onPressed: ()async{
                    //
                    //
                    //           List tmp = inputMap['scale'];
                    //           for(int k = 0; k<tmp.length-1;k++){
                    //             _flutterMidi.playMidiNote(midi: MidiNum[tmp[k]]);
                    //             await Future.delayed(Duration(milliseconds: 250));
                    //             if (k == 6){
                    //               _flutterMidi.playMidiNote(midi: MidiNum[tmp[0]]+12);
                    //
                    //             }
                    //           }
                    //
                    //           await Future.delayed(Duration(milliseconds: 500));
                    //           for(int k = tmp.length-1; k>=0;k--){
                    //
                    //             if (k == 7){
                    //               _flutterMidi.playMidiNote(midi: MidiNum[tmp[0]]+12);
                    //               await Future.delayed(Duration(milliseconds: 250));
                    //             }
                    //             else{
                    //               _flutterMidi.playMidiNote(midi: MidiNum[tmp[k]]);
                    //               await Future.delayed(Duration(milliseconds: 250));
                    //             }
                    //           }
                    //
                    //         },
                    //         child: Text(ragam2.substring(1, (ragam2.length - 1)),style: mainTxt,textAlign: TextAlign.center,)),
                    //
                    //     ElevatedButton(
                    //       style: chordTileBTN,
                    //         onPressed: ()async{
                    //           List tmp = inputMap['scale'];
                    //
                    //           for(int k = tmp.length-1; k>=0;k--){
                    //
                    //             if (k == 7){
                    //               _flutterMidi.playMidiNote(midi: MidiNum[tmp[0]]+12);
                    //               await Future.delayed(Duration(milliseconds: 250));
                    //             }
                    //             else{
                    //               _flutterMidi.playMidiNote(midi: MidiNum[tmp[k]]);
                    //               await Future.delayed(Duration(milliseconds: 250));
                    //             }
                    //           }
                    //         },
                    //         child:Icon(Icons.keyboard_arrow_left)),
                    //
                    //   ],
                    // ),
                    // //THE BUTTON TYPE

                  ],
                ),
              ),



              // //The Original Script that has the Page view, and Swara Input Selection...!
              // Container(
              //   margin: EdgeInsets.only(top: didYouMean?  0 : 20, bottom: 0),
              //   alignment: Alignment.center,
              //   child: Column(
              //     children: [
              //       GestureDetector(
              //         key: _CurrentRaag,
              //         onTap: (){
              //           setState(() {
              //             AnimatedContainerInput = !AnimatedContainerInput;
              //             setRiVal();
              //           });
              //         },
              //         child: Text(RaagamName,
              //             style: mainTxt.copyWith(
              //                 fontFamily: 'NotoSansRegular',
              //                 fontSize: CT_heigh / 1.5,
              //                 fontWeight: FontWeight.bold,
              //                 color: Color.fromRGBO(11, 111, 244, 1))),
              //       ),
              //       AnimatedContainer(
              //         curve: Curves.easeInOutQuint,
              //         duration: Duration(milliseconds: 100),
              //         width: AnimatedContainerInput?330:10,
              //         height: AnimatedContainerInput?300:5,
              //         onEnd: (){scrollController.animateToItem(RaagaNum-1, duration: Duration(milliseconds: 10* RaagaNum), curve: Curves.easeInExpo);},
              //         child:
              //         AnimatedContainerInput? Container(
              //           decoration: SwarasContainerDeco,
              //           padding: EdgeInsets.all(3),
              //           child: Scaffold(
              //             bottomSheet: SmoothPageIndicator(
              //                 onDotClicked: (index){
              //                   scrollController2.animateToPage(index, duration:Duration(milliseconds: 600), curve: Curves.slowMiddle);
              //                 },
              //                 effect:  WormEffect(
              //                     type: WormType.thinUnderground,
              //                     // jumpScale: .5,
              //                     // verticalOffset: 15,
              //                     spacing:  30.0,
              //                     radius:  4.0,
              //                     dotWidth:  30,
              //                     dotHeight:  10.0,
              //                     paintStyle:  PaintingStyle.stroke,
              //                     strokeWidth:  1.5,
              //                     dotColor:  Colors.grey,
              //                     activeDotColor:  Colors.indigo
              //                 ),
              //                 controller: scrollController2,
              //                 count: 3),
              //             body: Container(
              //
              //               child: PageView(
              //                 controller: scrollController2,
              //                 children: [
              //                   CupertinoScrollbar(
              //                     controller: scrollController,
              //                     thumbVisibility: true,
              //                     // trackVisibility: true,
              //                     thickness: 15,
              //                     radius: Radius.circular(10),
              //                     radiusWhileDragging: Radius.circular(25),
              //                     // interactive: true,
              //                     child:ListWheelScrollView.useDelegate(
              //                       itemExtent: 60,
              //                       controller: scrollController,
              //                       perspective: 0.002,
              //                       diameterRatio: 1.01,
              //                       physics: FixedExtentScrollPhysics(),
              //                       childDelegate: ListWheelChildBuilderDelegate(builder: (context,index){
              //                         return GestureDetector(
              //                           onTap: (){
              //                             setState(() {
              //                               RaagamName = RaagaList[index];
              //                               inputMap = inputToNotes(RaagaLib[RaagaList[index]], carnatic_swaras);
              //                               initialPlay(false);
              //                               AnimatedContainerInput = !AnimatedContainerInput;
              //                               RaagaNum = index+1;
              //                             });
              //                           },
              //                           child: Container(
              //                               margin: EdgeInsets.only(right: 10,left: 10),
              //                               alignment: Alignment.center,
              //                               decoration: SwarasContainerDeco,
              //                               child: Text(RaagaList[index],style: popupMainText,)),
              //                         );
              //                       },
              //                         childCount: RaagaList.length,
              //                       ),
              //                     ),
              //                   ),
              //                   Container(
              //                     margin: EdgeInsets.only(bottom: 10),
              //                     child:Column(
              //                       children: [
              //                         Container(
              //                           margin: EdgeInsets.symmetric(vertical: 10),
              //                           height: 200,
              //                           child: Row(
              //                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //                             children: [
              //                               Column(
              //                                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //                                 children: [
              //                                   Container(child: Text('S',style: notesBoxTextstyl,)),
              //
              //                                   Container(
              //                                     decoration: PitchSliderDeco,
              //                                     width: 100,
              //                                     height: 50,
              //                                     child: ElevatedButton(
              //                                         style: PitchSlider,
              //                                         onPressed: (){
              //                                           print(raagRangeStart);
              //                                           print(raagRangeEnd);
              //                                           print(RaagaLib[RaagamName]);
              //
              //                                           setState(() {
              //                                             SwaraRi = !SwaraRi;
              //                                             SwaraGa = false;
              //                                             SwaraDa = false;
              //                                             SwaraNi = false;
              //                                           });
              //                                         }, child: Row(
              //                                       mainAxisAlignment: MainAxisAlignment.center,
              //                                       children: [
              //                                         Text("R"),
              //                                         Icon(SwaraRi? Icons.arrow_drop_down:Icons.arrow_drop_up),
              //                                       ],
              //                                     )),
              //                                   ),
              //                                   AnimatedContainer(
              //                                     duration: Duration(milliseconds: 300),
              //                                     curve: Curves.linear,
              //                                     margin: SwaraRi? EdgeInsets.all(5):EdgeInsets.all(0),
              //                                     width:  SwaraRi? 200:0,
              //                                     height: SwaraRi? 60:0,
              //                                     child:  SwaraRi? Container(
              //                                       child: Row(
              //                                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //                                         children: [
              //                                           Flexible(
              //                                             child: Container(
              //                                                 width:40,
              //                                                 child: ElevatedButton(
              //                                                     style: PitchSlider,
              //                                                     onPressed: (){
              //                                                       List tmp = RaagaLib[RaagamName];
              //                                                       tmp[1] = true;
              //                                                       tmp[2] = false;
              //                                                       tmp[3] = false;
              //                                                       setRaagamforSwaras(tmp, carnatic_swaras,1.toInt(),"RiVal"); },
              //                                                     child: Text('R1'))),
              //                                           ),
              //                                           Flexible(
              //                                             child: Container(
              //                                                 width:40,
              //                                                 child: ElevatedButton(
              //                                                     style: PitchSlider,
              //                                                     onPressed: (){
              //                                                       List tmp = RaagaLib[RaagamName];
              //                                                       tmp[1] = false;
              //                                                       tmp[2] = true;
              //                                                       tmp[3] = false;
              //                                                       if(tmp[4] == true){
              //                                                         tmp[4] = false;
              //                                                         tmp[5] = true;
              //                                                       }
              //                                                       setRaagamforSwaras(tmp, carnatic_swaras,2.toInt(),"RiVal"); },
              //
              //                                                     child: Text('R2'))),
              //                                           ),
              //                                           Flexible(
              //                                             child: Container(
              //                                                 width:40,
              //                                                 child: ElevatedButton(
              //                                                     style: PitchSlider,
              //                                                     onPressed: (){
              //                                                       List tmp = RaagaLib[RaagamName];
              //                                                       tmp[1] = false;
              //                                                       tmp[2] = false;
              //                                                       tmp[3] = true;
              //                                                       tmp[4] = false;
              //                                                       tmp[5] = false;
              //                                                       tmp[6] = true;
              //                                                       setRaagamforSwaras(tmp, carnatic_swaras,3.toInt(),"RiVal"); },
              //                                                     child: Text('R3',))),
              //                                           ),
              //                                         ],),
              //                                     ):
              //                                     Container(),
              //                                   ),
              //
              //                                   Container(
              //                                     decoration: PitchSliderDeco,
              //                                     width: 100,
              //                                     height: 50,
              //                                     child: ElevatedButton(
              //                                         style: PitchSlider,
              //                                         onPressed: (){
              //                                           setState(() {
              //                                             SwaraRi = false;
              //                                             SwaraGa = !SwaraGa;
              //                                             SwaraDa = false;
              //                                             SwaraNi = false;
              //                                           });
              //                                         }, child: Row(
              //                                       mainAxisAlignment: MainAxisAlignment.center,
              //                                       children: [
              //                                         Text("G"),
              //                                         Icon(SwaraRi? Icons.arrow_drop_down:Icons.arrow_drop_up),
              //                                       ],
              //                                     )),
              //                                   ),
              //                                   AnimatedContainer(
              //                                     duration: Duration(milliseconds: 300),
              //                                     curve: Curves.linear,
              //                                     margin: SwaraGa? EdgeInsets.all(5):EdgeInsets.all(0),
              //                                     width:  SwaraGa? 200:0,
              //                                     height: SwaraGa? 60:0,
              //                                     child:  SwaraGa? Container(
              //                                       child: Row(
              //                                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //                                         children: [
              //                                           Flexible(
              //                                             child: Container(
              //                                                 width:40,
              //                                                 child: ElevatedButton(
              //                                                     style: PitchSlider,
              //                                                     onPressed: (){
              //                                                       List tmp = RaagaLib[RaagamName];
              //                                                       tmp[1] = true;
              //                                                       tmp[2] = false;
              //                                                       tmp[3] = false;
              //                                                       tmp[4] = true;
              //                                                       tmp[5] = false;
              //                                                       tmp[6] = false;
              //                                                       setRaagamforSwaras(tmp, carnatic_swaras,1.toInt(),"GaVal"); },
              //                                                     child: Text('G1'))),
              //                                           ),
              //                                           Flexible(
              //                                             child: Container(
              //                                                 width:40,
              //                                                 child: ElevatedButton(
              //                                                     style: PitchSlider,
              //                                                     onPressed: (){
              //                                                       List tmp = RaagaLib[RaagamName];
              //                                                       if(tmp[3]){
              //                                                         tmp[2] = true;
              //                                                         tmp[3] = false;
              //                                                       }
              //                                                       tmp[4] = false;
              //                                                       tmp[5] = true;
              //                                                       tmp[6] = false;
              //                                                       setRaagamforSwaras(tmp, carnatic_swaras,2.toInt(),"GaVal"); },
              //                                                     child: Text('G2'))),
              //                                           ),
              //                                           Flexible(
              //                                             child: Container(
              //                                                 width:40,
              //                                                 child: ElevatedButton(
              //                                                     style: PitchSlider,
              //                                                     onPressed: (){
              //                                                       List tmp = RaagaLib[RaagamName];
              //                                                       tmp[4] = false;
              //                                                       tmp[5] = false;
              //                                                       tmp[6] = true;
              //                                                       setRaagamforSwaras(tmp, carnatic_swaras,3.toInt(),"GaVal"); },
              //                                                     child: Text('G3'))),
              //                                           ),
              //
              //
              //                                         ],),
              //                                     ):
              //                                     Container(decoration: SwarasContainerDeco,),
              //                                   ),
              //                                 ],),
              //                               Column(
              //                                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //                                 children: [
              //                                   Container(
              //                                     child: Text('P',style: notesBoxTextstyl,),
              //                                   ),
              //                                   Container(
              //                                     decoration: PitchSliderDeco,
              //                                     width:100,
              //                                     height: 50,
              //                                     child: ElevatedButton(
              //                                         style: PitchSlider,
              //                                         onPressed: (){
              //                                           setState(() {
              //                                             SwaraRi = false;
              //                                             SwaraGa = false;
              //                                             SwaraDa = !SwaraDa;
              //                                             SwaraNi = false;
              //                                           });
              //                                         }, child: Row(
              //                                       mainAxisAlignment: MainAxisAlignment.center,
              //                                       children: [
              //                                         Text("D"),
              //                                         Icon(SwaraRi? Icons.arrow_drop_down:Icons.arrow_drop_up),
              //                                       ],
              //                                     )),
              //                                   ),
              //                                   AnimatedContainer(
              //                                     duration: Duration(milliseconds: 300),
              //                                     curve: Curves.linear,
              //                                     margin: SwaraDa? EdgeInsets.all(5):EdgeInsets.all(0),
              //                                     width:  SwaraDa? 200:0,
              //                                     height: SwaraDa? 60:0,
              //                                     child:  SwaraDa? Container(
              //                                       child: Row(
              //                                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //                                         children: [
              //                                           Flexible(
              //                                             child: Container(
              //                                                 width:40,
              //                                                 child: ElevatedButton(
              //                                                     style: PitchSlider,
              //                                                     onPressed: (){
              //                                                       List tmp = RaagaLib[RaagamName];
              //                                                       tmp[10] = true;
              //                                                       tmp[11] = false;
              //                                                       tmp[12] = false;
              //                                                       setRaagamforSwaras(tmp, carnatic_swaras,1.toInt(),"DaVal"); },
              //                                                     child: Text('D1'))),
              //                                           ),
              //                                           Flexible(
              //                                             child: Container(
              //                                                 width:40,
              //                                                 child: ElevatedButton(
              //                                                     style: PitchSlider,
              //                                                     onPressed: (){
              //                                                       List tmp = RaagaLib[RaagamName];
              //                                                       tmp[10] = false;
              //                                                       tmp[11] = true;
              //                                                       tmp[12] = false;
              //                                                       if(tmp[13]){
              //                                                         tmp[13] = false;
              //                                                         tmp[14] = true;
              //                                                       }
              //                                                       setRaagamforSwaras(tmp, carnatic_swaras,2,"DaVal"); },
              //                                                     child: Text('D2'))),
              //                                           ),
              //                                           Flexible(
              //                                             child: Container(
              //                                                 width:40,
              //                                                 child: ElevatedButton(
              //                                                     style: PitchSlider,
              //                                                     onPressed: (){
              //                                                       List tmp = RaagaLib[RaagamName];
              //                                                       tmp[10] = false;
              //                                                       tmp[11] = false;
              //                                                       tmp[12] = true;
              //                                                       tmp[13] = false;
              //                                                       tmp[14] = false;
              //                                                       tmp[15] = true;
              //                                                       setRaagamforSwaras(tmp, carnatic_swaras,3,"DaVal"); },
              //                                                     child: Text('D3'))),
              //                                           ),
              //
              //
              //                                         ],),
              //                                     ):
              //                                     Container(),
              //                                   ),
              //
              //                                   Container(
              //                                     width: 100,
              //                                     height: 50,
              //                                     decoration: PitchSliderDeco,
              //                                     child: ElevatedButton(
              //                                         style: PitchSlider,
              //                                         onPressed: (){
              //                                           setState(() {
              //                                             SwaraRi = false;
              //                                             SwaraGa = false;
              //                                             SwaraDa = false;
              //                                             SwaraNi = !SwaraNi;
              //                                           });
              //                                         }, child: Row(
              //                                       mainAxisAlignment: MainAxisAlignment.center,
              //                                       children: [
              //                                         // Text("N"+NiVal.toString()),
              //                                         Text("N"),
              //                                         Icon(SwaraRi? Icons.arrow_drop_down:Icons.arrow_drop_up),
              //                                       ],
              //                                     )),
              //                                   ),
              //                                   AnimatedContainer(
              //                                     duration: Duration(milliseconds: 300),
              //                                     curve: Curves.linear,
              //                                     margin: SwaraNi? EdgeInsets.all(5):EdgeInsets.all(0),
              //                                     width:  SwaraNi? 200:0,
              //                                     height: SwaraNi? 60:0,
              //                                     child:  SwaraNi? Container(
              //                                       child: Row(
              //                                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //                                         children: [
              //                                           Flexible(
              //                                             child: Container(
              //                                                 width:40,
              //                                                 child: ElevatedButton(
              //                                                     style: PitchSlider,
              //                                                     onPressed: (){
              //                                                       List tmp = RaagaLib[RaagamName];
              //                                                       tmp[10] = true;
              //                                                       tmp[11] = false;
              //                                                       tmp[12] = false;
              //                                                       tmp[13] = true;
              //                                                       tmp[14] = false;
              //                                                       tmp[15] = false;
              //                                                       setRaagamforSwaras(tmp, carnatic_swaras,1.toInt(),"NiVal"); },
              //                                                     child: Text('N1'))),
              //                                           ),
              //                                           Flexible(
              //                                             child: Container(
              //                                                 width:40,
              //                                                 child: ElevatedButton(
              //                                                     style: PitchSlider,
              //                                                     onPressed: (){
              //                                                       List tmp = RaagaLib[RaagamName];
              //                                                       if(tmp[12]){
              //                                                         tmp[11] = true;
              //                                                         tmp[12] = false;
              //                                                       }
              //                                                       tmp[13] = false;
              //                                                       tmp[14] = true;
              //                                                       tmp[15] = false;
              //                                                       setRaagamforSwaras(tmp, carnatic_swaras,2.toInt(),"NiVal"); },
              //                                                     child: Text('N2'))),
              //                                           ),
              //                                           Flexible(
              //                                             child: Container(
              //                                                 width:40,
              //                                                 child: ElevatedButton(
              //                                                     style: PitchSlider,
              //                                                     onPressed: (){
              //                                                       List tmp = RaagaLib[RaagamName];
              //                                                       tmp[13] = false;
              //                                                       tmp[14] = false;
              //                                                       tmp[15] = true;
              //                                                       setRaagamforSwaras(tmp, carnatic_swaras,3.toInt(),"NiVal"); },
              //                                                     child: Text('N3'))),
              //                                           ),
              //
              //
              //                                         ],),
              //                                     ):
              //                                     Container(),
              //                                   ),
              //                                 ],),
              //                             ],),
              //                         ),
              //
              //                         GestureDetector(
              //                           onTap: (){
              //                             SwaraMa = !SwaraMa;
              //
              //                             List tmp = RaagaLib[RaagamName];
              //                             //[true, true, false, false, false, false, true, false, true, true, false, true, false, false, false, true, true]
              //                             if(SwaraMa){
              //                               tmp[7] = true;
              //                               tmp[8] = false;
              //                             } else{
              //                               tmp[7] = false;
              //                               tmp[8] = true;
              //                             }
              //                             setRaagamforSwaras(tmp, carnatic_swaras,SwaraMa,"Swarama");
              //                           },
              //
              //                           child: Container(
              //                             decoration: SwarasContainerDeco.copyWith(color: Colors.white),
              //                             height: 40,
              //                             width: 150 ,
              //                             child: Row(
              //                               mainAxisAlignment: SwaraMa? MainAxisAlignment.start:MainAxisAlignment.end,
              //                               children: [
              //                                 AnimatedContainer(duration: Duration(milliseconds: 300),
              //                                   child:Text("M1",style: SwaraMa?chordTiletxtStyl:null,),
              //                                   width: SwaraMa? 100:40,
              //                                   alignment: Alignment.center,
              //                                   decoration: SwaraMa?SwarasContainerDeco:SwarasContainerDeco.copyWith(boxShadow: [
              //                                     BoxShadow(color: Colors.transparent),],
              //                                     border: Border.all(width: 0,color: Colors.transparent,),
              //                                     color: Colors.white,),
              //
              //                                 ),
              //                                 AnimatedContainer(duration: Duration(milliseconds: 300),
              //                                   child:Text("M2",style: SwaraMa?null:chordTiletxtStyl,),
              //                                   width: SwaraMa? 40: 100,
              //                                   alignment: Alignment.center,
              //                                   decoration: SwaraMa?SwarasContainerDeco.copyWith(boxShadow: [
              //                                     BoxShadow(color: Colors.transparent),],
              //                                     border: Border.all(width: 0,color: Colors.transparent,),
              //                                     color: Colors.white,):SwarasContainerDeco,
              //
              //                                 ),
              //                                 // ElevatedButton(
              //                                 //   style: ElevatedButton.styleFrom(
              //                                 //     foregroundColor: SwaraMa?Colors.red:Colors.blue,
              //                                 //     backgroundColor: SwaraMa?Colors.blue:Colors.red,
              //                                 //   ),
              //                                 //   onPressed: (){
              //                                 //     setState(() {
              //                                 //       SwaraMa = !SwaraMa;
              //                                 //     });
              //                                 //   },
              //                                 //   child: SwaraMa? Text('M1'):Text('M2'),
              //                                 // ),
              //                                 // ElevatedButton(
              //                                 //   style: ElevatedButton.styleFrom(
              //                                 //     foregroundColor: SwaraMa?Colors.red:Colors.blue,
              //                                 //     backgroundColor: SwaraMa?Colors.blue:Colors.red,
              //                                 //   ),
              //                                 //   onPressed: (){
              //                                 //     setState(() {
              //                                 //       SwaraMa = !SwaraMa;
              //                                 //     });
              //                                 //   },
              //                                 //   child: SwaraMa? Text('M1'):Text('M2'),
              //                                 // ),
              //                               ],
              //                             ),
              //                           ),
              //                         ),
              //
              //                       ],
              //                     ),
              //                   ),
              //                   Container(decoration: SwarasContainerDeco,),
              //
              //
              //                 ],
              //               ),
              //             ),
              //           ),
              //         ):
              //         Container(decoration: SwarasContainerDeco),
              //       ),
              //
              //
              //
              //
              //
              //
              //
              //       // Container(
              //       //   decoration: SwarasContainerDeco,
              //       //   height: 500,
              //       //   child: ListWheelScrollView(
              //       //     children: [
              //       //       for(int i = 0;i<72;i++)
              //       //         GestureDetector(
              //       //             onTap: (){
              //       //               setState(() {
              //       //                 RaagamName = RaagaList[i];
              //       //                 inputMap = inputToNotes(RaagaLib[RaagaList[i]], carnatic_swaras);
              //       //                 initialPlay(false);
              //       //               });
              //       //
              //       //             },
              //       //             child: Container(
              //       //                 padding: EdgeInsets.symmetric(horizontal: 40,vertical: 15),
              //       //                 decoration: SwarasContainerDeco,
              //       //                 child: Text(RaagaList[i]))),
              //       //     ],
              //       //     controller: scrollController,
              //       //     perspective: 0.001,
              //       //     itemExtent: 50,
              //       //     diameterRatio: 1,
              //       //   ),
              //       // ),
              //
              //       Container(margin: EdgeInsets.all(5),),
              //
              //       // Text('\t\tswaras',style: TextStyle(fontSize: 14,fontWeight: FontWeight.w300,color: subText,)),
              //
              //       // Row(
              //       //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //       //   children: [
              //       //     Column(
              //       //       children: [
              //       //         Container(alignment: Alignment.centerRight ,width:180, child: Text(ragam.substring(1, (ragam.length - 1)),style: mainTxt)),
              //       //         Container(alignment: Alignment.centerRight ,width:180, child: Text('Western\t\t',style: TextStyle(fontSize: 14,fontWeight: FontWeight.w300,color: subText,))),
              //       //       ],
              //       //     ),
              //       //     Container(alignment: Alignment.center ,width: 1, child: Text('|')),
              //       //     Column(
              //       //       children: [
              //       //         Container(alignment: Alignment.topLeft ,width:180, child: Text(ragam2.substring(1, (ragam2.length - 1)),style:mainTxt)),
              //       //         Container(alignment: Alignment.topLeft ,width:180, child: Text('\t\tCarnatic',style: TextStyle(fontSize: 14,fontWeight: FontWeight.w300,color: subText,))),
              //       //       ],
              //       //     ),],),
              //
              //       Container(
              //         key:_CurrentSwaras,
              //         padding: EdgeInsets.symmetric(horizontal: 20),
              //         child: GestureDetector(
              //             onHorizontalDragStart: (details)async{
              //               if (details.localPosition.dx<screenWidth/4){
              //                 List tmp = inputMap['scale'];
              //                 for(int k = 0; k<tmp.length-1;k++){
              //                   _flutterMidi.playMidiNote(midi: MidiNum[tmp[k]]);
              //                   await Future.delayed(Duration(milliseconds: 250));
              //                   if (k == 6){
              //                     _flutterMidi.playMidiNote(midi: MidiNum[tmp[0]]+12);
              //                   }
              //                 }
              //
              //
              //               }
              //               if (details.localPosition.dx>screenWidth/4){
              //                 List tmp = inputMap['scale'];
              //
              //                 for(int k = tmp.length-1; k>=0;k--){
              //
              //                   if (k == 7){
              //                     _flutterMidi.playMidiNote(midi: MidiNum[tmp[0]]+12);
              //                     await Future.delayed(Duration(milliseconds: 250));
              //                   }
              //                   else{
              //                     _flutterMidi.playMidiNote(midi: MidiNum[tmp[k]]);
              //                     await Future.delayed(Duration(milliseconds: 250));
              //                   }
              //                 }
              //
              //               }
              //
              //             },
              //             onTap: ()async{
              //
              //
              //               List tmp = inputMap['scale'];
              //               for(int k = 0; k<tmp.length-1;k++){
              //                 _flutterMidi.playMidiNote(midi: MidiNum[tmp[k]]);
              //                 await Future.delayed(Duration(milliseconds: 250));
              //                 if (k == 6){
              //                   _flutterMidi.playMidiNote(midi: MidiNum[tmp[0]]+12);
              //
              //                 }
              //               }
              //
              //               await Future.delayed(Duration(milliseconds: 500));
              //               for(int k = tmp.length-1; k>=0;k--){
              //
              //                 if (k == 7){
              //                   _flutterMidi.playMidiNote(midi: MidiNum[tmp[0]]+12);
              //                   await Future.delayed(Duration(milliseconds: 250));
              //                 }
              //                 else{
              //                   _flutterMidi.playMidiNote(midi: MidiNum[tmp[k]]);
              //                   await Future.delayed(Duration(milliseconds: 250));
              //                 }
              //               }
              //
              //             },
              //             child: Text(ragam2.substring(1, (ragam2.length - 1)),style: mainTxt,textAlign: TextAlign.center,)),
              //       ),
              //       Container(
              //         alignment: Alignment.center,
              //         margin: EdgeInsets.symmetric(horizontal: 20),
              //         child: Text(
              //           'swipe me to play swaras!',
              //           style: TextStyle(
              //             fontSize: CT_heigh / 4,
              //             fontFamily: 'NotoSansRegular',
              //             fontWeight: FontWeight.normal,
              //             color: Color.fromRGBO(0, 0, 0, 1),
              //           ),
              //         ),
              //       ),
              //
              //       // Row(
              //       //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //       //   children: [
              //       //     ElevatedButton(
              //       //       style:chordTileBTN,
              //       //         onPressed: ()async{
              //       //           List tmp = inputMap['scale'];
              //       //           for(int k = 0; k<tmp.length-1;k++){
              //       //             _flutterMidi.playMidiNote(midi: MidiNum[tmp[k]]);
              //       //             await Future.delayed(Duration(milliseconds: 250));
              //       //             if (k == 6){
              //       //               _flutterMidi.playMidiNote(midi: MidiNum[tmp[0]]+12);
              //       //             }
              //       //           }
              //       //         },
              //       //         child:Icon(Icons.keyboard_arrow_right)),
              //       //
              //       //
              //       //     ElevatedButton(
              //       //       style: chordTileBTN,
              //       //         onPressed: ()async{
              //       //
              //       //
              //       //           List tmp = inputMap['scale'];
              //       //           for(int k = 0; k<tmp.length-1;k++){
              //       //             _flutterMidi.playMidiNote(midi: MidiNum[tmp[k]]);
              //       //             await Future.delayed(Duration(milliseconds: 250));
              //       //             if (k == 6){
              //       //               _flutterMidi.playMidiNote(midi: MidiNum[tmp[0]]+12);
              //       //
              //       //             }
              //       //           }
              //       //
              //       //           await Future.delayed(Duration(milliseconds: 500));
              //       //           for(int k = tmp.length-1; k>=0;k--){
              //       //
              //       //             if (k == 7){
              //       //               _flutterMidi.playMidiNote(midi: MidiNum[tmp[0]]+12);
              //       //               await Future.delayed(Duration(milliseconds: 250));
              //       //             }
              //       //             else{
              //       //               _flutterMidi.playMidiNote(midi: MidiNum[tmp[k]]);
              //       //               await Future.delayed(Duration(milliseconds: 250));
              //       //             }
              //       //           }
              //       //
              //       //         },
              //       //         child: Text(ragam2.substring(1, (ragam2.length - 1)),style: mainTxt,textAlign: TextAlign.center,)),
              //       //
              //       //     ElevatedButton(
              //       //       style: chordTileBTN,
              //       //         onPressed: ()async{
              //       //           List tmp = inputMap['scale'];
              //       //
              //       //           for(int k = tmp.length-1; k>=0;k--){
              //       //
              //       //             if (k == 7){
              //       //               _flutterMidi.playMidiNote(midi: MidiNum[tmp[0]]+12);
              //       //               await Future.delayed(Duration(milliseconds: 250));
              //       //             }
              //       //             else{
              //       //               _flutterMidi.playMidiNote(midi: MidiNum[tmp[k]]);
              //       //               await Future.delayed(Duration(milliseconds: 250));
              //       //             }
              //       //           }
              //       //         },
              //       //         child:Icon(Icons.keyboard_arrow_left)),
              //       //
              //       //   ],
              //       // ),
              //       // //THE BUTTON TYPE
              //
              //     ],
              //   ),
              // ),


              Container(
                key: _PitchSelector,
                margin: EdgeInsets.only(top: 0, bottom: 10),
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    // Divider(height: 5,
                    //   thickness: 1.0,
                    //   indent: 50,
                    //   endIndent: 50,
                    //   color: lineColor,),
                    SizedBox(
                      height: 50.0, // Adjust the height as needed
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: Pitches.length,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            width: 30.0,
                            // Adjust the width as needed
                            margin: EdgeInsets.symmetric(
                                vertical: CT_Fheigh / 3, horizontal: 6),
                            // padding: EdgeInsets.symmetric(vertical: 4.0),
                            decoration: PitchSliderDeco,
                            child: ElevatedButton(
                              style: PitchSlider,
                              onPressed: () {
                                setPitch(Pitches[index]);
                                currentPitch = Pitches[index];
                                setRaagam(inputMap['notes'], western_swaras);
                                initialPlay(true);
                                // _flutterMidi.playMidiNote(midi: MidiNum[currentPitch]);
                              },
                              child: Text(
                                Pitches[index],
                                style: TextStyle(
                                  // fontFamily: 'NotoSansRegular',
                                  fontSize: CT_heigh / 3,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'Select tonic note',
                        style: TextStyle(
                          fontSize: CT_heigh / 4,
                          fontFamily: 'NotoSansRegular',
                          fontWeight: FontWeight.normal,
                          color: Color.fromRGBO(0, 0, 0, 1),
                        ),
                      ),
                    ),
                    Divider(
                      height: 10,
                      indent: 15,
                      endIndent: 15,
                      thickness: 2.0,
                      color: lineColor,
                    ),
                  ],
                ),
              ),

              // WheelSlider.customWidget(
              //   totalCount: Pitches.length,
              //   initValue: 3,
              //   isInfinite: true,
              //   scrollPhysics: const BouncingScrollPhysics(),
              //   children: List.generate(12, (index) => Container(
              //     decoration: PitchSliderDeco,
              //       alignment: Alignment.center,
              //       child:Text(Pitches[index]))),
              //   onValueChanged: (val) {
              //     setState(() {
              //       setPitch(Pitches[val]);
              //       currentPitch = Pitches[val];
              //       setRaagam(inputMap['notes'], western_swaras);
              //       initialPlay(true);
              //     });
              //   },
              //   hapticFeedbackType: HapticFeedbackType.vibrate,
              //   showPointer: false,
              //   itemSize: 60,
              // ),





              // GestureDetector(
              //   key: _AllChordPlay,
              //   onTap: () async {
              //     for(int i = 0;i<(mainOut.length);i++){play(FamChdList[i][0]);await Future.delayed(Duration(milliseconds: 400));}},
              //   onDoubleTap: ()async{for(int i = 0;i<(mainOut.length);i++){play(FamChdList[i][0]);await Future.delayed(Duration(milliseconds: 200));}},
              //   onLongPress: (){setState(() {ins = 'Single Tap or Double Tap on this blue box, it will play the chords for you';});},
              //   child: Container(
              //       decoration: notesBox,
              //       margin: const EdgeInsets.only(top: 20.0,left: 50,right: 50),
              //       padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 10),
              //       child: Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //         children: [
              //           for(int i =0;i<inputMap['scale'].length;i++)
              //             Text(inputMap['scale'][i],style: notesBoxTextstyl,)
              //           // Text(input.substring(1, (input.length-1)),style: notesBoxTextstyl,),
              //         ],
              //       )),
              // ),

              Container(
                child: Column(
                key: _ChordTiles,
                children: [
                  for (int content =0;content< 7;content++)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          // decoration: chordTileCNT,
                          margin:EdgeInsets.symmetric(vertical: 5.0, horizontal: 0),
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: (CT_heigh / 5)),
                          height: CT_heigh,
                          child: GestureDetector(
                            onTap: () {
                              final PageController _pageController = PageController();
                              List <Widget> list_of_chords = allChord_maps[content];
                              String msg = "";
                              if(list_of_chords.length>1){msg = "\nSwipe for an alternative chord position";}
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    backgroundColor:
                                    Color.fromRGBO(240, 255, 255, 1),
                                    content: SizedBox(
                                      height: 500,
                                      width: 500,
                                      child: GestureDetector(
                                        onTap: () {
                                          play(FamChdList[content][0]);



                                        },
                                        child: ListView(
                                          children: [
                                            Container(
                                              height: 350,
                                              decoration: SwarasContainerDeco,
                                              margin: const EdgeInsets.only(top: 0.0,left: 0,right: 0,bottom: 20),
                                              padding: EdgeInsets.only(top: 10.0, bottom: 0, left: 10),
                                              child: PageView(
                                                children: list_of_chords,
                                                controller: _pageController,
                                              ),
                                            ),

                                            Container(
                                              alignment: Alignment.center,
                                              child: RichText(
                                                text: TextSpan(
                                                  text: ' ',
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                        text: mainOut[content],
                                                        style: popupMainText),
                                                    TextSpan(
                                                        text: notesData[content],
                                                        style:popupNormalText.copyWith(fontSize: 19,color: Colors.black)
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),

                                            Text(msg,style: popupNoteText,textAlign: TextAlign.center,)
                                          ],),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            child: Icon(Icons.grid_on_rounded,color: Color.fromRGBO(0,0,0,120),size: 27),

                            // Text('Map', style: popupNormalText,textAlign: TextAlign.center, //color: Colors.white
                            // ),

                          ),
                        ),
                        Listener(
                          onPointerDown: (PointerEvent Details){
                            play(FamChdList[content][0]);
                          },
                          child: Container(
                            width: 250,
                            decoration: chordTileCNT,
                            margin: EdgeInsets.only(left: 10,right:10, top: 0,bottom: 10),
                            padding: EdgeInsets.only(left: 20,top:12,bottom:12,right: 10),
                            child: Text(mainOut[content].trim(),style: chordTiletxtStyl,),),),
                      ],
                    ),
                ],
              ),),
              // // Actual Container, Original
              // Container(
              //   key: _ChordTiles,
              //   child: Column(
              //     children: [
              //       for (int content = 0; content < mainOut.length; content++)
              //         Row(
              //           mainAxisAlignment: MainAxisAlignment.center,
              //           children: [
              //             Container(
              //               // decoration: chordTileCNT,
              //               margin:EdgeInsets.symmetric(vertical: 5.0, horizontal: 0),
              //               padding: EdgeInsets.symmetric(horizontal: 10, vertical: (CT_heigh / 5)),
              //               height: CT_heigh,
              //               child: GestureDetector(
              //                 onTap: () {
              //                   final PageController _pageController = PageController();
              //                   List <Widget> list_of_chords = allChord_maps[content];
              //                   String msg = "";
              //                   if(list_of_chords.length>1){msg = "\nSwipe for an alternative chord position";}
              //                   showDialog(
              //                     context: context,
              //                     builder: (BuildContext context) {
              //                       return AlertDialog(
              //                         backgroundColor:
              //                         Color.fromRGBO(240, 255, 255, 1),
              //                         content: SizedBox(
              //                           height: 500,
              //                           width: 500,
              //                           child: GestureDetector(
              //                                 onTap: () {
              //                                   play(FamChdList[content][0]);
              //
              //
              //
              //                                 },
              //                                 child: ListView(
              //                                   children: [
              //                                     Container(
              //                                       height: 350,
              //                                       decoration: SwarasContainerDeco,
              //                                       margin: const EdgeInsets.only(top: 0.0,left: 0,right: 0,bottom: 20),
              //                                       padding: EdgeInsets.only(top: 10.0, bottom: 0, left: 10),
              //                                       child: PageView(
              //                                         children: list_of_chords,
              //                                         controller: _pageController,
              //                                       ),
              //                                     ),
              //
              //                                     Container(
              //                                       alignment: Alignment.center,
              //                                       child: RichText(
              //                                         text: TextSpan(
              //                                           text: ' ',
              //                                           children: <TextSpan>[
              //                                             TextSpan(
              //                                                 text: mainOut[content],
              //                                                 style: popupMainText),
              //                                             TextSpan(
              //                                                 text: notesData[content],
              //                                                 style:popupNormalText.copyWith(fontSize: 19,color: Colors.black)
              //                                             ),
              //                                           ],
              //                                         ),
              //                                       ),
              //                                     ),
              //
              //                                     Text(msg,style: popupNoteText,textAlign: TextAlign.center,)
              //                             ],),
              //                           ),
              //                         ),
              //                       );
              //                     },
              //                   );
              //                 },
              //                 child: Icon(Icons.grid_on_rounded,color: Color.fromRGBO(0,0,0,120),size: 27),
              //
              //                 // Text('Map', style: popupNormalText,textAlign: TextAlign.center, //color: Colors.white
              //                 // ),
              //
              //               ),
              //             ),
              //             Container(
              //             decoration: chordTileCNT,
              //             margin:
              //                 EdgeInsets.symmetric(vertical: 5.0, horizontal: 0),
              //             padding: EdgeInsets.symmetric(
              //                 horizontal: 30, vertical: (CT_heigh / 5)),
              //             height: CT_heigh,
              //             width: 200,
              //             //padding: EdgeInsets.symmetric(vertical: 10.0),
              //             //alignment: Alignment.center,
              //             child: Listener(
              //               // style:chordTileBTN,
              //
              //               onPointerDown: (details) {
              //
              //
              //                 play(FamChdList[content][0]);
              //
              //                 // var a = FamChdList[content][0];
              //                 // int note2 = (MidiNum[a[1]]);
              //                 // if (note2 < note1) {
              //                 //   note2 = note2 + 12;
              //                 // }
              //                 // int note3 = (MidiNum[a[2]]);
              //                 // if (note3 < note2) {
              //                 //   note3 = note3 + 12;
              //                 // }
              //                 //
              //
              //
              //                 // _flutterMidi.playMidiNote(midi:MidiNum[currentPitch]+content);
              //
              //                 //THE CONTENT COULD BE A PROBLEM
              //
              //
              //
              //                 // _flutterMidi.playMidiNote(midi:MidiNum[currentPitch]);
              //                 // _flutterMidi.playMidiNote(midi: 60+content);
              //
              //                 // var tmp = FamChdList[content][0];
              //                 // for(int i = 0;i<tmp.length;i++){
              //                 //   _flutterMidi.playMidiNote(midi: MidiNum[tmp[i]]);
              //                 // }
              //
              //               },
              //               child: Text(
              //                 mainOut[content], style: chordTiletxtStyl,
              //                 textAlign: TextAlign.left, //color: Colors.white
              //               ),
              //             ),
              //           ),
              //           ]
              //         ),
              //     ],
              //   ),
              // ),
              Container(),
              // Text("Elevated BUtton"),
              // for (int i =0;i< 2;i++)
              //   ElevatedButton(
              //       onPressed: (){
              //         play(FamChdList[i][0]);
              //         // int num = MidiNum[currentPitch]+inputMap['notes'][i];
              //         // int num2 = MidiNum[currentPitch]+inputMap['notes'][i+2];
              //         // int num3 = MidiNum[currentPitch]+inputMap['notes'][i+3];
              //         // _flutterMidi.playMidiNote(midi: num);
              //         // _flutterMidi.playMidiNote(midi: num2);
              //         // _flutterMidi.playMidiNote(midi: num3);
              //         // Future.delayed(Duration(milliseconds: 100),(){
              //         //   _flutterMidi.stopMidiNote(midi: num);
              //         //   _flutterMidi.stopMidiNote(midi: num2);
              //         //   _flutterMidi.stopMidiNote(midi: num3);
              //         // });
              //       },
              //
              //       child: Text(mainOut[i])),

              // Text("Gesture Detector"),
              // Container(
              //   decoration: chordTileCNT,
              //   margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 0),
              //   padding: EdgeInsets.symmetric(horizontal: 30, vertical: (CT_heigh / 5)),
              //   height: CT_heigh,
              //   width: 200,
              //   //padding: EdgeInsets.symmetric(vertical: 10.0),
              //   //alignment: Alignment.center,
              //   child: GestureDetector(
              //     // style:chordTileBTN,
              //     onTap: () {
              //       play(FamChdList[0][0]);
              //
              //       // var a = FamChdList[content][0];
              //       // int note2 = (MidiNum[a[1]]);
              //       // if (note2 < note1) {
              //       //   note2 = note2 + 12;
              //       // }
              //       // int note3 = (MidiNum[a[2]]);
              //       // if (note3 < note2) {
              //       //   note3 = note3 + 12;
              //       // }
              //       //
              //
              //
              //       // _flutterMidi.playMidiNote(midi:MidiNum[currentPitch]+content);
              //
              //       //THE CONTENT COULD BE A PROBLEM
              //
              //
              //
              //       // _flutterMidi.playMidiNote(midi:MidiNum[currentPitch]);
              //       // _flutterMidi.playMidiNote(midi: 60+content);
              //
              //       // var tmp = FamChdList[content][0];
              //       // for(int i = 0;i<tmp.length;i++){
              //       //   _flutterMidi.playMidiNote(midi: MidiNum[tmp[i]]);
              //       // }
              //
              //     },
              //     child: Text(
              //       mainOut[0], style: chordTiletxtStyl,
              //       textAlign: TextAlign.left, //color: Colors.white
              //     ),
              //   ),
              // ),
              // Container(
              //   decoration: chordTileCNT,
              //   margin:EdgeInsets.symmetric(vertical: 5.0, horizontal: 0),
              //   padding: EdgeInsets.symmetric(horizontal: 30, vertical: (CT_heigh / 5)),
              //   height: CT_heigh,
              //   width: 200,
              //   //padding: EdgeInsets.symmetric(vertical: 10.0),
              //   //alignment: Alignment.center,
              //   child: GestureDetector(
              //     // style:chordTileBTN,
              //
              //     onTap: () {
              //
              //
              //       play(FamChdList[1][0]);
              //
              //       // var a = FamChdList[content][0];
              //       // int note2 = (MidiNum[a[1]]);
              //       // if (note2 < note1) {
              //       //   note2 = note2 + 12;
              //       // }
              //       // int note3 = (MidiNum[a[2]]);
              //       // if (note3 < note2) {
              //       //   note3 = note3 + 12;
              //       // }
              //       //
              //
              //
              //       // _flutterMidi.playMidiNote(midi:MidiNum[currentPitch]+content);
              //
              //       //THE CONTENT COULD BE A PROBLEM
              //
              //
              //
              //       // _flutterMidi.playMidiNote(midi:MidiNum[currentPitch]);
              //       // _flutterMidi.playMidiNote(midi: 60+content);
              //
              //       // var tmp = FamChdList[content][0];
              //       // for(int i = 0;i<tmp.length;i++){
              //       //   _flutterMidi.playMidiNote(midi: MidiNum[tmp[i]]);
              //       // }
              //
              //     },
              //     child: Text(
              //       mainOut[1], style: chordTiletxtStyl,
              //       textAlign: TextAlign.left, //color: Colors.white
              //     ),
              //   ),
              // ),
              // Container(
              //   decoration: chordTileCNT,
              //   margin:
              //   EdgeInsets.symmetric(vertical: 5.0, horizontal: 0),
              //   padding: EdgeInsets.symmetric(
              //       horizontal: 30, vertical: (CT_heigh / 5)),
              //   height: CT_heigh,
              //   width: 200,
              //   //padding: EdgeInsets.symmetric(vertical: 10.0),
              //   //alignment: Alignment.center,
              //   child: GestureDetector(
              //     // style:chordTileBTN,
              //
              //     onTap: () {
              //
              //
              //       play(FamChdList[2][0]);
              //
              //       // var a = FamChdList[content][0];
              //       // int note2 = (MidiNum[a[1]]);
              //       // if (note2 < note1) {
              //       //   note2 = note2 + 12;
              //       // }
              //       // int note3 = (MidiNum[a[2]]);
              //       // if (note3 < note2) {
              //       //   note3 = note3 + 12;
              //       // }
              //       //
              //
              //
              //       // _flutterMidi.playMidiNote(midi:MidiNum[currentPitch]+content);
              //
              //       //THE CONTENT COULD BE A PROBLEM
              //
              //
              //
              //       // _flutterMidi.playMidiNote(midi:MidiNum[currentPitch]);
              //       // _flutterMidi.playMidiNote(midi: 60+content);
              //
              //       // var tmp = FamChdList[content][0];
              //       // for(int i = 0;i<tmp.length;i++){
              //       //   _flutterMidi.playMidiNote(midi: MidiNum[tmp[i]]);
              //       // }
              //
              //     },
              //     child: Text(
              //       mainOut[2], style: chordTiletxtStyl,
              //       textAlign: TextAlign.left, //color: Colors.white
              //     ),
              //   ),
              // ),
              // Container(
              //   decoration: chordTileCNT,
              //   margin:
              //   EdgeInsets.symmetric(vertical: 5.0, horizontal: 0),
              //   padding: EdgeInsets.symmetric(
              //       horizontal: 30, vertical: (CT_heigh / 5)),
              //   height: CT_heigh,
              //   width: 200,
              //   //padding: EdgeInsets.symmetric(vertical: 10.0),
              //   //alignment: Alignment.center,
              //   child: GestureDetector(
              //     // style:chordTileBTN,
              //
              //     onTap: () {
              //
              //
              //       play(FamChdList[3][0]);
              //
              //       // var a = FamChdList[content][0];
              //       // int note2 = (MidiNum[a[1]]);
              //       // if (note2 < note1) {
              //       //   note2 = note2 + 12;
              //       // }
              //       // int note3 = (MidiNum[a[2]]);
              //       // if (note3 < note2) {
              //       //   note3 = note3 + 12;
              //       // }
              //       //
              //
              //
              //       // _flutterMidi.playMidiNote(midi:MidiNum[currentPitch]+content);
              //
              //       //THE CONTENT COULD BE A PROBLEM
              //
              //
              //
              //       // _flutterMidi.playMidiNote(midi:MidiNum[currentPitch]);
              //       // _flutterMidi.playMidiNote(midi: 60+content);
              //
              //       // var tmp = FamChdList[content][0];
              //       // for(int i = 0;i<tmp.length;i++){
              //       //   _flutterMidi.playMidiNote(midi: MidiNum[tmp[i]]);
              //       // }
              //
              //     },
              //     child: Text(
              //       mainOut[3], style: chordTiletxtStyl,
              //       textAlign: TextAlign.left, //color: Colors.white
              //     ),
              //   ),
              // ),
              // Container(
              //   decoration: chordTileCNT,
              //   margin:
              //   EdgeInsets.symmetric(vertical: 5.0, horizontal: 0),
              //   padding: EdgeInsets.symmetric(
              //       horizontal: 30, vertical: (CT_heigh / 5)),
              //   height: CT_heigh,
              //   width: 200,
              //   //padding: EdgeInsets.symmetric(vertical: 10.0),
              //   //alignment: Alignment.center,
              //   child: GestureDetector(
              //     // style:chordTileBTN,
              //
              //     onTap: () {
              //
              //
              //       play(FamChdList[4][0]);
              //
              //       // var a = FamChdList[content][0];
              //       // int note2 = (MidiNum[a[1]]);
              //       // if (note2 < note1) {
              //       //   note2 = note2 + 12;
              //       // }
              //       // int note3 = (MidiNum[a[2]]);
              //       // if (note3 < note2) {
              //       //   note3 = note3 + 12;
              //       // }
              //       //
              //
              //
              //       // _flutterMidi.playMidiNote(midi:MidiNum[currentPitch]+content);
              //
              //       //THE CONTENT COULD BE A PROBLEM
              //
              //
              //
              //       // _flutterMidi.playMidiNote(midi:MidiNum[currentPitch]);
              //       // _flutterMidi.playMidiNote(midi: 60+content);
              //
              //       // var tmp = FamChdList[content][0];
              //       // for(int i = 0;i<tmp.length;i++){
              //       //   _flutterMidi.playMidiNote(midi: MidiNum[tmp[i]]);
              //       // }
              //
              //     },
              //     child: Text(
              //       mainOut[4], style: chordTiletxtStyl,
              //       textAlign: TextAlign.left, //color: Colors.white
              //     ),
              //   ),
              // ),
              // Container(
              //   decoration: chordTileCNT,
              //   margin:
              //   EdgeInsets.symmetric(vertical: 5.0, horizontal: 0),
              //   padding: EdgeInsets.symmetric(
              //       horizontal: 30, vertical: (CT_heigh / 5)),
              //   height: CT_heigh,
              //   width: 200,
              //   //padding: EdgeInsets.symmetric(vertical: 10.0),
              //   //alignment: Alignment.center,
              //   child: GestureDetector(
              //     // style:chordTileBTN,
              //
              //     onTap: () {
              //
              //
              //       play(FamChdList[5][0]);
              //
              //       // var a = FamChdList[content][0];
              //       // int note2 = (MidiNum[a[1]]);
              //       // if (note2 < note1) {
              //       //   note2 = note2 + 12;
              //       // }
              //       // int note3 = (MidiNum[a[2]]);
              //       // if (note3 < note2) {
              //       //   note3 = note3 + 12;
              //       // }
              //       //
              //
              //
              //       // _flutterMidi.playMidiNote(midi:MidiNum[currentPitch]+content);
              //
              //       //THE CONTENT COULD BE A PROBLEM
              //
              //
              //
              //       // _flutterMidi.playMidiNote(midi:MidiNum[currentPitch]);
              //       // _flutterMidi.playMidiNote(midi: 60+content);
              //
              //       // var tmp = FamChdList[content][0];
              //       // for(int i = 0;i<tmp.length;i++){
              //       //   _flutterMidi.playMidiNote(midi: MidiNum[tmp[i]]);
              //       // }
              //
              //     },
              //     child: Text(
              //       mainOut[5], style: chordTiletxtStyl,
              //       textAlign: TextAlign.left, //color: Colors.white
              //     ),
              //   ),
              // ),
              // Container(
              //   decoration: chordTileCNT,
              //   margin:EdgeInsets.symmetric(vertical: 5.0, horizontal: 0),
              //   padding: EdgeInsets.symmetric(horizontal: 30, vertical: (CT_heigh / 5)),
              //   height: CT_heigh,
              //   width: 200,
              //   //padding: EdgeInsets.symmetric(vertical: 10.0),
              //   //alignment: Alignment.center,
              //   child: GestureDetector(
              //     // style:chordTileBTN,
              //
              //     onTap: () {
              //
              //
              //       play(FamChdList[6][0]);
              //
              //       // var a = FamChdList[content][0];
              //       // int note2 = (MidiNum[a[1]]);
              //       // if (note2 < note1) {
              //       //   note2 = note2 + 12;
              //       // }
              //       // int note3 = (MidiNum[a[2]]);
              //       // if (note3 < note2) {
              //       //   note3 = note3 + 12;
              //       // }
              //       //
              //
              //
              //       // _flutterMidi.playMidiNote(midi:MidiNum[currentPitch]+content);
              //
              //       //THE CONTENT COULD BE A PROBLEM
              //
              //
              //
              //       // _flutterMidi.playMidiNote(midi:MidiNum[currentPitch]);
              //       // _flutterMidi.playMidiNote(midi: 60+content);
              //
              //       // var tmp = FamChdList[content][0];
              //       // for(int i = 0;i<tmp.length;i++){
              //       //   _flutterMidi.playMidiNote(midi: MidiNum[tmp[i]]);
              //       // }
              //
              //     },
              //     child: Text(
              //       mainOut[6], style: chordTiletxtStyl,
              //       textAlign: TextAlign.left, //color: Colors.white
              //     ),
              //   ),
              // ),
              Container(),
              //THis is also Not Great..!

              // Container(
              //   key: _ChordTiles,
              //   child: Column(
              //     children: [
              //       for (int content = 0; content < mainOut.length; content++)
              //         Container(
              //           decoration: chordTileCNT,
              //           margin:EdgeInsets.symmetric(vertical: 6, horizontal: 0),
              //           padding: EdgeInsets.symmetric(horizontal: 30),
              //           height: 30,
              //           width: 200,
              //
              //           //padding: EdgeInsets.symmetric(vertical: 10.0),
              //           //alignment: Alignment.center,
              //           child: GestureDetector(
              //             // style:chordTileBTN,
              //             onTap: () {
              //               final PageController _pageController = PageController();
              //               List <Widget> list_of_chords = allChord_maps[content];
              //               String msg = "";
              //               if(list_of_chords.length>1){msg = "\nSwipe for Alternative Chord Position";}
              //
              //               showDialog(
              //                 context: context,
              //                 builder: (BuildContext context) {
              //                   return AlertDialog(
              //                     backgroundColor:Color.fromRGBO(240, 255, 255, 1),
              //                     content: SizedBox(height: 500,width: 500,
              //                       child: GestureDetector(
              //                         onTap: () {
              //                           play(FamChdList[content][0]);},
              //                         child: Column(
              //                           children: [
              //                             Container(
              //                               height: 350,
              //                               decoration: SwarasContainerDeco,
              //                               margin: const EdgeInsets.only(top: 5.0,left: 0,right: 0,bottom: 20),
              //                               padding: EdgeInsets.only(top: 10.0, bottom: 0, left: 5),
              //                               child: PageView(
              //                                 controller: _pageController,
              //                                 children: list_of_chords,
              //                               ),
              //                             ),
              //
              //                             Container(
              //                               child: Center(
              //                                 child: RichText(
              //                                   text: TextSpan(
              //                                     text: ' ',
              //                                     children: <TextSpan>[
              //                                       TextSpan(
              //                                           text: mainOut[content],
              //                                           style: popupMainText),
              //                                       TextSpan(
              //                                         text: notesData[content],
              //                                         style:popupNormalText.copyWith(fontSize: 19,color: Colors.black),
              //                                       ),
              //                                     ],
              //                                   ),
              //                                 ),
              //                               ),
              //                             ),
              //
              //
              //
              //                             Text(msg),
              //
              //
              //
              //
              //                           ],
              //                         )
              //                       )
              //
              //
              //                       // Column(
              //                       //   children: [
              //                       //     GestureDetector(
              //                       //       onTap: () {
              //                       //         play(FamChdList[content][0]);
              //                       //       },
              //                       //       child: Container(
              //                       //         decoration: SwarasContainerDeco,
              //                       //         margin: const EdgeInsets.only(
              //                       //             top: 0.0,
              //                       //             left: 0,
              //                       //             right: 0,
              //                       //             bottom: 20),
              //                       //         padding: EdgeInsets.only(
              //                       //             top: 10.0, bottom: 0, left: 10),
              //                       //         child: PageView(
              //                       //           children: list_of_chords,
              //                       //
              //                       //         ),
              //                       //       ),
              //                       //     ),
              //                       //
              //                       //     Container(
              //                       //       child: RichText(
              //                       //         text: TextSpan(
              //                       //           text: ' ',
              //                       //           children: <TextSpan>[
              //                       //             TextSpan(
              //                       //                 text: mainOut[content],
              //                       //                 style: popupMainText),
              //                       //             TextSpan(
              //                       //               text: notesData[content],
              //                       //               style:
              //                       //               popupNormalText.copyWith(
              //                       //                   fontSize: 19,
              //                       //                   color: Colors.black),
              //                       //             ),
              //                       //           ],
              //                       //         ),
              //                       //       ),
              //                       //     ),
              //                       //
              //                       //   ],
              //                       // ),
              //                     ),
              //                   );
              //                 },
              //               );
              //             },
              //             onDoubleTap: () {
              //               play(FamChdList[content][0]);
              //             },
              //             child: Text(
              //               mainOut[content], style: chordTiletxtStyl,
              //               textAlign: TextAlign.left, //color: Colors.white
              //             ),
              //           ),
              //         ),
              //     ],
              //   ),
              // ),
              Container(),
              // Container(
              //     alignment: Alignment.center,
              //     margin: EdgeInsets.only(top: 10),
              //     child: Text(
              //       'Family of Chords',
              //       style: TextStyle(
              //           color: Color.fromRGBO(0, 0, 0, 1),
              //           fontWeight: FontWeight.normal,
              //           fontSize: CT_heigh / 3,
              //           fontFamily: 'NotoSansRegular'),
              //     )),
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  child: Text(msg,style: TextStyle(color: subText,),)),

            ],
          ),
        ),
      ),
    );
  }

  void _createTutorialChord() {
    var HeadingTextStyle = TextStyle(
        fontSize: 28,
        fontFamily: 'NotoSansRegular',
        color: Colors.white,
        fontWeight: FontWeight.bold);
    var ImportantNormal = TextStyle(
        fontFamily: 'NotoSansMid',
        fontSize: 16,
        color: Color.fromRGBO(255, 255, 255, 1));
    var normalTextStyle = TextStyle(
        fontWeight: FontWeight.w200,
        fontFamily: 'NotoSansMid',
        fontSize: 16,
        color: Color.fromRGBO(180, 180, 180, 1));
    var padding_TargetContainer =
        EdgeInsets.symmetric(horizontal: 10, vertical: 10);

    var boxDecoration_TargetContainer = BoxDecoration(
      border: Border.all(color: Color.fromRGBO(11, 111, 244, 1), width: 2.0),
    );
    double rad = 20;

    final targets = [
      TargetFocus(
        radius: rad,
        enableTargetTab: true,
        enableOverlayTab: true,
        identify: 'Raaga Input Search ',
        keyTarget: _SwarasInputSearch,
        //alignSkip: Alignment.bottomCenter,
        shape: ShapeLightFocus.RRect,
        contents: [
          TargetContent(
              align: ContentAlign.bottom,
              builder: (context, controller) => Container(
                    padding: padding_TargetContainer,
                    decoration: boxDecoration_TargetContainer,
                    child: RichText(
                      text: TextSpan(
                        text: 'Raaga Name Search bar',
                        style: HeadingTextStyle,
                        children: <TextSpan>[
                          TextSpan(
                              text:
                                  '\n\nUsing this search bar you can search the',
                              style: normalTextStyle),
                          TextSpan(
                              text: ' Melakarta Raaga\'s Name',
                              style: ImportantNormal),
                          TextSpan(
                              text:
                                  '\n\nIf a raaga is not displayed, even if it is Melakarta Raaga, please try other spellings.',
                              style: normalTextStyle),
                        ],
                      ),
                    ),
                  )),
        ],
      ),
      //Raag Input Search

      TargetFocus(
        radius: rad,
        enableTargetTab: true,
        enableOverlayTab: true,
        identify: 'Current Raaga Name',
        keyTarget: _CurrentRaag,
        alignSkip: Alignment.bottomCenter,
        shape: ShapeLightFocus.RRect,
        contents: [
          TargetContent(
              align: ContentAlign.bottom,
              builder: (context, controller) => Container(
                    padding: padding_TargetContainer,
                    decoration: boxDecoration_TargetContainer,
                    child: RichText(
                      text: TextSpan(
                        text: 'Current Raag',
                        style: HeadingTextStyle,
                        children: <TextSpan>[
                          TextSpan(
                              text:
                                  '\n\nThe Current Raaga is selected by user using Search Bar either selecting',
                              style: normalTextStyle),
                          TextSpan(
                              text: '\n\nRaaga Swaras ', style: ImportantNormal),
                          TextSpan(
                              text:
                                  'the Swaras of the Raaga is also given below to Raaga Name ',
                              style: normalTextStyle),
                        ],
                      ),
                    ),
                  )),
        ],
      ),
      //Current Raaga

      TargetFocus(
        radius: rad,
        enableTargetTab: true,
        enableOverlayTab: true,
        identify: 'Current Raaga Swaras',
        keyTarget: _CurrentSwaras,
        alignSkip: Alignment.bottomCenter,
        shape: ShapeLightFocus.RRect,
        contents: [
          TargetContent(
              align: ContentAlign.bottom,
              builder: (context, controller) => Container(
                padding: padding_TargetContainer,
                decoration: boxDecoration_TargetContainer,
                child: RichText(
                  text: TextSpan(
                    text: 'Current Raag\'s Swaras ',
                    style: HeadingTextStyle,
                    children: <TextSpan>[
                      TextSpan(text:'\n\nSwipe and Tap ', style: ImportantNormal),
                      TextSpan(text:'this swaras to play (Ascending)',style: normalTextStyle),
                      TextSpan(text:' Aarohanam ', style: ImportantNormal),
                      TextSpan(text:'and the (Descending)',style: normalTextStyle),
                      TextSpan(text:' Avarahonam ', style: ImportantNormal),
                      TextSpan(text:'of the Raaga.',style: normalTextStyle),
                    ],
                  ),
                ),
              )),
        ],
      ),
      //Current Swaras

      TargetFocus(
        radius: rad,
        enableTargetTab: true,
        enableOverlayTab: true,
        identify: 'PitchSelector',
        keyTarget: _PitchSelector,
        // alignSkip: Alignment.bottomCenter,
        shape: ShapeLightFocus.RRect,

        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) => Container(
              decoration: boxDecoration_TargetContainer,
              padding: padding_TargetContainer,
              child: RichText(
                text: TextSpan(
                  text: 'Selecting the Pitch for the Raaga',
                  style: HeadingTextStyle,
                  children: <TextSpan>[
                    TextSpan(
                        text:
                            '\n\nThis is a horizontal Slider, which contains all the 12 Pitches and users can just ',
                        style: normalTextStyle),
                    TextSpan(
                        text: 'Tap on the Ellipses ', style: ImportantNormal),
                    TextSpan(
                        text:
                            'to set that pitch respectively. \n\nThe changes are updated above, for users to verify the change of Pitch.',
                        style: normalTextStyle),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      //Pitches

      TargetFocus(
        radius: rad,
        enableTargetTab: true,
        enableOverlayTab: true,
        identify: 'Fam chord list',
        keyTarget: _ChordTiles,
        
        //alignSkip: Alignment.bottomCenter,
        shape: ShapeLightFocus.RRect,
        contents: [
          TargetContent(
              align: ContentAlign.top,
              builder: (context, controller) => Container(
                    padding: padding_TargetContainer,
                    decoration: boxDecoration_TargetContainer,
                    child: RichText(
                      text: TextSpan(
                        text: 'Family of chords',
                        style: HeadingTextStyle,
                        children: <TextSpan>[
                          TextSpan(
                              text:
                                  '\n\nThese tiles displays the family of chords for the selected raaga.',
                              style: normalTextStyle),
                          TextSpan(
                              text: '\n\nTap a tile', style: ImportantNormal),
                          TextSpan(
                              text: ' to hear the sound of that chord.',
                              style: normalTextStyle),
                          TextSpan(
                              text: '\n\nThe Icon', style: ImportantNormal),
                          TextSpan(
                              text: ' shows you the Diagram of the Chord layout.',
                              style: normalTextStyle),

                        ],
                      ),
                    ),
                  )),
        ],
      ),
      // Chord Tiles
    ];
    final tutorial = TutorialCoachMark(


      targets: targets,
      showSkipInLastTarget: false,
      hideSkip: false,
      opacityShadow: 0.93,
      paddingFocus: 10,
      focusAnimationDuration: Duration(milliseconds: 300),
      unFocusAnimationDuration: Duration(milliseconds: 300),
      pulseAnimationDuration: Duration(milliseconds: 300),

    );




    Future.delayed(const Duration(milliseconds: 500), () {
      tutorial.show(context: context);
    });
    tutorialChordState = false;
  }
}



class chords_Painter{
  var valu;  //[A#	, -, 	Major \n]
  var chordNote_Index;  //1
  chords_Painter({required this.valu, required this.chordNote_Index});



}

class PaintChord extends CustomPainter {

  // ✅ So yes, in your words:
  // There should be a Top Class that:
  // Handles conditions
  // Manages painter selection
  // Controls order
  // Returns a list of CustomPaint widgets
  //
  // And the UI uses a PageView, which:
  // Displays 1 or more diagrams
  // Uses the list returned by the Top Class


  // Other way of doing this, the current mode has Charts created on tap, for every Runtime this is Created,
  //instead for every Scale, pitch change the Fretter has to be changed and
  //the Custom painter has to be created
  // each type of Custom painter has to be called once, whenever a change in ptich, sclae etc.,
  // it shuld be added to a List, say the outs, List of Widgets, then the
  // page Control in the column will be using that list to jsut display the chords

  var valu;  //[A#	, -, 	Major \n]
  var chordNote_Index;  //1
  var Fret_positions = [];

  PaintChord({required this.valu, required this.chordNote_Index,required this.Fret_positions});

  final Paint stringPaint = Paint()
    ..color = Colors.brown.withOpacity(0.6)
    ..strokeWidth = 4
    ..style = PaintingStyle.stroke;


  final Paint fretPaint = Paint()
    ..color = Colors.brown
    ..strokeWidth = 2
    ..style = PaintingStyle.stroke;

  final Paint fretPaint_moded = Paint()
    ..color = Color.fromRGBO(11, 111, 244, 0.8)
    ..strokeWidth = 2
    ..style = PaintingStyle.fill;

  final Paint fretPaint_moded2 = Paint()
    ..color = Color.fromRGBO(11, 111, 244, 1)
    ..strokeWidth = 3
    ..style = PaintingStyle.stroke;
  final Paint barThick = Paint()
    ..color = Color.fromRGBO(11, 111, 244, 1)
    ..strokeWidth = 10
    ..style = PaintingStyle.stroke;

  int fretCount = 5;
  int stringCount = 6;



  @override
  void paint(Canvas canvas, Size size) {
    // ✅ Your Case Summary:
    // 🪶 Only one chord is shown at a time (in a popup).
    // 🎯 Feature is optional — not all users will trigger it.
    // 🎸 Target users may already know chords (minimal use).
    // 🧠 You’re dynamically generating chord visuals from notes.
    // 🎨 CustomPaint is used once at a time, with user interaction.

    // No caching needed. Performance impact is negligible.
    // If in the future you:
    // Show 10–20 chords at once,
    // Start animating them,
    // Or render them in a ListView,
    // Then caching is worth adding.
    // But for now: you’re making the right call. Keep your code simple and flexible.



    //returns the one Lower octave scale of the Raag

    var stringgap = size.width /(stringCount - 1); //count-1 due to the no of gaps between 6-5, 5,4,3,2, 2-1
    var fretgap = size.height /(fretCount); //13 due to the no of gaps between all the frets

    canvas.translate(stringgap / 2, fretgap / 2);
    canvas.scale(.85, .85);

    //STRINGs
    var StringsList = [];
    for (int i = 0; i < stringCount; i++) {
      StringsList.add(size.width - stringgap * i);
    }
    var a = StringsList.reversed;
    StringsList = a.toList();
    for (int i = 0; i < stringCount; i++) {
      canvas.drawLine(Offset(StringsList[i], 0),
          Offset(StringsList[i], size.height), stringPaint);
    }

    //FRETs
    var FretList = [];
    for (int i = 0; i <= fretCount; i++) {
      FretList.add(size.height - fretgap * i);
    }
    for (int i = 0; i <= fretCount; i++) {
      canvas.drawLine(
          Offset(0, FretList[i]), Offset(size.width, FretList[i]), fretPaint);
    }

    void ChordNoteMarker(int string, int fret, val) {
      if (fret == 0) {
        string = stringCount - string;
        double angle = fretgap / 5;
        double stringPix = StringsList[string] + angle / 2;
        if (val == 1) {
          canvas.drawCircle(Offset(StringsList[string], 0), angle, fretPaint_moded2);
        } else if (val == 0) {
          canvas.drawLine(Offset(stringPix, -angle),
              Offset(stringPix - angle, angle), fretPaint_moded2);
          canvas.drawLine(Offset(stringPix - angle, -angle),
              Offset(stringPix, angle), fretPaint_moded2);
        }
      }
      if (val == 'bar') {

        var tmpStr = string;
        string = stringCount - string;
        double angle = fretgap / 5;
        canvas.drawLine(
            Offset(StringsList[stringCount - 1],
                (FretList[FretList.length - fret] + fretgap * 0.5)),
            Offset(StringsList[string],
                (FretList[FretList.length - fret] + fretgap * 0.5)),
            barThick);

        for (int i = 0; i < tmpStr; i++) {
          ChordNoteMarker(i + 1, fret, 1);
        }
      }
      else if (fret >= 1) {
        double rectStartX =
            StringsList[StringsList.length - string] - stringgap * 20 / 100;
        double rectStartY =
            FretList[FretList.length - fret] + fretgap * 30 / 100;
        double rectWidth = stringgap * 40 / 100;
        double rectHeight = fretgap * 40 / 100;
        double textY = FretList[FretList.length - fret] +
            fretgap *
                30 /
                100; // /2 =half of string Gap - 5 = innum 5 pixel gap
        double textX =
            StringsList[StringsList.length - string] - stringgap * 10 / 100;

        Rect rectangle2 =
            Rect.fromLTWH(rectStartX, rectStartY, rectWidth, rectHeight);
        canvas.drawRect(rectangle2, fretPaint_moded2);
        canvas.drawRect(rectangle2, fretPaint_moded);

        TextPainter textPainter = TextPainter(
          text: TextSpan(
            text: val.toString(),
            style: TextStyle(
                fontFamily: 'NotoSansRegular',
                color: Colors.white,
                fontSize: fretgap / 3,
                fontWeight: FontWeight.bold),
          ),
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr,
        );
        textPainter.layout(
          minWidth: 10,
          maxWidth: double.infinity,
        );
        textPainter.paint(canvas, Offset(textX, textY));
      }
    }

    var last_fret = 5;
    var tmp;
    var chordType = valu[2].toLowerCase();

         if (chordType == '\tminor\n\n') {
      A_progression(){
        var bassString = 5; //intha postion oda bass ennavo athu
        var bassFret;

        tmp = Fret_positions[chordNote_Index];
        for (int j = 0; j < tmp.length; j++) {
          if (tmp[j][0] == bassString) {
            if (tmp[j][1] < 12) {
              last_fret = tmp[j][1] + fretCount - 2; //-2 is because of BAR
              bassFret = tmp[j][1];
              if (tmp[j][1] == 0) {
                last_fret = fretCount;
                bassFret = 0;
              }
            }
          }
        }
        // print(input[chordNote_Index]);
        // print(bassFret);
        // print('bassFret');

        if (bassFret == 0) {
          ChordNoteMarker(6, 0, 1); //5th string, 3rd Fret, Finger no 3
          ChordNoteMarker(5, 0, 1); //5th string, 3rd Fret, Finger no 3
          ChordNoteMarker(4, 2, 3);
          ChordNoteMarker(3, 2, 4);
          ChordNoteMarker(2, 1, 2);
          ChordNoteMarker(1, 0, 1);
        } else {
          ChordNoteMarker(6, 2, 'bar'); //5th string, 3rd Fret, Finger no 3
          ChordNoteMarker(4, 4, 3);
          ChordNoteMarker(3, 4, 4);
          ChordNoteMarker(2, 3, 2);
        }
      }
      E_progression(){

        var bassString = 6; //intha postion oda bass ennavo athu
        var bassFret;
        tmp = Fret_positions[chordNote_Index];
        for (int j = 0; j < tmp.length; j++) {
          if (tmp[j][0] == bassString) {
            if (tmp[j][1] < 12) {
              last_fret = tmp[j][1] + fretCount - 2; //-2 is because of BAR
              bassFret = tmp[j][1];
              if (tmp[j][1] == 0) {
                last_fret = fretCount;
                bassFret = 0;
            }
          }
        }
      }
      // print(input[chordNote_Index]);
      // print(bassFret);
      // print('bassFret');

      if (bassFret == 0) {
        ChordNoteMarker(6, 0, 1); //5th string, 3rd Fret, Finger no 3
        ChordNoteMarker(5, 2, 2); //5th string, 3rd Fret, Finger no 3
        ChordNoteMarker(4, 2, 3);
        ChordNoteMarker(3, 0, 1);
        ChordNoteMarker(2, 0, 1);
        ChordNoteMarker(1, 0, 1);
      } else {
        ChordNoteMarker(6, 2, 'bar'); //5th string, 3rd Fret, Finger no 3
        ChordNoteMarker(5, 4, 3); //5th string, 3rd Fret, Finger no 3
        ChordNoteMarker(4, 4, 4);

      }

      }


      A_progression();

    }
    else if (chordType == '\tmajor\n\n'){
      var bassString = 5; //intha postion oda bass ennavo athu
      var bassFret;

      tmp = Fret_positions[chordNote_Index];
      for (int j = 0; j < tmp.length; j++) {
        if (tmp[j][0] == bassString) {
          if (tmp[j][1] < 12) {
            last_fret = tmp[j][1] + fretCount - 2; //-2 is because of BAR
            bassFret = tmp[j][1];
            if (tmp[j][1] == 0) {
              last_fret = fretCount;
              bassFret = 0;
            }
          }
        }
      }
      // print(input[chordNote_Index]);

      if (bassFret == 0) {
        ChordNoteMarker(6, 0, 1); //5th string, 3rd Fret, Finger no 3
        ChordNoteMarker(5, 0, 1); //5th string, 3rd Fret, Finger no 3
        ChordNoteMarker(4, 2, 3);
        ChordNoteMarker(3, 2, 4);
        ChordNoteMarker(2, 2, 2);
        ChordNoteMarker(1, 0, 1);
      } else {
        ChordNoteMarker(6, 2, 'bar'); //5th string, 3rd Fret, Finger no 3
        ChordNoteMarker(4, 4, 3);
        ChordNoteMarker(3, 4, 4);
        ChordNoteMarker(2, 4, 2);
      }
    }
    else if (chordType == '\tdiminished\n\n'){
      var bassString = 5; //intha postion oda bass ennavo athu
      var bassFret;

      tmp = Fret_positions[chordNote_Index];
      for (int j = 0; j < tmp.length; j++) {
        if (tmp[j][0] == bassString) {
          if (tmp[j][1] < 12) {
            last_fret = tmp[j][1] + fretCount;
            bassFret = tmp[j][1];
          }
        }
      }
      // print(input[chordNote_Index]);
      // print(bassFret);
      // print('bassFret');
      if (bassFret == 0) {
        last_fret = fretCount;
        ChordNoteMarker(6, 0, 0); //5th string, 3rd Fret, Finger no 3
        ChordNoteMarker(5, 0, 1); //5th string, 3rd Fret, Finger no 3
        ChordNoteMarker(4, 1, 3);
        ChordNoteMarker(3, 2, 1);
        ChordNoteMarker(2, 1, 2);
        ChordNoteMarker(1, 0, 0);
      } else {
        ChordNoteMarker(6, 0, 0); //5th string, 3rd Fret, Finger no 3
        ChordNoteMarker(5, 0, 0); //5th string, 3rd Fret, Finger no 3
        ChordNoteMarker(4, 1, 3);
        ChordNoteMarker(3, 2, 1);
        ChordNoteMarker(2, 1, 2);
        ChordNoteMarker(1, 0, 0);
      }
    }
    else if (chordType == '\taugmented\n\n') {
      var bassString = 6; //intha postion oda bass ennavo athu
      var bassFret;

      tmp = Fret_positions[chordNote_Index];
      for (int j = 0; j < tmp.length; j++) {
        if (tmp[j][0] == bassString) {
          if (tmp[j][1] < 12) {
            last_fret = tmp[j][1] + fretCount - 1;
            bassFret = tmp[j][1];
          }
        }
      }
      // print(input[chordNote_Index]);
      // print(bassFret);
      // print('bassFret');
      if (bassFret == 0) {
        last_fret = fretCount;
        ChordNoteMarker(6, 0, 1); //5th string, 3rd Fret, Finger no 3
        ChordNoteMarker(5, 1, 2); //5th string, 3rd Fret, Finger no 3
        ChordNoteMarker(4, 2, 3);
        ChordNoteMarker(3, 3, 4);
        ChordNoteMarker(2, 0, 0);
        ChordNoteMarker(1, 0, 0);
      } else {
        ChordNoteMarker(6, 1, 1); //5th string, 3rd Fret, Finger no 3
        ChordNoteMarker(5, 2, 2); //5th string, 3rd Fret, Finger no 3
        ChordNoteMarker(4, 3, 3);
        ChordNoteMarker(3, 4, 4);
        ChordNoteMarker(2, 0, 0);
        ChordNoteMarker(1, 0, 0);
      }
    }
    else if (chordType == '\tinverted') {
      var bassString = 5; //intha postion oda bass ennavo athu
      var bassFret;

      tmp = Fret_positions[chordNote_Index];
      for (int j = 0; j < tmp.length; j++) {
        if (tmp[j][0] == bassString) {
          if (tmp[j][1] < 12) {
            last_fret = tmp[j][1] + fretCount - 2; //-2 is because of BAR
            bassFret = tmp[j][1];
            if (tmp[j][1] == 0) {
              last_fret = fretCount;
              bassFret = 0;
            }
          }
        }
      }
      // print(input[chordNote_Index]);
      // print(bassFret);
      // print('bassFret');

      if (bassFret == 0) {
        ChordNoteMarker(6, 0, 1); //5th string, 3rd Fret, Finger no 3
        ChordNoteMarker(5, 0, 1); //5th string, 3rd Fret, Finger no 3
        ChordNoteMarker(4, 2, 3);
        ChordNoteMarker(3, 2, 4);
        ChordNoteMarker(2, 0, 1);
        ChordNoteMarker(1, 0, 1);
      } else {
        ChordNoteMarker(6, 2, 'bar'); //5th string, 3rd Fret, Finger no 3
        ChordNoteMarker(4, 4, 3);
        ChordNoteMarker(3, 4, 4);
      }
    }
    else if (chordType == '\tmajor3') {
      var bassString = 5; //intha postion oda bass ennavo athu
      var bassFret;

      tmp = Fret_positions[chordNote_Index];
      for (int j = 0; j < tmp.length; j++) {
        if (tmp[j][0] == bassString) {
          if (tmp[j][1] < 12) {
            last_fret = tmp[j][1] + fretCount - 2; //-2 is because of BAR
            bassFret = tmp[j][1];
            if (tmp[j][1] == 0) {
              last_fret = fretCount;
              bassFret = 0;
            }
          }
        }
      }
      // print(input[chordNote_Index]);

      if (bassFret == 0) {
        ChordNoteMarker(6, 0, 0); //5th string, 3rd Fret, Finger no 3
        ChordNoteMarker(5, 0, 1); //5th string, 3rd Fret, Finger no 3
        ChordNoteMarker(4, 1, 1);
        ChordNoteMarker(3, 2, 2);
        ChordNoteMarker(2, 2, 3);
        ChordNoteMarker(1, 0, 0);
      } else {
        ChordNoteMarker(6, 0, 0);
        ChordNoteMarker(5, 2, 1); //5th string, 3rd Fret, Finger no 3
        ChordNoteMarker(4, 3, 2);
        ChordNoteMarker(3, 4, 3);
        ChordNoteMarker(2, 4, 4);
        ChordNoteMarker(1, 0, 0);
      }
    }
    else if (chordType == '\tdom7omit5') {
      var bassString = 6; //intha postion oda bass ennavo athu
      var bassFret;

      tmp = Fret_positions[chordNote_Index];
      for (int j = 0; j < tmp.length; j++) {
        if (tmp[j][0] == bassString) {
          if (tmp[j][1] < 12) {
            last_fret = tmp[j][1] + fretCount + 2; //-2 is because of BAR
            // print(last_fret);
            // print('last_fret');
            // bassFret = tmp[j][1];
            if (tmp[j][1] == 0) {
              last_fret = fretCount;
              bassFret = 0;
            }
          }
        }
      }
      // print(input[chordNote_Index]);

      if (bassFret == 0) {
        ChordNoteMarker(6, 2, 2); //5th string, 3rd Fret, Finger no 3
        ChordNoteMarker(5, 1, 1); //5th string, 3rd Fret, Finger no 3
        ChordNoteMarker(4, 2, 3);
        ChordNoteMarker(3, 3, 4);
        ChordNoteMarker(2, 0, 0);
        ChordNoteMarker(1, 0, 0);
      } else {
        last_fret = last_fret - 3;
        ChordNoteMarker(6, 3, 2); //5th string, 3rd Fret, Finger no 3
        ChordNoteMarker(5, 2, 1); //5th string, 3rd Fret, Finger no 3
        ChordNoteMarker(4, 3, 3);
        ChordNoteMarker(3, 4, 4);
        ChordNoteMarker(2, 0, 0);
        ChordNoteMarker(1, 0, 0);
      }
    }


    void stringPainter(stringNo, int fretNo, String val_to_print) {
      if (fretNo == 0) {
        fretNo = 1;
      }
      TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: val_to_print,
          style: TextStyle(
              fontFamily: 'NotoSansRegular',
              color: Colors.black,
              fontSize: stringgap / 3,
              fontWeight: FontWeight.bold),
        ),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout(
        minWidth: 10,
        maxWidth: double.infinity,
      ); // Prepare TextPainter to draw text inside the circle
      double textY = (0 - stringgap / 2) -
          10; // /2 =half of string Gap - 5 = innum 5 pixel gap
      double textX = stringNo - textPainter.width + 5;
      textPainter.paint(canvas, Offset(textX, textY));
    }

    for (int i = 0; i < stringCount; i++) {
      stringPainter(StringsList[i], 0, (stringCount - i).toString());
    }

    void FretPainter(stringNo, fretNo, String val_to_print) {
      if (fretNo == 0) {
        fretNo = 1;
      }
      TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: val_to_print,
          style: TextStyle(
              fontFamily: 'NotoSansRegular',
              color: Colors.black,
              fontSize: fretgap / 3,
              fontWeight: FontWeight.bold),
        ),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout(
        minWidth: 10,
        maxWidth: double.infinity,
      ); // Prepare TextPainter to draw text inside the circle
      double textY = -fretgap / 2;
      double textX = fretNo -
          fretgap +
          fretgap / fretCount; // Draw the text inside the circle
      // FretList[FretList.length-fretNo]+fretgap*(-.8) - textPainter.height / 2;// *-8 is done to go negative to 0, 0th fret is not accessible only fret 1 is done, and so -1
      // double textX = stringNo - textPainter.width / 1;// Draw the text inside the circle
      textPainter.paint(canvas, Offset(textY, textX));
    }

    for (int i = 0; i < fretCount; i++) {
      FretPainter(StringsList[i], FretList[i], (last_fret - i).toString());
    }
  }


  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
    // TODO: implement shouldRepaint
    throw UnimplementedError();
  }
}
class PaintChord2 extends CustomPainter {

  // ✅ So yes, in your words:
  // There should be a Top Class that:
  // Handles conditions
  // Manages painter selection
  // Controls order
  // Returns a list of CustomPaint widgets
  //
  // And the UI uses a PageView, which:
  // Displays 1 or more diagrams
  // Uses the list returned by the Top Class


  // Other way of doing this, the current mode has Charts created on tap, for every Runtime this is Created,
  //instead for every Scale, pitch change the Fretter has to be changed and
  //the Custom painter has to be created
  // each type of Custom painter has to be called once, whenever a change in ptich, sclae etc.,
  // it shuld be added to a List, say the outs, List of Widgets, then the
  // page Control in the column will be using that list to jsut display the chords

  var valu;  //[A#	, -, 	Major \n]
  var chordNote_Index;  //1
  var Fret_positions = [];

  PaintChord2({required this.valu, required this.chordNote_Index,required this.Fret_positions});

  final Paint stringPaint = Paint()
    ..color = Colors.brown.withOpacity(0.6)
    ..strokeWidth = 4
    ..style = PaintingStyle.stroke;


  final Paint fretPaint = Paint()
    ..color = Colors.brown
    ..strokeWidth = 2
    ..style = PaintingStyle.stroke;

  final Paint fretPaint_moded = Paint()
    ..color = Color.fromRGBO(11, 111, 244, 0.8)
    ..strokeWidth = 2
    ..style = PaintingStyle.fill;

  final Paint fretPaint_moded2 = Paint()
    ..color = Color.fromRGBO(11, 111, 244, 1)
    ..strokeWidth = 3
    ..style = PaintingStyle.stroke;
  final Paint barThick = Paint()
    ..color = Color.fromRGBO(11, 111, 244, 1)
    ..strokeWidth = 10
    ..style = PaintingStyle.stroke;

  int fretCount = 5;
  int stringCount = 6;



  @override
  void paint(Canvas canvas, Size size) {
    // ✅ Your Case Summary:
    // 🪶 Only one chord is shown at a time (in a popup).
    // 🎯 Feature is optional — not all users will trigger it.
    // 🎸 Target users may already know chords (minimal use).
    // 🧠 You’re dynamically generating chord visuals from notes.
    // 🎨 CustomPaint is used once at a time, with user interaction.

    // No caching needed. Performance impact is negligible.
    // If in the future you:
    // Show 10–20 chords at once,
    // Start animating them,
    // Or render them in a ListView,
    // Then caching is worth adding.
    // But for now: you’re making the right call. Keep your code simple and flexible.



    //returns the one Lower octave scale of the Raag

    var stringgap = size.width /(stringCount - 1); //count-1 due to the no of gaps between 6-5, 5,4,3,2, 2-1
    var fretgap = size.height /(fretCount); //13 due to the no of gaps between all the frets

    canvas.translate(stringgap / 2, fretgap / 2);
    canvas.scale(.85, .85);

    //STRINGs
    var StringsList = [];
    for (int i = 0; i < stringCount; i++) {
      StringsList.add(size.width - stringgap * i);
    }
    var a = StringsList.reversed;
    StringsList = a.toList();
    for (int i = 0; i < stringCount; i++) {
      canvas.drawLine(Offset(StringsList[i], 0),
          Offset(StringsList[i], size.height), stringPaint);
    }

    //FRETs
    var FretList = [];
    for (int i = 0; i <= fretCount; i++) {
      FretList.add(size.height - fretgap * i);
    }
    for (int i = 0; i <= fretCount; i++) {
      canvas.drawLine(
          Offset(0, FretList[i]), Offset(size.width, FretList[i]), fretPaint);
    }

    void ChordNoteMarker(int string, int fret, val) {
      if (fret == 0) {
        string = stringCount - string;
        double angle = fretgap / 5;
        double stringPix = StringsList[string] + angle / 2;
        if (val == 1) {
          canvas.drawCircle(Offset(StringsList[string], 0), angle, fretPaint_moded2);
        } else if (val == 0) {
          canvas.drawLine(Offset(stringPix, -angle),
              Offset(stringPix - angle, angle), fretPaint_moded2);
          canvas.drawLine(Offset(stringPix - angle, -angle),
              Offset(stringPix, angle), fretPaint_moded2);
        }
      }
      if (val == 'bar') {

        var tmpStr = string;
        string = stringCount - string;
        double angle = fretgap / 5;
        canvas.drawLine(
            Offset(StringsList[stringCount - 1],
                (FretList[FretList.length - fret] + fretgap * 0.5)),
            Offset(StringsList[string],
                (FretList[FretList.length - fret] + fretgap * 0.5)),
            barThick);

        for (int i = 0; i < tmpStr; i++) {
          ChordNoteMarker(i + 1, fret, 1);
        }
      }
      else if (fret >= 1) {
        double rectStartX =
            StringsList[StringsList.length - string] - stringgap * 20 / 100;
        double rectStartY =
            FretList[FretList.length - fret] + fretgap * 30 / 100;
        double rectWidth = stringgap * 40 / 100;
        double rectHeight = fretgap * 40 / 100;
        double textY = FretList[FretList.length - fret] +
            fretgap *
                30 /
                100; // /2 =half of string Gap - 5 = innum 5 pixel gap
        double textX =
            StringsList[StringsList.length - string] - stringgap * 10 / 100;

        Rect rectangle2 =
        Rect.fromLTWH(rectStartX, rectStartY, rectWidth, rectHeight);
        canvas.drawRect(rectangle2, fretPaint_moded2);
        canvas.drawRect(rectangle2, fretPaint_moded);

        TextPainter textPainter = TextPainter(
          text: TextSpan(
            text: val.toString(),
            style: TextStyle(
                fontFamily: 'NotoSansRegular',
                color: Colors.white,
                fontSize: fretgap / 3,
                fontWeight: FontWeight.bold),
          ),
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr,
        );
        textPainter.layout(
          minWidth: 10,
          maxWidth: double.infinity,
        );
        textPainter.paint(canvas, Offset(textX, textY));
      }
    }

    var last_fret = 5;
    var tmp;
    var chordType = valu[2].toLowerCase();

    if (chordType == '\tminor\n\n') {
        var bassString = 6; //intha postion oda bass ennavo athu
        var bassFret;
        tmp = Fret_positions[chordNote_Index];
        for (int j = 0; j < tmp.length; j++) {
          if (tmp[j][0] == bassString) {
            if (tmp[j][1] < 12) {
              last_fret = tmp[j][1] + fretCount - 2; //-2 is because of BAR
              bassFret = tmp[j][1];
              if (tmp[j][1] == 0) {
                last_fret = fretCount;
                bassFret = 0;
              }
            }
          }
        }
        // print(input[chordNote_Index]);
        // print(bassFret);
        // print('bassFret');

        if (bassFret == 0) {
          ChordNoteMarker(6, 0, 1); //5th string, 3rd Fret, Finger no 3
          ChordNoteMarker(5, 2, 2); //5th string, 3rd Fret, Finger no 3
          ChordNoteMarker(4, 2, 3);
          ChordNoteMarker(3, 0, 1);
          ChordNoteMarker(2, 0, 1);
          ChordNoteMarker(1, 0, 1);
        } else {
          ChordNoteMarker(6, 2, 'bar'); //5th string, 3rd Fret, Finger no 3
          ChordNoteMarker(5, 4, 3); //5th string, 3rd Fret, Finger no 3
          ChordNoteMarker(4, 4, 4);
        }
    }
    else if (chordType == '\tmajor\n\n'){
      var bassString = 6; //intha postion oda bass ennavo athu
      var bassFret;

      tmp = Fret_positions[chordNote_Index];
      for (int j = 0; j < tmp.length; j++) {
        if (tmp[j][0] == bassString) {
          if (tmp[j][1] < 12) {
            last_fret = tmp[j][1] + fretCount - 2; //-2 is because of BAR
            bassFret = tmp[j][1];
            if (tmp[j][1] == 0) {
              last_fret = fretCount;
              bassFret = 0;
            }
          }
        }
      }
      // print(input[chordNote_Index]);

      if (bassFret == 0) {
        ChordNoteMarker(6, 0, 1); //5th string, 3rd Fret, Finger no 3
        ChordNoteMarker(5, 2, 2); //5th string, 3rd Fret, Finger no 3
        ChordNoteMarker(4, 2, 3);
        ChordNoteMarker(3, 1, 1);
        ChordNoteMarker(2, 0, 1);
        ChordNoteMarker(1, 0, 1);
      } else {
        ChordNoteMarker(6, 2, 'bar'); //5th string, 3rd Fret, Finger no 3
        ChordNoteMarker(5, 4, 3); //5th string, 3rd Fret, Finger no 3
        ChordNoteMarker(4, 4, 4);
        ChordNoteMarker(3, 3, 2);


      }
    }




    else if (chordType == '\tdiminished\n\n'){
      var bassString = 5; //intha postion oda bass ennavo athu
      var bassFret;

      tmp = Fret_positions[chordNote_Index];
      for (int j = 0; j < tmp.length; j++) {
        if (tmp[j][0] == bassString) {
          if (tmp[j][1] < 12) {
            last_fret = tmp[j][1] + fretCount;
            bassFret = tmp[j][1];
          }
        }
      }
      // print(input[chordNote_Index]);
      // print(bassFret);
      // print('bassFret');
      if (bassFret == 0) {
        last_fret = fretCount;
        ChordNoteMarker(6, 0, 0); //5th string, 3rd Fret, Finger no 3
        ChordNoteMarker(5, 0, 1); //5th string, 3rd Fret, Finger no 3
        ChordNoteMarker(4, 1, 3);
        ChordNoteMarker(3, 2, 1);
        ChordNoteMarker(2, 1, 2);
        ChordNoteMarker(1, 0, 0);
      } else {
        ChordNoteMarker(6, 0, 0); //5th string, 3rd Fret, Finger no 3
        ChordNoteMarker(5, 0, 0); //5th string, 3rd Fret, Finger no 3
        ChordNoteMarker(4, 1, 3);
        ChordNoteMarker(3, 2, 1);
        ChordNoteMarker(2, 1, 2);
        ChordNoteMarker(1, 0, 0);
      }
    }
    else if (chordType == '\taugmented\n\n') {
      var bassString = 6; //intha postion oda bass ennavo athu
      var bassFret;

      tmp = Fret_positions[chordNote_Index];
      for (int j = 0; j < tmp.length; j++) {
        if (tmp[j][0] == bassString) {
          if (tmp[j][1] < 12) {
            last_fret = tmp[j][1] + fretCount - 1;
            bassFret = tmp[j][1];
          }
        }
      }
      // print(input[chordNote_Index]);
      // print(bassFret);
      // print('bassFret');
      if (bassFret == 0) {
        last_fret = fretCount;
        ChordNoteMarker(6, 0, 1); //5th string, 3rd Fret, Finger no 3
        ChordNoteMarker(5, 1, 2); //5th string, 3rd Fret, Finger no 3
        ChordNoteMarker(4, 2, 3);
        ChordNoteMarker(3, 3, 4);
        ChordNoteMarker(2, 0, 0);
        ChordNoteMarker(1, 0, 0);
      } else {
        ChordNoteMarker(6, 1, 1); //5th string, 3rd Fret, Finger no 3
        ChordNoteMarker(5, 2, 2); //5th string, 3rd Fret, Finger no 3
        ChordNoteMarker(4, 3, 3);
        ChordNoteMarker(3, 4, 4);
        ChordNoteMarker(2, 0, 0);
        ChordNoteMarker(1, 0, 0);
      }
    }
    else if (chordType == '\tinverted') {
      var bassString = 5; //intha postion oda bass ennavo athu
      var bassFret;

      tmp = Fret_positions[chordNote_Index];
      for (int j = 0; j < tmp.length; j++) {
        if (tmp[j][0] == bassString) {
          if (tmp[j][1] < 12) {
            last_fret = tmp[j][1] + fretCount - 2; //-2 is because of BAR
            bassFret = tmp[j][1];
            if (tmp[j][1] == 0) {
              last_fret = fretCount;
              bassFret = 0;
            }
          }
        }
      }
      // print(input[chordNote_Index]);
      // print(bassFret);
      // print('bassFret');

      if (bassFret == 0) {
        ChordNoteMarker(6, 0, 1); //5th string, 3rd Fret, Finger no 3
        ChordNoteMarker(5, 0, 1); //5th string, 3rd Fret, Finger no 3
        ChordNoteMarker(4, 2, 3);
        ChordNoteMarker(3, 2, 4);
        ChordNoteMarker(2, 0, 1);
        ChordNoteMarker(1, 0, 1);
      } else {
        ChordNoteMarker(6, 2, 'bar'); //5th string, 3rd Fret, Finger no 3
        ChordNoteMarker(4, 4, 3);
        ChordNoteMarker(3, 4, 4);
      }
    }
    else if (chordType == '\tmajor3') {
      var bassString = 5; //intha postion oda bass ennavo athu
      var bassFret;

      tmp = Fret_positions[chordNote_Index];
      for (int j = 0; j < tmp.length; j++) {
        if (tmp[j][0] == bassString) {
          if (tmp[j][1] < 12) {
            last_fret = tmp[j][1] + fretCount - 2; //-2 is because of BAR
            bassFret = tmp[j][1];
            if (tmp[j][1] == 0) {
              last_fret = fretCount;
              bassFret = 0;
            }
          }
        }
      }
      // print(input[chordNote_Index]);

      if (bassFret == 0) {
        ChordNoteMarker(6, 0, 0); //5th string, 3rd Fret, Finger no 3
        ChordNoteMarker(5, 0, 1); //5th string, 3rd Fret, Finger no 3
        ChordNoteMarker(4, 1, 1);
        ChordNoteMarker(3, 2, 2);
        ChordNoteMarker(2, 2, 3);
        ChordNoteMarker(1, 0, 0);
      } else {
        ChordNoteMarker(6, 0, 0);
        ChordNoteMarker(5, 2, 1); //5th string, 3rd Fret, Finger no 3
        ChordNoteMarker(4, 3, 2);
        ChordNoteMarker(3, 4, 3);
        ChordNoteMarker(2, 4, 4);
        ChordNoteMarker(1, 0, 0);
      }
    }
    else if (chordType == '\tdom7omit5') {
      var bassString = 6; //intha postion oda bass ennavo athu
      var bassFret;

      tmp = Fret_positions[chordNote_Index];
      for (int j = 0; j < tmp.length; j++) {
        if (tmp[j][0] == bassString) {
          if (tmp[j][1] < 12) {
            last_fret = tmp[j][1] + fretCount + 2; //-2 is because of BAR
            // print(last_fret);
            // print('last_fret');
            // bassFret = tmp[j][1];
            if (tmp[j][1] == 0) {
              last_fret = fretCount;
              bassFret = 0;
            }
          }
        }
      }
      // print(input[chordNote_Index]);

      if (bassFret == 0) {
        ChordNoteMarker(6, 2, 2); //5th string, 3rd Fret, Finger no 3
        ChordNoteMarker(5, 1, 1); //5th string, 3rd Fret, Finger no 3
        ChordNoteMarker(4, 2, 3);
        ChordNoteMarker(3, 3, 4);
        ChordNoteMarker(2, 0, 0);
        ChordNoteMarker(1, 0, 0);
      } else {
        last_fret = last_fret - 3;
        ChordNoteMarker(6, 3, 2); //5th string, 3rd Fret, Finger no 3
        ChordNoteMarker(5, 2, 1); //5th string, 3rd Fret, Finger no 3
        ChordNoteMarker(4, 3, 3);
        ChordNoteMarker(3, 4, 4);
        ChordNoteMarker(2, 0, 0);
        ChordNoteMarker(1, 0, 0);
      }
    }

    void stringPainter(stringNo, int fretNo, String val_to_print) {
      if (fretNo == 0) {
        fretNo = 1;
      }
      TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: val_to_print,
          style: TextStyle(
              fontFamily: 'NotoSansRegular',
              color: Colors.black,
              fontSize: stringgap / 3,
              fontWeight: FontWeight.bold),
        ),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout(
        minWidth: 10,
        maxWidth: double.infinity,
      ); // Prepare TextPainter to draw text inside the circle
      double textY = (0 - stringgap / 2) -
          10; // /2 =half of string Gap - 5 = innum 5 pixel gap
      double textX = stringNo - textPainter.width + 5;
      textPainter.paint(canvas, Offset(textX, textY));
    }

    for (int i = 0; i < stringCount; i++) {
      stringPainter(StringsList[i], 0, (stringCount - i).toString());
    }

    void FretPainter(stringNo, fretNo, String val_to_print) {
      if (fretNo == 0) {
        fretNo = 1;
      }
      TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: val_to_print,
          style: TextStyle(
              fontFamily: 'NotoSansRegular',
              color: Colors.black,
              fontSize: fretgap / 3,
              fontWeight: FontWeight.bold),
        ),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout(
        minWidth: 10,
        maxWidth: double.infinity,
      ); // Prepare TextPainter to draw text inside the circle
      double textY = -fretgap / 2;
      double textX = fretNo -
          fretgap +
          fretgap / fretCount; // Draw the text inside the circle
      // FretList[FretList.length-fretNo]+fretgap*(-.8) - textPainter.height / 2;// *-8 is done to go negative to 0, 0th fret is not accessible only fret 1 is done, and so -1
      // double textX = stringNo - textPainter.width / 1;// Draw the text inside the circle
      textPainter.paint(canvas, Offset(textY, textX));
    }

    for (int i = 0; i < fretCount; i++) {
      FretPainter(StringsList[i], FretList[i], (last_fret - i).toString());
    }
  }


  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
    // TODO: implement shouldRepaint
    throw UnimplementedError();
  }
}

class TapRenderBox extends LeafRenderObjectWidget {
  final VoidCallback? onTap;
  final Color color;
  final Size size;

  const TapRenderBox({
    Key? key,
    this.onTap,
    this.color = Colors.blue,
    this.size = const Size(100, 100),
  }) : super(key: key);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderTapBox(onTap: onTap, color: color, size: size);
  }

  @override
  void updateRenderObject(BuildContext context, _RenderTapBox renderObject) {
    renderObject
      ..onTap = onTap
      ..color = color
      ..boxSize = size;
  }
}

class _RenderTapBox extends RenderBox {
  _RenderTapBox({
    VoidCallback? onTap,
    required Color color,
    required Size size,
  })  : _onTap = onTap,
        _color = color,
        _boxSize = size {
    _tapRecognizer = TapGestureRecognizer()..onTap = _handleTap;
  }

  VoidCallback? _onTap;
  Color _color;
  Size _boxSize;
  late TapGestureRecognizer _tapRecognizer;

  set onTap(VoidCallback? value) {
    if (_onTap != value) {
      _onTap = value;
      _tapRecognizer.onTap = _handleTap;
    }
  }

  set color(Color value) {
    if (_color != value) {
      _color = value;
      markNeedsPaint();
    }
  }

  set boxSize(Size value) {
    if (_boxSize != value) {
      _boxSize = value;
      markNeedsLayout();
    }
  }

  void _handleTap() {
    _onTap?.call();
  }

  @override
  void performLayout() {
    size = constraints.constrain(_boxSize);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final canvas = context.canvas;
    final paint = Paint()..color = _color;
    canvas.drawRect(offset & size, paint);
  }

  @override
  bool hitTestSelf(Offset position) => true;

  @override
  void handleEvent(PointerEvent event, HitTestEntry entry) {
    if (event is PointerDownEvent) {
      _tapRecognizer.addPointer(event);
    }
  }

  @override
  void detach() {
    _tapRecognizer.dispose();
    super.detach();
  }
}
