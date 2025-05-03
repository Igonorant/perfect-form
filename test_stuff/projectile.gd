class_name Projectile
extends Area2D

@onready var c_velocity: VelocityComponent = $VelocityComponent
@onready var m_screen_size = get_viewport_rect().size

@export var speed: float = 300
@export var rotation_speed: float = 0.1 * PI

@export var destroy_on_hit: bool

var m_spawn_direction: Vector2
var m_spawn_position: Vector2
var m_effect: Node2D

func _ready() -> void:
    position = m_spawn_position
    rotation = m_spawn_direction.angle()
    c_velocity.set_direction(m_spawn_direction)
    c_velocity.set_velocity(m_spawn_direction.normalized() * speed)
    m_effect = get_node_or_null("ShakingLightningEffect")
    if (m_effect):
        m_effect.rotation = randf_range(0.0, TAU)


func _physics_process(delta: float) -> void:
    var velocity: Vector2 = c_velocity.get_velocity()
    position += velocity * delta
    position = position.clamp(Vector2.ZERO, m_screen_size)
    rotation += rotation_speed * delta


func _on_life_timeout() -> void:
    queue_free()

func _on_hurt_box_component_hurt_body(body: Node2D, _damage: float) -> void:
    if (body.is_in_group("enemies")):
        body.queue_free()
        if (destroy_on_hit):
            queue_free()
