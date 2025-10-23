import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Importation ajoutée
import 'package:google_fonts/google_fonts.dart';
import 'package:kivu/emission/podcast_model.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayerScreen extends StatefulWidget {
  final Podcast podcast;
  final List<Podcast> allPodcasts;

  const VideoPlayerScreen({
    super.key,
    required this.podcast,
    required this.allPodcasts,
  });

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  VideoPlayerController? _videoPlayerController;
  YoutubePlayerController? _youtubePlayerController;
  bool _isYoutubeVideo = false;
  bool _isFullScreen = false; // Nouvel état pour le mode plein écran

  late Podcast _currentPodcast;

  @override
  void initState() {
    super.initState();
    _currentPodcast = widget.podcast;
    _initializeVideoPlayer();
  }

  @override
  void didUpdateWidget(covariant VideoPlayerScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.podcast.id != oldWidget.podcast.id) {
      _currentPodcast = widget.podcast;
      _initializeVideoPlayer();
    }
  }

  // Permet seulement l'orientation portrait
  void _setPortraitMode() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  // Permet toutes les orientations
  void _setAllOrientations() {
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
  }

  void _initializeVideoPlayer() {
    _youtubePlayerController?.dispose();
    _videoPlayerController?.dispose();

    final videoUrl = _currentPodcast.videoUrl;
    final youtubeVideoId = YoutubePlayer.convertUrlToId(videoUrl);

    if (youtubeVideoId != null) {
      _isYoutubeVideo = true;
      _youtubePlayerController = YoutubePlayerController(
        initialVideoId: youtubeVideoId,
        flags: const YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
          disableDragSeek: false,
          loop: false,
          isLive: false,
          forceHD: false,
          enableCaption: true,
        ),
      )..addListener(_youtubeListener); // Ajout d'un écouteur pour le plein écran
    } else {
      _isYoutubeVideo = false;
      _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(videoUrl))
        ..initialize().then((_) {
          if (mounted) {
            setState(() {});
          }
          _videoPlayerController?.play();
        }).catchError((error) {
          debugPrint("Erreur de chargement vidéo MP4: $error");
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Impossible de lire la vidéo MP4: $error'),
                backgroundColor: Colors.red,
              ),
            );
          }
        });
    }
    // Assurez-vous d'être en mode portrait au début
    _setPortraitMode();
  }

  // Écouteur pour les changements d'état du lecteur YouTube
  void _youtubeListener() {
    if (_youtubePlayerController == null) return;

    if (_youtubePlayerController!.value.isFullScreen && !_isFullScreen) {
      _isFullScreen = true;
      _setAllOrientations(); // Autorise la rotation en mode plein écran
    } else if (!_youtubePlayerController!.value.isFullScreen && _isFullScreen) {
      _isFullScreen = false;
      _setPortraitMode(); // Revient au mode portrait en sortant du plein écran
    }
  }

  // Fonction pour gérer le plein écran du lecteur MP4
  void _toggleVideoPlayerFullScreen() {
    setState(() {
      _isFullScreen = !_isFullScreen;
      if (_isFullScreen) {
        _setAllOrientations();
        // Cacher la barre de statut et la barre de navigation
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      } else {
        _setPortraitMode();
        // Afficher la barre de statut et la barre de navigation
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      }
    });
  }

  void _playNewPodcast(Podcast newPodcast) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => VideoPlayerScreen(
          podcast: newPodcast,
          allPodcasts: widget.allPodcasts,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _youtubePlayerController?.removeListener(_youtubeListener); // Supprime l'écouteur
    _youtubePlayerController?.dispose();
    _videoPlayerController?.dispose();
    _setPortraitMode(); // S'assure que l'application revient en mode portrait à la sortie
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge); // Réaffiche les barres système
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF0A1B3B);
    final Color accentColor = Colors.red.shade400;

    final List<Podcast> suggestedPodcasts =
        widget.allPodcasts.where((p) => p.id != _currentPodcast.id).toList();

    return Scaffold(
      backgroundColor: primaryColor,
      appBar: _isFullScreen
          ? null // Cache l'AppBar en mode plein écran
          : AppBar(
              backgroundColor: primaryColor,
              elevation: 0,
              iconTheme: const IconThemeData(color: Colors.white),
              title: Text(
                _currentPodcast.title,
                style: GoogleFonts.oswald(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Video Player Area
            GestureDetector(
              onDoubleTap: _isYoutubeVideo ? null : _toggleVideoPlayerFullScreen, // Double tap pour MP4 en plein écran
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  _isYoutubeVideo
                      ? (_youtubePlayerController != null
                          ? YoutubePlayer(
                              controller: _youtubePlayerController!,
                              showVideoProgressIndicator: true,
                              progressIndicatorColor: accentColor,
                              progressColors: ProgressBarColors(
                                playedColor: accentColor,
                                handleColor: accentColor,
                              ),
                            )
                          : Container(
                              width: double.infinity,
                              height: 220,
                              color: Colors.black,
                              child: const Center(
                                child: CircularProgressIndicator(color: Colors.white),
                              ),
                            ))
                      : (_videoPlayerController != null &&
                              _videoPlayerController!.value.isInitialized
                          ? AspectRatio(
                              aspectRatio: _videoPlayerController!.value.aspectRatio,
                              child: VideoPlayer(_videoPlayerController!),
                            )
                          : Container(
                              width: double.infinity,
                              height: 220,
                              color: Colors.black,
                              child: const Center(
                                child: CircularProgressIndicator(color: Colors.white),
                              ),
                            )),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Image.asset(
                      'assets/logo.png',
                      width: 70,
                      height: 70,
                    ),
                  ),
                ],
              ),
            ),
            // Le reste du contenu de la page n'est affiché qu'en mode non plein écran
            if (!_isFullScreen)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _currentPodcast.showName,
                      style: GoogleFonts.inter(
                        color: accentColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _currentPodcast.title,
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today, color: Colors.white54, size: 16),
                        const SizedBox(width: 5),
                        Text(
                          _currentPodcast.releaseDate,
                          style: GoogleFonts.inter(
                            color: Colors.white54,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(width: 15),
                        const Icon(Icons.watch_later, color: Colors.white54, size: 16),
                        const SizedBox(width: 5),
                        Text(
                          _currentPodcast.duration,
                          style: GoogleFonts.inter(
                            color: Colors.white54,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Description:",
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _currentPodcast.description,
                      style: GoogleFonts.inter(
                        color: Colors.white70,
                        fontSize: 15,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          if (_isYoutubeVideo) {
                            _youtubePlayerController?.value.isPlaying ?? false
                                ? _youtubePlayerController?.pause()
                                : _youtubePlayerController?.play();
                          } else if (_videoPlayerController != null &&
                              _videoPlayerController!.value.isInitialized) {
                            _videoPlayerController!.value.isPlaying
                                ? _videoPlayerController!.pause()
                                : _videoPlayerController!.play();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: accentColor,
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        icon: Icon(
                            _isYoutubeVideo
                                ? (_youtubePlayerController?.value.isPlaying ?? false
                                    ? Icons.pause
                                    : Icons.play_arrow)
                                : (_videoPlayerController?.value.isPlaying ?? false
                                    ? Icons.pause
                                    : Icons.play_arrow),
                            color: Colors.white),
                        label: Text(
                          _isYoutubeVideo
                              ? ((_youtubePlayerController?.value.isPlaying ?? false)
                                  ? "Mettre en pause"
                                  : "Reprendre la lecture")
                              : ((_videoPlayerController?.value.isPlaying ?? false)
                                  ? "Mettre en pause"
                                  : "Reprendre la lecture"),
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      "Autres vidéos que vous pourriez aimer:",
                      style: GoogleFonts.oswald(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 15),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: suggestedPodcasts.length,
                      itemBuilder: (context, index) {
                        final Podcast suggestedPodcast = suggestedPodcasts[index];
                        return GestureDetector(
                          onTap: () {
                            _playNewPodcast(suggestedPodcast);
                          },
                          child: Card(
                            color: const Color(0xFF1A2C4B),
                            margin: const EdgeInsets.only(bottom: 10),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(6.0),
                                    child: Image.network(
                                      suggestedPodcast.imageUrl,
                                      width: 70,
                                      height: 70,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Container(
                                          width: 70,
                                          height: 70,
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade700,
                                            borderRadius: BorderRadius.circular(6.0),
                                          ),
                                          child: const Icon(Icons.broken_image,
                                              color: Colors.white54, size: 30),
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          suggestedPodcast.title,
                                          style: GoogleFonts.inter(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          suggestedPodcast.showName,
                                          style: GoogleFonts.inter(
                                            color: Colors.red.shade300,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Icon(Icons.play_circle_fill,
                                      color: Colors.white54, size: 24),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
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