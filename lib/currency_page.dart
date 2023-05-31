import 'package:flutter/material.dart';

class CurrencyPage extends StatefulWidget {
  const CurrencyPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CurrencyPageState createState() => _CurrencyPageState();
}

class _CurrencyPageState extends State<CurrencyPage> {
  String _selectedCurrencyFrom =
      'IDR'; // Default selected currency for "Convert From"
  String _selectedCurrencyTo =
      'USD'; // Default selected currency for "Convert To"
  double _inputValue = 0;
  double _convertedValue = 0;

  final Map<String, double> _conversionRates = {
    'IDR': 1, // 1 IDR = 1 IDR
    'USD': 0.000067, // 10,000 IDR = 0.67 USD
    'Yen': 0.0076, // 1 IDR = 0.0076 Yen
    // Add more currency conversion rates here
  };

  void _convertCurrency() {
    setState(() {
      double rateFrom = _conversionRates[_selectedCurrencyFrom]!;
      double rateTo = _conversionRates[_selectedCurrencyTo]!;
      double convertedValueFrom = _inputValue * (1 / rateFrom);
      _convertedValue = convertedValueFrom * rateTo;
    });
  }

  void _swapValues() {
    setState(() {
      String tempCurrency = _selectedCurrencyFrom;
      _selectedCurrencyFrom = _selectedCurrencyTo;
      _selectedCurrencyTo = tempCurrency;

      _convertCurrency(); // Automatically convert the currency after swapping
    });
  }

  String _formatConvertedValue(double value) {
    if (value >= 1) {
      return value.toStringAsFixed(2);
    } else {
      return value.toStringAsFixed(6);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isMobile = screenSize.width < 600;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Currency Conversion'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Currency Converter',
              style: TextStyle(
                fontSize: isMobile ? 24 : 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: isMobile ? double.infinity : 400,
              child: TextField(
                decoration: const InputDecoration(
                  labelText: 'Enter value',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    _inputValue = double.tryParse(value) ?? 0;
                  });
                },
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButton<String>(
                    value: _selectedCurrencyFrom,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedCurrencyFrom = newValue!;
                      });
                    },
                    items: _conversionRates.keys.map((currency) {
                      return DropdownMenuItem<String>(
                        value: currency,
                        child: Text(currency),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(width: 16),
                IconButton(
                  onPressed: _swapValues,
                  icon: const Icon(Icons.swap_horiz),
                ),
                const SizedBox(width: 16),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButton<String>(
                    value: _selectedCurrencyTo,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedCurrencyTo = newValue!;
                      });
                    },
                    items: _conversionRates.keys.map((currency) {
                      return DropdownMenuItem<String>(
                        value: currency,
                        child: Text(currency),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _convertCurrency,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.deepOrange, // Set the text color
              ),
              child: const Text('Convert'),
            ),
            const SizedBox(height: 16),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  const Text(
                    'Converted Value:',
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${_formatConvertedValue(_convertedValue)} ${_selectedCurrencyTo.toUpperCase()}',
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
