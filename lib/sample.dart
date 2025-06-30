// // Necessary Imports
// import 'package:dart_melty_soundfont/dart_melty_soundfont.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart' show rootBundle;
// import 'dart:typed_data';
// // import 'package:flutter_sound/flutter_sound.dart';
//
// void main() {  runApp(const sample()); }
//
// class sample extends StatelessWidget {
//   const sample({super.key});
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: ThemeData(
//         // colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
//         // useMaterial3: true,
//       ),
//       home: trial(),
//     );
//   }
// }
//
//
// class trial extends StatefulWidget {
//   trial();
//
//
//   final String title = 'MusicInterval';
//   @override
//   State<trial> createState() => _trialState();
// }
//
// class _trialState extends State<trial> {
// // final _flutterMidi = FlutterMidi();
// //   late Type synth = Synthesizer;
//
//   void initState(){
//     load();
//   }
//
//
//   void load() async{
//     // final FlutterSoundPlayer _player = FlutterSoundPlayer();
//     // await _player.openPlayer();
//
//     // await _player.startPlayerFromStream(
//     //   codec: Codec.pcm16,
//     //   numChannels: 1,
//     //   sampleRate: 44100,
//     // );
//
//
//
//     ByteData _byte = await rootBundle.load('assets/audios/Guitar1.sf2');
//
//     Synthesizer synth = Synthesizer.loadByteData(_byte,
//         SynthesizerSettings(
//           sampleRate: 44100,
//           blockSize: 64,
//           maximumPolyphony: 64,
//           enableReverbAndChorus: true,
//         ));
//     // _flutterMidi.prepare(sf2: _byte);
//
//
//     //optional: print available instruments (aka presets)
//     List<Preset> p = synth.soundFont.presets;
//     for (int i = 0; i < p.length; i++) {
//       String instrumentName = p[i].regions.isNotEmpty ? p[i].regions[0].instrument.name : "N/A";
//       print('[preset $i] name: ${p[i].name} instrument: $instrumentName');
//     }
//
// //  optional: select first instrument (aka preset)
//     synth.selectPreset(channel: 0, preset: 0);
//
// // turn on some notes
//     synth.noteOn(channel: 0, key: 72, velocity: 120);
//     synth.noteOn(channel: 0, key: 76, velocity: 120);
//     synth.noteOn(channel: 0, key: 79, velocity: 120);
//     synth.noteOn(channel: 0, key: 82, velocity: 120);
//
// // create a pcm buffer
//
//     ArrayInt16 buf16 = ArrayInt16.zeros(numShorts: 44100 * 3);
//
// // render the waveform (1 second)
//     synth.renderMonoInt16(buf16);
//     //
//     // Future<void> playArrayInt16(ArrayInt16 buf16) async {
//     //   final _player = FlutterSoundPlayer();
//     //   await _player.openPlayer();
//     //
//     //   await _player.startPlayerFromStream(
//     //     codec: Codec.pcm16,
//     //     numChannels: 1,
//     //     sampleRate: 44100,
//     //   );
//     //
//     //   Uint8List pcmBytes = buf16.bytes.buffer.asUint8List();
//     //
//     //   _player.foodSink!.add(FoodData(pcmBytes));
//     //
//     //   // Automatically stops when done
//     //   await Future.delayed(Duration(seconds: 3));
//     //   await _player.stopPlayer();
//     //   await _player.closePlayer();
//     // }
//     //
//     // playArrayInt16(buf16);
//     // await _player.startPlayer(
//     //   fromDataBuffer: buf16 as Uint8List,
//     //   codec: Codec.pcm16,
//     //   numChannels: 1, // or 2 if stereo
//     //   sampleRate: 44100, // adjust based on your PCM sample rate
//     // );
//
//
//
//
//
//
//
//
// // turn off a note
// //     synth.noteOff(channel: 0, key: 72);
//
// // render another second
// //     synth.renderMonoInt16(buf16);
//
//
//
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     void play(){
//       load();
//       print("Hi");
//
//     }
//
//
//     // IntervalVector();
//     // List input =  inputMap['scale'];
//     // Color OverallBG =Color.fromRGBO(250, 250, 250, 1);
//
//     return WillPopScope(
//       onWillPop:  () async {
//         Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> sample()));
//         return true; // Prevent back navigation
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           // leading: IconButton(
//           //   icon: Icon(Icons.arrow_back,color:backArrow,),
//           //   onPressed: () {
//           //     pairOutPut = '0';patternOutPut = '0';
//           //     Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> HomeApp()));
//           //
//           //   },
//           // ),
//           title: Text('Intervals'),
//         ),
//
//         body: Center(
//           child: ListView(
//             padding: const EdgeInsets.symmetric(horizontal: 10.0),
//
//             // Important: Remove any padding from the ListView.
//             children: [
//               ElevatedButton(onPressed: (){
//                 play();
//
//                 },
//                   child: Text("Hit it")),
//
//               //NEW
//               Container(margin: EdgeInsets.all(10),),
//
//
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//   }