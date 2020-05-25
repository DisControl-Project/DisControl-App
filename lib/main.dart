import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:firebase_database/firebase_database.dart';
import 'Teclado.dart';
import 'iconos_icons.dart';

final FirebaseDatabase database = FirebaseDatabase();
// Definimos que usuario hace la conexion(falta por implementar)
DatabaseReference itemRef = database.reference().child('usuario');

void main() {

  runApp(MaterialApp(

    title: 'Navigation Basics',
    home: MyApp(),

  ));
  itemRef.child('texto').update({
    'texto' : ""
  });
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

                    // LLamamos a la clase "TouchControl"
                    // Mostramos el panel en el donde ejecutaremos la función de mover el ratón
                      child: new TouchControl()

                  ),
                ),
                Container(

                    child: new Row (

                      children: <Widget>[

                        Expanded(

                          flex: 1,

                          // Botón click izquierdo
                          child: new IconButton(

                            color: Colors.black,
                            icon: Icon(Iconos.mouse_left_button),

                            // Al hacer click actualizamos Firebase con un "true", luego vuelve a "false"
                            onPressed: () {

                              itemRef.child('clicks').update({
                                'clickL' : "true"
                              });

                              itemRef.child('clicks').update({
                                'clickL' : "false"
                              });

                              },
                            // Metodo que se usa al mantener pulsado el botón
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

                            // Botón click izquierdo
                            child: new IconButton(

                              color: Colors.black,
                              icon: Icon(Iconos.mouse_right_button),

                              // Al hacer click actualizamos Firebase con un "true", luego vuelve a "false"
                              onPressed: () {
                                itemRef.child('clicks').update({
                                  'clickR' : "true"
                                });
                                itemRef.child('clicks').update({
                                  'clickR' : "false"
                                });

                                },
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

                          // Botón Teclado

                          child: new IconButton(

                            color: Colors.black,
                            icon: new Icon(Icons.keyboard),

                            // Al hacer click navegamos a la ventana "Teclado"
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
// Almacenamos las posiciones del ratón
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

class TouchControlState extends State<TouchControl> {
  double xPos = 0.0;
  double yPos = 0.0;

  // Actualiza la daistancia que se tiene que mover el ratón en el Firebase
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

// Cuando arrastras en el panel, envía la distancia recorrida al método "onChanged"
  void _handlePanUpdate(DragUpdateDetails details) {
    onChanged(details.delta);
  }

  @override
  Widget build(BuildContext context) {
    return new ConstrainedBox(

      // Define el tamaño del panel
      constraints: new BoxConstraints(

        minWidth: MediaQuery.of(context).size.width,
        maxWidth: MediaQuery.of(context).size.width,
        minHeight: MediaQuery.of(context).size.height * 0.75,
        maxHeight: MediaQuery.of(context).size.height * 0.75,

      ),

      // Detecta el movimiento en el panel y llama al método "_handlePanUpdate"
      child: new GestureDetector(

        behavior: HitTestBehavior.opaque,
        onPanUpdate: _handlePanUpdate,

      ),
    );
  }
}
