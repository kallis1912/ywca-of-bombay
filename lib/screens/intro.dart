import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:ywcaofbombay/widgets/blue_bubble_design.dart';

import '../widgets/constants.dart';
import 'authentication/register.dart';

class Intro extends StatefulWidget {
  @override
  _IntroState createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  final List<String> images = [
    'https://images.unsplash.com/photo-1586882829491-b81178aa622e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2850&q=80',
    'https://images.unsplash.com/photo-1586871608370-4adee64d1794?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2862&q=80',
    'https://images.unsplash.com/photo-1586901533048-0e856dff2c0d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1650&q=80',
    'https://images.unsplash.com/photo-1586902279476-3244d8d18285?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2850&q=80',
    'https://images.unsplash.com/photo-1586943101559-4cdcf86a6f87?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1556&q=80',
    'https://images.unsplash.com/photo-1586951144438-26d4e072b891?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1650&q=80',
    'https://images.unsplash.com/photo-1586953983027-d7508a64f4bb?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1650&q=80',
  ];
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      images.forEach((imageUrl) {
        precacheImage(NetworkImage(imageUrl), context);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    // final _width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: _height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // padding: const EdgeInsets.all(8),
            children: <Widget>[
              // circle design and Appbar
              Stack(
                children: <Widget>[
                  // Positioned(
                  //   child: Image.asset("assets/images/circle-design.png"),
                  // ),
                  DetailPageBlueBubbleDesign(),
                  Positioned(
                    child: AppBar(
                      centerTitle: true,
                      title: Text("YWCA Of Bombay",
                          style: TextStyle(
                              fontFamily: 'LilyScriptOne',
                              fontSize: 24.0,
                              color: Colors.black87)),
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                    ),
                  ),
                ],
              ),
              // TODO: Make the carousel responsive
              CarouselSlider.builder(
                itemCount: images.length,
                options: CarouselOptions(
                  // Changes the size of the carousel
                  //
                  // https://medium.com/flutter-community/flutter-web-getting-started-with-responsive-design-231511ef15d3
                  // https://stackoverflow.com/questions/61207980/create-a-flutter-carousel-slider-with-dynamic-heigth-for-each-page
                  // aspectRatio: 1.4, // This value perfectly fits for Pixel 2
                  // aspectRatio: 0.95, // This value perfectly fits for Redmi 8
                  aspectRatio: 1.1, // This value perfectly fits for Pixel 4XL
                  autoPlay: true,
                  autoPlayCurve: Curves.fastOutSlowIn,
                  autoPlayAnimationDuration: Duration(milliseconds: 700),
                  viewportFraction: 0.8,
                  enlargeCenterPage: true,
                  // height: _height * 0.45, //distorta everything
                ),
                itemBuilder: (context, index, realIdx) {
                  return Container(
                    height: 100,
                    child: Center(
                      child: Image.network(
                        images[index],
                        fit: BoxFit.cover,
                        width: 1000, // No effect on changing value
                      ),
                    ),
                  );
                },
              ),
              Center(
                child: Text(
                  '\"BY LOVE, SERVE ONE ANOTHER\"',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Montserrat',
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 70.0, vertical: 0.0),
                  child: Text(
                    'To empower women at all levels to struggle for justice',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Montserrat',
                      color: Colors.black45,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      // horizontal: _width * 0.35,
                      vertical: _height * 0.015,
                    ),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            firstButtonGradientColor,
                            firstButtonGradientColor,
                            secondButtonGradientColor,
                          ],
                          begin: FractionalOffset.centerLeft,
                          end: FractionalOffset.centerRight,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    child: TextButton(
                      child: Center(
                        child: Text(
                          'LET\'S GO',
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Montserrat',
                            color: Colors.white,
                          ),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => RegisterScreen()));
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
