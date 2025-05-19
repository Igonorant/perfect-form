@icon("res://assets/icons/icon_player.png")
class_name Player
extends CharacterBody2D

@export var status: StatusRes

@onready var _move = %Move
@onready var _brain = %PlayerBrain

func _ready() -> void:
    _move.load(status)

func _physics_process(delta: float) -> void:
    _move.execute(self, _brain.get_move_direction(), delta)