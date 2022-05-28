import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:rechner_begrenztes_wachstum/main.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = "/homeScreen";

  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appInfo.title),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline),
            tooltip: "Appinformationen anzeigen",
            onPressed: () {
              showAboutDialog(
                context: context,
                applicationLegalese: "(C) 2021 Justus Seeck",
                applicationVersion: appInfo.version.toString(),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.code_outlined),
            tooltip: "Source Code auf Github ansehen",
            onPressed: () async {
              String _url = "https://github.com/AstragoEdu/calculator_for_limited_groth";
              if (await canLaunch(_url)) {
                launch(_url);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("URL kann nich geöffnet werden."),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: HomePage(),
    );
  }
}

class FieldData {
  dynamic anfangswert;
  dynamic grenze;
  dynamic prozentsatz;
  dynamic durchlaeufe;

  void convert() {
    if (anfangswert == null ||
        anfangswert == "" ||
        grenze == null ||
        grenze == "" ||
        prozentsatz == null ||
        prozentsatz == "" ||
        durchlaeufe == null ||
        durchlaeufe == "") {
      print(
          "startwert: ${this.anfangswert}; grenze: ${this.grenze}; prozentsatz: ${this.prozentsatz}; durchlaeufe: ${this.durchlaeufe}");
    } else {
      anfangswert = anfangswert.toString();
      grenze = grenze.toString();
      prozentsatz = prozentsatz.toString();
      durchlaeufe = durchlaeufe.toString();

      anfangswert = anfangswert.replaceAll(",", ".");
      grenze = grenze.replaceAll(",", ".");
      prozentsatz = prozentsatz.replaceAll(",", ".");

      anfangswert = double.parse(anfangswert);
      grenze = double.parse(grenze);
      prozentsatz = double.parse(prozentsatz);
      durchlaeufe = int.parse(durchlaeufe);
    }
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  TabController? tabController;
  double minY = 0;
  double maxY = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    // tabController.addListener(() { });
  }

  FieldData fieldData = FieldData();

  List results = [];
  int i = 0;
  double? ergebnis;

  void calculateBTN() {
    fieldData.convert();

    if (fieldData.durchlaeufe > 1000) {
      fieldData.durchlaeufe = 1000;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text("Es werden aus technischen Gründen nicht mehr als 1000 Durchläufe ausgeführt."),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }

    if (fieldData.anfangswert == null ||
        fieldData.anfangswert == "" ||
        fieldData.grenze == null ||
        fieldData.grenze == "" ||
        fieldData.prozentsatz == null ||
        fieldData.prozentsatz == "" ||
        fieldData.durchlaeufe == null ||
        fieldData.durchlaeufe == "") {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Bitte fülle alle Felder aus."),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      results.clear();
      i = 0;
      results.add(fieldData.anfangswert);
      calculateResults(fieldData.anfangswert);
    }

    minY = results[0];
    for (double d in results) {
      if (d < minY) {
        setState(() {
          minY = d;
        });
      }
    }

    maxY = results[0];
    for (double d in results) {
      if (d > maxY) {
        setState(() {
          maxY = d;
        });
      }
    }

    if (maxY < fieldData.grenze) maxY = fieldData.grenze;

    setState(() {
      fieldData.anfangswert = fieldData.anfangswert;
      fieldData.grenze = fieldData.grenze;
      fieldData.prozentsatz = fieldData.prozentsatz;
      fieldData.durchlaeufe = fieldData.durchlaeufe;
    });
  }

