import 'dart:async';
import 'dart:convert';

import 'dart:io';
import 'dart:math';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:dio/dio.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

final formatCurrency =
    NumberFormat.currency(locale: 'eu', name: 'NGN', symbol: "");
var response = "rr";
void main() {
  //WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Color(0xff33415c),
  ));
  runApp(const MyApp());
  FlutterDisplayMode.setHighRefreshRate();
}

icheck() async {
  bool result2 = await InternetConnection().hasInternetAccess;
  if (result2 == true) {
    return "true";
  } else {
    return "false";
  }
}

TextEditingController message = TextEditingController();
TextEditingController myController = TextEditingController();
final TextEditingController Input = TextEditingController();
var Output = TextEditingController();
var controller = TextEditingController();
var controllerrate = TextEditingController();
String currensies =
    "EUR=1.0000, USD=1.0597, GBP=0.87213, SEK=11.634, NOK=11.681, CHF=0.9442, JPY=158.80, CNY=7.7489, AUD=1.6772, RUB=98.970";
var list = [
  "EUR Euro",
  "USD US dollar",
  "GBP Pound sterling",
  "SEK Swedish krona",
  "NOK Norweigian krone",
  "CHF Swiss franc",
  "JPY Japanese yen",
  "CNY Chinese yuan",
  "AUD Australian dollar"
];

Map<String, String> currensies3 = <String, String>{
  "🇪🇺 EUR Euro": "🇪🇺 EUR",
  "🇺🇸 USD US Dollar": "🇺🇸 USD",
  "🇬🇧 GBP Pound Sterling": "🇬🇧 GBP",
  "🇸🇪 SEK Swedish krona": "🇸🇪 SEK",
  "🇳🇴 NOK Norweigian krone": "🇳🇴 NOK",
  "🇨🇭 CHF Swiss franc": "🇨🇭 CHF",
  "🇯🇵 JPY Japanese yen": "🇯🇵 JPY",
  "🇨🇳 CNY Chinese yuan": "🇨🇳 CNY",
  "🇦🇺 AUD Australian dollar": "🇦🇺 AUD",
  "🇷🇺 RUB Russian ruble": "🇷🇺 RUB"
};

