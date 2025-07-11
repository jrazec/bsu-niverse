import 'dart:math';

/// Configuration class for individual popup quests
class PopupConfig {
  final String id;
  final String dialogue;
  final String image;
  final String location;
  final String questTitle;
  final String questDescription;
  final int coinsReward;
  final int coinsPenalty;

  const PopupConfig({
    required this.id,
    required this.dialogue,
    required this.image,
    required this.location,
    required this.questTitle,
    required this.questDescription,
    this.coinsReward = 5,
    this.coinsPenalty = 2,
  });
}

/// Contains all popup configurations that can be randomly spawned
class PopupConfigs {
  // Main building popups (5 each for gzb, vmb, abb, lsb)
  static final List<PopupConfig> gzbPopups = [
    PopupConfig(
      id: 'gzb_1',
      dialogue: 'Hello there! I need help finding my lost textbook in the GZB building. Can you help me search for it?',
      image: 'sirt.png',
      location: 'GZB Building - Ground Floor',
      questTitle: 'Lost Textbook Hunt',
      questDescription: 'Find the missing textbook somewhere in GZB building',
    ),
    PopupConfig(
      id: 'gzb_2',
      dialogue: 'Excuse me! I\'m organizing a study group for our Computer Science exam. Would you like to join us?',
      image: 'sirt.png',
      location: 'GZB Building - 2nd Floor',
      questTitle: 'Study Group Formation',
      questDescription: 'Help organize a study group for Computer Science students',
    ),
    PopupConfig(
      id: 'gzb_3',
      dialogue: 'The printer in the computer lab is acting up again. Do you know anything about fixing printers?',
      image: 'sirt.png',
      location: 'GZB Building - Computer Lab',
      questTitle: 'Printer Repair Mission',
      questDescription: 'Fix the malfunctioning printer in the computer lab',
    ),
    PopupConfig(
      id: 'gzb_4',
      dialogue: 'I\'m conducting a survey about student satisfaction. Would you mind answering a few questions?',
      image: 'sirt.png',
      location: 'GZB Building - Hallway',
      questTitle: 'Student Survey',
      questDescription: 'Participate in a student satisfaction survey',
    ),
    PopupConfig(
      id: 'gzb_5',
      dialogue: 'Our department is hosting a coding competition next week. Are you interested in participating?',
      image: 'sirt.png',
      location: 'GZB Building - Faculty Office',
      questTitle: 'Coding Competition',
      questDescription: 'Join the upcoming coding competition',
    ),
  ];

  static final List<PopupConfig> vmbPopups = [
    PopupConfig(
      id: 'vmb_1',
      dialogue: 'Welcome to VMB! I\'m looking for volunteers to help clean the engineering labs. Interested?',
      image: 'sirt.png',
      location: 'VMB Building - Engineering Lab',
      questTitle: 'Lab Cleaning Volunteer',
      questDescription: 'Help clean and organize the engineering laboratories',
    ),
    PopupConfig(
      id: 'vmb_2',
      dialogue: 'We\'re setting up a robotics exhibition. Can you help us arrange the display tables?',
      image: 'sirt.png',
      location: 'VMB Building - Exhibition Hall',
      questTitle: 'Robotics Setup',
      questDescription: 'Assist in setting up the robotics exhibition',
    ),
    PopupConfig(
      id: 'vmb_3',
      dialogue: 'I need someone to test this new circuit design. Are you familiar with electronics?',
      image: 'sirt.png',
      location: 'VMB Building - Electronics Lab',
      questTitle: 'Circuit Testing',
      questDescription: 'Test and validate a new circuit design',
    ),
    PopupConfig(
      id: 'vmb_4',
      dialogue: 'The 3D printer needs new filament. Could you help me replace it?',
      image: 'sirt.png',
      location: 'VMB Building - Maker Space',
      questTitle: 'Printer Maintenance',
      questDescription: 'Replace filament in the 3D printer',
    ),
    PopupConfig(
      id: 'vmb_5',
      dialogue: 'I\'m organizing a workshop on renewable energy. Would you like to help with preparations?',
      image: 'sirt.png',
      location: 'VMB Building - Conference Room',
      questTitle: 'Energy Workshop',
      questDescription: 'Help prepare for the renewable energy workshop',
    ),
  ];

  static final List<PopupConfig> abbPopups = [
    PopupConfig(
      id: 'abb_1',
      dialogue: 'The old building archives need sorting. It\'s dusty work, but historically important!',
      image: 'sirt.png',
      location: 'ABB Building - Archives',
      questTitle: 'Archive Organization',
      questDescription: 'Sort and organize historical documents in the archives',
    ),
    PopupConfig(
      id: 'abb_2',
      dialogue: 'I\'m researching the history of our university. Do you know any interesting stories?',
      image: 'sirt.png',
      location: 'ABB Building - Research Office',
      questTitle: 'University History',
      questDescription: 'Share stories and help with university history research',
    ),
    PopupConfig(
      id: 'abb_3',
      dialogue: 'The administration needs help updating student records. Are you good with data entry?',
      image: 'sirt.png',
      location: 'ABB Building - Records Office',
      questTitle: 'Data Entry Task',
      questDescription: 'Assist with updating student record databases',
    ),
    PopupConfig(
      id: 'abb_4',
      dialogue: 'We\'re planning a campus tour for new students. Would you like to be a tour guide?',
      image: 'sirt.png',
      location: 'ABB Building - Information Desk',
      questTitle: 'Tour Guide Volunteer',
      questDescription: 'Guide new students around the campus',
    ),
    PopupConfig(
      id: 'abb_5',
      dialogue: 'The bulletin board needs updating with new announcements. Can you help post them?',
      image: 'sirt.png',
      location: 'ABB Building - Main Lobby',
      questTitle: 'Bulletin Board Update',
      questDescription: 'Update bulletin boards with new announcements',
    ),
  ];

