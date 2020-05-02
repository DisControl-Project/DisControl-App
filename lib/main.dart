import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:firebase_database/firebase_database.dart';

final FirebaseDatabase database = FirebaseDatabase();
// definimos que usuario hace la conexion
DatabaseReference itemRef = database.reference().child('usuario');

void main() {

  runApp(MyApp());
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
        )
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
    final RenderBox referenceBox = context.findRenderObject();
    Offset position = referenceBox.globalToLocal(offset);
   
    if (widget.onChanged != null)
      widget.onChanged(position);

    setState(() {
      xPos = position.dx;
      yPos = position.dy;

      itemRef.child('pos').update({
        'y_pos' : yPos, 'x_pos' : xPos
      });

    });


  }

  bool hitTestSelf(Offset position) => true;

  void handleEvent(PointerEvent event, BoxHitTestEntry entry) {
    if (event is PointerDownEvent ) {
      // ??


    }
  }

  void _handlePanStart(DragStartDetails details) {
    onChanged(details.globalPosition);
  }

  void _handlePanEnd(DragEndDetails details) {
    print('end');
    // TODO
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    onChanged(details.globalPosition);
  }

  @override
  Widget build(BuildContext context) {
    return new ConstrainedBox(
      constraints: new BoxConstraints.expand(),
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

    canvas.drawCircle(new Offset(xPos, yPos), markerRadius, paint);
  }


  @override
  bool shouldRepaint(TouchControlPainter old) => xPos != old.xPos && yPos !=old.yPos;
}