// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

/// A basic digital clock.
///
/// You can do better than this!
class MavyaClock extends StatefulWidget {
  const MavyaClock(this.model);

  final ClockModel model;

  @override
  _MavyaClockState createState() => _MavyaClockState();
}

class _MavyaClockState extends State<MavyaClock> {
  DateTime _dateTime = DateTime.now();
  Timer _timer;

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(MavyaClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    widget.model.dispose();
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      // Cause the clock to rebuild when the model changes.
    });
  }

  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();
      // Update once per minute. If you want to update every second, use the
      // following code.
//      _timer = Timer(
//        Duration(minutes: 1) -
//            Duration(seconds: _dateTime.second) -
//            Duration(milliseconds: _dateTime.millisecond),
//        _updateTime,
//      );
      // Update once per second, but make sure to do it at the beginning of each
      // new second, so that the clock is accurate.
       _timer = Timer(
         Duration(seconds: 1) - Duration(milliseconds: _dateTime.millisecond),
         _updateTime,
       );
    });
  }

  @override
  Widget build(BuildContext context) {
    final hour =
        DateFormat(widget.model.is24HourFormat ? 'HH' : 'hh').format(_dateTime);
    final minute = DateFormat('mm').format(_dateTime);
    final seconds = DateFormat('ss').format(_dateTime);
    final fontSize = MediaQuery.of(context).size.width / 3.5;
    final offset = -fontSize / 7;
    final Shader linearGradient = LinearGradient(
      colors: <Color>[Color(0xffedf5fe), Color(0xcc01aaaa)],
    ).createShader(Rect.fromLTWH(0.0, 0.0, 250.0, 70.0));

    return Center(
      child: Container(
//        color: const Color(0xFFe0f2f1),
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Text(
              DateFormat('EEEE').format(_dateTime).toUpperCase(),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: GoogleFonts.calistoga(
                textStyle: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    foreground: Paint()..shader = linearGradient),
              ),
            ),
            Container(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    hour,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: GoogleFonts.calistoga(
                      textStyle: TextStyle(
                          fontSize: 80,
                          fontWeight: FontWeight.bold,
                          foreground: Paint()..shader = linearGradient),
                    ),
                  ),
                  Text(
                    ":" + minute,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: GoogleFonts.calistoga(
                      textStyle: TextStyle(
                          fontSize: 80,
                          fontWeight: FontWeight.bold,
                          foreground: Paint()..shader = linearGradient),
                    ),
                  ),
                  Text(
                    ":" + seconds,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: GoogleFonts.calistoga(
                      textStyle: TextStyle(
                          fontSize: 80,
                          fontWeight: FontWeight.bold,
                          foreground: Paint()..shader = linearGradient),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              DateFormat('MMMM   d').format(_dateTime).toUpperCase(),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: GoogleFonts.calistoga(
                textStyle: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    foreground: Paint()..shader = linearGradient),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
