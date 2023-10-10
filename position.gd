extends Node
## Global-access postition representation and helpers


const START_FEN = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1"
const TEST_FEN = "4n3/n7/7N/8/8/8/5N2/3N4"
const PIECES_FROM_FEN = {
	'p': Piece.PAWN,
	'n': Piece.KNIGHT,
	'b': Piece.BISHOP,
	'r': Piece.ROOK,
	'q': Piece.QUEEN,
	'k': Piece.KING,
}

var board : Array[int]
var color_to_move : int = Piece.WHITE
var ep_target_square : int


func _ready() -> void:
	# Read from FEN
	board = _fen_to_int(TEST_FEN)
	_pretty_print_board()


func make_move(move:Move) -> void:
	board[move.end_square] = board[move.start_square]
	board[move.start_square] = Piece.NONE
	color_to_move = Piece.BLACK if color_to_move == Piece.WHITE else Piece.WHITE
	_pretty_print_board()


func _fen_to_int(fen_str: String) -> Array:
	var int_board: Array[int]
	var parts = fen_str.split(" ")
	parts = parts[0].split("/")

	var p : int = 7
	while p > -1:
		for char in parts[p]:
			if char.is_valid_int():
				for i in range(0, char.to_int()):
					int_board.append(Piece.NONE)
					continue
			else:
				var piece_color : int
				if _is_upper(char):
					piece_color = Piece.WHITE
				else:
					piece_color = Piece.BLACK
				var piece_type : int = PIECES_FROM_FEN[char.to_lower()]
				int_board.append(piece_color | piece_type)
		p -= 1

	return int_board


func _is_upper(str: String):
	if str.to_upper() == str:
		return true
	if str.to_lower() == str:
		return false


func _pretty_print_board() -> void:
	var pretty_board : Array
	# Get rows
	var i = 0
	var rows : Array[Array]
	for r in range(0, 8):
		rows.append(board.slice(i, i+8))
		i += 8
	# Reverse and clean rows
	rows.reverse()
	for row in rows:
		for square in row:
			if square == 0:
				pretty_board.append("")
			elif square == 9:
				pretty_board.append(99)
			else:
				pretty_board.append(square)
	# Print rows
	print("\n")
	i = 0
	while i < 63:
		print(pretty_board.slice(i, i+8), "\n")
		i += 8
