import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SevenDayForecastPage extends StatelessWidget {
  // Menerima data ramalan dari halaman utama
  final List<dynamic> forecastDays;

  const SevenDayForecastPage({
    super.key,
    required this.forecastDays,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('7-Day Forecast'),
        backgroundColor: const Color(0xFF63D2D2),
      ),
      body: ListView.builder(
        itemCount: forecastDays.length,
        itemBuilder: (context, index) {
          final dayData = forecastDays[index];
          final dayInfo = dayData['day'];
          final date = DateTime.parse(dayData['date']);

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  // Ikon Cuaca
                  Image.network(
                    'https:${dayInfo['condition']['icon']}',
                    width: 50,
                    height: 50,
                  ),
                  const SizedBox(width: 16),
                  // Informasi Tanggal dan Kondisi
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          DateFormat('EEEE, d MMM').format(date), // Format: "Monday, 2 Jul"
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          dayInfo['condition']['text'],
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Informasi Suhu (Tertinggi / Terendah)
                  Text(
                    '${dayInfo['maxtemp_c'].round()}° / ${dayInfo['mintemp_c'].round()}°',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.blueAccent,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}