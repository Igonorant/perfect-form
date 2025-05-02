class_name Enemy
extends CharacterBody2D

@onready var c_velocity: VelocityComponent = $VelocityComponent

var m_target: Node2D

func _ready() -> void:
    pass

func _physics_process(_delta: float) -> void:
    c_velocity.set_direction(m_target.global_position - global_position)
    velocity = c_velocity.get_velocity()
    move_and_slide()

func set_target(target: Node2D) -> void:
    m_target = target

func get_hurt_box() -> HurtBoxComponent:
    return $HurtBoxComponent
