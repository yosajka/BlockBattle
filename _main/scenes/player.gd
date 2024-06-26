class_name Player
extends Area2D

@export var health_component: HealthComponent
@export var game_over: Control
@export var victory: Control

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var state_machine: AnimationNodeStateMachinePlayback = animation_tree.get("parameters/playback")
@onready var animation_player: AnimationPlayer = $AnimationPlayer

signal action_completed()
signal receive_damage()
signal dead()

func _ready() -> void:
	receive_damage.connect(func(): state_machine.travel("hit"))
	health_component.health_depleted.connect(die)
	
func attack(target: Enemy, damage: float) -> void:
	state_machine.travel("attack")
	target.health_component.decrease_health(damage)
	
	if damage > 0:
		target.receive_damage.emit()
		
func attack_aoe(targets: Array[Enemy], damage: float) -> void:
	state_machine.travel("attack")
	for target in targets:
		target.health_component.decrease_health(damage)
		if damage > 0:
			target.receive_damage.emit()
	
func heal(amount: float) -> void:
	health_component.increase_health(amount)
	
func shield_up(amount: float) -> void:
	health_component.increase_armor(amount)
	
	
func new_turn() -> void:
	pass
	
func die() -> void:
	game_over.visible = true
	dead.emit()