var inputcurrency = "🇪🇺 EUR Euro";
var outputcurrency = "🇺🇸 USD US Dollar";

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
          canvasColor: Color(0xffFFFFFF),
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          useMaterial3: true,
          hintColor: Colors.white,
          textSelectionTheme:
              TextSelectionThemeData(selectionHandleColor: Colors.black54)),
      home: const MyHomePage(title: 'Currency Converter'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;
  static String test7 = "jsd";
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  InternetStatus? _connectionStatus;
  late StreamSubscription<InternetStatus> _subscription;

  final listener =
      InternetConnection().onStatusChange.listen((InternetStatus status) {
    switch (status) {
      case InternetStatus.connected:
        break;
      case InternetStatus.disconnected:
        break;
    }
  });

  @override
  void initState() {
    super.initState();

    _subscription = InternetConnection().onStatusChange.listen((status) {
      setState(() {
        _connectionStatus = status;
        if (_connectionStatus == InternetStatus.connected) {
          message.text = "Online";
          request();
          Future.delayed(const Duration(milliseconds: 1000), () {
            setState(() {
              ratecalc();
            });
          });
        } else {
          message.text =
              "No internet connection: Exchange rates not up to date";
          ratecalc2();
          ;
        }
      });
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xff33415c),
                  Color(0xff33415c),
                ]),
          ),
          child: Column(children: [
            Column(children: [
              SizedBox(height: 35),
              //Text(_connectionStatus?.toString() ?? 'Unknown'),

              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: 10),
                      Text("CURRENCY",
                          style: TextStyle(fontSize: 40, color: Colors.black)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: 10),
                      Container(
                        transform: Matrix4.translationValues(0.0, -20.0, 0.0),
                        child: Text("Converter",
                            style:
                                TextStyle(fontSize: 30, color: Colors.white54)),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 50,
                  )
                ],
              ),

              SizedBox(height: 60),
              PhysicalModel(
                borderRadius: BorderRadius.all(Radius.circular(50)),
                color: Colors.black12,
                elevation: 20,
                child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.black),
                        color: Color(0xff5c677d)),
                    height: 380,
                    width: 300,
                    child: Column(
                      children: [
                        Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(width: 20, height: 20),
                              SizedBox(height: 15),
                              Container(
                                  width: 240,
                                  height: 50,
                                  child: TextField(
                                    cursorColor: Colors.black,
                                    keyboardType:
                                        TextInputType.numberWithOptions(
                                            decimal: true),
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'^(\d+)?\,?\d{0,2}'))
                                    ],
                                    controller: Input,
                                    decoration: const InputDecoration(
                                        fillColor: Color(0xffFFFFFF),
                                        filled: true,
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15.0)),
                                          borderSide:
                                              BorderSide(color: Colors.black),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15.0)),
                                          borderSide:
                                              BorderSide(color: Colors.black),
                                        ),
                                        labelText: 'Enter Amount',
                                        hintStyle:
                                            TextStyle(color: Colors.white),
                                        labelStyle: TextStyle(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 20,
                                            color: Colors.black54),
                                        floatingLabelStyle: TextStyle(
                                            fontWeight: FontWeight.w300,
                                            color: Colors.black),
                                        contentPadding: EdgeInsets.all(11)),
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w300),
                                    onChanged: (value) {
                                      if (_connectionStatus ==
                                          InternetStatus.connected) {
                                        calc();
                                        setState(() {});
                                      } else {
                                        calc2();
                                        setState(() {});
                                      }
                                    },
                                  )),
                              SizedBox(width: 20, height: 20),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 4),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton2<String>(
                                    //isExpanded: true,
                                    buttonStyleData: ButtonStyleData(
                                      height: 50,
                                      width: 150,
                                      padding: const EdgeInsets.only(
                                          left: 14, right: 14),
                                      decoration: BoxDecoration(
                                        color: Color(0xff979dac),
                                        borderRadius: BorderRadius.circular(14),
                                        border: Border.all(
                                          color: Colors.black,
                                        ),
                                        //color: Colors.redAccent,
                                      ),
                                      elevation: 9,
                                    ),
                                    //borderRadius: BorderRadius.circular(10.0),
                                    value: inputcurrency,
                                    //icon: const Icon(Icons.arrow_drop_down),
                                    iconStyleData: const IconStyleData(
                                      icon: Icon(
                                        Icons.arrow_drop_down,
                                      ),
                                      iconSize: 20,
                                    ),
                                    dropdownStyleData: DropdownStyleData(
                                      maxHeight: 300,
                                      width: 250,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: Color(0xff979dac),
                                      ),
                                      offset: const Offset(-20, 0),
                                      scrollbarTheme: ScrollbarThemeData(
                                        radius: const Radius.circular(40),
                                        thickness:
                                            MaterialStateProperty.all<double>(
                                                6),
                                        thumbVisibility:
                                            MaterialStateProperty.all<bool>(
                                                true),
                                      ),
                                    ),

                                    hint: const Text(
                                      "currency",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w300),
                                    ),
                                    //elevation: 16,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w300),
                                    onChanged: (String? value) {
                                      if (_connectionStatus ==
                                          InternetStatus.connected) {
                                        setState(() {
                                          inputcurrency = value!;
                                          calc();
                                        });
                                      } else {
                                        setState(() {
                                          inputcurrency = value!;
                                          calc2();
                                        });
                                      }
                                    },
                                    selectedItemBuilder:
                                        (BuildContext context) {
                                      return currensies3.values
                                          .map<Widget>((String item) {
                                        // This is the widget that will be shown when you select an item.
                                        // Here custom text style, alignment and layout size can be applied
                                        // to selected item string.
                                        return Container(
                                          alignment: Alignment.centerLeft,
                                          constraints: const BoxConstraints(
                                              minWidth: 100),
                                          child: Text(
                                            item,
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w200),
                                          ),
                                        );
                                      }).toList();
                                    },
                                    items: currensies3.keys
                                        .map<DropdownMenuItem<String>>(
                                            (String item) {
                                      return DropdownMenuItem<String>(
                                        value: item,
                                        child: Container(
                                          //height:10,
                                          width: 400,
                                          child: Text(item),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ]),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(width: 0),
                            IconButton(
                              icon: Image.asset('assets/images/updown.png'),
                              iconSize: 10,
                              onPressed: () {
                                HapticFeedback.heavyImpact();
                                if (_connectionStatus ==
                                    InternetStatus.connected) {
                                  setState(() {
                                    change();
                                  });
                                } else {
                                  setState(() {
                                    change2();
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                        Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(width: 20),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton2<String>(
                                    //isExpanded: true,
                                    buttonStyleData: ButtonStyleData(
                                      height: 50,
                                      width: 150,
                                      padding: const EdgeInsets.only(
                                          left: 14, right: 14),
                                      decoration: BoxDecoration(
                                        color: Color(0xff979dac),
                                        borderRadius: BorderRadius.circular(14),
                                        border: Border.all(
                                          color: Colors.black,
                                        ),
                                        //color: Colors.redAccent,
                                      ),
                                      elevation: 9,
                                    ),
                                    //borderRadius: BorderRadius.circular(10.0),
                                    value: outputcurrency,
                                    //icon: const Icon(Icons.arrow_drop_down),
                                    iconStyleData: const IconStyleData(
                                      icon: Icon(
                                        Icons.arrow_drop_down,
                                      ),
                                      iconSize: 20,
                                    ),
                                    dropdownStyleData: DropdownStyleData(
                                      maxHeight: 300,
                                      width: 250,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(14),
                                        color: Color(0xff979dac),
                                      ),
                                      offset: const Offset(-20, 0),
                                      scrollbarTheme: ScrollbarThemeData(
                                        radius: const Radius.circular(40),
                                        thickness:
                                            MaterialStateProperty.all<double>(
                                                6),
                                        thumbVisibility:
                                            MaterialStateProperty.all<bool>(
                                                true),
                                      ),
                                    ),

                                    hint: const Text(
                                      "currency",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w300),
                                    ),
                                    //elevation: 16,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w300),
                                    onChanged: (String? value) {
                                      if (_connectionStatus ==
                                          InternetStatus.connected) {
                                        setState(() {
                                          outputcurrency = value!;
                                          calc();
                                        });
                                      } else {
                                        setState(() {
                                          outputcurrency = value!;
                                          calc2();
                                        });
                                      }
                                    },
                                    selectedItemBuilder:
                                        (BuildContext context) {
                                      return currensies3.values
                                          .map<Widget>((String item) {
                                        // This is the widget that will be shown when you select an item.
                                        // Here custom text style, alignment and layout size can be applied
                                        // to selected item string.
                                        return Container(
                                          alignment: Alignment.centerLeft,
                                          constraints: const BoxConstraints(
                                              minWidth: 100),
                                          child: Text(
                                            item,
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w200),
                                          ),
                                        );
                                      }).toList();
                                    },
                                    items: currensies3.keys
                                        .map<DropdownMenuItem<String>>(
                                            (String item) {
                                      return DropdownMenuItem<String>(
                                        value: item,
                                        child: Container(
                                          //height:10,
                                          width: 400,
                                          child: Text(item),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              SizedBox(
                                  width: 240,
                                  height: 50,
                                  child: TextField(
                                    enabled: false,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    controller: Output,
                                    decoration: const InputDecoration(
                                        fillColor: Color(0xffFFFFFF),
                                        filled: true,
                                        //border: OutlineInputBorder(),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15.0)),
                                            borderSide: BorderSide(
                                                color: Colors.blue,
                                                width: 1.0)),
                                        disabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15.0)),
                                            borderSide: BorderSide(
                                                color: Colors.black,
                                                width: 1.0)),
                                        labelText: 'Conversion',
                                        labelStyle: TextStyle(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 20,
                                            color: Colors.black54),
                                        floatingLabelStyle: TextStyle(
                                            fontWeight: FontWeight.w300,
                                            color: Colors.black),
                                        contentPadding: EdgeInsets.all(11)),
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w300,
                                        color: Colors.black),
                                    onChanged: (value) {
                                      //calc();
                                      setState(() {});
                                    },
                                  )),
                              SizedBox(height: 5),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Exchage rate: "),
                                    Text(controllerrate.text),
                                  ]),
                            ]),
                      ],
                    )),
              ),
              Text(message.text)
            ]),
          ])),
    );
  }
}

