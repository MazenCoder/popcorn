import 'package:flutter/material.dart';

class SuccessScreen extends StatelessWidget {

  SuccessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(
              Icons.tag_faces,
              size: 150,
            ),
            const SizedBox(height: 10),
            Text(
              'Success',
              style: Theme.of(context).textTheme.bodyText1?.copyWith(fontSize: 45),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
