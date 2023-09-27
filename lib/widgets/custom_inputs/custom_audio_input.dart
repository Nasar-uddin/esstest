import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:record/record.dart';

class CustomAudionInput extends StatefulWidget {
  const CustomAudionInput({super.key, this.onRecordComplete});

  final void Function(String? path)? onRecordComplete;

  @override
  State<CustomAudionInput> createState() => _CustomAudionInputState();
}

class _CustomAudionInputState extends State<CustomAudionInput> {
  
  bool isRecording = false;
  bool isPlaying = false;
  
  final Record recorder = Record();
  final player = AudioPlayer();
  
  String? recoredFilePath;

  @override
  void initState() {
    player.onPlayerStateChanged.listen((state) {
      if(state == PlayerState.playing){
        setState(() {
          isPlaying = true;
        });
      }else{
        setState(() {
          isPlaying = false;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: const Color(0xFFE7EAEA),
      ),
      child: Row(
        children: recoredFilePath != null ? [
          Expanded(
            child: Text(recoredFilePath ?? "")
          ),
          GestureDetector(
            child: isPlaying 
            ? const Icon(
              Icons.pause,
              size: 30,
            ) 
            : const Icon(
              Icons.play_arrow,
              size: 30,
            ),
            onTap: () async {
              if(isPlaying){
                await player.stop();
              }else{
                await player.setSource(DeviceFileSource(recoredFilePath?? ""));
                await player.resume();
              }
            },
          )
        ] : [
          Expanded(
            child: Text(isRecording ? "Recording..." : "Please record"),
          ),
          GestureDetector(
            child: isRecording
                ? const Icon(Icons.stop_circle, size: 30, color: Colors.red)
                : const Icon(
                    Icons.mic,
                    size: 30,
                    color: Colors.red,
                  ),
            onTap: () async {
              if (isRecording) {
                try{
                  String? path = await recorder.stop();
                  widget.onRecordComplete!(path);
                  setState(() {
                    isRecording = !isRecording;
                    recoredFilePath = path;
                  });
                }catch(error){
                  Fluttertoast.showToast(msg: error.toString());
                }
              }else{
                try {
                  if (await recorder.hasPermission()) {
                    setState(() {
                      isRecording = !isRecording;
                    });
                    await recorder.start(
                        // path: newFile.path,
                        encoder: AudioEncoder.aacLc);
                  } else {
                    Fluttertoast.showToast(msg: "Please Allow to record audio first");
                  }
                } catch (error) {
                  Fluttertoast.showToast(msg: error.toString());
                }
              }
            },
          )
        ],
      ),
    );
  }
}
