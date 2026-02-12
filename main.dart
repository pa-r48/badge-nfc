import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

/// =======================
/// APP ROOT
/// =======================
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login & Carta Wallet Moderna',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Colors.grey[100],
        fontFamily: 'Roboto',
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 18,
            horizontal: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
      home: const LoginPage(),
    );
  }
}

/// =======================
/// LOGIN PAGE
/// =======================
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  void _login() {
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Per favore, compila tutti i campi")),
      );
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => CardPage(
          nome: _usernameController.text,
          cognome: "Rossi",
          comune: "Milano",
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              Image.asset("assets/Favicon-DiMaggio@2x.png", width: 110),
              const SizedBox(height: 16),
              const Text(
                "I.T.E.T. Luigi Di Maggio",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              const Text(
                "Accesso Area Studenti",
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 40),
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password'),
              ),
              const SizedBox(height: 36),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    "ACCEDI",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// =======================
/// CARD PAGE
/// =======================
class CardPage extends StatefulWidget {
  final String nome;
  final String cognome;
  final String comune;

  const CardPage({
    super.key,
    required this.nome,
    required this.cognome,
    required this.comune,
  });

  @override
  State<CardPage> createState() => _CardPageState();
}

class _CardPageState extends State<CardPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _isFront = true;

  late final Color color1;
  late final Color color2;

  final Random random = Random();

  // Palette colori armonici sicuri
  final List<Color> safeColors = [
    Color(0xFF003399), // blu logo
    Color(0xFFFFD700), // giallo logo
    Color(0xFF4CAF50), // verde tenue
    Color(0xFFFFA726), // arancio pastello
    Color(0xFFBA68C8), // lilla pastello
  ];

  Color _randomShade(Color base) {
    int r = (base.red + random.nextInt(40) - 20).clamp(0, 255);
    int g = (base.green + random.nextInt(40) - 20).clamp(0, 255);
    int b = (base.blue + random.nextInt(40) - 20).clamp(0, 255);
    return Color.fromARGB(255, r, g, b);
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    // Scegli due colori diversi dalla palette
    int firstIndex = random.nextInt(safeColors.length);
    int secondIndex;
    do {
      secondIndex = random.nextInt(safeColors.length);
    } while (secondIndex == firstIndex);

    color1 = _randomShade(safeColors[firstIndex]);
    color2 = _randomShade(safeColors[secondIndex]);
  }

  void _flipCard() {
    _isFront ? _controller.forward() : _controller.reverse();
    _isFront = !_isFront;
  }

  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Il tuo badge"),
        centerTitle: true,
        backgroundColor: color1,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: _logout,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: _flipCard,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (_, __) {
                  final angle = _controller.value * pi;
                  final isUnder = angle > pi / 2;
                  return Stack(
                    children: [
                      Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.001)
                          ..rotateY(angle),
                        child: Opacity(
                          opacity: isUnder ? 0 : 1,
                          child: _frontCard(),
                        ),
                      ),
                      Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.001)
                          ..rotateY(angle + pi),
                        child: Opacity(
                          opacity: isUnder ? 1 : 0,
                          child: _backCard(),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 30),
            Text(
              "Benvenuto, ${widget.nome}!",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            const Text(
              "Tocca la carta per visualizzare i dettagli",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _frontCard() {
    return _baseCard(
      child: Center(
        child: Image.asset("assets/Favicon-DiMaggio@2x.png", width: 150),
      ),
    );
  }

  Widget _backCard() {
    return _baseCard(
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _label("COGNOME"),
              _value(widget.cognome),
              const SizedBox(height: 10),
              _label("NOME"),
              _value(widget.nome),
              const SizedBox(height: 10),
              _label("COMUNE"),
              _value(widget.comune),
            ],
          ),
          Positioned(
            bottom: 6,
            right: 6,
            child: Opacity(
              opacity: 0.85,
              child: Image.asset("assets/Favicon-DiMaggio@2x.png", width: 80),
            ),
          ),
        ],
      ),
    );
  }

  Widget _baseCard({required Widget child}) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.88,
      height: 220,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          colors: [color1, color2],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 18,
            offset: Offset(4, 8),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _label(String text) => Text(
    text,
    style: const TextStyle(
      fontSize: 13,
      color: Colors.white70,
      letterSpacing: 1.6,
    ),
  );

  Widget _value(String text) => Text(
    text.toUpperCase(),
    style: const TextStyle(
      fontSize: 22,
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),
  );
}
