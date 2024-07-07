extends CharacterBody3D

var mouse_sensitivity := 0.001
var twist_input := 0.0
var pitch_input := 0.0
var jump_strength := 5.0
var gravity := -9.8
var walk_speed := 5.0
var sprint_speed := 10.0
var current_speed := 5.0
var max_health := 100.0  # Default values, adjust as necessary
var health := 100.0
var max_stamina := 100.0
var stamina := 100.0
var stamina_regeneration := 1
var stamina_consumption := 5
var stamina_regeneration_delay := 3.0  # Delay in seconds before stamina starts regenerating after fully depleted
var current_regeneration_delay := 0.0  # Current countdown for regeneration delay

@onready var twist_pivot := $TwistPivot
@onready var pitch_pivot := $TwistPivot/PitchPivot
@onready var ui_container := $UserInterface
var health_bar
var stamina_bar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	# Initialize UI references
	health_bar = ui_container.get_node("HealthBar/Value")
	stamina_bar = ui_container.get_node("StaminaBar/Value")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Unlocking the Mouse, nya
	if Input.is_action_just_pressed("pause_game"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().change_scene_to_file("res://pause_menu.tscn")

	# Basic Camera Orientation
	twist_pivot.rotate_y(twist_input)
	pitch_pivot.rotate_x(pitch_input)
	pitch_pivot.rotation.x = clamp(pitch_pivot.rotation.x, deg_to_rad(-60), deg_to_rad(60))
	twist_input = 0.0
	pitch_input = 0.0

	# Check and update UI values
	if health_bar and stamina_bar:
		max_health = health_bar.max_value
		health = health_bar.value
		max_stamina = stamina_bar.max_value
		stamina = stamina_bar.value

func _physics_process(delta: float) -> void:
	# Sprint Mechanic
	if Input.is_action_pressed("sprint") and stamina > 0:  # Only sprint if there is stamina
		current_speed = sprint_speed
		stamina -= stamina_consumption * delta  # Adjust for smooth decrease over time
	else:
		current_speed = walk_speed
		if stamina < max_stamina:
			if stamina <= 0:
				current_regeneration_delay += delta
				if current_regeneration_delay >= stamina_regeneration_delay:
					stamina = min(max_stamina, stamina + stamina_regeneration * delta)  # Regenerate stamina over time after delay
			else:
				stamina = min(max_stamina, stamina + stamina_regeneration * delta)  # Regenerate stamina over time

	# Update UI for stamina
	update_stamina_ui()

	# Basic Player Movement
	var input_direction := Vector3.ZERO
	input_direction.x = Input.get_axis("move_left", "move_right")
	input_direction.z = Input.get_axis("move_forward", "move_backwards")
	input_direction = input_direction.normalized()

	var direction = twist_pivot.basis * input_direction

	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			if stamina >= 30:
				jump()
				stamina -= 30
				update_stamina_ui()  # Update UI after stamina deduction
	else:
		velocity.y += gravity * delta

	# Horizontal movement
	var horizontal_velocity = direction * current_speed  # Adjust the speed as needed, nya
	velocity.x = horizontal_velocity.x
	velocity.z = horizontal_velocity.z

	# Move the player
	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			twist_input = - event.relative.x * mouse_sensitivity
			pitch_input = - event.relative.y * mouse_sensitivity

func jump():
	velocity.y = jump_strength

func fullHeal():
	health = max_health

func heal(healing_amount: int):
	health = clamp(health + healing_amount, 0, max_health)

func fullRest():
	stamina = max_stamina

func update_stamina_ui():
	if stamina_bar:
		stamina_bar.value = stamina
