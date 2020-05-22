import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:firebase_database/firebase_database.dart';
import 'Teclado.dart';
import 'iconos_icons.dart';

final FirebaseDatabase database = FirebaseDatabase();
// definimos que usuario hace la conexion
DatabaseReference itemRef = database.reference().child('usuario');
void main() {
  runApp(MaterialApp(
    title: 'Navigation Basics',
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return new MaterialApp(
        title: 'DisControl',
        theme: new ThemeData(
          primarySwatch: Colors.pink,
        ),
        home: new Scaffold(
          appBar: new AppBar(
            title: const Text('DisControL'),
          ),
          body: new Container(
            child: Column(
              children: <Widget>[
                Container(
                  decoration: new BoxDecoration(
                  color: Colors.white,
                  border: new Border.all(
                    color: Colors.black,
                    width: 2.0,
                  ),
                ),
                  child: new Center(
                      child: new TouchControl()
              ),
            ),
                Container(

                    child: new Row (

                      children: <Widget>[

                        Expanded(

                          flex: 1,

                          child: new IconButton(

                            color: Colors.black,
                            icon: Icon(Iconos.mouse_left_button),
                            onPressed: () {

                              itemRef.child('clicks').update({
                                'clickL' : "true"
                              });

                              itemRef.child('clicks').update({
                                'clickL' : "false"
                              });


                              },
//                            onLongPress: () {
//
//                              itemRef.child('clicks').update({
//                                'clickL' : "true"
//                              });
//
//                              },

                          ),

                        ),

                          Expanded(

                            flex: 1,

                            child: new IconButton(
                              color: Colors.black,

                              icon: Icon(Iconos.mouse_right_button),
                              onPressed: () {
                                itemRef.child('clicks').update({
                                  'clickR' : "true"
                                });
                                itemRef.child('clicks').update({
                                  'clickR' : "false"
                                });

                                },
//                            onLongPress: () {
//
//                              itemRef.child('clicks').update({
//                                'clickR' : "true"
//                              });
//
//                              },

                            ),

                          ),
                      ],


                    )

                ),
                Container(

                    child: new Row (
                      children: <Widget>[

                        Expanded(

                          flex: 1,

                          child: new IconButton(

                            color: Colors.black,
                            icon: new Icon(Icons.keyboard),
                            onPressed: () {

                              print("Teclado");
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Teclado()),
                              );

                              },

                          ),

                        ),

                      ],

                    )

                ),

              ]
            ),
          ),
        ),
    );
  }
}

class TouchControl extends StatefulWidget {
  final double xPos;
  final double yPos;
  final ValueChanged<Offset> onChanged;

  const TouchControl({Key key,
    this.onChanged,
    this.xPos:0.0,
    this.yPos:0.0}) : super(key: key);

  @override
  TouchControlState createState() => new TouchControlState();
}

/**
 * Draws a circle at supplied position.
 *
 */

class TouchControlState extends State<TouchControl> {
  double xPos = 0.0;
  double yPos = 0.0;


  void onChanged(Offset offset) {
    if (widget.onChanged != null)
      widget.onChanged(offset);

      xPos = offset.dx;
      yPos = offset.dy;

      print(xPos);
      print(yPos);
      print("-------------");

      itemRef.child('pos').update({
        'y_pos' : yPos, 'x_pos' : xPos
      });





  }


  bool hitTestSelf(Offset position) => true;

  void handleEvent(PointerEvent event, BoxHitTestEntry entry) {
    if (event is PointerDownEvent ) {
      // ??
    }
  }

  void _handlePanStart(DragStartDetails details) {
    print("start");
   // onChanged(details.localPosition);
  }

  void _handlePanEnd(DragEndDetails details) {
    print('end');
    // TODO
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    print("grab");
    onChanged(details.delta);
  }

  @override
  Widget build(BuildContext context) {
    return new ConstrainedBox(
      constraints: new BoxConstraints(
        minWidth: MediaQuery.of(context).size.width,
        maxWidth: MediaQuery.of(context).size.width,
        minHeight: MediaQuery.of(context).size.height * 0.75,
        maxHeight: MediaQuery.of(context).size.height * 0.75,

      ),
      child: new GestureDetector(
        behavior: HitTestBehavior.opaque,
        onPanStart:_handlePanStart,
        onPanEnd: _handlePanEnd,
        onPanUpdate: _handlePanUpdate,
        child: new CustomPaint(
          size: new Size(xPos, yPos),
          painter: new TouchControlPainter(xPos, yPos),
        ),
      ),
    );
  }
}

class TouchControlPainter extends CustomPainter {
  static const markerRadius = 10.0;
  final double xPos;
  final double yPos;

  TouchControlPainter(this.xPos, this.yPos);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = new Paint()
      ..color = Colors.pink
      ..style = PaintingStyle.fill;
  }


  @override
  bool shouldRepaint(TouchControlPainter old) => xPos != old.xPos && yPos !=old.yPos;
}