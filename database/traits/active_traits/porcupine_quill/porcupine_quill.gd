@icon("res://assets/traits/porcupine_quill.png")
class_name PorcupineQuill
extends TraitInterface

@export var _trait: Trait

@onready var _velocity: VelocityComponent = %VelocityComponent
@onready var _hurt_box: HurtBoxComponent = %HurtBoxComponent
@onready var _life_timer: Timer = %LifeTimer

@onready var _attached_timer: Timer = %AttachedTimer

var _direction: Vector2 = Vector2.ZERO
var _is_attached: bool = false
var _attached_body: Node2D = null
var _attached_rotation_variation: float = PI / 18
var _attached_offset: Vector2 = Vector2.ZERO
var _is_forked: bool = false
var _has_pierce_modifier: bool = false

##### BEGIN INTERFACE IMPLEMENTATION #####

func set_spawn_info(spawn_info: SpawnInfo) -> void:
    global_position = spawn_info.spawn_position
    _direction = spawn_info.spawn_direction.normalized()
    _is_forked = spawn_info.is_forked
    _has_pierce_modifier = spawn_info.has_pierce_modifier

func connect_on_body_hurted(callable: Callable) -> void:
    _hurt_box.body_hurted.connect(callable)

func is_forked() -> bool:
    return _is_forked

func has_pierce_modifier() -> bool:
    return _has_pierce_modifier

func get_hurtbox() -> HurtBoxComponent:
    return _hurt_box

func set_direction(direction: Vector2) -> void:
    _direction = direction

func get_direction() -> Vector2:
    return _direction

##### END INTERFACE IMPLEMENTATION #####

func _ready() -> void:
    super ()
    assert(!_direction.is_zero_approx() and _direction.is_normalized())
    z_index = -1

    _velocity.set_acceleration_direction(_direction)
    rotation = _direction.angle()

    _hurt_box.damages = _trait.damages
    _hurt_box.body_hurted.connect(_on_body_hurted)

    _attached_timer.timeout.connect(_on_life_or_attached_timer_timeout)
    _life_timer.timeout.connect(_on_life_or_attached_timer_timeout)
    _life_timer.start()


func _physics_process(delta: float) -> void:
    super (delta)

    if _is_attached:
        if _attached_body == null:
            queue_free()
            return
        global_position = _attached_body.global_position + _attached_offset
    else:
        translate(_velocity.get_velocity() * delta)

func _on_life_or_attached_timer_timeout() -> void:
    queue_free()

func _on_body_hurted(hurter: Node2D, hurted: Node2D) -> void:
    if (_has_pierce_modifier):
        return

    # Free hurt box and velocity components to stop unnecessary calculations moving forward
    _hurt_box.queue_free()
    _velocity.queue_free()

    # Calculate how to attach the quill to the body
    _attached_body = hurted
    _is_attached = true
    _attached_timer.start()
    _life_timer.stop()
    _calculate_attached_offset(hurter, hurted)
    _calculate_rotation(hurter, hurted)

func _calculate_attached_offset(hurter: Node2D, hurted: Node2D) -> void:
    _attached_offset = hurter.global_position - hurted.global_position

func _calculate_rotation(hurter: Node2D, hurted: Node2D) -> void:
    # Add some variation to make multiple quills attached to the same position to look different
    rotation = (hurted.global_position - hurter.global_position).angle() \
             + randf_range(-_attached_rotation_variation, _attached_rotation_variation)
