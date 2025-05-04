class_name Projectile
extends Area2D

@onready var c_velocity: VelocityComponent = $VelocityComponent
@onready var m_screen_size = get_viewport_rect().size

@export var rotation_speed: float = 0.1 * PI

var m_spawn_direction: Vector2
var m_spawn_position: Vector2

func _ready() -> void:
    pass

func _physics_process(delta: float) -> void:
    var velocity: Vector2 = c_velocity.get_velocity()
    rotation += rotation_speed * delta
    position += velocity * delta
    # TODO: Make it better later
    if position.x < 0 or position.x > m_screen_size.x or position.y < 0 or position.y > m_screen_size.y:
        queue_free()


func _on_life_timeout() -> void:
    queue_free()

func _on_hurt_box_component_hurt_body(body: Node2D, _damage: float) -> void:
    if (body.is_in_group("enemies")):
        body.queue_free()

func set_direction(direction: Vector2) -> void:
    m_spawn_direction = direction
    c_velocity.set_acceleration_direction(m_spawn_direction)
    rotation = m_spawn_direction.angle()
