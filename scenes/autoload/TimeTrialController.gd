extends Node

const SAVE_FILE: String               = "user://save_data.dat"
const TIME_DEFAULT: float             = 60 * 60 * 24
const TIMEOUT_RESET_POSITION: Vector2 = Vector2(960, 540)
@onready var timer: Timer = $Timer

var level_1_best_time: float = TIME_DEFAULT
var level_2_best_time: float = TIME_DEFAULT
var level_3_best_time: float = TIME_DEFAULT


####################################################################################################
# Built-In Functions                                                                               #
####################################################################################################
func _ready():
	load_level_times()
	timer.start()


func _process(_delta):
	HudController.set_level_time(get_timestamp())


####################################################################################################
# Timer Functions                                                                                  #
####################################################################################################
func get_time() -> float:
	return timer.wait_time - timer.time_left if timer.time_left != 0 else 0


func get_timestamp(time: float = get_time()) -> String:
	if time == TIME_DEFAULT:
		return "--:--:--"

	return "%02d:%02d:%02d" % [time / 60, fmod(time, 60), fmod(time, 1) * 100]


func start_timer():
	timer.start()


func stop_timer():
	timer.stop()


func store_level_time():
	var time       = get_time()
	var level_name = get_tree().current_scene.name

	if level_name == "Graveyard" and time < level_1_best_time:
		level_1_best_time = time
	elif level_name == "Sewer" and time < level_2_best_time:
		level_2_best_time = time
	elif level_name == "Cave" and time < level_3_best_time:
		level_3_best_time = time

	save_level_times()


####################################################################################################
# Save / Load Functions                                                                            #
####################################################################################################
func save_level_times():
	var file = FileAccess.open(SAVE_FILE, FileAccess.WRITE)
	file.store_float(level_1_best_time)
	file.store_float(level_2_best_time)
	file.store_float(level_3_best_time)
	file.close()


func load_level_times():
	if not FileAccess.file_exists(SAVE_FILE):
		return

	var file = FileAccess.open(SAVE_FILE, FileAccess.READ)
	level_1_best_time = file.get_float()
	level_2_best_time = file.get_float()
	level_3_best_time = file.get_float()
	file.close()


####################################################################################################
# Timer Signals                                                                                    #
####################################################################################################
func _on_timer_timeout():
	TransitionController.reload_current_level(Vector2.ZERO, TIMEOUT_RESET_POSITION)
