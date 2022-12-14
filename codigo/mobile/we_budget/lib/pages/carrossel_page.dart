import 'package:carousel_images/carousel_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../utils/app_routes.dart';

class CarroselTutorial extends StatefulWidget {
  const CarroselTutorial({super.key});

  @override
  State<CarroselTutorial> createState() => _CarroselTutorialState();
}

class _CarroselTutorialState extends State<CarroselTutorial> {
  final List<String> listImages = [
    'imagens/4.png',
    'imagens/1.png',
    'imagens/2.png',
    'imagens/3.png',
  ];
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          const SizedBox(
            height: 0,
            width: 200,
          ),
          AppBar(
            backgroundColor: Colors.white,
            toolbarHeight: 50,
            elevation: 0,
            flexibleSpace: Container(
              margin: const EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Color(0xFF5B4BF8)),
                    ),
                    child: const Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 27, 0, 0),
                      child: Icon(
                        Icons.close_rounded,
                        color: Colors.white,
                        size: 35,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context)
                          .pushReplacementNamed(AppRoutes.authOrHome);
                    },
                  ),
                ],
              ),
            ),
          ),
          CarouselImages(
            scaleFactor: 0.7,
            listImages: listImages,
            height: MediaQuery.of(context).size.height * 0.89,
            viewportFraction: 1,
            borderRadius: 00.0,
            cachedNetworkImage: true,
            verticalAlignment: Alignment.bottomCenter,
          )
        ],
      ),
    );
  }
}
