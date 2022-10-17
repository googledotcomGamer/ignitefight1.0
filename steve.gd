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
	$ProgressBar.value = health
	
func damage(amount):
	health += -20
	$AnimationPlayer.play("DamageTaken")
	$AnimationPlayer.queue("immune")
	kill()

func kill():
	if health == 0:
		get_tree().change_scene("res://kentrupwin.tscn")

func _set_health(value):
	var prev_health = health
	health = clamp(value, 0, max_health)
	if health != prev_health:
		emit_signal("health_updated", health)
		if health == 0:
			kill()

var shooting = false

func walk():
	if velocity.x != 0:
		$AnimationPlayer.play("brown_walk")

func attack():
	shooting = true
	$AnimationPlayer.play("brown_attack")
	shooting = false

func _physics_process(delta):
	if Input.is_action_pressed("p1right"):
		velocity.x = SPEED
	
	if Input.is_action_pressed("p1left"):
		velocity.x = -SPEED
		
	if Input.is_action_just_pressed("p1left") and self.scale.x == 1:
		self.scale.x *= -1
	
	if Input.is_action_just_pressed("p1right") and self.scale.x != 1:
		self.scale.x *= 1
		
	if Input.is_action_just_pressed("p1attack"):
		attack()
	
	if Input.is_action_pressed("p1right"):
		pass
		
	if Input.is_action_pressed("p1left"):
		pass
		
	velocity.y = velocity.y + GRAVITY
	
	if Input.is_action_just_pressed("p1jump") and is_on_floor():
		velocity.y = JUMPFORCE
		
	velocity = move_and_slide(velocity,Vector2.UP)
	
	velocity.x = lerp(velocity.x,0,0.2)
	






func _on_Area2D_body_entered(KinematicBody2D):
	print("hello world!")
	if KinematicBody2D.name == "gobot":
		KinematicBody2D.damage(10)
