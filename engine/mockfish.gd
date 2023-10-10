extends Node
## Primary engine node


var moves : Array[Move]


func _ready() -> void:
	$Movegen.precompute_move_data()
	update_moves()


func get_legal_moves_for_square(square) -> Array[Move]:
	var moves_for_square : Array[Move]
	for move in moves:
		if move.start_square == square:
			moves_for_square.append(move)
	return moves_for_square


func update_moves() -> void:
	moves = $Movegen.generate_moves()
