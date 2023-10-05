extends Control


@export var light_color := Color("e1dac0")
@export var dark_color := Color("4a72ab")


func _draw():
	_create_board()


func _create_board():
	for r in range(0,8):
		for f in range(0,8):
			var square_color: Color
			if (r + f) % 2 != 0:
				square_color = dark_color
			else:
				square_color = light_color
			var square_rect := Rect2(64*f, 64*r, 64, 64)
			draw_rect(square_rect,square_color,true)
