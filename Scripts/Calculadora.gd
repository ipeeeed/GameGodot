extends Control

@onready var display_text: Label = get_node("Background/Display/Text")
var num1: String
var num2: String
var operador: String = ""
var indiceNumAtual: int = 0

func _ready():
	display_text.text = "0"
	for button in get_tree().get_nodes_in_group("button"):
		button.pressed.connect(botao_pressionado.bind(button.name))
		#button.connect("pressed", Callable(self, "botao_pressionado"))

func botao_pressionado(nomeBotao: String) -> void:
	match nomeBotao:
		"Reset":
			reset(true)
		"=":
			var valor1: int = int(num1)
			var valor2: int = int(num2)
			var result:int = 0

			match operador:
				"+":
					result = valor1 + valor2
				"-":
					result = valor1 - valor2
				"*":
					result = valor1 * valor2
				"/":
					@warning_ignore("integer_division")
					result = valor1 / valor2

			display_text.text = str(result)
			reset()
		"soma":
			change_operator("+")
		"sub":
			change_operator("-")
		"div":
			change_operator("/")
		"mult":
			change_operator("*")
		_:
			if indiceNumAtual == 0:
				num1 += nomeBotao

				if operador == "":
					display_text.text = num1

			if indiceNumAtual == 1:
				num2 += nomeBotao
				display_text.text = num1 + " " + operador + " " + num2

	print(nomeBotao)

func change_operator(sig: String) -> void:
	if num1 == "" or operador != "":
		return
	operador = sig
	indiceNumAtual = 1
	display_text.text = num1 + " " + operador

func reset(is_reseting: bool = false) -> void:
	num1 = ""
	num2 = ""
	operador = ""
	indiceNumAtual = 0
	
	if is_reseting:
		display_text.text = "0"
