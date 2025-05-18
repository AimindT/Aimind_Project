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
  String? _selectedEmotion; // Variable para almacenar la emoción seleccionada
  bool _showThankYou = false; // New state to show thank-you message

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

  // Lista de etiquetas de emoción para cada opción, con salto de línea
  final List<String> _labels = [
    'Muy\ninsatisfecho',
    'Insatisfecho',
    'Neutral',
    'Satisfecho',
    'Muy\nsatisfecho',
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
          'emotion': _selectedEmotion, // Enviar la emoción seleccionada
        });
      }

      // Show thank-you message before closing
      setState(() {
        _showThankYou = true;
        _isSubmitting = false;
      });

      // Delay to show thank-you message for 1.5 seconds
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
      child: contentBox(context),
    );
  }

  Widget contentBox(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
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
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 25),
            const Text(
              '¿CÓMO CALIFICARÍAS EL DESEMPEÑO DE AIMIND?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                5,
                (index) => GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedRating = index + 1;
                      _selectedEmotion = _labels[index].replaceAll(
                          '\n', ' '); // Almacenar la emoción sin salto de línea
                    });
                  },
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
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
                          size: 40,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _labels[index],
                        style: TextStyle(
                          fontSize: 12,
                          color:
                              isDarkMode ? Colors.grey[400] : Colors.grey[600],
                          fontWeight: _selectedRating == index + 1
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                height: 10,
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
                                  size: 10,
                                ),
                              )
                            : null,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text(
                    'OMITIR',
                    style: TextStyle(
                      color: isDarkMode ? Colors.grey : Colors.grey[700],
                    ),
                  ),
                ),
                ElevatedButton(
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
                ),
              ],
            ),
          ] else ...[
            const Text(
              '¡Gracias por tu calificación!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
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
}
