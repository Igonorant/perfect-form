class_name ProjectileBurst
extends Projectile

@export var max_variation: float

enum Behavior {STARTING, RUNNING, EXPLODING}
var state: Behavior = Behavior.STARTING

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready():
    super ()
    sprite.play("start")
    sprite.animation_finished.connect(_on_animation_finished)

func _on_animation_finished():
    match state:
        Behavior.STARTING:
            state = Behavior.RUNNING
            sprite.play("going")
        Behavior.EXPLODING:
            queue_free() # Or emit signal / pool it

func explode():
    if state != Behavior.EXPLODING:
        state = Behavior.EXPLODING
        sprite.play("hit")

func _on_hurt_box_component_hurt_body(body: Node2D, _damage: float) -> void:
    if (body.is_in_group("enemies")):
        body.queue_free()
        explode()
