extends Node
## Primary engine node


var moves : Array[Move]


func _ready() -> void:
	moves = $Movegen.generate_moves()
	var move : Move = moves[0]
	print("\n",[move.start_square, move.end_square, move.result])
	var test_board = Position.board
	test_board[move.end_square] = test_board[move.start_square]
	test_board[move.start_square] = 0
	Position.pretty_print_board(test_board)


func get_legal_moves_for_square(square) -> Array[Move]:
	var moves_for_square : Array[Move]
	for move in moves:
		if move.start_square == square:
			moves_for_square.append(move)
	return moves_for_square