void calc() async {
  if (Input.text == "") {
    calc3();
    ratecalc();
  } else {
    if (inputcurrency != outputcurrency) {
      var inputcurrency2 = inputcurrency.substring(5, 8);
      var outputcurrency2 = outputcurrency.substring(5, 8);
      var inputcurrencylower = inputcurrency2.toLowerCase();

      if (inputcurrency2 != "EUR" && outputcurrency2 != "EUR") {
        var response2 = controller.text;
        var response3 = response2.toString();
        //var responseData = json.decode(response2);

        var response4 =
            response3.substring(response3.indexOf("$inputcurrency2") + 1);
        var response5 = response4.substring(54, 92);
        var response6 = response5.replaceAll(new RegExp(r'[^0-9.]'), '');
        var rate1 = double.parse(response6);

        var response7 =
            response3.substring(response3.indexOf("$outputcurrency2") + 1);
        var response8 = response7.substring(54, 90);
        var response9 = response8.replaceAll(new RegExp(r'[^0-9.]'), '');
        var rate2 = double.parse(response9);
        var input2 = Input.text;
        var input3 = input2.replaceAll(',', '.');

        var totalrate = (rate2 / rate1).toStringAsFixed(4);
        controllerrate.text = totalrate;

        var toeuro = double.parse(input2) / rate1;
        var tooutput = toeuro * rate2;
        var tooutput2 = formatCurrency.format(tooutput);
        var answer = tooutput.toStringAsFixed(2);

        Output.text = "$tooutput2 $outputcurrency2";
        //Output.text = response.toString();
        print(inputcurrency2);
      } else if (inputcurrency2 == "EUR" && outputcurrency2 != "EUR") {
        var rate1 = 1.0;

        var response2 = controller.text;
        var response3 = response2.toString();
        //var responseData = json.decode(response2);
        var response7 =
            response3.substring(response3.indexOf("$outputcurrency2") + 1);
        var response8 = response7.substring(54, 90);
        var response9 = response8.replaceAll(new RegExp(r'[^0-9.]'), '');

        var rate2 = double.parse(response9);
        var input2 = Input.text;
        var input3 = input2.replaceAll(',', '.');

        var totalrate = (rate2 / rate1).toStringAsFixed(4);
        controllerrate.text = totalrate;

        var toeuro = double.parse(input3) / rate1;
        var tooutput = toeuro * rate2;

        var tooutput2 = formatCurrency.format(tooutput);
        var answer = tooutput.toStringAsFixed(2);

        Output.text = "$tooutput2 $outputcurrency2";
      } else if (inputcurrency2 != "EUR" && outputcurrency2 == "EUR") {
        var response2 = controller.text;
        var response3 = response2.toString();
        //var responseData = json.decode(response2);

        var response4 =
            response3.substring(response3.indexOf("$inputcurrency2") + 1);
        var response5 = response4.substring(54, 90);
        var response6 = response5.replaceAll(new RegExp(r'[^0-9.]'), '');
        var rate1 = double.parse(response6);

        var rate2 = 1.0;
        var input2 = Input.text;
        var input3 = input2.replaceAll(',', '.');

        var totalrate = (rate2 / rate1).toStringAsFixed(4);
        controllerrate.text = totalrate;

        var toeuro = double.parse(input3) / rate1;
        var tooutput = toeuro * rate2;

        var tooutput2 = formatCurrency.format(tooutput);
        var answer = tooutput.toStringAsFixed(2);

        Output.text = "$tooutput2 $outputcurrency2";
      } else {
        var rate1 = 1.0;
        var rate2 = 1.0;

        var input2 = Input.text;
        var input3 = input2.replaceAll(',', '.');
        var toeuro = double.parse(input3) / rate1;
        var tooutput = toeuro * rate2;
        var tooutput2 = formatCurrency.format(tooutput);

        var answer = tooutput.toStringAsFixed(2);

        Output.text = "$tooutput2 $outputcurrency2";
      }
    } else {
      var outputcurrency2 = outputcurrency.substring(5, 8);
      var Input2 = Input.text;
      Output.text = "$Input2 $outputcurrency2";

      controllerrate.text = 1.0.toString();
    }
  }
}

