import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const ConvertisseurApp());
}

class ConvertisseurApp extends StatelessWidget {
  const ConvertisseurApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Currency Converter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const ConvertisseurHome(),
    );
  }
}

class ConvertisseurHome extends StatefulWidget {
  const ConvertisseurHome({super.key});

  @override
  State<ConvertisseurHome> createState() => _ConvertisseurHomeState();
}

class _ConvertisseurHomeState extends State<ConvertisseurHome> {
  String _selectedConversion = "EuroToDinar";
  final TextEditingController _controller = TextEditingController();
  double? _resultat;
  bool _hasConverted = false;

  // Conversion rates
  static const double _euroToDinarRate = 3.4;

  void _convertir() {
    if (_controller.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter an amount'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      final montant = double.tryParse(_controller.text);
      if (montant == null || montant < 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter a valid positive number'),
            backgroundColor: Colors.red,
          ),
        );
        _hasConverted = false;
        return;
      }

      if (_selectedConversion == "EuroToDinar") {
        _resultat = montant * _euroToDinarRate;
      } else {
        _resultat = montant / _euroToDinarRate;
      }
      _hasConverted = true;
    });
  }

  void _swapConversion() {
    setState(() {
      _selectedConversion = _selectedConversion == "EuroToDinar" 
          ? "DinarToEuro" 
          : "EuroToDinar";
      _hasConverted = false;
      _resultat = null;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String get _fromCurrency => _selectedConversion == "EuroToDinar" ? "EUR" : "TND";
  String get _toCurrency => _selectedConversion == "EuroToDinar" ? "TND" : "EUR";
  String get _fromSymbol => _selectedConversion == "EuroToDinar" ? "€" : "د.ت";
  String get _toSymbol => _selectedConversion == "EuroToDinar" ? "د.ت" : "€";

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              primaryColor.withOpacity(0.1),
              Colors.white,
              primaryColor.withOpacity(0.05),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                // Header
                Text(
                  '💱 Currency Converter',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                    letterSpacing: 0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Euro ⇄ Dinar Tunisien',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                
                // Input Card
                Card(
                  elevation: 8,
                  shadowColor: primaryColor.withOpacity(0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        // Amount Input
                        TextField(
                          controller: _controller,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                          ],
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: InputDecoration(
                            labelText: 'Amount',
                            hintText: '0.00',
                            prefixText: _fromSymbol,
                            prefixStyle: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(color: primaryColor.withOpacity(0.3)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(color: primaryColor.withOpacity(0.3)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(color: primaryColor, width: 2),
                            ),
                            filled: true,
                            fillColor: primaryColor.withOpacity(0.05),
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Swap Button
                        GestureDetector(
                          onTap: _swapConversion,
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: primaryColor.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.swap_horiz_rounded,
                              size: 32,
                              color: primaryColor,
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Conversion Type Selection
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildConversionOption(
                              context,
                              'Dinar',
                              'Euro',
                              'د.ت',
                              '€',
                              "DinarToEuro",
                            ),
                            _buildConversionOption(
                              context,
                              'Euro',
                              'Dinar',
                              '€',
                              'د.ت',
                              "EuroToDinar",
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Result Card
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: Card(
                    elevation: 8,
                    shadowColor: _hasConverted 
                        ? Colors.green.withOpacity(0.3) 
                        : Colors.grey.withOpacity(0.3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    color: _hasConverted 
                        ? Colors.green.withOpacity(0.05) 
                        : Colors.grey.withOpacity(0.05),
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        children: [
                          Text(
                            _hasConverted ? 'Result' : 'Enter an amount to convert',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 16),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            transitionBuilder: (Widget child, Animation<double> animation) {
                              return ScaleTransition(scale: animation, child: child);
                            },
                            child: _hasConverted && _resultat != null
                                ? Text(
                                    '${_toSymbol} ${_resultat!.toStringAsFixed(3)} $_toCurrency',
                                    key: ValueKey(_resultat),
                                    style: TextStyle(
                                      fontSize: 36,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green[700],
                                      letterSpacing: 1,
                                    ),
                                  )
                                : Text(
                                    '${_toSymbol} --- $_toCurrency',
                                    key: const ValueKey('placeholder'),
                                    style: TextStyle(
                                      fontSize: 36,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[400],
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Convert Button
                ElevatedButton(
                  onPressed: _convertir,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 6,
                    shadowColor: primaryColor.withOpacity(0.4),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.calculate_rounded, size: 24),
                      SizedBox(width: 12),
                      Text(
                        'CONVERT',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Exchange Rate Info
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.info_outline, size: 20, color: Colors.grey[600]),
                        const SizedBox(width: 8),
                        Text(
                          'Exchange rate: 1 EUR = $_euroToDinarRate TND',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildConversionOption(
    BuildContext context,
    String from,
    String to,
    String fromSymbol,
    String toSymbol,
    String value,
  ) {
    final isSelected = _selectedConversion == value;
    final theme = Theme.of(context);
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedConversion = value;
          _hasConverted = false;
          _resultat = null;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primary : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? theme.colorScheme.primary : Colors.grey[300]!,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Text(
              '$fromSymbol → $toSymbol',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '$from to $to',
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? Colors.white70 : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}










