# Quest Overlay Sprite Configuration System

This document explains how to use the configurable sprite system for quest overlays.

## Overview

The quest overlay now supports easy configuration of both player and NPC sprites, making it ready for:
- Multiple player outfits/characters
- Different NPCs throughout the map
- Dynamic sprite changes based on game state

## Configuration Classes

### PlayerSpriteConfig
Used for configuring the player character's appearance in quest dialogs.

```dart
PlayerSpriteConfig(
  imagePath: 'sprite_file.png',
  frameIndex: 3,              // Which frame from sprite sheet
  isSpriteSheet: true,        // true for sprite sheets, false for single images
)
```

### NPCSpriteConfig
Used for configuring NPC appearance in quest dialogs.

```dart
NPCSpriteConfig(
  imagePath: 'npc_file.png',
  frameIndex: 0,              // Only used if isSpriteSheet is true
  isSpriteSheet: false,       // true for sprite sheets, false for single images
)
```

## Current Implementation

### GameScreen.dart
The quest overlay is created with sprite configurations:
```dart
QuestOverlay(
  playerSprite: game.getCurrentPlayerSprite(),
  npcSprite: game.getCurrentNPCSprite(),
  // ... other parameters
)
```

### BSUniverseGame.dart
Helper methods provide current sprite configurations:
```dart
PlayerSpriteConfig getCurrentPlayerSprite() {
  return PlayerSpriteConfig.defaultPlayer;
}

NPCSpriteConfig getCurrentNPCSprite() {
  return NPCSpriteConfig.sirtNPC;
}
```

## Predefined Configurations

### Player Sprites
- `PlayerSpriteConfig.defaultPlayer` - Default boy_pe.png sprite
- `PlayerSpriteConfig.uniformOutfit` - Future uniform outfit (to be implemented)
- `PlayerSpriteConfig.casualOutfit` - Future casual outfit (to be implemented)

### NPC Sprites
- `NPCSpriteConfig.sirtNPC` - Current sirt.png NPC
- `NPCSpriteConfig.teacherNPC` - Future teacher NPC (to be implemented)
- `NPCSpriteConfig.studentNPC` - Future student NPC (to be implemented)
- `NPCSpriteConfig.janitorNPC` - Future janitor NPC (to be implemented)

## Future Implementation Steps

### 1. Player Outfit System
When implementing the outfit system:
1. Add outfit tracking variables to the game state
2. Update `getCurrentPlayerSprite()` to return the active outfit configuration
3. Add outfit change methods that update the sprite configuration

### 2. NPC Interaction System
When implementing NPC interactions:
1. Add NPC identification system (NPC IDs, positions, etc.)
2. Update `getCurrentNPCSprite()` to return the interacting NPC's configuration
3. Add quest triggering that passes NPC-specific data to the overlay

### 3. Dynamic Quest Content
The system is ready for:
- NPC-specific questions and answers
- Different quest types per NPC
- Contextual dialogue based on player outfit and NPC type

## Adding New Sprites

### New Player Outfit
1. Add sprite file to `assets/images/`
2. Add new configuration to `PlayerSpriteConfig` static constants
3. Update outfit selection logic in the game

### New NPC
1. Add sprite file to `assets/images/`
2. Add new configuration to `NPCSpriteConfig` static constants
3. Add NPC to interaction system

## Benefits

- **Easy to maintain**: All sprite configurations in one place
- **Future-proof**: Ready for outfit and NPC systems
- **Flexible**: Supports both sprite sheets and single images
- **Type-safe**: Compile-time checking of sprite configurations
- **Extensible**: Easy to add new characters and outfits