void calc2() {
  if (Input.text == "") {
    calc3();
    ratecalc2();
  } else {
    var inputcurrency2 = inputcurrency.substring(5, 8);
    var outputcurrency2 = outputcurrency.substring(5, 8);
    var inputcurrencylower = inputcurrency2.toLowerCase();

    var rate1 = currensies.substring(currensies.indexOf("$inputcurrency2") + 1);
    var rate2 = rate1.substring(3, 9);
    var rate3 = double.parse(rate2);

    var rate4 =
        currensies.substring(currensies.indexOf("$outputcurrency2") + 1);
    var rate5 = rate4.substring(3, 9);
    var rate6 = double.parse(rate5);

    var input2 = Input.text;
    var input3 = input2.replaceAll(',', '.');
    var toeuro = double.parse(input3) / rate3;
    var tooutput = toeuro * rate6;
    var tooutput2 = formatCurrency.format(tooutput);

    var totalrate = (rate6 / rate3).toStringAsFixed(4);
    controllerrate.text = totalrate;

    Output.text = "$tooutput2 $outputcurrency2";
  }
}

void calc3() {
  if (inputcurrency != outputcurrency) {
    var inputcurrency2 = inputcurrency.substring(5, 8);
    var outputcurrency2 = outputcurrency.substring(5, 8);
    var inputcurrencylower = inputcurrency2.toLowerCase();

    if (inputcurrency2 != "EUR" && outputcurrency2 != "EUR") {
      var input2 = Input.text;
      var input3 = input2.replaceAll(',', '.');

      //var toeuro = double.parse(input2) / rate1;
      //var tooutput = toeuro * rate2;
      //var tooutput2 = formatCurrency.format(tooutput);
      //var answer = tooutput.toStringAsFixed(2);

      Output.text = "$input3";
      //Output.text = response.toString();
    } else if (inputcurrency2 == "EUR" && outputcurrency2 != "EUR") {
      var input2 = Input.text;
      var input3 = input2.replaceAll(',', '.');

      //var toeuro = double.parse(input3) / rate1;
      //var tooutput = toeuro * rate2;

      //var tooutput2 = formatCurrency.format(tooutput);
      //var answer = tooutput.toStringAsFixed(2);

      Output.text = "$input3";
    } else if (inputcurrency2 != "EUR" && outputcurrency2 == "EUR") {
      //var responseData = json.decode(response2);

      var input2 = Input.text;
      var input3 = input2.replaceAll(',', '.');

      //var toeuro = double.parse(input3) / rate1;
      //var tooutput = toeuro * rate2;

      //var tooutput2 = formatCurrency.format(tooutput);
      //var answer = tooutput.toStringAsFixed(2);

      Output.text = "$input3";
    } else {
      var input2 = Input.text;
      var input3 = input2.replaceAll(',', '.');
      //var toeuro = double.parse(input3) / rate1;
      //var tooutput = toeuro * rate2;
      //var tooutput2 = formatCurrency.format(tooutput);

      //var answer = tooutput.toStringAsFixed(2);

      Output.text = "$input3";
    }
  } else {
    Output.text = Input.text;
    controllerrate.text = 1.0.toString();
  }
}

