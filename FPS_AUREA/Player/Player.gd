extends KinematicBody

export var speed = 10
export var acceleration = 5
export var gravity = 0.98
export var jump_power = 30
export var mouse_sensitivity = 0.3
## when fully loaded object, run or assign these objects to the variable
onready var head = $Head
onready var camera = $Head/Camera
var velocity = Vector3()

var camera_x_rotation = 0

# we use the head as our pivot sort of like object cause it is bount to the physics of tyhe world
# cause if we used the camera that is not bount to morta rules it would go flying over our heads
func _physics_process(delta):
	## we get the local rotation and moves transform of the head to rotate
	var head_basis = head.get_global_transform().basis
	var direction = Vector3()
	## move backwards and forward
	if Input.is_action_pressed("move_forward"):
		direction  -= head_basis.z
	elif Input.is_action_pressed("move_backward"):
		direction  += head_basis.z
	
	if Input.is_action_pressed("move_left"):
		direction  -= head_basis.x
	elif Input.is_action_pressed("move_right"):
		direction += head_basis.x
	## it normalizes the vector	
	direction = direction.normalized()
	
	## makes speed work like in real life so that movement isn't bound by fps
	
	velocity = velocity.linear_interpolate(direction * speed, acceleration * delta)
	velocity.y -= gravity
	
	
	if Input.is_action_just_released("jump") and is_on_floor():
		velocity.y += jump_power
	velocity = move_and_slide(velocity, Vector3.UP)

# This function and _ready locks the mouse on the screen so that it works you know right
func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if Input.is_action_just_pressed("ui_accept"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		head.rotate_y(
			deg2rad(-event.relative.x * mouse_sensitivity)
		)
		
		var x_delta = event.relative.y * mouse_sensitivity
		if camera_x_rotation + x_delta > -90 and camera_x_rotation + x_delta < 90:	
			camera.rotate_x(
				deg2rad(-x_delta)
			)
			camera_x_rotation += x_delta
