import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'dart:ui';
import 'Ecran_tactile.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zkeah',
      theme: ThemeData(primaryColor: Color(0xFFF8BA00)),
      home: MyHomePage(title: 'Zkeah'),
      routes: {
        "page_écrantactile": (context) => EcranTactile(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _canVibrate = true;
  double SpeedValeur = 5;
  double PuissanceValeur = 3;
  get label => null;
  String texte_field = "";
  String GuideOperation = "Bienvenue dans l'application Vibracheck!\n\n"
      "Sur cette page vous pouvez régler la durée des vibrations et leur intensité grâce aux curseurs ci-dessus.\n\n"
      "Entrez ensuite le mot à lire, puis confirmez le texte.\n\n"
      "Effectuez un appui bref sur l'écran pour lire le premier point braille (deux vibrations si le point est marqué, une seule sinon).\n\n"
      "Pour passer au point braille suivant, balayez vers le bas.\n"
      "Pour revenir au point braille précédent, balayez vers le haut.\n\n"
      "Pour passer au premier point braille de la lettre suivante, balayez à droite.\n"
      "Pour revenir au premier point braille de la lettre précédente, balayez à gauche.\n\n"
      "Pour lire les six points en une seule fois, effectuez un double appui bref sur l'écran.";
  static final TextEditingController text_a_translet = TextEditingController();

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    bool canVibrate = await Vibrate.canVibrate;
    setState(() {
      _canVibrate = canVibrate;
      _canVibrate
          ? debugPrint('This device can vibrate')
          : debugPrint('This device cannot vibrate');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20.0),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                      labelText: "Texte",
                      hintText: "Entrer le texte à transformer!"),
                  autofocus: true,
                  controller: text_a_translet,
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: ElevatedButton(
                    onPressed: () {
                      print("text_a_translet.text = " + text_a_translet.text);
                      print("texte_field = " + texte_field);
                      if (text_a_translet.text == "") {
                        print("text_a_translet.text是空值");
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return new AlertDialog(
                                title: Text("Oups!!"),
                                content: Text("Vous n'avez pas entré de texte!"),
                                actions: [
                                  TextButton(
                                    child: Text("J'ai compris!"),
                                    onPressed: () => Navigator.of(context).pop(),
                                  )
                                ],
                              );
                            });
                      } else {
                        Navigator.of(context).pushNamed(
                          "page_écrantactile",
                          arguments: Parametre(text_a_translet.text,
                              SpeedValeur.toInt(), PuissanceValeur.toInt()),
                        );
                      };
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Color(0xFFF8BA00)),
                    ),
                    child: Text("Confirmer le texte"),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Durée : ",
                    textScaleFactor: 1.3,
                  ),
                ),
                SliderTheme(
                  data: SliderThemeData(
                      activeTrackColor: Color(0xFFFBD8E9),
                      thumbColor: Color(0xFFEF5FA7),
                      inactiveTrackColor: Colors.grey,
                      valueIndicatorColor: Color(0xFFEF5FA7)),
                  child: Slider(
                    min: 1,
                    max: 10,
                    divisions: 9,
                    label: '$SpeedValeur',
                    value: SpeedValeur,
                    onChanged: (data) {
                      setState(() {
                        SpeedValeur = data;
                      });
                    },
                  ),
                ),
                Container(
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Intensité : ",
                      textScaleFactor: 1.3,
                    )),
                SliderTheme(
                  data: SliderThemeData(
                      activeTrackColor: Color(0xFFFBD8E9),
                      thumbColor: Color(0xFFEF5FA7),
                      inactiveTrackColor: Colors.grey,
                      valueIndicatorColor: Color(0xFFEF5FA7)),
                  child: Slider(
                    min: 1,
                    max: 5,
                    divisions: 4,
                    label: '$PuissanceValeur',
                    value: PuissanceValeur,
                    onChanged: (data) {
                      setState(() {
                        PuissanceValeur = data;
                      });
                    },
                  ),
                ),
                Container(
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                    alignment: Alignment.topLeft,
                    child: Text(
                      GuideOperation,
                      textScaleFactor: 1.3,
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
