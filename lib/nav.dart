import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:kivu/style.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Barre de navigation
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 66,
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(Icons.home, "Acceuil", 0),
                  _buildNavItem(Icons.calendar_today, "Programme", 1),
                  const SizedBox(width: 50), // espace pour le bouton central
                  _buildNavItem(Icons.flash_on, "Emission", 2),
                  _buildNavItem(Icons.article, "À la Une", 3),
                ],
              ),
            ),
          ),

          // Bouton central
          // Bouton central
          Positioned(
            bottom:
                22, // Ajustez cette valeur pour positionner le bouton plus haut
            child: FloatingActionButton(
              onPressed: () async {
                try {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext dialogContext) {
                      return StatefulBuilder(
                        builder: (context, setState) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            contentPadding: const EdgeInsets.all(20),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(height: 70, 'assets/logo.png'),
                                const SizedBox(height: 16),
                                Text(
                                  'DIRECT',
                                  style: GoogleFonts.inter(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "L'autre face du kivu",
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                const SizedBox(height: 24),
                                const LinearProgressIndicator(
                                  backgroundColor: Color(0xFFE0E0E0),
                                  color: kivuStarsYellow
                                ),
                              ],
                            ),
                            actions: [
                              TextButton.icon(
                                onPressed: () {
                                  _audioPlayer.stop();
                                  Navigator.of(dialogContext).pop();
                                },
                                icon: const Icon(Icons.stop,
                                    color: Colors.redAccent),
                                label: const Text(
                                  'Quitter',
                                  style: TextStyle(color: Colors.redAccent),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  );

                  await _audioPlayer
                      .setAudioSource(AudioSource.asset('assets/a.m4a'));
                  await _audioPlayer.play();

                  _audioPlayer.playerStateStream.listen((state) {
                    if (state.processingState == ProcessingState.completed) {
                      if (context.mounted) {
                        Navigator.of(context, rootNavigator: true).pop();
                      }
                    }
                  });
                } catch (e) {
                  print("Erreur de lecture audio : $e");
                  if (context.mounted) {
                    Navigator.of(context, rootNavigator: true).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Impossible de lire l'audio.")),
                    );
                  }
                }
              },
              backgroundColor:kivuStarsYellow,
              elevation: 4.0,
              shape: const CircleBorder(),
              child:
                  const Icon(Icons.play_arrow, color: Colors.white, size: 40),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final bool isSelected = widget.selectedIndex == index;
    final Color color = isSelected ? kivuStarsYellow : Colors.grey;

    return GestureDetector(
      onTap: () => widget.onItemTapped(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.inter(
              color: color,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