  static final List<PopupConfig> lsbPopups = [
    PopupConfig(
      id: 'lsb_1',
      dialogue: 'The library needs help cataloging new books. Are you familiar with the dewey decimal system?',
      image: 'sirt.png',
      location: 'LSB Library - Cataloging Department',
      questTitle: 'Book Cataloging',
      questDescription: 'Help catalog and organize new library books',
    ),
    PopupConfig(
      id: 'lsb_2',
      dialogue: 'We\'re hosting a reading marathon event. Would you like to participate or help organize?',
      image: 'sirt.png',
      location: 'LSB Library - Reading Area',
      questTitle: 'Reading Marathon',
      questDescription: 'Participate in or help organize the reading marathon',
    ),
    PopupConfig(
      id: 'lsb_3',
      dialogue: 'The digital archive system crashed. I need someone tech-savvy to help restore it.',
      image: 'sirt.png',
      location: 'LSB Library - Digital Archive',
      questTitle: 'System Recovery',
      questDescription: 'Help restore the digital archive system',
    ),
    PopupConfig(
      id: 'lsb_4',
      dialogue: 'I\'m setting up a quiet study area for finals week. Can you help arrange the furniture?',
      image: 'sirt.png',
      location: 'LSB Library - Study Hall',
      questTitle: 'Study Area Setup',
      questDescription: 'Arrange furniture for the finals week study area',
    ),
    PopupConfig(
      id: 'lsb_5',
      dialogue: 'We need to move rare books to climate-controlled storage. Handle with care!',
      image: 'sirt.png',
      location: 'LSB Library - Rare Books Section',
      questTitle: 'Rare Book Relocation',
      questDescription: 'Carefully move rare books to secure storage',
    ),
  ];

  // Other building popups (1 each for other locations)
  static final List<PopupConfig> otherPopups = [
    PopupConfig(
      id: 'gym_1',
      dialogue: 'The gymnasium equipment needs maintenance. Are you good with sports equipment?',
      image: 'sirt.png',
      location: 'Gymnasium',
      questTitle: 'Equipment Maintenance',
      questDescription: 'Help maintain and repair gymnasium equipment',
    ),
    PopupConfig(
      id: 'canteen_1',
      dialogue: 'We\'re introducing a new healthy menu. Would you like to be a taste tester?',
      image: 'sirt.png',
      location: 'Canteen',
      questTitle: 'Menu Tasting',
      questDescription: 'Test and provide feedback on new healthy menu items',
    ),
    PopupConfig(
      id: 'multimedia_1',
      dialogue: 'The multimedia room projector is acting up. Do you know anything about AV equipment?',
      image: 'sirt.png',
      location: 'Multimedia Room',
      questTitle: 'Projector Repair',
      questDescription: 'Fix the malfunctioning multimedia projector',
    ),
    PopupConfig(
      id: 'classroom_1',
      dialogue: 'I need help setting up chairs for tomorrow\'s lecture. There will be many students!',
      image: 'sirt.png',
      location: 'Classroom',
      questTitle: 'Classroom Setup',
      questDescription: 'Arrange chairs and prepare classroom for lecture',
    ),
    PopupConfig(
      id: 'office_1',
      dialogue: 'Important documents need to be delivered to different departments. Can you help?',
      image: 'sirt.png',
      location: 'Faculty Office',
      questTitle: 'Document Delivery',
      questDescription: 'Deliver important documents to various departments',
    ),
  ];

  /// Get random popup configurations for a specific scene
  static List<PopupConfig> getPopupsForScene(String sceneName, {int? count}) {
    final random = Random();
    List<PopupConfig> sourcePopups;
    int defaultCount;

    // Determine which popup set to use based on scene name
    switch (sceneName.toLowerCase()) {
      case 'gzb':
        sourcePopups = gzbPopups;
        defaultCount = 5;
        break;
      case 'vmb':
        sourcePopups = vmbPopups;
        defaultCount = 5;
        break;
      case 'abb':
        sourcePopups = abbPopups;
        defaultCount = 5;
        break;
      case 'lsb':
        sourcePopups = lsbPopups;
        defaultCount = 5;
        break;
      default:
        sourcePopups = otherPopups;
        defaultCount = 1;
        break;
    }

    final targetCount = count ?? defaultCount;
    
    // If we need more popups than available, return all
    if (targetCount >= sourcePopups.length) {
      return List<PopupConfig>.from(sourcePopups)..shuffle(random);
    }

    // Randomly select the required number of popups
    final shuffledPopups = List<PopupConfig>.from(sourcePopups)..shuffle(random);
    return shuffledPopups.take(targetCount).toList();
  }

  /// Get a random popup configuration from any category
  static PopupConfig getRandomPopup() {
    final random = Random();
    final allPopups = [
      ...gzbPopups,
      ...vmbPopups,
      ...abbPopups,
      ...lsbPopups,
      ...otherPopups,
    ];
    return allPopups[random.nextInt(allPopups.length)];
  }

  /// Get all popup configurations
  static List<PopupConfig> getAllPopups() {
    return [
      ...gzbPopups,
      ...vmbPopups,
      ...abbPopups,
      ...lsbPopups,
      ...otherPopups,
    ];
  }
}
