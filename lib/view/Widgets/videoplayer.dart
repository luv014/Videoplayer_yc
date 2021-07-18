import 'package:auto_orientation/auto_orientation.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  VideoPlayerController _controller;
  CameraController _camController;
  List<CameraDescription> cameras = [];
  Offset position;

  @override
  void initState() {
    super.initState();
    AutoOrientation.landscapeAutoMode();
    _controller = VideoPlayerController.asset('assets/Butterfly-209.mp4');
    _initializeVideoPlayer();
    _initializeCamera();
  }

  void _initializeVideoPlayer() async {
    await _controller.setLooping(true);
    await _controller.initialize();
    await _controller.seekTo(Duration(seconds: 0));
    await _controller.play();
    _controller.addListener(() {
      setState(() {});
    });
  }

  void _initializeCamera() async {
    try {
      cameras = await availableCameras();
      _camController = CameraController(cameras[1], ResolutionPreset.max);
      await _camController.initialize();
    } catch (e) {}
  }

  @override
  void dispose() {
    _controller.dispose();
    _camController?.dispose();
    AutoOrientation.portraitAutoMode();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OrientationBuilder(builder: (context, orientation) {
        final height = MediaQuery.of(context).size.height;
        final width = MediaQuery.of(context).size.width;
        final isPortrait = orientation == Orientation.portrait ? true : false;
        return Stack(
          fit: isPortrait ? StackFit.loose : StackFit.expand,
          children: <Widget>[
            AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: <Widget>[
                  VideoPlayer(_controller),
                  _ControlsOverlay(controller: _controller),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: VideoProgressIndicator(_controller,
                        allowScrubbing: true),
                  ),
                  cameras.length > 0
                      ? Positioned(
                          left: position?.dx ?? width - 120.0,
                          top: position?.dy ?? height - 120.0,
                          child: Draggable(
                            feedback: _cameraWindow(),
                            childWhenDragging: Opacity(
                              opacity: .3,
                              child: _cameraWindow(),
                            ),
                            onDragEnd: (details) =>
                                setState(() => position = details.offset),
                            child: _cameraWindow(),
                          ),
                        )
                      : Container()
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _cameraWindow() {
    return Container(
      width: 120,
      color: Colors.yellow,
      child: _camController?.value?.isInitialized == null
          ? Container()
          : Center(
              child: CameraPreview(_camController),
            ),
    );
  }
}

class _ControlsOverlay extends StatefulWidget {
  _ControlsOverlay({this.controller});

  final VideoPlayerController controller;

  @override
  __ControlsOverlayState createState() => __ControlsOverlayState();
}

class __ControlsOverlayState extends State<_ControlsOverlay> {
  double volume = 50;
  double maxVol = 100;
  double minVol = 0;
  @override
  void initState() {
    widget.controller.setVolume(volume / 100);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      // fit: StackFit.expand,
      children: <Widget>[
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(
              left: 25,
            ),
            child: Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("$maxVol"),
                    RotatedBox(
                      quarterTurns: 3,
                      child: Container(
                        child: CupertinoSlider(
                            onChangeStart: (val) {},
                            activeColor: Colors.red,
                            min: minVol,
                            max: maxVol,
                            thumbColor: Colors.red,
                            value: volume,
                            onChanged: (onChanged) {
                              volume = onChanged;
                              widget.controller.setVolume(onChanged / 100);
                            }),
                      ),
                    ),
                    Text("$minVol"),
                  ],
                ),
                Text(
                  "${volume.round()}",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 30),
                )
              ],
            ),
          ),
        ),
        Center(
          child: widget.controller.value.isPlaying
              ? SizedBox()
              : Container(
                  height: MediaQuery.of(context).size.height * .5,
                  width: MediaQuery.of(context).size.width * .5,
                  color: Colors.black26,
                  child: Center(
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 100.0,
                    ),
                  ),
                ),
        ),
        Align(
          alignment: Alignment.center,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * .5,
            width: MediaQuery.of(context).size.width * .5,
            child: GestureDetector(
              onTap: () {
                widget.controller.value.isPlaying
                    ? widget.controller.pause()
                    : widget.controller.play();
              },
            ),
          ),
        ),
      ],
    );
  }
}
