import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weatherapp/controller/api_controller.dart';
import 'package:weatherapp/controller/auth_controller.dart';
import 'package:weatherapp/view/forecast_weather.dart';
import 'package:weatherapp/view/history_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeWeatherScreen extends StatefulWidget {
  const HomeWeatherScreen({super.key});

  @override
  State<HomeWeatherScreen> createState() => _HomeWeatherScreenState();
}

class _HomeWeatherScreenState extends State<HomeWeatherScreen> {
  final WeatherApi _weatherApi = WeatherApi();
  final TextEditingController _searchController = TextEditingController();
  Future<Map<String, dynamic>>? _weatherData;
  String _location = "Medan, Indonesia";

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  Future<void> _fetchWeather() async {
    final user = FirebaseAuth.instance.currentUser;

    final forecastData = await _weatherApi.getForecast(_location);

    setState(() {
      _weatherData = Future.value(forecastData);
    });

    if (user != null) {
      final current = forecastData['current'];
      await FirebaseFirestore.instance
          .collection('search_history')
          .doc(user.uid)
          .collection('items')
          .add({
        'location': _location,
        'temperature': current['temp_c'],
        'timestamp': FieldValue.serverTimestamp(),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF63D2D2),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Hello!',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history, color: Colors.white, size: 28),
            tooltip: 'History',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HistoryScreen()),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: IconButton(
              onPressed: () => AuthController.logout(context),
              icon: const Icon(Icons.logout, color: Colors.white, size: 28),
              tooltip: 'Logout',
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF63D2D2),
              Color(0xFF90E2D1),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildCurrentWeatherSection(),
              _buildWeeklyForecastSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentWeatherSection() {
    return Expanded(
      flex: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _searchController,
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  setState(() {
                    _location = value;
                  });
                  _fetchWeather();
                }
              },
              decoration: InputDecoration(
                hintText: 'Find your location',
                suffixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.white.withOpacity(0.9),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
              ),
            ),
            const SizedBox(height: 40),
            FutureBuilder<Map<String, dynamic>>(
              future: _weatherData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(color: Colors.white);
                }
                if (snapshot.hasError) {
                  return Text(
                    'Error: ${snapshot.error}',
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                    textAlign: TextAlign.center,
                  );
                }
                if (snapshot.hasData) {
                  final data = snapshot.data!;
                  final current = data['current'];
                  final location = data['location'];

                  return Column(
                    children: [
                      Text(
                        '${location['name']}, ${location['country']}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Image.network('https:${current['condition']['icon']}', scale: 0.7),
                      const SizedBox(height: 8),
                      Text(
                        '${current['temp_c'].round()}°C',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        current['condition']['text'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklyForecastSection() {
    return Expanded(
      flex: 1,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
        decoration: const BoxDecoration(
          color: Color(0xFFB1EAE3),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
        ),
        child: FutureBuilder<Map<String, dynamic>>(
          future: _weatherData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (snapshot.hasData) {
              final forecastDays = snapshot.data!['forecast']['forecastday'] as List;
              final summaryForecast = forecastDays.skip(1).take(3).toList();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Weekly Forecast',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4A4A4A),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: summaryForecast.length,
                      itemBuilder: (context, index) {
                        final day = summaryForecast[index];
                        return _buildForecastItem(
                          iconUrl: 'https:${day['day']['condition']['icon']}',
                          day: DateFormat('EEEE').format(DateTime.parse(day['date'])),
                          temperature: '${day['day']['avgtemp_c'].round()}°C',
                        );
                      },
                    ),
                  ),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SevenDayForecastPage(
                              forecastDays: forecastDays,
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        'View 7-Day Forecast',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildForecastItem({
    required String iconUrl,
    required String day,
    required String temperature,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.network(iconUrl, width: 40, height: 40),
              const SizedBox(width: 16),
              Text(
                day,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A4A4A),
                ),
              ),
            ],
          ),
          Text(
            temperature,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4A4A4A),
            ),
          ),
        ],
      ),
    );
  }
}
