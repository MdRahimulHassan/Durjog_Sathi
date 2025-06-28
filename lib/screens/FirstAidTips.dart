import 'package:flutter/material.dart';

class FirstAidTips extends StatefulWidget {
  const FirstAidTips({super.key});

  @override
  State<FirstAidTips> createState() => _FirstAidTipsState();
}

class _FirstAidTipsState extends State<FirstAidTips> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> disasterCategories = [
    {
      'title': 'Earthquake',
      'icon': Icons.terrain,
      'color': const Color(0xFF8D6E63),
      'tips': [
        {
          'title': 'Crush Injuries',
          'icon': Icons.healing,
          'steps': [
            'DO NOT remove heavy objects from victims',
            'Check for pulse and breathing',
            'Control bleeding with direct pressure',
            'Immobilize injured limbs with splints',
            'Cover wounds with clean cloth',
            'Monitor for shock symptoms',
            'Keep victim warm and comfortable'
          ],
          'emergency': 'Call rescue teams immediately. Crush syndrome can be fatal if objects are removed improperly'
        },
        {
          'title': 'Building Collapse Injuries',
          'icon': Icons.home_repair_service,
          'steps': [
            'Assess scene safety before approaching',
            'Look for signs of life (movement, sounds)',
            'Clear airway of debris carefully',
            'Stabilize neck and spine',
            'Control bleeding with pressure bandages',
            'Treat for shock - elevate legs if no spinal injury',
            'Signal for professional rescue teams'
          ],
          'emergency': 'Never attempt to move structural debris alone. Wait for trained rescue personnel'
        },
        {
          'title': 'Glass & Debris Wounds',
          'icon': Icons.cut,
          'steps': [
            'Do NOT remove large glass pieces',
            'Stabilize embedded objects with padding',
            'Clean small cuts with bottled water',
            'Apply pressure around (not on) embedded objects',
            'Cover wounds with sterile gauze',
            'Watch for signs of internal bleeding',
            'Document injury location and time'
          ],
          'emergency': 'Seek immediate medical attention for deep puncture wounds or embedded objects'
        }
      ]
    },
    {
      'title': 'Flood',
      'icon': Icons.waves,
      'color': const Color(0xFF2196F3),
      'tips': [
        {
          'title': 'Near Drowning',
          'icon': Icons.pool,
          'steps': [
            'Remove victim from water safely',
            'Check for breathing and pulse',
            'If not breathing, begin rescue breathing',
            'If no pulse, start CPR immediately',
            'Clear mouth of water/debris',
            'Position on side to drain water',
            'Keep warm - hypothermia risk is high'
          ],
          'emergency': 'All near-drowning victims need hospital evaluation, even if they seem recovered'
        },
        {
          'title': 'Contaminated Water Exposure',
          'icon': Icons.water_drop,
          'steps': [
            'Remove contaminated clothing immediately',
            'Rinse exposed skin with clean water',
            'Flush eyes with clean water for 15 minutes',
            'Do NOT induce vomiting if ingested',
            'Give clean water to drink if conscious',
            'Monitor for infection signs',
            'Seek medical evaluation within 24 hours'
          ],
          'emergency': 'Contact poison control for chemical contamination. Watch for delayed reactions'
        },
        {
          'title': 'Hypothermia from Cold Water',
          'icon': Icons.severe_cold,
          'steps': [
            'Move victim to warm, dry location',
            'Remove wet clothing gently',
            'Wrap in dry blankets or sleeping bags',
            'Give warm (not hot) drinks if conscious',
            'Handle victim gently - rough movement dangerous',
            'Apply heat packs to chest, neck, groin',
            'Monitor breathing and heart rate'
          ],
          'emergency': 'Severe hypothermia can cause cardiac arrest. Handle victim very gently'
        }
      ]
    },
    {
      'title': 'Fire',
      'icon': Icons.local_fire_department,
      'color': const Color(0xFFE53935),
      'tips': [
        {
          'title': 'Severe Burns',
          'icon': Icons.whatshot,
          'steps': [
            'Remove victim from fire source safely',
            'Cool burns with clean water (not ice)',
            'Remove burned clothing (if not stuck to skin)',
            'Cover burns with sterile, non-stick dressings',
            'Do NOT apply ointments or home remedies',
            'Treat for shock - elevate feet if possible',
            'Give sips of water if victim is conscious'
          ],
          'emergency': 'Burns covering >10% of body or on face/hands/genitals need immediate hospital care'
        },
        {
          'title': 'Smoke Inhalation',
          'icon': Icons.air,
          'steps': [
            'Move victim to fresh air immediately',
            'Check airway for soot or burns',
            'Monitor breathing closely',
            'Position victim upright if conscious',
            'Loosen tight clothing around neck',
            'Be prepared to perform CPR',
            'Do NOT give food or water'
          ],
          'emergency': 'All smoke inhalation cases need hospital evaluation. Lung damage may not be immediate'
        },
        {
          'title': 'Carbon Monoxide Poisoning',
          'icon': Icons.warning,
          'steps': [
            'Remove victim from contaminated area',
            'Call 911 immediately',
            'Check breathing and pulse',
            'Give rescue breathing if needed',
            'Keep victim warm and quiet',
            'Monitor for unconsciousness',
            'Get high-flow oxygen as soon as possible'
          ],
          'emergency': 'Carbon monoxide poisoning can be fatal. Get victim to fresh air and call 911'
        }
      ]
    },
    {
      'title': 'Storm',
      'icon': Icons.thunderstorm,
      'color': const Color(0xFF9C27B0),
      'tips': [
        {
          'title': 'Lightning Strike',
          'icon': Icons.flash_on,
          'steps': [
            'Victim is safe to touch - no electrical charge remains',
            'Check for breathing and pulse immediately',
            'Begin CPR if no pulse detected',
            'Look for entry and exit burn wounds',
            'Check for spinal injuries',
            'Treat burns with cool, wet cloths',
            'Monitor for delayed cardiac effects'
          ],
          'emergency': 'All lightning strike victims need immediate hospital evaluation'
        },
        {
          'title': 'Flying Debris Injuries',
          'icon': Icons.scatter_plot,
          'steps': [
            'Assess head and neck injuries first',
            'Do NOT remove objects from head/neck',
            'Control bleeding with direct pressure',
            'Immobilize suspected fractures',
            'Check for signs of internal bleeding',
            'Monitor consciousness level',
            'Keep detailed record of injuries'
          ],
          'emergency': 'Head injuries can worsen rapidly. Seek immediate medical attention'
        },
        {
          'title': 'Wind-Related Trauma',
          'icon': Icons.air,
          'steps': [
            'Stabilize potential spinal injuries',
            'Check for chest injuries and breathing',
            'Look for signs of internal bleeding',
            'Immobilize fractures with available materials',
            'Keep victim still and warm',
            'Monitor vital signs every 15 minutes',
            'Prepare for rapid evacuation'
          ],
          'emergency': 'Multiple trauma requires immediate professional medical care'
        }
      ]
    }
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: disasterCategories.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF2C3E50),
        title: const Text(
          'Disaster Medical Guide',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Icon(Icons.warning, color: Colors.orange.shade600, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'For disaster-related injuries. Always prioritize scene safety.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.orange.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              TabBar(
                controller: _tabController,
                labelColor: const Color(0xFF2C3E50),
                unselectedLabelColor: Colors.grey,
                indicatorColor: const Color(0xFF3498DB),
                indicatorWeight: 3,
                isScrollable: true,
                tabs: disasterCategories.map((category) {
                  return Tab(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(category['icon'], size: 20),
                        const SizedBox(height: 4),
                        Text(
                          category['title'],
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: disasterCategories.map((category) {
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: category['tips'].length,
            itemBuilder: (context, index) {
              final tip = category['tips'][index];
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ExpansionTile(
                  tilePadding: const EdgeInsets.all(20),
                  childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  leading: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: category['color'].withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      tip['icon'],
                      color: category['color'],
                      size: 26,
                    ),
                  ),
                  title: Text(
                    tip['title'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2C3E50),
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      'Disaster-specific emergency care',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FA),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.medical_services,
                                color: category['color'],
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Emergency Response Steps:',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF2C3E50),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          ...tip['steps'].asMap().entries.map((entry) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: category['color'],
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Text(
                                        '${entry.key + 1}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      entry.value,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        height: 1.4,
                                        color: Color(0xFF34495E),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                          const SizedBox(height: 16),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.red.shade200),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.emergency,
                                  color: Colors.red.shade600,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Critical Warning:',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.red.shade700,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        tip['emergency'],
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.red.shade700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
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
        }).toList(),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(
                  Icons.phone_in_talk,
                  color: Colors.red.shade600,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Medical Help: 16263  | Emergency: 999',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.red.shade600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Colors.grey.shade600,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    'Ensure scene safety before providing aid. Wait for professional rescue teams when needed.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}