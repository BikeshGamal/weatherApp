import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather.dart';
import 'package:weather_app/consts.dart';
class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  String city="Nepal";
  final _textController=TextEditingController();
  final WeatherFactory _wf=WeatherFactory(OPENWEATHER_API_KEY);
  Weather? _weather;
  @override
  void initState()
  {
    super.initState();
    fetchWeatherData(city);
  }
  void fetchWeatherData(String city) {
    _wf.currentWeatherByCityName(city).then((weather) {
      setState(() {
        _weather = weather;
      });
    }).catchError((error) {
      // Handle error when fetching data
      print("Error fetching weather data: $error");
      setState(() {
        _weather = null; // Set _weather to null to indicate no data
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("MausamApp"),
        backgroundColor: Colors.deepOrange,
      ),
      body: _buildUI(),
    );
  }
  Widget _buildUI(){
    if(_weather==null)
      {
        return const Center(
          child: CircularProgressIndicator(
          ),
        );
      }
    return SizedBox(
      width:MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                controller: _textController,
                cursorColor: Colors.deepOrange,
                decoration:  InputDecoration(
                  hintText: 'Enter your city',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)
                  ),
                    suffixIcon: IconButton(onPressed: (){
                      setState(() {
                        city=_textController.text;
                      fetchWeatherData(city);
                      }
                      );
                      print(city);
                      }, icon: Icon(Icons.search_rounded,color: Colors.black,)),
                    prefixIcon: Icon(Icons.location_city,color: Colors.black,)
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height*0.04,
            ),
            _loacationHeader(),
            SizedBox(
              height: MediaQuery.of(context).size.height*0.04,
            ),
            _dateTimeInfo(),
            SizedBox(
              height: MediaQuery.of(context).size.height*0.05,
            ),
            _weatherIcon(),
            SizedBox(
              height: MediaQuery.of(context).size.height*0.02,
            ),
            _currentTemp(),
            SizedBox(
              height: MediaQuery.of(context).size.height*0.02,
            ),
            _extraInfo(),
          ],
        ),
      ),
    );
  }
_loacationHeader() {
  return Text(_weather?.areaName??"",
    style:const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w500
    )
    ,);
}
_dateTimeInfo(){
    DateTime now=_weather!.date!;
    return Column(
      children: [
        Text(DateFormat("h:mm a").format(now),
        style: const TextStyle(
          fontSize: 35
        ),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(DateFormat("EEEE").format(now),
              style: const TextStyle(
                  fontWeight: FontWeight.w700
              ),
            ),
            Text("${DateFormat(" d.M.y").format(now)}",
              style: const TextStyle(
                  fontWeight: FontWeight.w400
              ),
            ),
        ],),
      ],
    );
}
_weatherIcon(){
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: MediaQuery.of(context).size.height*0.20,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage("http://openweathermap.org/img/wn/${_weather?.weatherIcon}@4x.png")
            )
          ),
        ),
        Text(_weather?.weatherDescription??"",
        style: const TextStyle(
          color: Colors.black,
          fontSize: 20
        ),
        )
      ],
    );
}
_currentTemp(){
    return Text("${_weather?.temperature?.celsius?.toStringAsFixed(0)}° C",
    style: TextStyle(
      color: Colors.black,
      fontSize: 90,
      fontWeight: FontWeight.w500
    ),
    );
}
_extraInfo(){
    return Container(
        height: MediaQuery.of(context).size.height*0.15,
      width: MediaQuery.of(context).size.width*0.80,
      decoration: BoxDecoration(
        color: Colors.deepOrange,
        borderRadius: BorderRadius.circular(20)
      ),
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Max : ${_weather?.tempMax?.celsius?.toStringAsFixed(0)}° C",
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold
              ),
              ),
              Text("Min : ${_weather?.tempMin?.celsius?.toStringAsFixed(0)}° C",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15
                    ,
                    fontWeight: FontWeight.bold
                ),
              ),
          ],),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Wind : ${_weather?.windSpeed?.toStringAsFixed(0)} m/s",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15
                    ,
                    fontWeight: FontWeight.bold
                ),
              ),
              Text("Humidity : ${_weather?.humidity?.toStringAsFixed(0)}%",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15
                    ,
                    fontWeight: FontWeight.bold
                ),
              ),
            ],)

        ],
      ),

    );
}
}
