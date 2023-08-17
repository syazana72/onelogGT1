import 'dart:io';
import 'package:afrv1/forgotpassword.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<PlatformFile> pickedFile = [];
//  await uploadFiles(pickedFiles);
  UploadTask? uploadTask;

  String generateShortUniqueId() {
    final random = Random();
    final timestamp = DateTime.now().microsecondsSinceEpoch;
    final randomInt = random.nextInt(99999); // Change the range as per your requirement
   // return '$timestamp-$randomInt';
    return'$randomInt';
  }

  Future uploadFiles() async {
    final path = 'before/';
    for (final pickedFile in pickedFile) {
      final file = File(pickedFile.path!);
      final uniqueId = generateShortUniqueId();
      final date = DateTime.now().toString().substring(0, 10); // use current date as part of the filename
      final fileName = '$date-$uniqueId.${pickedFile.extension}'; // use unique ID and date in the filename
      final ref = FirebaseStorage.instance.ref().child(path + fileName);

      setState(() {
        uploadTask = ref.putFile(file);
      });

      final snapshot = await uploadTask!.whenComplete(() {});
      final urlDownload = await snapshot.ref.getDownloadURL();
      print('Download Link: $urlDownload');
    }

    setState(() {
      pickedFile.clear();
      uploadTask = null;
    });
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result == null) return;
    setState(() {
      pickedFile = result.files.toList();
    });
  }

  Widget buildProgress() => StreamBuilder<TaskSnapshot>(
    stream: uploadTask?.snapshotEvents,
    builder: (context, snapshot) {
      if (snapshot.data == null) return Container();
      final data = snapshot.data!;
      final double progress = data.bytesTransferred / data.totalBytes;

      if (progress == 1.0) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () {
                //Handle button pressed when progress is 100%
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ForgotPassword()),
                );
              },
              child: const Text('Successful. Back to report'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
            ),
            SizedBox(height: 16),
          ],
        );
      }

      return SizedBox(
        height: 50,
        child: Stack(
          fit: StackFit.expand,
          children: [
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey,
              color: Colors.green,
            ),
            Center(
              child: Text(
                '${(100 * progress).roundToDouble()}%',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      );
    },
  );

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Upload Photo'),
      backgroundColor: Color(0xff091647),),
  body: Center(
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      if (pickedFile != null && pickedFile!.isNotEmpty)
        Expanded(
          child: ListView.builder(
            itemCount: pickedFile!.length,
            itemBuilder: (context, index) => Container(
              color: Colors.blue[100],
              margin: EdgeInsets.all(8),
              child: Center(
                child: Image.file(
                  File(pickedFile![index].path!),
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),

      const SizedBox (height: 32),
      ElevatedButton(
        child: const Text('Select Photos'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xff091647),
        ),
        onPressed: selectFile,
      ),
      const SizedBox(height: 32),
      ElevatedButton(
        child: const Text(' Upload Files '),
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xff091647),
        ),
        onPressed: uploadFiles,
      ),

      const SizedBox(height :32),
      buildProgress(),
  ],
  ),
  ),
  );
}
