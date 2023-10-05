extends Control
## Handles GUI highlighting of squares in different contexts


var highlights : Array[Array] # (square, color)


func _draw() -> void:
	if len(highlights) > 0:
		# Draw highlights
		for square in highlights:
			var coords := Vector2((square[0] % 8) * 64, (square[0] / 8) * 64)
			var rect := Rect2(coords.x, coords.y, 64, 64)
			draw_rect(rect, square[1], true)


func add_highlight(square: int, color:Color) -> void:
	highlights.append([square, color])
	queue_redraw()


func remove_highlight(square: int) -> void:
	for highlight in highlights:
		if highlight.has(square):
			highlights.erase(highlight)
	queue_redraw()
