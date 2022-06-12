import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:myproject/main.dart';

enum ScreenMode { liveFeed, gallery }

class CameraView extends StatefulWidget {
  const CameraView(
      {Key? key,
      required this.title,
      required this.customPaint,
      required this.onImage,
      required this.size,
      this.initialDirection = CameraLensDirection.back})
      : super(key: key);

  final String title;
  final CustomPaint? customPaint;
  final Function(InputImage inputImage) onImage;
  final CameraLensDirection initialDirection;
  final size;

  @override
  _CameraViewState createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  PoseDetector poseDetector = GoogleMlKit.vision.poseDetector();
  CameraController? _controller;
  late Map<String, List<double>> inputArr;

  late int _counter = 0;
  late bool check, checkNext;
  late bool _checkPose = false;

  @override
  void initState() {
    super.initState();

    setState(() {
      check = true;
      checkNext = true;
    });

    _startCamera();
  }

  incrementCounter() {
    _counter++;
  }

  setCheckTrue() {
    setState(() {
      check = true;
    });
  }

  setCheckFalse() {
    setState(() {
      check = false;
    });
  }

  setCheckNextTrue() {
    setState(() {
      checkNext = true;
    });
  }

  setCheckNextFalse() {
    setState(() {
      checkNext = false;
    });
  }

  @override
  void dispose() {
    _stopCamera();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.orange,
      ),
      body: _body(),
    );
  }

  Widget _body() {
    Widget body;
    body = _liveFeedBody();
    return body;
  }

  Widget _liveFeedBody() {
    if (_controller?.value.isInitialized == false) {
      return Container();
    }

    return Container(
      color: Colors.black,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          CameraPreview(_controller!),
          if (widget.customPaint != null) widget.customPaint!,
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if(_checkPose) const Text('Odlična pozicija',style: TextStyle(
                          color: Colors.green,
                          fontSize: 40,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      if(!_checkPose) const Text('Loša pozicija', style: TextStyle(
                            color: Colors.red,
                            fontSize: 40,
                            fontWeight: FontWeight.bold
                          ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                      '$_counter',
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 40,
                        fontWeight: FontWeight.bold
                      ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future _startCamera() async {
    final camera = cameras[1];

    _controller = CameraController(
      camera,
      ResolutionPreset.low,
      enableAudio: false,
    );

    _controller?.initialize().then((_) {
      if (!mounted) {
        return;
      }

      _controller?.startImageStream(_processCameraImage);

      setState(() {});
    });
  }

  Future _stopCamera() async {
    await _controller?.stopImageStream();
    await _controller?.dispose();
    _controller = null;
  }

  Future _processCameraImage(CameraImage image) async {
    final WriteBuffer allBytes = WriteBuffer();

    for (Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }

    final bytes = allBytes.done().buffer.asUint8List();

    final Size imageSize =
        Size(image.width.toDouble(), image.height.toDouble());

    final camera = cameras[1];
    final imageRotation =
        InputImageRotationValue.fromRawValue(camera.sensorOrientation) ??
            InputImageRotation.rotation0deg;

    final inputImageFormat =
        InputImageFormatValue.fromRawValue(image.format.raw) ??
            InputImageFormat.nv21;

    final planeData = image.planes.map(
      (Plane plane) {
        return InputImagePlaneMetadata(
          bytesPerRow: plane.bytesPerRow,
          height: plane.height,
          width: plane.width,
        );
      },
    ).toList();

    final inputImageData = InputImageData(
      size: imageSize,
      imageRotation: imageRotation,
      inputImageFormat: inputImageFormat,
      planeData: planeData,
    );

    final inputImage =
        InputImage.fromBytes(bytes: bytes, inputImageData: inputImageData);

    getDataForProcess(inputImage);

    widget.onImage(inputImage);
  }

  Future? getDataForProcess(inputImage) async {
    final List<Pose> poses = await poseDetector.processImage(inputImage);

    for (Pose pose in poses) {
      // Usta
      final rightMouth = pose.landmarks[PoseLandmarkType.rightMouth]!.y.toInt();
      // Ramena
      final rightShoulder = pose.landmarks[PoseLandmarkType.rightShoulder]!.y.toInt();
      // Kukovi
      final rightHip = pose.landmarks[PoseLandmarkType.rightHip]!.y.toInt();
      // Koljena
      final rightKnee = pose.landmarks[PoseLandmarkType.rightKnee]!.y.toInt();

      // Za povecanje countera
      // I za potvrdu položaja
      final rightHipRightKnee = (rightHip - rightKnee).abs();
      const minValue = 30;

      _checkPose = checkScreenAndPose(rightShoulder);

      print(rightHipRightKnee);

      if (checkNext == true && rightHipRightKnee < minValue) {
        setCheckTrue();
      }

      // Ako je true, treba povecati za 1
      if (check == true && rightHipRightKnee < minValue) {
        incrementCounter();
        setCheckFalse();
      }

      if (!check) {
        checkForNext(rightHipRightKnee, minValue);
      }
    }
  }

  Future checkForNext(val, min) async {
    if (val < min) {
      setCheckNextFalse();
    } else {
      setCheckNextTrue();
    }
  }

  bool checkScreenAndPose(pose){

    final size = widget.size;
    final deviceRatio = size.width / size.height;
    final test = _controller!.value.aspectRatio / deviceRatio;

    final result = (pose / test) * 100;

    if(result >= 4300 && result <= 4800){
      return true;
    }

    return false;
  }
}
