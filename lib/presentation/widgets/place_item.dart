import 'package:flutter/material.dart';
import '../../constnats/my_colors.dart';
import '../../data/models/place_suggestion.dart';

class PlaceItem extends StatelessWidget {
  final PlaceSuggestion suggestion;

  const PlaceItem({super.key, required this.suggestion});

  @override
  Widget build(BuildContext context) {
    var subtitle = suggestion.description
        .replaceAll(suggestion.description.split(',')[0], '');

    return Container(
      width: double.infinity,
      margin: const EdgeInsetsDirectional.all(8),
      padding: const EdgeInsetsDirectional.all(4),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8)),
      child: Column(children: [
        ListTile(
          title: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '${suggestion.description.split(',')[0]}\n',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: subtitle.substring(2),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          leading: Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: MyColors.lightBlue,
            ),
            child: const Icon(
              Icons.place,
              color: MyColors.blue,
            ),
          ),
        )
      ]),
    );
  }
}
