extends CharacterBody2D

@onready var animation: AnimationPlayer = get_node("Animation")
@onready var texture: Sprite2D = get_node("Texture")
@onready var attack_area_collision: CollisionShape2D = get_node("AttackArea/Collision")
@onready var aux_animation_player: AnimationPlayer = get_node("AuxAnimationPlayer")

@export var move_speed: float = 256.0
@export var damage: int = 1
@export var health: int = 5

var can_attack: bool = true
var can_die: bool = false

func _physics_process(_delta: float) -> void:
	if can_attack == false or can_die:
		return

	move()
	animate()
	attack_handler()

func move() -> void:
	var direction: Vector2 = get_direction()
	velocity = direction * move_speed
	move_and_slide()

func get_direction() -> Vector2:
	return Vector2(
		Input.get_axis("mov_esquerda", "mov_direita"),
		Input.get_axis("mov_cima", "mov_baixo")
	).normalized()

func animate() -> void:
	if velocity.x > 0:
		texture.flip_h = false
		attack_area_collision.position.x = 58

	if velocity.x < 0:
		texture.flip_h = true
		attack_area_collision.position.x = -58

	if velocity != Vector2.ZERO:
		animation.play("run")
		return
	animation.play("idle")

func attack_handler() -> void:
	if Input.is_action_just_pressed("ataque") and can_attack:
		can_attack = false
		animation.play("attack")

func _on_animation_finished(anim_name: String):
	match anim_name:
		"attack":
			can_attack = true
		"death":
			get_tree().reload_current_scene()

func _on_attack_area_body_entered(body) -> void:
	body.update_health(damage)

func update_health(value: int) -> void:
	health -= value
	if health <= 0:
		can_die = true
		animation.play("death")
		attack_area_collision.set_deferred("disabled", true)
		#attack_area_collision.disabled = true
		return
	aux_animation_player.play("hit")
