@icon("res://assets/icons/blinking.png")
class_name BlinkingComponent
extends Node

@onready var m_blinking_timer: Timer = $IntervalTimer

@export var blinking_interval: float = 0.1
@export var item: CanvasItem
@export var material: CanvasItemMaterial

var m_blinking_remaining_time: float = 0.0
var m_original_material: CanvasItemMaterial
var m_is_original_material: bool = false

func _ready() -> void:
    m_blinking_timer.wait_time = blinking_interval

func start_blinking(time: float) -> void:
    if (m_blinking_timer.is_stopped() == false):
        m_blinking_timer.stop()
        item.material = m_original_material
        m_is_original_material = true

    m_original_material = item.material
    item.material = material
    m_is_original_material = false

    m_blinking_remaining_time = time
    m_blinking_timer.start()
    print("Blinking animation started for ", time, " seconds.")

func _on_interval_timer_timeout() -> void:
    m_blinking_remaining_time -= m_blinking_timer.wait_time
    if (m_blinking_remaining_time <= 0.0):
        m_blinking_timer.stop()
        item.material = m_original_material
    else:
        if (m_is_original_material):
            item.material = material
            m_is_original_material = false
        else:
            item.material = m_original_material
            m_is_original_material = true
