
class_name ProjectileBurst
extends Projectile

@export var max_variation: float

enum State { STARTING, RUNNING, EXPLODING }
var state: State = State.STARTING

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready():
    super()
    sprite.animation = "start"
    sprite.play("start")
    sprite.animation_finished.connect(_on_animation_finished)

func _on_animation_finished():
    print("chamou callback")

    match state:
        State.STARTING:
            state = State.RUNNING
            sprite.animation = "going"
            sprite.play()
        State.EXPLODING:
            print("someeee")
            queue_free()  # Or emit signal / pool it

func explode():
    if state != State.EXPLODING:
        state = State.EXPLODING
        sprite.animation = "hit"
        print("ta explodindo")
        sprite.play()

func _on_hurt_box_component_hurt_body(body: Node2D, _damage: float) -> void:
    if (body.is_in_group("enemies")):
        body.queue_free()
        explode()

