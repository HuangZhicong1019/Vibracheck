import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'Braill.dart';
import 'dart:io';
import 'dart:ui';


class EcranTactile extends StatefulWidget {
  const EcranTactile({Key? key}) : super(key: key);

  @override
  _EcranTactileState createState() => _EcranTactileState();
}

void vibration_au_choix(int Puissance) {
  switch (Puissance) {
    case 1:
      Vibrate.feedback(FeedbackType.medium);
      break;
    case 2:
      Vibrate.feedback(FeedbackType.success);
      break;
    case 3:
      Vibrate.feedback(FeedbackType.heavy);
      break;
    case 4:
      Vibrate.feedback(FeedbackType.warning);
      break;
    case 5:
      Vibrate.feedback(FeedbackType.error);
      break;
    default:
  }
}

void vibration_une_lettre(String lettre, int Speed, int Puissance) {
  for (var i = 0; i < 6; i++) {
    var braill_lettre = braill[lettre];
    if (braill_lettre![i] == '1') {
      vibration_au_choix(Puissance);
      sleep(Duration(milliseconds: (11 - Speed) * 100));
      vibration_au_choix(Puissance);
      sleep(Duration(milliseconds: 500 + (11 - Speed) * 100));
    } else {
      vibration_au_choix(Puissance);
      sleep(Duration(milliseconds: 500 + (11 - Speed) * 100));
    }
  }
  ;
}

void vibration_un_point(String point, int Speed, int Puissance) {
  if (point == '1') {
    vibration_au_choix(Puissance);
    sleep(Duration(milliseconds: (11 - Speed) * 100));
    vibration_au_choix(Puissance);
  } else {
    vibration_au_choix(Puissance);
    sleep(Duration(milliseconds: 500 + (11 - Speed) * 100));
  }
}

Icon Icon_Adapte(String lettre, int num, int select) {
  Map Couleur_Point = {
    "0": Color(0xFFFEC9E3),
    "1": Color(0xFFEF5FA7),
  };
  double Size_Point = 85;
  if (num == select) {
    return Icon(
      Icons.check_circle,
      color: Couleur_Point[braill[lettre]![num]],
      size: Size_Point,
    );
  } else {
    return Icon(
      Icons.circle,
      color: Couleur_Point[braill[lettre]![num]],
      size: Size_Point,
    );
  }
}

class _EcranTactileState extends State<EcranTactile> {
  String Text_a_transforme = "Rien pour l'instant!";
  String Lettre_a_vibrer = "Rien pour l'instant!";
  int num_select = 0;
  int taille_mot = 0;
  Map Button_Color = {'0': Colors.blue, '1': Colors.black};
  double size_button = 75;
  double _hight = 0.0; //距顶部的偏移
  double _width = 0.0; //距左边的偏移
  int Point_a_vibrer = 0;

  int Speed = 5;
  int Puissance = 3;

