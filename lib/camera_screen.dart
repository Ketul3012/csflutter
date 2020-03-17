import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Camerascreen extends StatefulWidget {
  Camerascreen({Key key}) : super(key: key);

  @override
  _CamerascreenState createState() => _CamerascreenState();
}

class _CamerascreenState extends State<Camerascreen> {
  CameraController controller;
  List cameras;
  int selectedCameraIdx;

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
    cameras[selectedCameraIdx] = null;
  }
  @override
void initState() {
  super.initState();
  // 1
  availableCameras().then((availableCameras) {
    
    cameras = availableCameras;
    if (cameras.length > 0) {
      setState(() {
        // 2
        selectedCameraIdx = 0;
      });

      _initCameraController(cameras[selectedCameraIdx]).then((void v) {});
    }else{
      print("No camera available");
    }
  }).catchError((err) {
    // 3
    print('Error: $err.code\nError Message: $err.message');
  });
}


  Future _initCameraController(CameraDescription cameraDescription) async {
  if (controller != null) {
    await controller.dispose();
  }

  // 3
  controller = CameraController(cameraDescription, ResolutionPreset.high);

  // If the controller is updated then update the UI.
  // 4
  controller.addListener(() {
    // 5
    if (mounted) {
      setState(() {});
    }

    if (controller.value.hasError) {
      print('Camera error ${controller.value.errorDescription}');
    }
  });

  // 6
  try {
    await controller.initialize();
  } on CameraException catch (e) {
    _showCameraException(e);
      }
    
      if (mounted) {
        setState(() {});
      }
    }
    
    
    
      @override
      Widget build(BuildContext context) {
        return Container(
           child: Column(
             children: <Widget>[
               _cameraPreviewWidget() ,
               FloatingActionButton(onPressed:  ()  {
                 Fluttertoast.showToast(msg: "Clicked"
                          ,toastLength: Toast.LENGTH_SHORT ,
                          timeInSecForIos: 2 ,
                          backgroundColor: Colors.blue,
                          textColor: Colors.white ,
                          gravity: ToastGravity.BOTTOM);
               },
               child: Icon(Icons.camera_alt , color: Colors.white,),
               backgroundColor: Colors.blue,)
             ],
           ),
        );
      }
    
      void _showCameraException(CameraException e) {}

  Widget _cameraPreviewWidget() {
    final size = MediaQuery.of(context).size;
    //final deviceRatio = size.width / size.height;
  if (controller == null || !controller.value.isInitialized) {
    return const Text(
      'Loading',
      style: TextStyle(
        color: Colors.white,
        fontSize: 20.0,
        fontWeight: FontWeight.w900,
      ),
    );
  }

  return Transform.scale(
  scale: controller.value.aspectRatio / size.aspectRatio,
  child: Center(
    child: AspectRatio(
      aspectRatio: controller.value.aspectRatio,
      child: CameraPreview(controller),
    ),
  ),
);
}
}