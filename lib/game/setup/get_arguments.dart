

//  TO BE MOVED SO EVERYONE CAN ACCESS!
import 'package:bsuniverse/game/bsuniverse.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
// import collisions?

void loopThroughPortals(List<Portal> portals,TiledComponent map) {
   for (final portal in portals) {
    final arguments = getArguments(map, portal);
    map.add(
      portal
        ..size = arguments[0]
        ..position = arguments[1],
    );
  }
}

List<Vector2> getArguments(TiledComponent map, Portal portal) {
  Vector2 size = Vector2.zero();
  Vector2 position = Vector2.zero();

  // FOR IN OR OUT PORTAL ONLY
  if (portal.selection.getActivePortals()[0] == 'out' ||
      'in' == portal.selection.getActivePortals()[0]) {
    size = Vector2(
      map.tileMap
          .getLayer<ObjectGroup>(portal.selection.getActivePortals()[0])!
          .objects
          .first
          .width,
      map.tileMap
          .getLayer<ObjectGroup>(portal.selection.getActivePortals()[0])!
          .objects
          .first
          .height,
    );
    position = Vector2(
      map.tileMap
          .getLayer<ObjectGroup>(portal.selection.getActivePortals()[0])!
          .objects
          .first
          .x,
      map.tileMap
          .getLayer<ObjectGroup>(portal.selection.getActivePortals()[0])!
          .objects
          .first
          .y,
    );
    return [size,position];
  }
  
  final popupsGroup = map.tileMap.getLayer<Group>('RoomPortals');
  // IN MAP, only 1 Floor (floor1) AND rooms d1-d7.
  ObjectGroup? floor;
  TiledObject? room;
  if (popupsGroup != null) {
    switch (portal.selection.getActivePortals()[0]) {
      case '1st':
        floor =
            popupsGroup.layers.firstWhere(
                  (layer) => layer is ObjectGroup && layer.name == '1st',
                )
                as ObjectGroup;
        break;
      case '2nd':
        floor =
            popupsGroup.layers.firstWhere(
                  (layer) => layer is ObjectGroup && layer.name == '2nd',
                )
                as ObjectGroup;
        break;
      case '3rd':
        floor =
            popupsGroup.layers.firstWhere(
                  (layer) => layer is ObjectGroup && layer.name == '3rd',
                )
                as ObjectGroup;
        break;
      case '4th':
        floor =
            popupsGroup.layers.firstWhere(
                  (layer) => layer is ObjectGroup && layer.name == '4th',
                )
                as ObjectGroup;
        break;
      case '5th':
        floor =
            popupsGroup.layers.firstWhere(
                  (layer) => layer is ObjectGroup && layer.name == '5th',
                )
                as ObjectGroup;
        break;
      default:
        break;
    }

    switch (portal.selection.getActivePortals()[1]) {
      case 'd1':
        room = floor?.objects.firstWhere((obj) => obj.name == 'd1');
        break;
      case 'd2':
        room = floor?.objects.firstWhere((obj) => obj.name == 'd2');
        break;
      case 'd3':
        room = floor?.objects.firstWhere((obj) => obj.name == 'd3');
        break;
      case 'd4':
        room = floor?.objects.firstWhere((obj) => obj.name == 'd4');
        break;
      case 'd5':
        room = floor?.objects.firstWhere((obj) => obj.name == 'd5');
        break;
      case 'd6':
        room = floor?.objects.firstWhere((obj) => obj.name == 'd6');
        break;
      case 'd7':
        room = floor?.objects.firstWhere((obj) => obj.name == 'd7');
        break;
      case 'd8':
        room = floor?.objects.firstWhere((obj) => obj.name == 'd8');
        break;
      case 'd9':
        room = floor?.objects.firstWhere((obj) => obj.name == 'd9');
        break;
      case 'd10':
        room = floor?.objects.firstWhere((obj) => obj.name == 'd10');
        break;
      case 'none':
        break;
      default:
        break;
    }

    if (room != null) {
      size = Vector2(room.width, room.height);
      position = Vector2(room.x, room.y);
    }
  }
  return [size, position];
}
