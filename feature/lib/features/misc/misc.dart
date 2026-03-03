import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class FullScreenShimmerEffect extends StatelessWidget {
  const FullScreenShimmerEffect({Key? key}) : super(key: key);
  //
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        itemCount: 15, // Adjust the count based on your needs
        itemBuilder: (context, index) {
          return ListTile(
            title: Container(
              height: 20,
              width: 200,
              color: Colors.white,
            ),
          );
        },
      ),
    );
  }
}