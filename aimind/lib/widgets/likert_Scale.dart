import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LikertScaleDialog extends StatefulWidget {
  final Function? onComplete;

  const LikertScaleDialog({
    Key? key,
    this.onComplete,
  }) : super(key: key);

  @override
  State<LikertScaleDialog> createState() => _LikertScaleDialogState();
}

class _LikertScaleDialogState extends State<LikertScaleDialog> {
  int _selectedRating = 0;
  bool _isSubmitting = false;
  String? _selectedEmotion;
  bool _showThankYou = false;

  // Lista de emojis y colores para la escala
  final List<IconData> _emojis = [
    Icons.sentiment_very_dissatisfied,
    Icons.sentiment_dissatisfied,
    Icons.sentiment_neutral,
    Icons.sentiment_satisfied,
    Icons.sentiment_very_satisfied,
  ];

  final List<Color> _colors = [
    Colors.red,
    Colors.orange,
    Colors.amber,
    Colors.lightGreen,
    Colors.green,
  ];

  // Lista de etiquetas de emoción para cada opción
  // Versión corta para pantallas pequeñas
  final List<String> _shortLabels = [
    'Muy mal',
    'Mal',
    'Neutral',
    'Bien',
    'Muy bien',
  ];
  
  // Versión completa para pantallas más grandes
  final List<String> _fullLabels = [
    'Muy insatisfecho',
    'Insatisfecho',
    'Neutral',
    'Satisfecho',
    'Muy satisfecho',
  ];

  Future<void> _submitRating() async {
    if (_selectedRating == 0) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      final user = Supabase.instance.client.auth.currentUser;

      if (user != null) {
        await Supabase.instance.client.from('likert').insert({
          'user_id': user.id,
          'question_id': '00000000-0000-0000-0000-000000000001',
          'rating': _selectedRating,
          'emotion': _selectedEmotion,
        });
      }

      setState(() {
        _showThankYou = true;
        _isSubmitting = false;
      });

      await Future.delayed(const Duration(milliseconds: 1500));

      if (widget.onComplete != null) {
        widget.onComplete!();
      }

      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al enviar la calificación: $e')),
        );
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return contentBox(context, constraints);
        },
      ),
    );
  }

  Widget contentBox(BuildContext context, BoxConstraints constraints) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    
    // Determine if we're in a compact layout
    final isCompact = screenWidth < 360;
    
    // Determine icon size based on available width
    final iconSize = isCompact ? 30.0 : (screenWidth < 400 ? 35.0 : 40.0);
    
    // Choose which labels to use based on screen width
    final useShortLabels = screenWidth < 400;
    
    // Calculate padding based on screen size
    final horizontalPadding = isCompact ? 12.0 : 20.0;
    final verticalPadding = isCompact ? 15.0 : 20.0;

    return Container(
      width: constraints.maxWidth,
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: isDarkMode ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 5,
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (!_showThankYou) ...[
            const Text(
              'ESCALA DE LIKERT',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: isCompact ? 15 : 20),
            const Text(
              '¿CÓMO CALIFICARÍAS EL DESEMPEÑO DE AIMIND?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: isCompact ? 15 : 20),
            LayoutBuilder(
              builder: (context, constraints) {
                // Use a grid for very small screens
                if (constraints.maxWidth < 300) {
                  // Distribuir con 3 arriba y 2 abajo centrados
                  return Column(
                    children: [
                      // Primera fila: 3 elementos
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(
                          3,
                          (index) => buildRatingItem(
                            index,
                            useShortLabels,
                            iconSize,
                            isDarkMode,
                            isCompact,
                          ),
                        ),
                      ),
                      SizedBox(height: isCompact ? 10 : 15),
                      // Segunda fila: 2 elementos centrados
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          buildRatingItem(
                            3,
                            useShortLabels,
                            iconSize,
                            isDarkMode,
                            isCompact,
                          ),
                          SizedBox(width: 20),
                          buildRatingItem(
                            4,
                            useShortLabels,
                            iconSize,
                            isDarkMode,
                            isCompact,
                          ),
                        ],
                      ),
                    ],
                  );
                } else {
                  // Use row for larger screens
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                      5,
                      (index) => buildRatingItem(
                        index,
                        useShortLabels,
                        iconSize,
                        isDarkMode,
                        isCompact,
                      ),
                    ),
                  );
                }
              },
            ),
            SizedBox(height: isCompact ? 10 : 15),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                height: 8,
                child: Row(
                  children: List.generate(
                    5,
                    (index) => Expanded(
                      child: Container(
                        color: _colors[index],
                        child: _selectedRating == index + 1
                            ? const Center(
                                child: Icon(
                                  Icons.star,
                                  color: Colors.white,
                                  size: 8,
                                ),
                              )
                            : null,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: isCompact ? 20 : 30),
            // Use a Row for larger screens, Column for smaller screens
            (constraints.maxWidth < 300)
                ? Column(
                    children: [
                      buildSubmitButton(isDarkMode),
                      const SizedBox(height: 10),
                      buildSkipButton(isDarkMode),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildSkipButton(isDarkMode),
                      buildSubmitButton(isDarkMode),
                    ],
                  ),
          ] else ...[
            const Text(
              '¡Gracias por tu calificación!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: isCompact ? 15 : 20),
            ElevatedButton(
              onPressed: () {
                if (widget.onComplete != null) {
                  widget.onComplete!();
                }
                Navigator.of(context).pop(true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isDarkMode ? Colors.indigo[600] : Colors.indigo[400],
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text('CERRAR'),
            ),
          ],
        ],
      ),
    );
  }

  Widget buildRatingItem(
    int index,
    bool useShortLabels,
    double iconSize,
    bool isDarkMode,
    bool isCompact,
  ) {
    final labels = useShortLabels ? _shortLabels : _fullLabels;
    final fontSize = isCompact ? 10.0 : 12.0;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedRating = index + 1;
          _selectedEmotion = _fullLabels[index];
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(isCompact ? 5 : 8),
            decoration: BoxDecoration(
              color: _selectedRating == index + 1
                  ? _colors[index].withOpacity(0.2)
                  : Colors.transparent,
              shape: BoxShape.circle,
              border: _selectedRating == index + 1
                  ? Border.all(color: _colors[index], width: 2)
                  : null,
            ),
            child: Icon(
              _emojis[index],
              color: _colors[index],
              size: iconSize,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            labels[index],
            style: TextStyle(
              fontSize: fontSize,
              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
              fontWeight: _selectedRating == index + 1
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget buildSkipButton(bool isDarkMode) {
    return TextButton(
      onPressed: () {
        Navigator.of(context).pop(false);
      },
      child: Text(
        'OMITIR',
        style: TextStyle(
          color: isDarkMode ? Colors.grey : Colors.grey[700],
        ),
      ),
    );
  }

  Widget buildSubmitButton(bool isDarkMode) {
    return ElevatedButton(
      onPressed: _selectedRating == 0 || _isSubmitting
          ? null
          : _submitRating,
      style: ElevatedButton.styleFrom(
        backgroundColor: _selectedRating == 0
            ? Colors.grey
            : _colors[_selectedRating - 1],
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(
            horizontal: 30, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: _isSubmitting
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
          : const Text('ENVIAR'),
    );
  }
}