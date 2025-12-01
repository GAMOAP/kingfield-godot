extends Node

const ADMIN_ID := "3c1485bf-c58c-4f11-b602-1df56fff3076"

const VOID : int = -1

const GRID_SIZE := Vector2(5, 5)
const CELL_SIZE := Vector2(128.0, 128.0)

const NBR_BLOCK_VAR := 3

enum SIDE {USER, OPPONENT}

enum SCENES {CONNECTION, HOME, SETTINGS, BARRACK, TRAINING, MATCH}

enum CONTAINER {NONE, LIBRARY, DECK}

enum BREEDS {WATER, AIR, GROUND, FIRE, FOREST, MECA, DAY, NIGHT, TIME}
enum ASC_BREEDS {}

enum CARD_TYPE {BREED, JOB, HELMET, ITEM, ARMOR, MOVE, SPELL, WEAPON, OBJECT}

enum SLOTS {
	VOID = 0,
	CRYSTAL_BLUE = 1, CRYSTAL_RED, LIFE, DEFENSE, ATTACK, CRYSTAL_MOVE, CRYSTAL_SPELL, CRYSTAL_WEAPON, CRYSTAL_OBJECT,
	MOVE = 10, STRIKE, HEALTH, CRYSTAL_BREAK, GIVE_XP,
	ATTACK_MORE = 20, ATTACK_LESS, DEFENSE_MORE, DEFENSE_LESS, BLOCK, SLEEP, POISON,
	};

const TEAM : Array = ["side_left", "center_left", "king", "center_right", "side_right"]

const CARDS : Array = ["breed", "job", "helmet", "item", "armor", "move", "spell", "weapon", "object"]

const CHAR : Array = ["front_leg", "back_leg", "armor", "head", "face", "helmet", "hand", "weapon", "arm" ]

const LEVEL : Array = [4, 8, 12]

#VARIABLES
var scene_selected = null
var char_selected = null
var card_selected = null
var block_selected = null
