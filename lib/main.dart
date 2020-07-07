import 'dart:convert';
import 'dart:async';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:math';
void main() {
  runApp(MaterialApp(
    title: 'The Quran App',
    theme: ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.red,
    ),
    darkTheme:
    ThemeData(brightness: Brightness.dark, primarySwatch: Colors.red),
    home: QuranApp(),
  ));
}

class QuranApp extends StatefulWidget {
  @override
  _QuranAppState createState() => _QuranAppState();
}

class _QuranAppState extends State<QuranApp>
    with SingleTickerProviderStateMixin {
  String number = "Fetching...."; //
  String quote = "Fetching...."; //
  String tag;
  String quoteTitle="Juz Of The Day";
  AnimationController controller;
  bool randomQuote=true;

  Future<String> fetchQuoteOfTheDay() async {
    quoteTitle="Juz Of The Day";
    Map quoteMap;

    Random random = new Random();
    int juzNumber = random.nextInt(30)+1;
    Response response = await get('http://api.alquran.cloud/v1/juz/$juzNumber/en.asad ');
    /* Response response = await get(
        'https://favqs.com/api/quotes/?filter=${widget.tag}&type=tag',
        headers: {
          'Authorization': 'Token token=3388d212c6f286a19932bf93aae6eb54'
        });*/
    print(response.statusCode);
    if (response.statusCode == 200) {
      quoteMap = jsonDecode(response.body);
    }
    print(quoteMap);
    print(juzNumber);
    print(quoteMap['data']['ayahs'][0]['text']);
    quote = quoteMap['data']['ayahs'][0]['text'];
    number=juzNumber.toString();
    print(quote);

    controller.forward(from: 0.0);

    loading = false;
    setState(() {});
  }
  Future<String> fetchSurahOfTheDay() async {
    quoteTitle="Surah Of The Day";
    String surah;


    Random random = new Random();
    int sura_Number = random.nextInt(114)+1;
    int ayah_Number = random.nextInt(5)+1;
    Response response = await get('http://api.quran-tafseer.com/quran/$sura_Number/$ayah_Number');
    /* Response response = await get(
        'https://favqs.com/api/quotes/?filter=${widget.tag}&type=tag',
        headers: {
          'Authorization': 'Token token=3388d212c6f286a19932bf93aae6eb54'
        });*/
    print(response.statusCode);
    if (response.statusCode == 200) {
       surah = utf8.decode(response.bodyBytes);
    }
    print(surah);
    for(int i=0;i<surah.length;i++){
      if(surah[i]=='t'&& surah[i+1]=='e'&&surah[i+2]=='x' && surah[i+3]=='t'){
       quote='';
        for(int j=i+7;surah[j]!='"';j++){
          quote=quote+surah[j];
        }
        print(quote);
      }
      if(surah[i]=='s'&& surah[i+1]=='u'&&surah[i+2]=='r' && surah[i+3]=='a'){
        number='';
        for(int j=i+12;surah[j]!='"';j++){
          number=number+surah[j];
        }
        print(number);
      }
    }


    controller.forward(from: 0.0);

    loading = false;
    setState(() {});
  }


  @override
  void initState() {
    controller = AnimationController(
        duration: Duration(milliseconds: 1200), vsync: this, value: 0);
    fetchQuoteOfTheDay();
    super.initState();

  }
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.red,
        title: Text(quoteTitle,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
                fontStyle: FontStyle.italic,
                color: Colors.white)),
      ),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text(
                'Holy Quran Quotes',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 35,
                    color: Colors.white,
                    fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,
              ),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: ExactAssetImage('assets/rose-wallpaper.jpg'),
                  fit: BoxFit.cover,
                ),
                color: Colors.red,
              ),
            ),
            Ink(
              color: Colors.pink[100],
              child: ListTile(
                title: Text('Get a Juz Of The Quran',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.red,
                        fontStyle: FontStyle.italic)),
                onTap: () {
                  randomQuote=true;
                  loading = true;
                  setState(() {});
                  fetchQuoteOfTheDay();
                  Navigator.pop(context);
                },
              ),
            ),

            Ink(
              color: Colors.pink[100],
              child: ListTile(
                title: Text('Get a Surah Of The Quran',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.red,
                        fontStyle: FontStyle.italic)),
                onTap: () {
                  randomQuote=true;
                  loading = true;
                  setState(() {});
                  fetchSurahOfTheDay();
                  Navigator.pop(context);
                },
              ),
            ),


          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left:20.0),
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Flexible(
                  flex: 5,
                  child: ScaleTransition(
                    scale: Tween(begin: 0.5, end: 1.0).animate(controller),
                    child: Text(
                      '$quote',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          fontStyle: FontStyle.italic,
                          color: Colors.red,

                          fontFamily: 'Quicksand'),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Flexible(
                  flex: 1,
                  child: ScaleTransition(
                    scale: Tween(begin: 1.5, end: 1.0).animate(controller),
                    child: Text('$number',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            fontStyle: FontStyle.italic,
                            color: Colors.pinkAccent[100])),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Flexible(
                  flex: 1,
                  child: FloatingActionButton(
                    child: AnimatedOpacity(
                      child: loading ?  CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),
                      ) : Icon(
                        Icons.arrow_forward,
                        color: Colors.red,
                        size: 40,
                      ),
                      opacity: (loading) ? 0 : 1,
                      duration: Duration(milliseconds: 2000),
                    ),
                    backgroundColor: Colors.white,
                    onPressed: () {
                      loading = true;
                      setState(() {});
                      fetchQuoteOfTheDay();


                    },
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}