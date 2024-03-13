extends Control

func _ready() -> void:
	for button in get_tree().get_nodes_in_group("button"):
		button.pressed.connect(on_button_pressed.bind(button.name))

func on_button_pressed(button_name: String) -> void:
	match button_name:
		"NovoJogo":
			transition_screen.scene_path = "res://Scenes/level1.tscn"
			transition_screen.fade_in()

		"Sair":
			transition_screen.can_quit = true
			transition_screen.fade_in()
