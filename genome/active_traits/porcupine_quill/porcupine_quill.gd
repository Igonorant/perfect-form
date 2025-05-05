@icon("res://assets/traits/porcupine_quill.png")
class_name PorcupineQuill
extends ActiveTrait

@onready var _velocity: VelocityComponent = %VelocityComponent
@onready var _hurt_box: HurtBoxComponent = %HurtBoxComponent
@onready var _life_timer: Timer = %LifeTimer
@onready var _hurt_box_collision_shape: CollisionShape2D = %HurtBoxComponent/CollisionShape2D

@export var damage: Damage

var _is_attached: bool = false
var _attached_body: Node2D = null
var _attached_rotation_variation: float = PI / 12
var _attached_offset: Vector2 = Vector2.ZERO

func _ready() -> void:
    # TODO: update collision mask of hurt box based on friendly variable
    assert(!_direction.is_zero_approx())
    _velocity.set_acceleration_direction(_direction)
    rotation = _direction.angle()
    z_index = -1

    _hurt_box.damage = damage.damage
    _hurt_box.body_hurted.connect(_on_body_hurted)

    _life_timer.timeout.connect(_on_life_timer_timeout)

func _physics_process(delta: float) -> void:
    if _is_attached:
        if _attached_body == null:
            queue_free()
            return
        global_position = _attached_body.global_position + _attached_offset
    else:
        translate(_velocity.get_velocity() * delta)

func _on_life_timer_timeout() -> void:
    queue_free()

func _on_body_hurted(body: Node2D) -> void:
    # Free hurt box and velocity components to stop unnecessary calculations moving forward
    _hurt_box.queue_free()
    _velocity.queue_free()

    # Calculate how to attach the quill to the body
    _attached_body = body
    _is_attached = true
    _calculate_attached_offset()
    # Add some variation to make multiple quills attached to the same body look different
    rotation = _attached_offset.angle() + randf_range(-_attached_rotation_variation, _attached_rotation_variation)

func _calculate_attached_offset() -> void:
    var collision_shape: CollisionShape2D = _attached_body.find_child("CollisionShape2D")
    if collision_shape:
        var body_shape_size := collision_shape.shape.get_rect().size
        var hurt_box_shape_size := _hurt_box_collision_shape.shape.get_rect().size
        _attached_offset = - _direction * body_shape_size * 0.5 - _direction * hurt_box_shape_size.y * 0.35
