extends KinematicBody2D

onready var Hitbox = $Hitbox
onready var health = health

signal entity_damage(entity)

export (float) var damage_amount = 1

var exceptions = []

func add_exception(node : Node):
	exceptions.append(node)
	
func remove_exception(node : Node):
	exceptions.erase(node)

