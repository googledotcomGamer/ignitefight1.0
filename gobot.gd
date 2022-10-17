extends KinematicBody2D

signal health_updated(health)
signal killed()

var velocity = Vector2 (0,0)
const SPEED = 180
const GRAVITY = 30
const JUMPFORCE = -900

export (float) var max_health = 100

onready var health = max_health

export (Color) var healthy_color = Color.green
export (Color) var caution_color = Color.yellow
export (Color) var danger_color = Color.red
export (float, 0 , 1, 0.05) var caution_zone = 0.05
export (float, 0 , 1, 0.05) var danger_zone = 0.02

func _process(_delta):
	$ProgressBar2.value = health

func damage(amount):
	health += -10
	$AnimationPlayer.play("damage")
	kill()

func kill():
	if health == 0:
		get_tree().change_scene("res://brownwin.tscn")

func _set_health(value):
	var prev_health = health
	health = clamp(value, 0, max_health)
	if health != prev_health:
		emit_signal("health_updated", health)
		if health == 0:
			kill()

var shooting = false

func walk():
	if not shooting:
		$AnimationPlayer.play("walk")

func attack():
	shooting = true
	$AnimationPlayer.play("attack")
	shooting = false

func _physics_process(delta):
	if Input.is_action_pressed("p2right"):
		velocity.x = SPEED
	
	if Input.is_action_pressed("p2left"):
		velocity.x = -SPEED
		
	if Input.is_action_just_pressed("p2left") and self.scale.x == 1:
		self.scale.x *= -1
	
	if Input.is_action_just_pressed("p2right") and self.scale.x == -1:
		self.scale.x *= -1
		
	if Input.is_action_just_pressed("p2attack"):
		attack()
	
	if Input.is_action_pressed("p2right"):
		pass
		
	if Input.is_action_pressed("p2left"):
		pass
		
	velocity.y = velocity.y + GRAVITY
	
	if Input.is_action_just_pressed("p2jump") and is_on_floor():
		velocity.y = JUMPFORCE
		
	velocity = move_and_slide(velocity,Vector2.UP)
	
	velocity.x = lerp(velocity.x,0,0.2)
	


func _on_Area2D_body_entered(KinematicBody2D):
	print("hello world!")
	if KinematicBody2D.name == "steve":
		KinematicBody2D.damage(10)
