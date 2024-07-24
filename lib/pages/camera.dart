import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite_v2/tflite_v2.dart';
import 'package:google_fonts/google_fonts.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  bool _isCameraInitialized = false;
  String? _prediction;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _loadModel();
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras != null && _cameras!.isNotEmpty) {
        _controller = CameraController(_cameras![0], ResolutionPreset.high);
        await _controller?.initialize();
        setState(() {
          _isCameraInitialized = true;
        });
      }
    } catch (e) {
      print("Error initializing camera: $e");
    }
  }

  Future<void> _loadModel() async {
    try {
      String? res = await Tflite.loadModel(
        model: "assets/models/converted_model.tflite",
        labels: "assets/models/labels.txt",
        numThreads: 1,
        isAsset: true,
        useGpuDelegate: false,
      );
      print("Model loaded: $res");
    } catch (e) {
      print("Error loading model: $e");
    }
  }

  Future<void> _classifyImage(String path) async {
    try {
      var recognitions = await Tflite.runModelOnImage(
        path: path,
        numResults: 5,
      );
      setState(() {
        _prediction = recognitions?.isNotEmpty == true
            ? recognitions!.first['label']
            : 'No Prediction';
      });
      print("The prediction is: $_prediction");
    } catch (e) {
      print("Error classifying image: $e");
    }
  }

  Future<void> _captureAndClassify() async {
    try {
      final image = await _controller?.takePicture();
      if (image != null) {
        await _classifyImage(image.path);
      }
    } catch (e) {
      print("Error capturing image: $e");
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    Tflite.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    'How are You Feeling.',
                    style: GoogleFonts.openSans(
                      textStyle: const TextStyle(
                        fontSize: 27,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(15, 9, 104, 1),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                if (_isCameraInitialized && _controller != null)
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(40.0),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.73,
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: AspectRatio(
                          aspectRatio: _controller!.value.aspectRatio,
                          child: CameraPreview(_controller!),
                        ),
                      ),
                    ),
                  )
                else
                  const Center(child: CircularProgressIndicator()),
                const SizedBox(height: 20),
                InkWell(
                  onTap: _captureAndClassify,
                  child: Container(
                    height: 80.0,
                    width: 80.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.black,
                    ),
                    child: const Icon(
                      Icons.camera,
                      color: Colors.white,
                      size: 55.0,
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              top: 13,
              left: 13,
              child: InkWell(
                onTap: () => Navigator.pushNamed(context, '/home'),
                child: Container(
                  height: 65.0,
                  width: 65.0,
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.white,
                    size: 34,
                  ),
                ),
              ),
            ),
            if (_prediction != null)
              Positioned(
                top: 5,
                left: 26,
                child: Text("The prediction is: $_prediction"),
              ),
          ],
        ),
      ),
    );
  }
}