ratecalc() {
  if (inputcurrency != outputcurrency) {
    var inputcurrency2 = inputcurrency.substring(5, 8);
    var outputcurrency2 = outputcurrency.substring(5, 8);
    var inputcurrencylower = inputcurrency2.toLowerCase();

    if (inputcurrency2 != "EUR" && outputcurrency2 != "EUR") {
      var response2 = controller.text;
      var response3 = response2.toString();
      //var responseData = json.decode(response2);

      var response4 =
          response3.substring(response3.indexOf("$inputcurrency2") + 1);
      var response5 = response4.substring(54, 92);
      var response6 = response5.replaceAll(new RegExp(r'[^0-9.]'), '');
      var rate1 = double.parse(response6);

      var response7 =
          response3.substring(response3.indexOf("$outputcurrency2") + 1);
      var response8 = response7.substring(54, 90);
      var response9 = response8.replaceAll(new RegExp(r'[^0-9.]'), '');
      var rate2 = double.parse(response9);

      var totalrate = (rate2 / rate1).toStringAsFixed(4);
      controllerrate.text = totalrate;

      //Output.text = response.toString();
    } else if (inputcurrency2 == "EUR" && outputcurrency2 != "EUR") {
      var rate1 = 1.0;

      var response2 = controller.text;
      var response3 = response2.toString();
      //var responseData = json.decode(response2);
      var response7 =
          response3.substring(response3.indexOf("$outputcurrency2") + 1);
      var response8 = response7.substring(54, 90);
      var response9 = response8.replaceAll(new RegExp(r'[^0-9.]'), '');

      var rate2 = double.parse(response9);

      var totalrate = (rate2 / rate1).toStringAsFixed(4);
      controllerrate.text = totalrate;
    } else if (inputcurrency2 != "EUR" && outputcurrency2 == "EUR") {
      var response2 = controller.text;
      var response3 = response2.toString();
      //var responseData = json.decode(response2);

      var response4 =
          response3.substring(response3.indexOf("$inputcurrency2") + 1);
      var response5 = response4.substring(54, 90);
      var response6 = response5.replaceAll(new RegExp(r'[^0-9.]'), '');
      var rate1 = double.parse(response6);

      var rate2 = 1.0;

      var totalrate = (rate2 / rate1).toStringAsFixed(4);
      controllerrate.text = totalrate;
    } else {
      var rate1 = 1.0;
      var rate2 = 1.0;

      var totalrate = (rate2 / rate1).toStringAsFixed(4);
      controllerrate.text = totalrate;
    }
  } else {
    var outputcurrency2 = outputcurrency.substring(5, 8);

    controllerrate.text = 1.0.toString();
  }
}

ratecalc2() {
  var inputcurrency2 = inputcurrency.substring(5, 8);
  var outputcurrency2 = outputcurrency.substring(5, 8);
  var inputcurrencylower = inputcurrency2.toLowerCase();

  var rate1 = currensies.substring(currensies.indexOf("$inputcurrency2") + 1);
  var rate2 = rate1.substring(3, 9);
  var rate3 = double.parse(rate2);

  var rate4 = currensies.substring(currensies.indexOf("$outputcurrency2") + 1);
  var rate5 = rate4.substring(3, 9);
  var rate6 = double.parse(rate5);

  var totalrate = (rate6 / rate3).toStringAsFixed(4);
  controllerrate.text = totalrate;
}

request() async {
  var url = Uri.parse('http://www.floatrates.com/daily/eur.json');
  http.Response response = await http.get(url);
  controller.text = response.body.toString();
}

void change() {
  var curr = outputcurrency;
  outputcurrency = inputcurrency;
  inputcurrency = curr;
  calc();
}

void change2() {
  var curr = outputcurrency;
  outputcurrency = inputcurrency;
  inputcurrency = curr;

  calc2();
}

//Output.text = response.toString();
