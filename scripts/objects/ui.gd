extends CanvasLayer

@onready var win_screen: Control = $WinScreen

func show_win_screen(flag: bool):
	win_screen.visible = flag
