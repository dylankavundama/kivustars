import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kivu/style.dart';

// UPDATED PROGRAM PAGE WITH REALISTIC DATA
class ProgramPage extends StatelessWidget {
  const ProgramPage({super.key});

  // Data for the Kivu Stars Goma program schedule
  static final List<Map<String, String>> _kivuStarsPrograms = [
    {
      'title': 'Le Réveil Matin du Kivu',
      'time': '06:00 - 08:00',
      'description':
          'Commencez votre journée avec les actualités locales, la météo et la musique inspirante pour bien démarrer.',
      'imageUrl':
          'https://themiceexperts.com/wp-content/uploads/2021/09/Le-Pays-des-milles-collines-1110x550.jpg', // Assuming you have a morning show image
    },
    {
      'title': 'Débat Citoyen',
      'time': '08:00 - 09:30',
      'description':
          'Une plateforme ouverte pour discuter des enjeux sociaux et politiques qui touchent la communauté de Goma. Vos appels et opinions comptent!',
      'imageUrl': 'https://pbs.twimg.com/media/FLKU17dXEAAAugr.jpg:large',
    },
    {
      'title': 'Kivu Sport Flash',
      'time': '09:30 - 10:00',
      'description':
          'Toutes les dernières nouvelles et analyses sportives, locales et internationales. Ne manquez rien de l\'action!',
      'imageUrl':
          'https://www.irisfootball.com/wp-content/uploads/2024/04/IMG-20240416-WA0036-1024x683.jpg', // Assuming a sport-related image
    },
    {
      'title': 'Mélodies du Kivu',
      'time': '10:00 - 12:00',
      'description':
          'Deux heures de musique variée, des hits du moment aux classiques congolais. Demandez vos chansons préférées!',
      'imageUrl':
          'https://wmahub.com/ss.jpg',
    },
    {
      'title': 'Journal de la Mi-Journée',
      'time': '12:00 - 12:30',
      'description':
          'Le point complet sur l\'actualité de la mi-journée, avec des reportages détaillés et des interviews.',
      'imageUrl':
          'https://media.istockphoto.com/id/1673718113/photo/woman-reporter-presents-news-bulletin.jpg?s=2048x2048&w=is&k=20&c=cupj0s6_WugjlkoTM-X_nzdY5BiquaiDmrsxQmHzY_E=', // Assuming a news image
    },
    {
      'title': 'Santé Pour Tous',
      'time': '12:30 - 13:30',
      'description':
          'Informations et conseils pratiques sur la santé, le bien-être et la prévention, avec des experts invités.',
      'imageUrl':
          'https://images.pexels.com/photos/7012343/pexels-photo-7012343.jpeg', // Assuming a health-related image
    },
    {
      'title': 'Culture et Traditions',
      'time': '13:30 - 14:30',
      'description':
          'Plongez au cœur de la richesse culturelle du Kivu et de la RDC. Musique, art, histoire et contes traditionnels.',
      'imageUrl':
          'https://www.amahoro-tours.com/wp-content/uploads/2025/06/best-things-to-do-in-Goma-1024x683.jpg', // Assuming a culture-related image
    },
    {
      'title': 'Le Talk Show de l\'Après-Midi',
      'time': '14:30 - 16:00',
      'description':
          'Entretiens avec des personnalités, débats légers et interactions avec les auditeurs sur des sujets variés.',
      'imageUrl': 'assets/talk_show.png', // Assuming a talk show image
    },
    {
      'title': 'Infos du Soir',
      'time': '16:00 - 16:30',
      'description':
          'Le bulletin d\'information du soir, pour rester informé des derniers développements avant la fin de journée.',
      'imageUrl': 'assets/journal_soir.png', // Assuming a news image
    },
    {
      'title': 'Nuit Blanche',
      'time': '16:30 - 18:00',
      'description':
          'Une sélection de musique douce et relaxante pour accompagner votre fin d\'après-midi et début de soirée.',
      'imageUrl': 'assets/nuit_blanche.png', // Assuming a relaxing music image
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F7),
      appBar: AppBar(
        title: Text(
          "Programme Kivu Stars ",
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            fontSize: 20, // Slightly reduced font size for longer title
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _kivuStarsPrograms.length,
        itemBuilder: (context, index) {
          final program = _kivuStarsPrograms[index];
          return _buildProgramCard(
            title: program['title']!,
            time: program['time']!,
            description: program['description']!,
            imageUrl: program['imageUrl']!,
          );
        },
      ),
    );
  }

  Widget _buildProgramCard({
    required String title,
    required String time,
    required String description,
    required String imageUrl,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image de gauche
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                // Use a default image if the specific one is not found
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
                // Add error handling for image if it's dynamic
                // onError: (exception, stackTrace) {
                //   print('Error loading image: $imageUrl');
                //   return const Icon(Icons.broken_image); // Placeholder
                // },
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Colonne de texte
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  time,
                  style: GoogleFonts.inter(
                    color: kivuStarsYellow,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: GoogleFonts.inter(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: GoogleFonts.inter(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}
