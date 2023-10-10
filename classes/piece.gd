extends Node
## Abstract elements of chess pieces


const NONE : int = 0
const PAWN : int = 1
const KNIGHT : int = 2
const BISHOP : int = 3
const ROOK : int = 4
const QUEEN : int = 5
const KING : int = 6
const WHITE : int = 8
const BLACK : int = 16
## Bitmask for extracting the type from a given piece
const TYPE_MASK : int = 0b00111
## Bitmask for extracting the color from a given piece
const COLOR_MASK : int = 0b11000


## Return the color of the given piece as a string
static func get_color(piece:int) -> int:
	return piece & COLOR_MASK


## Return the type (pawn, knight, king, etc) of the given piece
static func get_type(piece:int) -> int:
	return piece & TYPE_MASK
