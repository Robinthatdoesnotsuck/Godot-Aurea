extends KinematicBody

var speed  
var default_move_speed = 7
var crouch_move_speed = 3
var crouch_speed = 20
var sprint_speed = 14
var acceleration = 50
var gravity = 9.8
var jump = 5
var mouse_sensitivity = 0.05

var damage = 100

var sprinting = false

var default_height = 1.5
var crouch_height = 0.5

var direction = Vector3()
var velocity = Vector3()
var fall = Vector3()

onready var head = $Head
onready var pcap = $CollisionShape
onready var bonker = $HeadBonk
onready var aimcast = $Head/Camera/Aimcast
onready var muzzle = $Head/Gun/Muzzle
<<<<<<< HEAD
#onready var bullet = preload("res://scenes/Bullet.tscn")
=======
onready var bullet = preload("res://scenes/Bullet.tscn")
>>>>>>> 28f47a7e53dd499704c82c1769c208e0dad8c5cd


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))
		head.rotate_x(deg2rad(-event.relative.y * mouse_sensitivity))
		head.rotation.x = clamp(head.rotation.x, deg2rad(-90), deg2rad(90))

func _physics_process(delta):
	
	var head_bonked = false
	speed = default_move_speed
	
	direction = Vector3()
	
	if Input.is_action_just_pressed("fire"):
<<<<<<< HEAD
		print("fire fire")
		if aimcast.is_colliding():
			var bullet = get_world().direct_space_state
			var collision = bullet.intersect_ray(muzzle.transform.origin, aimcast.get_collision_point())
			
			if collision:
				var target = collision.collider
				print(target)
				if target.is_in_group("Enemy"):
					print("hit enemy")
					target.health -= damage
=======
		if aimcast.is_colliding():
			print("fire")
			var b = bullet.instance()
			muzzle.add_child(b)
			b.look_at(aimcast.get_collision_point(), Vector3.UP)
			print(b.rotation)
			b.shoot = true
>>>>>>> 28f47a7e53dd499704c82c1769c208e0dad8c5cd
	
	
	if bonker.is_colliding():
		head_bonked = true
		
	if not is_on_floor():
		fall.y -= gravity*delta
	if Input.is_action_just_pressed("jump") and is_on_floor():
		fall.y = jump
	
	if Input.is_action_just_pressed("sprint") and not sprinting: 
		sprinting = true
		print("sprinting")
	elif Input.is_action_just_pressed("sprint") and sprinting:
		sprinting = false
		print("not sprinting")
	
	if sprinting:
		speed = sprint_speed
		
	if head_bonked:
		fall.y = -2
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if Input.is_action_just_pressed("captureMouse"):
		Input.set_mouse_mode((Input.MOUSE_MODE_CAPTURED))
	if Input.is_action_pressed("crouch"):
		pcap.shape.height -= crouch_speed * delta
		speed = crouch_move_speed
	elif not head_bonked:
		pcap.shape.height += crouch_speed * delta
	
	pcap.shape.height = clamp(pcap.shape.height, crouch_height, default_height)
	if Input.is_action_pressed("move_forward"):
		direction -= transform.basis.z
	elif Input.is_action_pressed("move_backward"):
		direction += transform.basis.z
	if Input.is_action_pressed("move_right"):
		direction += transform.basis.x
	elif Input.is_action_pressed("move_left"):
		direction -= transform.basis.x
	
	direction = direction.normalized()
	velocity = velocity.linear_interpolate(direction * speed, acceleration * delta)
	velocity = move_and_slide(velocity, Vector3.UP)
	
	move_and_slide(fall, Vector3.UP, true)