  @override
  Widget build(BuildContext context) {
    Parametre? args = ModalRoute.of(context)!.settings.arguments as Parametre?;
    Text_a_transforme = args!.Text;
    Speed = args.Speed;
    Puissance = args.Puissance;
    print(Text_a_transforme + Speed.toString());
    taille_mot = Text_a_transforme.length;
    Lettre_a_vibrer = Text_a_transforme[num_select];

    return Scaffold(
        appBar: AppBar(
          title: Text("Ecran Tactile"),
        ),
        body: Stack(
          children: [
            Flex(
              direction: Axis.vertical,
              children: [
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    child: Container(
                        color: Color(0xFFFDEEC8),
                        child: Container(
                          padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                          child: Center(
                            child: Column(
                              children: [
                                Container(
                                  height: 500,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                          top: 50,
                                          left: 70,
                                          child: Icon_Adapte(Lettre_a_vibrer, 0,
                                              Point_a_vibrer)),
                                      Positioned(
                                          top: 50,
                                          right: 70,
                                          child: Icon_Adapte(Lettre_a_vibrer, 3,
                                              Point_a_vibrer)),
                                      Positioned(
                                          top: 200,
                                          left: 70,
                                          child: Icon_Adapte(Lettre_a_vibrer, 1,
                                              Point_a_vibrer)),
                                      Positioned(
                                          top: 200,
                                          right: 70,
                                          child: Icon_Adapte(Lettre_a_vibrer, 4,
                                              Point_a_vibrer)),
                                      Positioned(
                                          top: 350,
                                          left: 70,
                                          child: Icon_Adapte(Lettre_a_vibrer, 2,
                                              Point_a_vibrer)),
                                      Positioned(
                                          top: 350,
                                          right: 70,
                                          child: Icon_Adapte(Lettre_a_vibrer, 5,
                                              Point_a_vibrer)),
                                    ],
                                  ),
                                ),
                                Spacer(
                                  flex: 1,
                                ),
                                Text(
                                  "Le mot à transformer : " + Text_a_transforme,
                                  textScaleFactor: 1.5,
                                ),
                                Text(
                                  "La vibration pour la lettre : " +
                                      Lettre_a_vibrer,
                                  textScaleFactor: 1.5,
                                ),
                                Text(
                                  "La vibration pour le point : " +
                                      (Point_a_vibrer + 1).toString(),
                                  textScaleFactor: 1.5,
                                ),
                                Spacer(
                                  flex: 3,
                                ),
                              ],
                            ),
                          ),
                        )),
                    onTap: () => {
                      vibration_un_point(
                          braill[Lettre_a_vibrer]![Point_a_vibrer],
                          Speed,
                          Puissance)
                    },
                    onDoubleTap: () {
                      setState(() {
                        print("La lettre à vibrer : $Lettre_a_vibrer");
                        vibration_une_lettre(Lettre_a_vibrer, Speed, Puissance);
                      });
                    },
                    onVerticalDragStart: (DragStartDetails details) => {
                      print("用户手指按下：${details.globalPosition}"),
                      setState(() {
                        _hight = 0.0; //初始化垂直偏移
                      })
                    },
                    onVerticalDragUpdate: (DragUpdateDetails details) => {
                      setState(() {
                        _hight += details.delta.dy;
                      })
                    },
                    onVerticalDragEnd: (DragEndDetails details) => {
                      print("垂直偏移量为：${_hight}"),
                      if (_hight > 0)
                        {
                          setState(() {
                            print("La lettre à vibrer : $Lettre_a_vibrer");
                            if (Point_a_vibrer < 5) {
                              Point_a_vibrer++;
                            } else {
                              Point_a_vibrer = 0;
                            }
                          })
                        }
                      else
                        {
                          setState(() {
                            print("La lettre à vibrer : $Lettre_a_vibrer");
                            if (Point_a_vibrer > 0) {
                              Point_a_vibrer--;
                            } else {
                              Point_a_vibrer = 5;
                            }
                          })
                        }
                    },
                    onHorizontalDragStart: (DragStartDetails details) => {
                      print("用户手指按下：${details.globalPosition}"),
                      setState(() {
                        _width = 0.0; //初始化垂直偏移
                      })
                    },
                    onHorizontalDragUpdate: (DragUpdateDetails details) => {
                      setState(() {
                        _width += details.delta.dx;
                      })
                    },
                    onHorizontalDragEnd: (DragEndDetails details) => {
                      print("水平偏移量为：${_width}"),
                      if (_width > 0)
                        {
                          setState(() {
                            print("La lettre à vibrer : $Lettre_a_vibrer");
                            print("La taille du mot : $taille_mot");
                            if (num_select < taille_mot - 1) {
                              num_select++;
                            } else {
                              num_select = 0;
                            }
                            Lettre_a_vibrer = Text_a_transforme[num_select];
                            Point_a_vibrer =
                            0; //Initialisation du point à vibrer
                          })
                        }
                      else
                        {
                          setState(() {
                            print("La lettre à vibrer : $Lettre_a_vibrer");
                            print("La taille du mot : $taille_mot");
                            if (num_select > 0) {
                              num_select--;
                            } else {
                              num_select = taille_mot - 1;
                            }
                            ;
                            Lettre_a_vibrer = Text_a_transforme[num_select];
                            Point_a_vibrer =
                            0; //Initialisation du point à vibrer
                          })
                        }
                    },
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}

class Parametre {
  String Text;
  int Speed;
  int Puissance;
  Parametre(this.Text, this.Speed, this.Puissance);
}
