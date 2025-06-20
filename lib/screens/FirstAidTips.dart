import 'package:flutter/material.dart';

class FirstAidTips extends StatelessWidget {
  const FirstAidTips({super.key});

  final List<String> tips = const [
    "For burns, cool the burn under running water for at least 10 minutes.",
    "If someone is choking, perform the Heimlich maneuver.",
    "For cuts, clean the wound and apply a sterile bandage.",
    "If someone is bleeding heavily, apply pressure to the wound.",
    "For sprains, rest, ice, compression, and elevation (R.I.C.E).",
    "If a person is unconscious but breathing, place them in the recovery position.",
    "Call emergency services if the injury is severe or life-threatening.",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("First Aid Tips"),
        backgroundColor: Colors.redAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.separated(
          itemCount: tips.length,
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            return Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Number bubble
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Tip text
                    Expanded(
                      child: Text(
                        tips[index],
                        style: const TextStyle(
                          fontSize: 18,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
