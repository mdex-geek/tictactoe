import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  bool isOTurn = true;
  List<String> displayExOh = ['', '', '', '', '', '', '', '', ''];

  TextStyle myTextStyle = TextStyle(color: Colors.white, fontSize: 30);

  int oScore = 0;
  int xScore = 0;

  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, -1), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.bounceOut),
        );

    _fadeController.forward();
    _scaleController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              Expanded(
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                              decoration: BoxDecoration(
                                color: Colors.blue.shade700.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color: isOTurn
                                      ? Colors.transparent
                                      : Colors.blue,
                                  width: 3,
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 10,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Player X',
                                    style: myTextStyle.copyWith(fontSize: 20),
                                  ),
                                  AnimatedDefaultTextStyle(
                                    duration: const Duration(milliseconds: 300),
                                    style: myTextStyle.copyWith(
                                      fontSize: !isOTurn ? 28 : 24,
                                      fontWeight: !isOTurn
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                    child: Text(xScore.toString()),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                              decoration: BoxDecoration(
                                color: Colors.red.shade700.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color: isOTurn
                                      ? Colors.red
                                      : Colors.transparent,
                                  width: 3,
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 10,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Player O',
                                    style: myTextStyle.copyWith(fontSize: 20),
                                  ),
                                  AnimatedDefaultTextStyle(
                                    duration: const Duration(milliseconds: 300),
                                    style: myTextStyle.copyWith(
                                      fontSize: isOTurn ? 28 : 24,
                                      fontWeight: isOTurn
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                    child: Text(oScore.toString()),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: AspectRatio(
                      aspectRatio: 1.0,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: GridView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: 9,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                ),
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () => _tapped(index),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  decoration: BoxDecoration(
                                    color: displayExOh[index] != ''
                                        ? (displayExOh[index] == 'X'
                                              ? Colors.blue.shade100
                                              : Colors.red.shade100)
                                        : Colors.grey.shade200,
                                    border: Border.all(
                                      color: Colors.grey.shade400,
                                      width: 2,
                                    ),
                                  ),
                                  child: Center(
                                    child: AnimatedSwitcher(
                                      duration: const Duration(
                                        milliseconds: 300,
                                      ),
                                      transitionBuilder:
                                          (
                                            Widget child,
                                            Animation<double> animation,
                                          ) {
                                            return ScaleTransition(
                                              scale: animation,
                                              child: child,
                                            );
                                          },
                                      child: Text(
                                        displayExOh[index],
                                        key: ValueKey<String>(
                                          displayExOh[index],
                                        ),
                                        style: TextStyle(
                                          color: displayExOh[index] == 'X'
                                              ? Colors.blue.shade800
                                              : Colors.red.shade800,
                                          fontSize: 40,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 300),
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                        child: Text(
                          isOTurn ? "Player O's Turn" : "Player X's Turn",
                        ),
                      ),
                      SizedBox(height: 20),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        child: ElevatedButton.icon(
                          onPressed: _resetGame,
                          icon: Icon(Icons.refresh, color: Colors.white),
                          label: Text(
                            'Reset Game',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade600,
                            padding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
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
    );
  }

  void _tapped(int index) {
    if (displayExOh[index] == '') {
      // Add haptic feedback
      HapticFeedback.lightImpact();

      setState(() {
        displayExOh[index] = isOTurn ? 'O' : 'X';
        isOTurn = !isOTurn;
      });
      _checkWinner();
    }
  }

  void _checkWinner() {
    // List of all possible winning combinations
    final List<List<int>> winPatterns = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    for (List<int> pattern in winPatterns) {
      final a = pattern[0], b = pattern[1], c = pattern[2];
      if (displayExOh[a] != '' &&
          displayExOh[a] == displayExOh[b] &&
          displayExOh[a] == displayExOh[c]) {
        _showWinDailog(displayExOh[a]);
        (displayExOh[a] == 'O' ? oScore++ : xScore++);
        return;
      }
    }

    // Check for draw
    if (!displayExOh.contains('')) {
      _showDrawDialog();
    }
  }

  void _showWinDailog(String winner) {
    showAdaptiveDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog.adaptive(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('🎉'),
              SizedBox(width: 8),
              Text('WINNER!'),
              SizedBox(width: 8),
              Text('🎉'),
            ],
          ),
          content: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.emoji_events,
                  size: 50,
                  color: winner == 'X' ? Colors.blue : Colors.red,
                ),
                SizedBox(height: 16),
                Text(
                  'Player $winner wins this round!',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          actions: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _startNewGame();
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blue.shade100,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: Text(
                  'New Game',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade800,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showDrawDialog() {
    showAdaptiveDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog.adaptive(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('🤝'),
              SizedBox(width: 8),
              Text('DRAW!'),
              SizedBox(width: 8),
              Text('🤝'),
            ],
          ),
          content: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.handshake, size: 50, color: Colors.orange),
                SizedBox(height: 16),
                Text(
                  'It\'s a tie! Well played both!',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          actions: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _startNewGame();
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.orange.shade100,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: Text(
                  'New Game',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange.shade800,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _startNewGame() {
    // Reset animations
    _scaleController.reset();
    _fadeController.reset();

    setState(() {
      displayExOh = ['', '', '', '', '', '', '', '', ''];
      isOTurn = true;
    });

    // Restart animations for smooth transition
    _scaleController.forward();
    _fadeController.forward();
  }

  void _resetGame() {
    showAdaptiveDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog.adaptive(
          title: Text('Reset Game'),
          content: Text(
            'This will reset all scores and start a new game. Are you sure?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  displayExOh = ['', '', '', '', '', '', '', '', ''];
                  isOTurn = true;
                  oScore = 0;
                  xScore = 0;
                });
                // Reset and restart animations
                _scaleController.reset();
                _fadeController.reset();
                _scaleController.forward();
                _fadeController.forward();
              },
              child: Text('Reset', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
