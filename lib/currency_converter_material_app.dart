import 'dart:convert';

import 'package:currency_converter/constants/available_currencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class CurrencyConverterMaterialPage extends StatefulWidget {
  const CurrencyConverterMaterialPage({super.key});

  @override
  State<CurrencyConverterMaterialPage> createState() =>
      _CurrencyConverterMaterialPageState();
}

class _CurrencyConverterMaterialPageState
    extends State<CurrencyConverterMaterialPage> {
  late double result;
  String baseCurrency = "USD";
  String targetCurrency = "INR";
  final TextEditingController textEditingController = TextEditingController();

  late Future<Map<String, dynamic>> futureRate;

  Future<Map<String, dynamic>> getCurrentRate(
    String baseCurrency,
    String targetCurrency,
    double amount,
  ) async {
    try {
      final uri = Uri.https(
        "api.fxratesapi.com",
        "/convert",
        {
          "api_key": dotenv.env["FXRATES_API_KEY"] ?? "",
          "from": baseCurrency,
          "to": targetCurrency,
          "amount": amount.toString(),
          "format": "json",
        },
      );

      final response = await http.get(uri);
      final converted = jsonDecode(response.body);
      if (!converted['success']) {
        throw "An error occured";
      }
      return converted;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  initState() {
    super.initState();
    futureRate = getCurrentRate("USD", "INR", 1);
  }

  @override
  Widget build(BuildContext context) {
    final customOrange = const Color(0xFFFF9500);
    final border = const OutlineInputBorder(
      borderSide: BorderSide(
        width: 2.0,
        color: Colors.black,
        strokeAlign: BorderSide.strokeAlignInside,
        style: BorderStyle.solid,
      ),
      borderRadius: BorderRadius.all(Radius.circular(5)),
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Currency Converter',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: futureRate,
        builder: (context, asyncSnapshot) {
          if (asyncSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (asyncSnapshot.hasError) {
            return Center(
              child: Text(asyncSnapshot.error.toString()),
            );
          }
          final data = asyncSnapshot.data!;
          result = data["result"];
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "$targetCurrency ${result.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 45,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      
                      Row(
                        children: [
                          Expanded(child: _buildDropdown(baseCurrency, true)),
                          const SizedBox(width: 10),
                          Expanded(child: _buildDropdown(targetCurrency, false)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        style: const TextStyle(color: Colors.black),
                        controller: textEditingController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          focusedBorder: border,
                          enabledBorder: border,
                          hintText: 'Please enter amount',
                          hintStyle: const TextStyle(color: Colors.black),
                          prefixIcon:
                              const Icon(Icons.monetization_on_outlined),
                          prefixIconColor: Colors.black,
                        ),
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        futureRate = getCurrentRate(
                          baseCurrency,
                          targetCurrency,
                          double.parse(textEditingController.text),
                        );
                      });
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: (customOrange),
                      foregroundColor: (Colors.white),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text(
                      'Convert',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  
  Widget _buildDropdown(String value, bool isBase) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color.fromARGB(255, 24, 24, 24),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(style:BorderStyle.none),
        ),
      ),
      icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
      isExpanded: true,
      initialValue: value,
      items: currencies.map((currency) {
        return DropdownMenuItem<String>(
          value: currency["code"]!,
          child: Text(
            "${currency["code"]!} - ${currency["name"]!}",
            
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
      selectedItemBuilder: (context) {
        return currencies.map((currency) {
          return Text(currency["code"]!);
        }).toList();
      },
      onChanged: (newValue) {
        setState(() {
          if (isBase) {
            baseCurrency = newValue!;
          } else {
            targetCurrency = newValue!;
          }
        });
      },
    );
  }
}
