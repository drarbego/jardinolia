extends Node

const POISONED_TIME = 3.0
var is_cooled_down = true
const COOL_DOWN_TIME = 1.0
var cooldown_timer = Timer.new()

func _ready():
	cooldown_timer.connect("timeout", self, "_on_cooldown_timer_timeout")
	cooldown_timer.set_wait_time(COOL_DOWN_TIME)
	add_child(cooldown_timer)

func _on_cooldown_timer_timeout():
	is_cooled_down = true
	cooldown_timer.stop()

func handle_growing(_plant):
	pass

func handle_menaced(plant):
	poison_random_target(plant.targets)

func poison_random_target(targets):
	if not is_cooled_down:
		return

	if targets.empty():
		return

	is_cooled_down = false
	cooldown_timer.start()
	for target_id in targets:
		var target = targets[target_id]
		if target.has_method("apply_effect") and target.current_effect.get("name", null) != globals.EFFECTS.POISONED:
			target.apply_effect(globals.EFFECTS.POISONED, POISONED_TIME)
			return

func handle_idle(_plant):
	pass
