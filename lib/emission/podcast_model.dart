// lib/models/podcast.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kivu/emission/podcasts_screen.dart';
import 'package:kivu/style.dart';

class PodcastsScreen extends StatelessWidget {
  const PodcastsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = const Color(0xFF0A1B3B);
    final Color cardColor = const Color(0xFF1A2C4B);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Podcasts & Replays",
          style: GoogleFonts.oswald(
            fontWeight: FontWeight.bold,
            color: kivuStarsBlack,
          ),
        ),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              // Add search functionality here
            },
            icon: const Icon(Icons.search, color: kivuStarsBlack),
          ),
        ],
        elevation: 0,
        iconTheme: const IconThemeData(color: kivuStarsBlack),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: mockPodcasts.length,
        itemBuilder: (context, index) {
          final Podcast podcast = mockPodcasts[index];

          return GestureDetector(
            onTap: () {
              // Pass the entire list of mockPodcasts
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VideoPlayerScreen(
                    podcast: podcast,
                    allPodcasts: mockPodcasts, // <--- ADDED: Pass all podcasts
                  ),
                ),
              );
            },
            child: Card(
              color: Colors.white,
              elevation: 4,
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Podcast Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        podcast.imageUrl,
                        width: 90,
                        height: 90,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 90,
                            height: 90,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade700,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: const Icon(Icons.broken_image,
                                color: Colors.white54, size: 40),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Show Name
                          Text(
                            podcast.showName,
                            style: GoogleFonts.inter(
                              color: kivuStarsYellow,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          // Podcast Title
                          Text(
                            podcast.title,
                            style: GoogleFonts.inter(
                              color: kivuStarsBlack,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          // Podcast Description
                          Text(
                            podcast.description,
                            style: GoogleFonts.inter(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 10),
                          // Play, Duration, Download & Date Row
                          Row(
                            children: [
                              // Play Icon and Duration
                              const Icon(Icons.play_circle_fill,
                                  color: kivuStarsYellow, size: 20),
                              const SizedBox(width: 6),
                              Text(podcast.duration,
                                  style: GoogleFonts.inter(
                                      color: kivuStarsBlack, fontSize: 12)),
                              const Spacer(), // Pushes elements to ends

                              // Release Date
                              Text(
                                podcast.releaseDate,
                                style: GoogleFonts.inter(
                                    color: kivuStarsBlack, fontSize: 11),
                              ),
                              const SizedBox(width: 8),

                              // Download Icon
                              // const Icon(Icons.download_for_offline_outlined,
                              //     color: kivuStarsBlack, size: 20),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class Podcast {
  final String id;
  final String showName;
  final String title;
  final String description;
  final String imageUrl;
  final String duration;
  final String releaseDate;
  final String videoUrl; // <--- ADDED: URL of the video to play

  Podcast({
    required this.id,
    required this.showName,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.duration,
    required this.releaseDate,
    required this.videoUrl, // <--- ADDED: required for constructor
  });
}

final List<Podcast> mockPodcasts = [
  // Existing 10 Podcasts
  Podcast(
    id: '1',
    showName: 'Débat Citoyen',
    title: 'Impact de la Récente Crise Humanitaire',
    description:
        'Analyse approfondie des conséquences de la crise sur la population de Goma et les efforts d\'aide.',
    imageUrl:
        'https://www.openagrifood.org/wp-content/uploads/OPENAGRIFOOD2019-0075-2.jpg',
    duration: '28:15',
    releaseDate: '15 Juin 2025',
    videoUrl:
        'https://www.youtube.com/watch?v=OngbF-tXyfg&loop=0', // Example YouTube URL (replace with actual video)
  ),
  Podcast(
    id: '2',
    showName: 'Kivu Sport Flash',
    title: 'Préparatifs des Léopards pour la CAN',
    description:
        'Point sur l\'entraînement et les attentes des Léopards pour la prochaine Coupe d\'Afrique des Nations.',
    imageUrl:
        'https://www.irisfootball.com/wp-content/uploads/2024/04/IMG-20240424-WA0103-1024x712.jpg',
    duration: '15:30',
    releaseDate: '14 Juin 2025',
    videoUrl:
        'https://www.youtube.com/watch?v=Va_jg6WzvXY', // Example YouTube URL
  ),
  Podcast(
    id: '3',
    showName: 'Le Réveil Matin du Kivu',
    title: 'L\'Actualité Économique de la Semaine',
    description:
        'Un résumé des faits économiques marquants de la semaine à Goma et dans la région du Kivu.',
    imageUrl:
        'https://etudes-economiques.credit-agricole.com/var/etudeseco/storage/images/_aliases/publicationfull/2/3/3/1/2241332-1-fre-FR/3d0b170c1257-Economie-graphiques-GettyImages-1300120218-16-9.jpg',
    duration: '10:05',
    releaseDate: '13 Juin 2025',
    videoUrl:
        'https://www.youtube.com/watch?v=m_St8q3EfUg&loop=0', // Example YouTube URL
  ),
  Podcast(
    id: '4',
    showName: 'Mélodies du Kivu',
    title: 'Hommage aux Artistes Locaux',
    description:
        'Découvrez les voix émergentes et établies de la scène musicale du Kivu.',
    imageUrl:
        'https://peacekeeping.un.org/sites/default/files/field/image/didier_binyungu_atelier_1_goma.jpg',
    duration: '45:00',
    releaseDate: '12 Juin 2025',
    videoUrl:
        'https://www.youtube.com/watch?v=4MwsVXolra0&loop=0', // Example YouTube URL
  ),
  Podcast(
    id: '5',
    showName: 'Santé Pour Tous',
    title: 'Prévention du Paludisme en Saison des Pluies',
    description:
        'Conseils essentiels pour se protéger et protéger sa famille contre le paludisme pendant la saison des pluies.',
    imageUrl:
        'https://www.scidev.net/afrique-sub-saharienne/wp-content/uploads/sites/2/2019/08/student_midwife_from_the_school_of_midwifery_in_masuba-996x567.jpg',
    duration: '22:40',
    releaseDate: '11 Juin 2025',
    videoUrl:
        'https://www.youtube.com/watch?v=5uL1an5OOcg&loop=0', // Example YouTube URL
  ),
];
