import 'package:flutter/material.dart';

class NoDataFound extends StatelessWidget {
  const NoDataFound({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Center(
      child: SizedBox(
        height: deviceSize.height * 0.5,
        width: deviceSize.width * 0.5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              'https://st4.depositphotos.com/11574170/40206/v/380/depositphotos_402069102-stock-illustration-delete-vector-flat-color-icon.jpg?forcejpeg=true',
              fit: BoxFit.cover,
            ),
            SizedBox(
              height: deviceSize.height * 0.01,
            ),
            const Text(
              'No data found',
              style: TextStyle(
                fontSize: 20,
                color: Colors.black54,
              ),
            )
          ],
        ),
      ),
    );
  }
}
