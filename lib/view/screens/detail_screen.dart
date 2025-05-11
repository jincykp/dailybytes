import 'package:dailybytes/model/article_model.dart';
import 'package:dailybytes/viewmodel/article_providers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailScreen extends StatelessWidget {
  final Article article;

  const DetailScreen({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ArticleProvider>(context);
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Custom App Bar
            SliverAppBar(
              pinned: true,
              elevation: 0,
              backgroundColor: theme.scaffoldBackgroundColor,
              leading: IconButton(
                icon: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.white10 : Colors.black12,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.arrow_back, color: theme.primaryColor),
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              actions: [
                _buildFavoriteButton(context, provider, theme),
                IconButton(
                  icon: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isDarkMode ? Colors.white10 : Colors.black12,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.share, color: theme.primaryColor),
                  ),
                  onPressed: () => _showShareDialog(context),
                ),
              ],
            ),

            // Article Content
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 80),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title with decorative element
                    Container(
                      margin: EdgeInsets.only(bottom: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 60,
                            height: 6,
                            decoration: BoxDecoration(
                              color: theme.primaryColor,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            article.title,
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              height: 1.3,
                              letterSpacing: -0.5,
                              // Using theme.textTheme.titleLarge?.color ensures proper contrast
                              color: theme.textTheme.titleLarge?.color,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Article body with stylized first letter
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: article.body.substring(0, 1),
                            style: TextStyle(
                              fontSize: 56,
                              fontWeight: FontWeight.bold,
                              height: 0.8,
                              // Using a more visible color combination that works in both modes
                              color:
                                  isDarkMode
                                      ? Colors.lightBlue[300]
                                      : theme.primaryColor,
                            ),
                          ),
                          TextSpan(
                            text: article.body.substring(1),
                            style: TextStyle(
                              fontSize: 17,
                              height: 1.7,
                              // Using theme.textTheme.bodyLarge?.color instead of hardcoded Colors.black87
                              color: theme.textTheme.bodyLarge?.color,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Divider
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 32),
                      child: Divider(thickness: 1),
                    ),

                    // Feedback section
                    _buildFeedbackSection(context, theme),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showCommentsSheet(context);
        },
        icon: Icon(Icons.comment_outlined),
        label: Text('Comments'),
        backgroundColor: theme.primaryColor,
      ),
    );
  }

  Widget _buildFavoriteButton(
    BuildContext context,
    ArticleProvider provider,
    ThemeData theme,
  ) {
    final isDarkMode = theme.brightness == Brightness.dark;

    return IconButton(
      icon: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color:
              provider.isFavorite(article.id)
                  ? Colors.red.withOpacity(0.2)
                  : isDarkMode
                  ? Colors.white10
                  : Colors.black12,
          shape: BoxShape.circle,
        ),
        child: Icon(
          provider.isFavorite(article.id)
              ? Icons.favorite
              : Icons.favorite_outline,
          color:
              provider.isFavorite(article.id) ? Colors.red : theme.primaryColor,
        ),
      ),
      onPressed: () {
        provider.toggleFavorite(article);
        _showFavoriteSnackbar(context, provider);
      },
    );
  }

  void _showFavoriteSnackbar(BuildContext context, ArticleProvider provider) {
    final isFavorite = provider.isFavorite(article.id);

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: Colors.white,
            ),
            SizedBox(width: 12),
            Text(
              isFavorite ? 'Added to favorites' : 'Removed from favorites',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ],
        ),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        backgroundColor: isFavorite ? Colors.red : Colors.grey[700],
      ),
    );
  }

  Widget _buildFeedbackSection(BuildContext context, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'How would you rate this article?',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            // Using theme color for better dark mode visibility
            color: theme.textTheme.titleMedium?.color,
          ),
        ),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildRatingButton(context, '😔', 'Poor', theme),
            _buildRatingButton(context, '😐', 'Okay', theme),
            _buildRatingButton(context, '😊', 'Good', theme),
            _buildRatingButton(context, '😃', 'Great', theme),
            _buildRatingButton(context, '🤩', 'Amazing', theme),
          ],
        ),
      ],
    );
  }

  Widget _buildRatingButton(
    BuildContext context,
    String emoji,
    String label,
    ThemeData theme,
  ) {
    final isDarkMode = theme.brightness == Brightness.dark;

    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Thanks for rating this article as "$label"!'),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 6),
        child: Column(
          children: [
            Text(emoji, style: TextStyle(fontSize: 24)),
            SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                // Using theme-based colors instead of hardcoded Colors.grey[700]
                color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showShareDialog(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.grey[600] : Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Text(
                  'Share with friends',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: theme.textTheme.titleLarge?.color,
                  ),
                ),
              ),
              // Wrap in a SingleChildScrollView to prevent overflow
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: [
                      _buildShareOption(
                        context,
                        Icons.message,
                        'Message',
                        Colors.blue[600]!,
                      ),
                      SizedBox(width: 8),
                      _buildShareOption(
                        context,
                        Icons.email,
                        'Email',
                        Colors.red[600]!,
                      ),
                      SizedBox(width: 8),
                      _buildShareOption(
                        context,
                        Icons.link,
                        'Copy Link',
                        Colors.purple[600]!,
                      ),
                      SizedBox(width: 8),
                      _buildShareOption(
                        context,
                        Icons.more_horiz,
                        'More',
                        Colors.orange[600]!,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildShareOption(
    BuildContext context,
    IconData icon,
    String label,
    Color color,
  ) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$label sharing initiated'),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 80, // Fixed width to prevent overflow
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: theme.textTheme.bodyMedium?.color,
                fontSize: 13, // Slightly smaller text
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  void _showCommentsSheet(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.95,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  // Handle and title
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Column(
                      children: [
                        Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color:
                                isDarkMode
                                    ? Colors.grey[600]
                                    : Colors.grey[300],
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          'Comments',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: theme.textTheme.titleLarge?.color,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Comment list
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      padding: EdgeInsets.all(16),
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return _buildCommentItem(context);
                      },
                    ),
                  ),

                  // Comment input
                  Container(
                    padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
                    decoration: BoxDecoration(
                      color: theme.scaffoldBackgroundColor,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          offset: Offset(0, -1),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundColor:
                              isDarkMode ? Colors.grey[700] : Colors.grey[300],
                          child: Icon(
                            Icons.person,
                            color:
                                isDarkMode
                                    ? Colors.grey[300]
                                    : Colors.grey[600],
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Add a comment...',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor:
                                  isDarkMode
                                      ? Colors.grey[800]
                                      : Colors.grey[200],
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: theme.primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.send,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCommentItem(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: isDarkMode ? Colors.grey[700] : Colors.grey[300],
            child: Icon(
              Icons.person,
              color: isDarkMode ? Colors.grey[300] : Colors.grey[600],
              size: 16,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'User ${_getRandomName()}',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: theme.textTheme.bodyLarge?.color,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      '${_getRandomTime()}',
                      style: TextStyle(
                        color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  'This is a sample comment. Great article, thanks for sharing!',
                  style: TextStyle(
                    fontSize: 14,
                    color: theme.textTheme.bodyMedium?.color,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.thumb_up_outlined,
                      size: 14,
                      color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                    ),
                    SizedBox(width: 4),
                    Text(
                      '${_getRandomLikes()}',
                      style: TextStyle(
                        color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(width: 16),
                    Text(
                      'Reply',
                      style: TextStyle(
                        color: isDarkMode ? Colors.grey[300] : Colors.grey[800],
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper methods
  int _estimateReadingTime(String text) {
    // Average adult reading speed is around 200-250 words per minute
    // This is a simplified calculation
    final wordCount = text.split(' ').length;
    final minutes = (wordCount / 200).ceil();
    return minutes > 0 ? minutes : 1;
  }

  String _getRandomName() {
    final names = ['Alex', 'Jordan', 'Taylor', 'Morgan', 'Casey'];
    return names[DateTime.now().microsecond % names.length];
  }

  String _getRandomTime() {
    final times = ['2h ago', '1d ago', '3d ago', 'Just now', '5h ago'];
    return times[DateTime.now().microsecond % times.length];
  }

  int _getRandomLikes() {
    return DateTime.now().microsecond % 20;
  }
}
