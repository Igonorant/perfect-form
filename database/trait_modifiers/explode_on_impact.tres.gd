class_name ExplodeOnImpactRes
extends TraitModifier

var _power: Power
var scene: PackedScene = preload("res://database/trait_modifiers/explode_on_impact.tscn")
var damage: Damage = preload("res://database/trait_modifiers/explode_on_impact.damage.tres")

# TODO: maybe replace by a set_power function with overwritting init with parameter becomes a problem
func _init(power: Power) -> void:
    _power = power

# TODO: this is not working as an explosion right now because it does not detect bodies already inside the explostion
#       spawn point, only bodies "entering" the explosion hurt box.
func on_hurt_inject(_hurter: TraitInterface, hurted: Node2D) -> void:
    var instance: ExplodeOnImpact = scene.instantiate()

    # Add explostion to global position of the hurted enemy
    instance.global_position = hurted.global_position

    # An array should be instanciated here with type Damage, otherwise "take_damage" call will fail??
    var damage_array: Array[Damage] = [damage]
    hurted.take_damage(damage_array)

    _power.call_deferred("add_child", instance)
