import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kivu/style.dart';
import '../article_model.dart'; // Import the Article model
import '../data/mock_data.dart'; // Import the updated mock data
// lib/data/mock_data.dart
import '../article_model.dart'; // Make sure this path is correct if your model is elsewhere

// lib/article_model.dart
class Article {
  final String id;
  final String title;
  final String excerpt;
  final String category;
  final String imageUrl;
  final String fullContent; // Optional: for a detailed article view
  final String publishDate; // Added for publication date

  Article({
    required this.id,
    required this.title,
    required this.excerpt,
    required this.category,
    required this.imageUrl,
    this.fullContent = '', // Default empty if not provided
    required this.publishDate,
  });
}

final List<Article> mockArticles = [
  // Existing Article (example, modify as per your actual first article)
  Article(
    id: '1',
    title: 'Go Up Stars Bientot sur kivu stars',
    excerpt:
        'La nouvelle émission "Go Up Stars" arrive bientôt sur Kivu Stars, promettant de mettre en lumière les talents émergents de la région du Kivu.',
    category: 'Musique et Entrepreneuriat',
    imageUrl:
        'https://wmahub.com/r.png', // Blue
    publishDate: '18 Octobre 2025',
  ),
 
 
  Article(
    id: '4',
    title: 'Culture: Musiuque et les derniers préparatifs ',
    excerpt:
        'Le comité d\'organisation du Festival Amani de Goma annonce des préparatifs avancés pour une nouvelle édition riche en couleurs et en messages de paix.',
    category: 'Culture',
    imageUrl:
        'https://wmahub.com/ss.jpg', // Gold
    publishDate: '15 Juin 2025',
  ),
  // Article(
  //   id: '5',
  //   title: 'Santé Publique: Campagne de Vaccination Contre la Rougeole',
  //   excerpt:
  //       'Une vaste campagne de vaccination contre la rougeole est lancée dans plusieurs zones de santé du Nord-Kivu pour protéger les enfants.',
  //   category: 'Santé',
  //   imageUrl:
  //       'https://via.placeholder.com/600x400/DAA520/FFFFFF?text=Vaccination', // Goldenrod
  //   publishDate: '14 Juin 2025',
  // ),

  // --- NOUVELLES DONNÉES (3 Articles supplémentaires) ---
  Article(
    id: '6',
    title: 'Éducation: La Rentree Scolaire Anticipée dans Certaines Zones',
    excerpt:
        'Pour rattraper le temps perdu, la rentrée scolaire est anticipée dans les territoires de Rutshuru et Nyiragongo, avec un accent sur l\'encadrement des élèves.',
    category: 'Éducation',
    imageUrl:
        'https://wmahub.com/md.png', // SteelBlue
    publishDate: '18 Juin 2025',
  ),
  // Article(
  //   id: '7',
  //   title: 'Environnement: L\'Impact de la Déforestation sur le Climat Local',
  //   excerpt:
  //       'Une étude récente révèle les effets alarmants de la déforestation continue sur les conditions climatiques et la biodiversité autour du lac Kivu.',
  //   category: 'Environnement',
  //   imageUrl:
  //       'https://www.naturevolution.org/wp-content/uploads/2019/08/YBI_KON_07521-800x534.jpg', // Olive
  //   publishDate: '17 Juin 2025',
  // ),
  Article(
    id: '8',
    title: 'Société: Initiative pour l\'Autonomisation des Femmes Rurales',
    excerpt:
        'Un nouveau projet vise à renforcer les capacités économiques des femmes dans les zones rurales du Nord-Kivu par des formations et des micro-crédits.',
    category: 'Société',
    imageUrl:
        'https://www.ifad.org/documents/48415603/50096176/Promoting-women-economic-empowerment-in-West-and-Central-Africa.jpg/02a009ae-78f0-bdc7-10af-68abe1770485?version=1.0&t=1726664503968', // Hot Pink
    publishDate: '16 Juin 2025',
  ),
  // Add more mock articles here if needed to reach a good number
];

class AlaUneScreen extends StatelessWidget {
  const AlaUneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color cardColor =   Colors.white; 

    // Ensure there's at least one article for the featured section
    final Article featuredArticle = mockArticles.isNotEmpty
        ? mockArticles.first
        : Article(
            id: 'default',
            title: 'Aucun Article Disponible',
            excerpt: 'Veuillez vérifier votre connexion ou les données.',
            category: 'Information',
            imageUrl:
                'https://via.placeholder.com/600x400/CCCCCC/000000?text=No+Image',
            publishDate: 'N/A',
          );

    // Skip the first article for "Other News"
    final List<Article> otherArticles = mockArticles.skip(1).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "À la Une",
          style: GoogleFonts.oswald(
            fontWeight: FontWeight.bold,
            color: kivuStarsBlack
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Featured Article Card
          _buildFeaturedArticleCard(featuredArticle, cardColor),
          const SizedBox(height: 24),
          // Section Title for Other News
          Text(
            "Autres Actualités",
            style: GoogleFonts.oswald(
              color: kivuStarsBlack,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          // List of Other Articles
          ...otherArticles
              .map((article) => _buildArticleListItem(article, cardColor))
              .toList(),
        ],
      ),
    );
  }

  // Helper method to build the featured article card
  Widget _buildFeaturedArticleCard(Article article, Color cardColor) {
    return Card(
      color: Colors.white,
      elevation: 4,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.network(
              article.imageUrl,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 200,
                  width: double.infinity,
                  color: Colors.grey.shade800,
                  alignment: Alignment.center,
                  child: const Icon(Icons.broken_image,
                      color: Colors.black87, size: 50),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  article.category,
                  style: GoogleFonts.inter(
                    color: kivuStarsYellow,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  article.title,
                  style: GoogleFonts.oswald(
                    color: kivuStarsBlack,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  article.excerpt,
                  style: GoogleFonts.inter(
                    color: Colors.black87,
                    fontSize: 14,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    article.publishDate,
                    style: GoogleFonts.inter(
                      color: Colors.black87,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build individual article list items
  Widget _buildArticleListItem(Article article, Color cardColor) {
    return Card(
      color: cardColor,
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                article.imageUrl,
                width: 100,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 100,
                    height: 80,
                    color: Colors.grey.shade700,
                    alignment: Alignment.center,
                    child: const Icon(Icons.broken_image,
                        color: Colors.black87, size: 30),
                  );
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.category,
                    style: GoogleFonts.inter(
                      color:kivuStarsYellow,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    article.title,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      color: kivuStarsBlack,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    article.publishDate,
                    style: GoogleFonts.inter(
                      color: Colors.black87,
                      fontSize: 11,
                    ),
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
