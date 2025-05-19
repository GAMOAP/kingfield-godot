extends Node

const VOID : int = -1

const GRID_SIZE := Vector2(5, 5)
const CELL_SIZE := Vector2(128, 128)

const NBR_BLOCK_VAR := 3

enum SIDE {USER, OPPONENT}

enum BREEDS {WATER, AIR, GROUND, FIRE, FOREST, MECA, DAY, NIGHT, TIME}

const TEAM : Array = ["side_left", "center_left", "king", "center_right", "side_right"]

const CARDS : Array = ["breed", "job", "helmet", "item", "armor", "move", "spell", "weapon", "object"]

const CHAR : Array = ["front_leg", "back_leg", "armor", "head", "face", "helmet", "hand", "weapon", "arm" ]