  void calculateResults(double vorheriges) {
    i++;

    // FORMULA (vorheriges = ergebnis der vorherigen Berechnung)
    ergebnis = vorheriges + (fieldData.grenze - vorheriges) * fieldData.prozentsatz;

    // print(i.toString() + ":  " + ergebnis.toString());
    setState(() {
      results.add(ergebnis);
    });
    if (i < fieldData.durchlaeufe) {
      calculateResults(ergebnis!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      // decoration: BoxDecoration(
      //   gradient: RadialGradient(
      //     radius: 0.4,
      //     colors: [
      //       Color(0xff8E2DE2),
      //       // Color(0xff4A00E0),
      //       Colors.black,
      //     ],
      //   ),
      // ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //FORMELANZEIGE
            Text(
              "Formeln:",
              style: Theme.of(context).textTheme.headline4,
            ),
            DefaultTextStyle(
              style: Theme.of(context).textTheme.headline5!,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      child: Container(
                        margin: EdgeInsets.all(8),
                        child: Text(
                          "f(t) = (1-q) \u22C5 f(t-1) + Gq",
                          style: Theme.of(context).textTheme.headline5!,
                        ),
                      ),
                    ),
                    Card(
                      child: Container(
                        margin: EdgeInsets.all(8),
                        child: Text(
                          "f(t) = f(t-1) + (G-f(t-1)) \u22C5 q",
                          style: Theme.of(context).textTheme.headline5!,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // EINGABEBEREICH
            Container(height: 30),
            // Grenze + Prozentsatz
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Grenze
                Flexible(
                  flex: 1,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 30),
                    child: ConstrainedBox(
                      constraints:
                          BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 1.1),
                      child: Form(
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          onChanged: (text) {
                            setState(() {
                              fieldData.grenze = text;
                            });
                          },
                          autocorrect: false,
                          decoration: InputDecoration(
                            labelText: "Grenze (G)",
                            border: OutlineInputBorder(),
                          ),
                          inputFormatters: [
                            // FilteringTextInputFormatter.allow(
                            //   RegExp(r"[\d*\,?\d*$/]"),
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                // Prozentsatz
                Flexible(
                  flex: 1,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 30),
                    child: ConstrainedBox(
                      constraints:
                          BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 1.1),
                      child: Form(
                        child: TextField(
                          keyboardType: TextInputType.number,
                          onChanged: (text) {
                            setState(() {
                              fieldData.prozentsatz = text;
                            });
                          },
                          autocorrect: false,
                          decoration: InputDecoration(
                            labelText: "Prozentsatz (q)",
                            border: OutlineInputBorder(),
                          ),
                          inputFormatters: [
                            // FilteringTextInputFormatter.allow(
                            //   RegExp(r"[\d*\,?\d*$/]"),
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(height: 15),
            // Anfangswert + Durchläufe
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Anfangswert
                Flexible(
                  flex: 1,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 30),
                    child: ConstrainedBox(
                      constraints:
                          BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 1.1),
                      child: Form(
                        child: TextField(
                          keyboardType: TextInputType.number,
                          onChanged: (text) {
                            setState(() {
                              fieldData.anfangswert = text;
                            });
                          },
                          autocorrect: false,
                          decoration: InputDecoration(
                            labelText: "Anfangswert",
                            border: OutlineInputBorder(),
                          ),
                          inputFormatters: [
                            // FilteringTextInputFormatter.allow(
                            //   RegExp(r"[\d*\,?\d*$/]"),
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                // Durchläufe
                Flexible(
                  flex: 1,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 30),
                    child: ConstrainedBox(
                      constraints:
                          BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 1.1),
                      child: Form(
                        child: TextField(
                          keyboardType: TextInputType.number,
                          onChanged: (text) {
                            fieldData.durchlaeufe = int.parse(text);
                          },
                          autocorrect: false,
                          decoration: InputDecoration(
                            labelText: "Durchläufe",
                            border: OutlineInputBorder(),
                          ),
                          // inputFormatters: [
                          //   FilteringTextInputFormatter.digitsOnly,
                          // ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(height: 25),
            // BUTTON
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30),
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: double.infinity),
                child: ElevatedButton.icon(
                  onPressed: () {
                    calculateBTN();
                  },
                  icon: Icon(Icons.calculate),
                  label: Text("Berechnen"),
                ),
              ),
            ),
            Container(height: 20),
            // TABS
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30),
              // color: Colors.grey[900],
              color: Colors.indigo,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 600),
                child: DefaultTabController(
                  length: 2,
                  child: TabBar(
                    controller: tabController,
                    tabs: [
                      Tab(icon: Icon(Icons.table_chart), child: Text("Tabelle")),
                      Tab(icon: Icon(Icons.stacked_line_chart), child: Text("Graph")),
                    ],
                  ),
                ),
              ),
            ),

            Container(
              margin: EdgeInsets.symmetric(horizontal: 30),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 520),
                child: TabBarView(
                  controller: tabController,
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          DataTable(
                            columns: [
                              DataColumn(
                                label: Text("Durchlauf"),
                                numeric: true,
                              ),
                              DataColumn(
                                label: Text("Ergebnis"),
                                numeric: true,
                              ),
                            ],
                            rows: List.generate(
                              results.length,
                              (index) => DataRow(
                                cells: [
                                  DataCell(Text(index.toString())),
                                  DataCell(Text(results[index].toString())),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(height: 20),
                          Container(
                            height: 500,
                            width: 800,
                            child: Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32),
                              ),
                              // color: Color(0xff020227),
                              color: Colors.white,
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(0, 16, 40, 0),
                                child: LineChart(
                                  LineChartData(
                                    lineTouchData: LineTouchData(
                                      touchTooltipData: LineTouchTooltipData(
                                        fitInsideVertically: true,
                                        fitInsideHorizontally: true,
                                      ),
                                    ),
                                    minX: 0,
                                    maxX: fieldData.durchlaeufe,
                                    minY: minY,
                                    maxY: maxY,
                                    lineBarsData: [
                                      LineChartBarData(
                                        isCurved: true,
                                        spots: (results.length != 0)
                                            ? List.generate(
                                                results.length,
                                                (index) => FlSpot(
                                                    double.parse(index.toString()), results[index]),
                                              ).toList()
                                            // : List.generate(
                                            //     5,
                                            //     (index) => FlSpot(double.parse(index.toString()),
                                            //         double.parse(index.toString())),
                                            //   ).toList(),
                                            : [
                                                FlSpot(0, 0),
                                              ],
                                      ),
                                      LineChartBarData(
                                        isCurved: false,
                                        spots: (results.length != 0)
                                            ? [
                                                FlSpot(0, fieldData.grenze),
                                                FlSpot(fieldData.durchlaeufe, fieldData.grenze),
                                              ]
                                            : [
                                                FlSpot(0, 0),
                                              ],
                                        colors: [
                                          Colors.green,
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
