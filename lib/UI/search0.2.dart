// ignore_for_file: must_be_immutable

import 'package:awesomeweather/WeatherModals/forcast.dart';
import 'package:awesomeweather/WeatherModals/locations.dart';
import 'package:awesomeweather/weatherRepo.dart';
import 'package:provider/provider.dart';
import 'package:awesomeweather/Bloc/weather_bloc.dart';
import 'package:awesomeweather/Bloc/weather_event.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  Forecast? forecast;
  Location? location;
  SearchPage({Key? key, required this.forecast, required this.location})
      : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final popularCities = [
    'Delhi',
    'Mumbai',
    'Bangalore',
    'Chennai',
    'Dehradun',
    'Punjab',
    'Uttar Pradesh',
    'Los Angeles',
    'Bihar',
    'New York',
    'Las Vegas'
  ];
  List<String> cities = [''];
  final TextEditingController query = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.blueAccent),
        elevation: 0,
        leading: IconButton(
            iconSize: 35,
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.keyboard_arrow_left_rounded)),
        shadowColor: Colors.transparent,
        backgroundColor: Colors.black,
        title: Card(
          color: Colors.cyanAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 10,
          // constraints: BoxConstraints(maxHeight: 40, maxWidth: 400),
          child: TextField(
            autofocus: true,
            onChanged: (text) {
              setState(() {
                buildSuggestions(context);
              });
            },
            // onSubmitted: (data) {
            //   close(context, query);
            // },
            cursorColor: Colors.cyanAccent,
            cursorRadius: Radius.circular(5),
            cursorWidth: 4,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            controller: query,
            cursorHeight: 25,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(left: 40),
              hintText: ' Search your City',
              hintStyle: TextStyle(color: Colors.white60),
              suffixIcon: IconButton(
                iconSize: 20,
                color: Colors.white,
                onPressed: () {
                  if (query.text == '') {
                    Navigator.of(context).pop();
                  } else {
                    query.clear();
                    setState(() {
                      buildSuggestions(context);
                    });
                  }
                },
                icon: Icon(Icons.clear),
              ),
              fillColor: Colors.black87,
              filled: true,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ),
      ),
      body: query.text.isEmpty
          ? buildPopularCities(context, popularCities)
          : buildSuggestions(context),
    );
  }

  close(BuildContext context, TextEditingController query) {
    if (query.text.isNotEmpty)
      context.read<WeatherBloc>().add(
            GetWeather(
              city: query.text,
              predata: {
                'forecast': widget.forecast,
                'location': widget.location
              },
            ),
          );
    Navigator.of(context).pop();
  }

  Widget buildSuggestions(BuildContext context) => FutureBuilder<List<String>>(
        future: WeatherRepo.searchCities(query.text),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Container(
                color: Colors.black,
                child: Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.black,
                  ),
                ),
              );
            default:
              if (snapshot.hasError || snapshot.data!.isEmpty) {
                return Container(
                  color: Colors.black,
                  child: Center(
                    child: Text(
                      'No Such City Found',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              } else if ((snapshot.hasError || snapshot.data!.isEmpty) ||
                  query.text.isEmpty) {
                return buildPopularCities(context, popularCities);
              } else {
                return buildPopularCities(context, snapshot.data);
              }
          }
        },
      );

  List<Widget> recentCity(BuildContext context, List<String>? city) {
    int count = city!.length;
    return List<Widget>.generate(
        count,
        (i) => GestureDetector(
              onTap: () {
                query.text = city[i];
                close(context, query);
              },
              child: Container(
                margin: EdgeInsets.all(8),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white24,
                ),
                child: Text(
                  city[i],
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                ),
              ),
            )).toList();
  }

  Widget buildPopularCities(BuildContext context, List<String>? recents) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: ListView(
        padding: EdgeInsets.only(top: 20, right: 5),
        children: [
          Wrap(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10, top: 8),
                child: TextButton(
                  style: buttonStyle,
                  onPressed: () {},
                  child: Text(
                    'Locate',
                    style: TextStyle(color: Colors.cyanAccent),
                  ),
                ),
              ),
              Wrap(children: recentCity(context, recents)),
            ],
          )
        ],
      ),
    );
  }

  ButtonStyle buttonStyle = TextButton.styleFrom(
      backgroundColor: Colors.white24,
      padding: EdgeInsets.all(15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)));
}
