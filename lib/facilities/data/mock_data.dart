import 'facility_models.dart';

final List<Building> mockBuildings = [
  Building(
    id: 'facade',
    name: 'Facade',
    shortName: 'Gateway to BSU!',
    image: 'assets/images/facade.png',
    floors: [
      Floor(
        name: 'Facade',
        image: 'assets/images/facade.png',
        rooms: [Room(name: 'Facade Area')],
      ),
    ],
  ),
  Building(
    id: 'lsb',
    name: 'Leonor Solis Building',
    shortName: 'LSB',
    image: 'assets/images/comlab-cecs.png',
    floors: [
      Floor(
        name: '1st Floor',
        image: 'assets/images/classroom cecs-heb.png',
        rooms: [
          Room(name: 'Testing and Admission Office'),
          Room(name: 'Budget Office'),
          Room(name: 'Cashier\'s Office'),
          Room(name: 'Accounting Office 1'),
          Room(name: 'Accounting Office 2'),
          Room(name: 'Registrar\'s Office'),
        ],
      ),
      Floor(
        name: '2nd Floor',
        image: 'assets/images/classroom cecs-heb.png',
        rooms: [
          Room(name: 'Office of the Chancellor'),
          Room(
            name:
                'Office of the Vice Chancellor for Development and External Affairs',
          ),
          Room(name: 'Office of the Vice Chancellor for Admin and Finance'),
        ],
      ),
      Floor(
        name: '3rd Floor',
        image: 'assets/images/classroom cecs-heb.png',
        rooms: [
          Room(
            name:
                'Office of the Vice Chancellor for Resource Development and Extension Services',
          ),
          Room(name: 'Human Resource Management Office'),
          Room(name: 'COA Office'),
          Room(name: 'ICT Office'),
          Room(name: 'Speech Lab'),
        ],
      ),
      Floor(
        name: '4th Floor',
        image: 'assets/images/classroom cecs-heb.png',
        rooms: [
          Room(name: 'CICS Office'),
          Room(name: 'Procurement Office/ICT Office'),
          Room(name: 'Records Management Office'),
          Room(name: 'Property and Supply Office/Storage'),
          Room(
            name: 'Project and Facilites Management Office/Environmental Unit',
          ),
        ],
      ),
      Floor(
        name: '5th Floor',
        image: 'assets/images/comlab-cecs.png',
        rooms: [
          Room(
            name: 'Computer Laboratory 1/SSC/Publication',
            image: 'assets/images/comlab-cecs2.png',
          ),
          Room(name: 'Computer Laboratory 2'),
          Room(name: 'Chemistry Laboratory'),
        ],
      ),
    ],
  ),
  Building(
    id: 'vmb',
    name: 'Valerio Malabanan Building',
    shortName: 'VMB',
    image: 'assets/images/comlabheb.png',
    floors: [
      Floor(
        name: '1st Floor',
        image: 'assets/images/mappreview.png',
        rooms: [
          Room(
            name: 'Psychology Laboratory',
            image: 'assets/images/classroom cecs-heb.png',
          ),
          Room(name: 'Electrical Technology Laboratory'),
          Room(name: 'General Service Office/Storage'),
          Room(name: 'Physics Laboratory'),
          Room(name: 'Biology Laboratory'),
          Room(name: 'Dean\'s Office (CTE)'),
          Room(name: 'Sports Office'),
        ],
      ),
      Floor(
        name: '2nd Floor',
        image: 'assets/images/classroom cecs-heb.png',
        rooms: [
          Room(name: 'Dean\'s Office (OVCAA)'),
          Room(name: 'Accreditation Room'),
          Room(name: 'Faculty Room 2'),
          Room(name: 'Faculty Lounge'),
          Room(name: 'Faculty Room 1'),
          Room(name: 'Dean\'s Office (CIT)'),
        ],
      ),
      Floor(
        name: '3rd Floor',
        image: 'assets/images/classroom cecs-heb.png',
        rooms: [
          Room(
            name: 'Computer Laboratory 1',
            image: 'assets/images/comlabheb.png',
          ),
          Room(
            name: 'Computer Laboratory 2',
            image: 'assets/images/comlabheb.png',
          ),
          Room(name: 'Production Laboratory'),
          Room(name: 'VMB 302'),
          Room(name: 'VMB 303'),
          Room(name: 'OJT/SOA'),
        ],
      ),
      Floor(
        name: '4th Floor',
        image: 'assets/images/classroom cecs-heb.png',
        rooms: [
          Room(name: 'VMB 401'),
          Room(name: 'VMB 402'),
          Room(name: 'VMB 403'),
          Room(name: 'VMB 404'),
          Room(name: 'VMB 405'),
          Room(name: 'Dean\'s Office (CE)'),
        ],
      ),
      Floor(
        name: '5th Floor',
        image: 'assets/images/classroom cecs-heb.png',
        rooms: [
          Room(name: 'VMB 501'),
          Room(name: 'VMB 502'),
          Room(name: 'VMB 503'),
          Room(name: 'Multipurpose 1'),
          Room(name: 'Multipurpose 2'),
        ],
      ),
    ],
  ),
  Building(
    id: 'gzb',
    name: 'Gregorio Zara Building',
    shortName: 'GZB',
    image: 'assets/images/canteenldc.png',
    floors: [
      Floor(
        name: '1st Floor',
        image: 'assets/images/canteenldc.png',
        rooms: [
          Room(name: 'Canteen'),
          Room(name: 'Resource Generation Office'),
        ],
      ),
      Floor(
        name: '2nd Floor',
        image: 'assets/images/classroom-ldc.png',
        rooms: [
          Room(name: 'GZB 201'),
          Room(name: 'GZB 202'),
          Room(name: 'GZB 203'),
          Room(name: 'GZB 204'),
          Room(name: 'GZB 205'),
          Room(name: 'Dean Office (CAS)'),
        ],
      ),
      Floor(
        name: '3rd Floor',
        image: 'assets/images/classroom-ldc.png',
        rooms: [
          Room(name: 'GZB 301'),
          Room(name: 'GZB 302'),
          Room(name: 'GZB 303'),
          Room(name: 'GZB 304'),
          Room(name: 'GZB 305'),
          Room(name: 'NSTP/OSD'),
        ],
      ),
    ],
  ),
  Building(
    id: 'abb',
    name: 'Andres Bonifacio Building',
    shortName: 'ABB',
    image: 'assets/images/libr.png',
    floors: [
      Floor(
        name: '1st Floor',
        image: 'assets/images/classroom-ob.png',
        rooms: [
          Room(
            name: 'Music/Dance Studio',
            image: 'assets/images/classroom-ob.png',
          ),
          Room(name: 'ABB 101', image: 'assets/images/classroom-ob.png'),
          Room(name: 'ABB 102', image: 'assets/images/classroom-ob.png'),
          Room(name: 'ABB 103', image: 'assets/images/classroom-ob.png'),
          Room(name: 'ABB 104', image: 'assets/images/classroom-ob.png'),
        ],
      ),
      Floor(
        name: '2nd Floor',
        image: 'assets/images/classroom-ob.png',
        rooms: [
          Room(name: 'Clinic', image: 'assets/images/classroom-ob.png'),
          Room(name: 'ABB 201', image: 'assets/images/classroom-ob.png'),
          Room(name: 'ABB 202', image: 'assets/images/classroom-ob.png'),
          Room(name: 'ABB 203', image: 'assets/images/classroom-ob.png'),
        ],
      ),
      Floor(
        name: '3rd Floor',
        image: 'assets/images/classroom-ob.png',
        rooms: [
          Room(name: 'Dean\'s Office (CABE)'),
          Room(name: 'ABB 301'),
          Room(name: 'ABB 302'),
          Room(name: 'Electrical Laboratory'),
          Room(name: 'Computer Laboratory 1'),
        ],
      ),
      Floor(
        name: '4th Floor',
        image: 'assets/images/classroom-ob.png',
        rooms: [
          Room(name: 'Guidance Office'),
          Room(name: 'ABB 401'),
          Room(name: 'ABB 402'),
          Room(name: 'ABB 403'),
          Room(name: 'ABB 404'),
        ],
      ),
      Floor(
        name: '5th Floor',
        image: 'assets/images/libr.png',
        rooms: [Room(name: 'Library')],
      ),
    ],
  ),
  Building(
    id: 'gymn',
    name: 'Gymnasium',
    shortName: 'Gymn',
    image: 'assets/images/courtss.png',
    floors: [
      Floor(
        name: 'Gymnasium',
        image: 'assets/images/courtss.png',
        rooms: [Room(name: 'Gymnasium')],
      ),
    ],
  ),
];
