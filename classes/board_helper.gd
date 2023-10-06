class_name BoardHelper
extends Node



## Calculate square index given coords
static func get_square_from_coords(pos:Vector2) -> int:
	return ((pos.x - 32) / 64) + (448 - (pos.y - 32)) / 8


## Calculate coords given square index
static func get_coords_from_square(square: int) -> Vector2:
	return Vector2(
		(square % 8) * 64 + 32,
		448 - (square / 8) * 64 + 32
	)
