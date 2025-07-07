import 'package:bsuniverse/pages/home.dart';
import 'package:flutter/material.dart';

const Color championWhite = Color.fromRGBO(250, 249, 246, 1.0);
const Color pixelGold = Color.fromRGBO(255, 215, 0, 1.0);
const Color lavanderGray = Color.fromRGBO(197, 197, 214, 1.0);
const Color blazingOrange = Color.fromRGBO(255, 106, 0, 1.0);
const Color charcoalBlack = Color.fromRGBO(27, 27, 27, 1.0);
const Color ashMaroon = Color.fromRGBO(110, 14, 21, 1.0);
const Color funRed = Color.fromRGBO(255, 66, 66, 1.0);

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          color: fineRed,
          padding: EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: ashMaroon,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(150, 27, 27, 27),
                      blurRadius: 20,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [

                    SizedBox(height: 10),
                    Text(
                      "Customize your experience",
                      style: TextStyle(
                        fontFamily: 'PixeloidSans',
                        fontSize: 12,
                        color: championWhite,
                      ),
                    ),
                    Text(
                      "Settings",
                      style: TextStyle(
                        fontFamily: 'PixeloidSans-Bold',
                        fontSize: 30,
                        color: championWhite,
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),

              Container(
                decoration: BoxDecoration(
                  color: championWhite,
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(150, 27, 27, 27),
                      blurRadius: 20,
                      spreadRadius: 1,
                      offset: Offset(0, 4),
                    ),
                  ],
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    _buildProfileCard(),
                    _buildSectionHeader("Account"),
                    _buildListTile(
                      Icons.person_outline,
                      "Profile",
                      "View and edit your profile",
                    ),
                    _buildListTile(
                      Icons.star_border,
                      "Achievements",
                      "View your game achievements",
                    ),
                    _buildSectionHeader("Game Settings"),
                    _buildSwitchTile(
                      Icons.volume_up_outlined,
                      "Sound Effects",
                      "Enable or disable sound effects",
                      true,
                    ),
                    _buildListTile(
                      Icons.gamepad_outlined,
                      "Controls",
                      "Customize game controls",
                    ),
                    _buildSwitchTile(
                      Icons.nightlight_round,
                      "Dark Mode",
                      "Switch to dark theme",
                      false,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 22,
            backgroundColor: lavanderGray,
            child: Icon(Icons.person_outline, color: ashMaroon),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Player",
                  style: TextStyle(
                    fontFamily: 'PixeloidSans-Bold',
                    fontSize: 14,
                  ),
                ),
                Text(
                  "Start your adventure today!",
                  style: TextStyle(
                    fontFamily: 'PixeloidSans',
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: funRed,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: const Text(
              "Edit",
              style: TextStyle(
                fontFamily: 'PixeloidSans-Bold',
                fontSize: 12,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        title,
        style: const TextStyle(
          fontFamily: 'PixeloidSans-Bold',
          fontSize: 13,
          color: charcoalBlack,
        ),
      ),
    );
  }

  Widget _buildListTile(IconData icon, String title, String subtitle) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: lavanderGray,
        child: Icon(icon, color: ashMaroon),
      ),
      title: Text(
        title,
        style: const TextStyle(fontFamily: 'PixeloidSans-Bold', fontSize: 13),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontFamily: 'PixeloidSans', fontSize: 11),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
    );
  }

  Widget _buildSwitchTile(
    IconData icon,
    String title,
    String subtitle,
    bool value,
  ) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: lavanderGray,
        child: Icon(icon, color: ashMaroon),
      ),
      title: Text(
        title,
        style: const TextStyle(fontFamily: 'PixeloidSans-Bold', fontSize: 13),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontFamily: 'PixeloidSans', fontSize: 11),
      ),
      trailing: Switch(value: value, activeColor: funRed, onChanged: (val) {}),
    );
  }
}
