extends CharacterBody2D


@export var speed: float = 200.0
@export var jump_velocity: float = -150.0
@export var double_jump_velocity: float = -100

@onready var animated_sprite_2d = $AnimatedSprite2D

var has_double_jumped: bool = false
var animation_locked = false
var direction: Vector2 = Vector2.ZERO

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		has_double_jumped = false 

	# Handle jump.
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			# Normal jump
			velocity.y = jump_velocity
		# double jump
		elif not has_double_jumped:
			velocity.y = double_jump_velocity
			has_double_jumped = true
			

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_vector("left", "right", "up", "down")
	if direction:
		velocity.x = direction.x * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()
	update_animaltion()
	update_facing_direction()
	
func update_animaltion():
	if not animation_locked:
		if direction.x != 0:
			animated_sprite_2d.play("run")
		else:
			animated_sprite_2d.play("idle")
			
func update_facing_direction():
	if direction.x > 0:
		animated_sprite_2d.flip_h = false
	elif direction.x < 0:
		animated_sprite_2d.flip_h = true
		
	
