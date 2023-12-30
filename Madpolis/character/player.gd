extends CharacterBody2D


@export var speed: float = 200.0
@export var jump_velocity: float = -150.0
@export var double_jump_velocity: float = -100

@onready var animated_sprite_2d = $AnimatedSprite2D

var has_double_jumped: bool = false
var animation_locked: bool = false
var was_in_air: bool = false
var direction: Vector2 = Vector2.ZERO

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		was_in_air = true
	else:
		has_double_jumped = false 
		
	if was_in_air == true:
		land()
		
	was_in_air = false

	# Handle jump.
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			# Normal jump
			jump()
		# double jump
		elif not has_double_jumped:
			double_jump()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_vector("left", "right", "up", "down")
	if direction.x != 0 && animated_sprite_2d.animation != "jump_end" :
		velocity.x = direction.x * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()
	update_animaltion()
	update_facing_direction()
	
func update_animaltion():
	if not animation_locked:
		if not is_on_floor():
			animated_sprite_2d.play("jump_loop")
		else:
			if direction.x != 0:
				animated_sprite_2d.play("run")
			else:
				animated_sprite_2d.play("idle")
			
func update_facing_direction():
	if direction.x > 0:
		animated_sprite_2d.flip_h = false
	elif direction.x < 0:
		animated_sprite_2d.flip_h = true
		
func jump():
	velocity.y = jump_velocity
	animated_sprite_2d.play("jump_start")
	animation_locked = true

func double_jump():
	velocity.y = double_jump_velocity
	animated_sprite_2d.play("jump_double")
	animation_locked = true
	has_double_jumped = true

func land():
	animated_sprite_2d.play("jump_end")
	animation_locked = true
	
		
func _on_animated_sprite_2d_animation_finished():
	if(["jump_end", "jump_start", "double_jump"].has(animated_sprite_2d.animation)):
		animation_locked = false


