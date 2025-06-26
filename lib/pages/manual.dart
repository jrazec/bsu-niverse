import 'package:flutter/material.dart';
import '../widgets/title_desc.dart';

final Color championWhite = Color.fromRGBO(250, 249, 246, 1.0);
final Color pixelGold = Color.fromRGBO(255, 215, 0, 1.0);
final Color lavanderGray = Color.fromRGBO(197, 197, 214, 1.0);
final Color blazingOrange = Color.fromRGBO(255, 106, 0, 1.0);
final Color charcoalBlack = Color.fromRGBO(27, 27, 27, 1.0);
final Color ashMaroon = Color.fromRGBO(110, 14, 21, 1.0);
final Color fineRed = Color.fromRGBO(201, 33, 30, 1.0);

class Manual extends StatefulWidget {
  const Manual({super.key});

  @override
  State<Manual> createState() => _ManualState();
}

class _ManualState extends State<Manual> {
  @override
  Widget build(BuildContext context) {
    final List departments = [
      {
        "subTitle": "College of Accountancy, Business and Economics",
        "description":
            "The College of Accountancy, Business and Economics aims to develop a well-rounded graduate attuned to the promotion of a national identity imbued with moral integrity, spiritual vigor, utmost concern for environmental protection and conservation, and credible and relevant ideals in the pursuit and furtherance of the chosen profession.",
        "image": Image.asset('assets/images/cics.png'),
        "colorInput": ashMaroon,
        "fontSizeInput": 20.0,
        "fontWeightInput": FontWeight.bold,
      },
      {
        "subTitle": "College of Arts and Sciences",
        "description":
            "The College aims to provide exemplary leadership essential to the education of proficient and humane professionals in the arts and sciences.",
        "image": Image.asset('assets/images/cics.png'),
        "colorInput": ashMaroon,
        "fontSizeInput": 20.0,
        "fontWeightInput": FontWeight.bold,
      },
      {
        "subTitle": "College of Engineering",
        "description":
            "The College of Engineering aims to develop a well-rounded graduate imbued with moral and ethical values, spiritual vigor, and utmost concern for the environment as integral parts of furtherance of a chosen profession.",
        "image": Image.asset('assets/images/cics.png'),
        "colorInput": ashMaroon,
        "fontSizeInput": 20.0,
        "fontWeightInput": FontWeight.bold,
      },
      {
        "subTitle": "College of Engineering Technology",
        "description":
            "The College of Industrial Technology is the first college established in the university, and has since proven to be a premier producer of well-rounded and globally competitive professionals who meet local, national, and international demands for skilled workers who significantly contribute to the manpower resources in response to the rapid industrialization of the modern world.",
        "image": Image.asset('assets/images/cics.png'),
        "colorInput": ashMaroon,
        "fontSizeInput": 20.0,
        "fontWeightInput": FontWeight.bold,
      },
      {
        "subTitle": "College of Informatics and Computing Sciences",
        "description":
            "The College of Informatics and Computing Sciences offers ITE graduate and undergraduate programs, facilitated by highly competent faculty members catering to over 2,000 Information Technology and Computer Science students. The college focuses on the technical aspects and real-world applications of artificial intelligence, machine learning, deep learning, and security.",
        "image": Image.asset('assets/images/cics.png'),
        "colorInput": ashMaroon,
        "fontSizeInput": 20.0,
        "fontWeightInput": FontWeight.bold,
      },
      {
        "subTitle": "College of Teacher Education",
        "description":
            "The College of Teacher Education endeavors to produce well-rounded academicians who possess technical, pedagogical and research skills in order to address the challenges of diverse educational settings and engage in lifelong learning.",
        "image": Image.asset('assets/images/cics.png'),
        "colorInput": ashMaroon,
        "fontSizeInput": 20.0,
        "fontWeightInput": FontWeight.bold,
      },
    ];

    return ListView(
      children: [
        Container(
          padding: EdgeInsets.all(12),
          color: fineRed,
          alignment: Alignment.center,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
                child: Text(
                  "ABOUT BSU LIPA",
                  style: TextStyle(
                    fontFamily: 'VT323',
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                    color: championWhite,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Color.fromRGBO(255, 252, 252, 0.8),
                    width: 4,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  color: Color.fromRGBO(255, 252, 252, 0.5),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  child: Image.asset(
                    'assets/images/bsu_lipa.png',
                    width: 350,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 40, 0, 0),
                padding: EdgeInsets.only(left: 25, right: 25),
                child: Text(
                  'Batangas State University, The National Engineering University Lipa, previously named as Don Claro M. Recto Campus, stands in a first-class City of Lipa in the province known for its religious and heritage sites, notable attractions, and landmarks that prides itself as one of the most prominent economic and commercial areas in Batangas.',
                  style: TextStyle(
                    fontFamily: 'PixeloidSans',
                    fontSize: 14,
                    color: championWhite,
                  ),
                  textAlign: TextAlign.justify,
                ),
              ),
              Column(
                children: departments
                    .map(
                      (dep) => Container(
                        margin: EdgeInsets.only(top:50),
                        child: TitleDesc(
                          description: dep["description"],
                          subTitle: dep["subTitle"],
                          image: dep["image"],
                          fontSizeInput: dep["fontSizeInput"],
                          colorInput: dep["colorInput"],
                          fontWeightInput: dep["fontWeightInput"],
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
