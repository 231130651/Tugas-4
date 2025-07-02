import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weatherapp/controller/api_controller.dart';
import 'package:weatherapp/view/forecast_weather.dart';

class HomeWeatherScreen extends StatefulWidget {
  const HomeWeatherScreen({super.key});

  @override
  State<HomeWeatherScreen> createState() => _HomeWeatherScreenState();
}

class _HomeWeatherScreenState extends State<HomeWeatherScreen> {
  final WeatherApi _weatherApi = WeatherApi();
  Future<Map<String, dynamic>>? _weatherData;
  String _location = "Medan, Indonesia";

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  void _fetchWeather() {
    setState(() {
      _weatherData = _weatherApi.getForecast(_location);
    });
  }

  // >>> KODE BAGIAN ATAS (build, _buildCurrentWeatherSection) TETAP SAMA <<<
  // ... (salin dari jawaban sebelumnya)
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              _buildWeeklyForecastSection(), // Bagian ini akan dimodifikasi
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
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  _location = value;
                  _fetchWeather();
                }
              },
              decoration: InputDecoration(
                hintText: 'Find your location',
                prefixIcon: const Icon(Icons.search, color: Colors.white),
                filled: true,
                fillColor: Colors.white.withOpacity(0.9),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 16.0)
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


  // ### MODIFIKASI DIMULAI DI SINI ###
  Widget _buildWeeklyForecastSection() {
    return Expanded(
      flex: 1,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 12), // Padding bawah dikecilkan
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
              // Ambil data mulai dari besok untuk ditampilkan di ringkasan
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
                  // Menampilkan ringkasan 3 hari berikutnya
                  Expanded(
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(), // Biar tidak bisa di-scroll
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
                  // Tombol untuk navigasi
                  Center(
                    child: TextButton(
                      onPressed: () {
                        // Navigasi ke halaman 7 hari dengan mengirim data
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SevenDayForecastPage(
                              forecastDays: forecastDays, // Kirim semua data 7 hari
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        'View 7-Day Forecast',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black54),
                      ),
                    ),
                  )
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  // Widget untuk item di ringkasan forecast (disederhanakan)
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