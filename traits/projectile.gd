class_name Projectile
extends Area2D

@onready var c_velocity : VelocityComponent = $VelocityComponent
@onready var m_screen_size = get_viewport_rect().size

@export var speed : float = 300

var m_spawn_direction : Vector2
var m_spawn_position : Vector2

func _ready() -> void:
    position = m_spawn_position
    c_velocity.set_direction(m_spawn_direction)
    c_velocity.velocity_limit = speed
    c_velocity.m_velocity = m_spawn_direction.normalized() * speed


func _physics_process(delta: float) -> void:
    var velocity : Vector2 = c_velocity.get_velocity()
    position += velocity * delta
    position = position.clamp(Vector2.ZERO, m_screen_size)


func _on_life_timeout() -> void:
    queue_free()
