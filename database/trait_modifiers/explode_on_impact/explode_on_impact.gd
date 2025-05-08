class_name ExplodeOnImpact
extends TraitInterface

@onready var _life_timer: Timer = %LifeTimer

func _ready() -> void:
    _life_timer.timeout.connect(_on_life_timer_timout)

func _on_life_timer_timout() -> void:
    queue_free()
