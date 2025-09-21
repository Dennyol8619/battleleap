extends CharacterBody2D

@export var id:int = 1
var speed:float = 7000
var jump_velocity:float = -15000
var health:int = 5

@onready var animated_sprite:AnimatedSprite2D = $AnimatedSprite2D
@onready var head_collision:CollisionShape2D = $Head
@onready var body_collision:CollisionShape2D = $Body
@onready var bullet_position:Marker2D = $BulletPos
@onready var muzzle_flash:Sprite2D = $MuzzleFlash
@onready var timer:Timer = $MuzzleFlash/Timer
@onready var head_area:CollisionShape2D = $Area2D/Head
@onready var healt_bar:Sprite2D = $HealthBar
@onready var bullet = preload("res://Prefabs/bullet.tscn")

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var animation_locked:bool = false
var direction:Vector2 = Vector2.ZERO
var was_in_air:bool = false
var is_crouched:bool = false
var is_dead:bool = false
var can_fall:bool = true
var face_right:bool = true
var bullet_pos:Vector2 = Vector2(15.5, -2.5)
var muzzle_pos:Vector2 = Vector2(19, -2.5)
var bullet_ins

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		was_in_air = true
	else:
		was_in_air = false
		if !is_crouched:
			animation_locked = false
	
	if is_dead:
		head_collision.disabled = true
		if is_on_floor():
			can_fall = false
			body_collision.disabled = true
	
	# Handle jump.
	if Input.is_action_just_pressed("Up" + str(id)) and is_on_floor() and !is_crouched and !is_dead:
		jump(delta)
	
	if Input.is_action_just_pressed("Down" + str(id)) and is_on_floor() and !is_dead:
		crouch(true)
	if Input.is_action_just_released("Down" + str(id)) and is_on_floor() and !is_dead:
		crouch(false)
		
	if Input.is_action_just_pressed("Shoot" + str(id)) and !is_dead:
		shoot()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_vector("Left" + str(id), "Right" + str(id), "Up" + str(id), "Down" + str(id))
	if direction and !is_crouched and !is_dead:
		velocity.x = direction.x * speed * delta
	else:
		velocity.x = move_toward(velocity.x, 0, speed * delta)
	
	if can_fall:
		move_and_slide()
	if !is_dead:
		update_animation()
		update_facing_direction()
		var rnd1:float = randf_range(-1, 0)
		var rnd2:float = randf_range(-0.1, 0.1)
		bullet_position.position = Vector2(bullet_pos.x, bullet_pos.y + rnd1)
		muzzle_flash.position = Vector2(muzzle_pos.x, muzzle_pos.y + rnd2)

func update_animation():
	if !animation_locked:
		if direction.x != 0:
			animated_sprite.play("run")
		else :
			animated_sprite.play("idle")

func update_facing_direction():
	if direction.x > 0:
		animated_sprite.flip_h = false
		muzzle_flash.flip_h = false
		face_right = true
		bullet_pos = Vector2(15.5, bullet_pos.y)
		muzzle_pos = Vector2(19, muzzle_pos.y)
	elif direction.x < 0:
		animated_sprite.flip_h = true
		muzzle_flash.flip_h = true
		face_right = false
		bullet_pos = Vector2(-15.5, bullet_pos.y)
		muzzle_pos = Vector2(-19, muzzle_pos.y)

func jump(delta):
	velocity.y = jump_velocity * delta
	animated_sprite.play("jump")
	animation_locked = true

func crouch(pressed:bool):
	if pressed:
		is_crouched = true
		head_collision.disabled = true
		head_area.disabled = true
		animated_sprite.play("crouch")
		bullet_pos = Vector2(bullet_pos.x, 5)
		muzzle_pos = Vector2(muzzle_pos.x, 1.5)
		animation_locked = true
	else:
		is_crouched = false
		head_collision.disabled = false
		head_area.disabled = false
		animated_sprite.play_backwards("crouch")
		bullet_pos = Vector2(bullet_pos.x, -3)
		muzzle_pos = Vector2(muzzle_pos.x, -2.5)
		animation_locked = false

func shoot(): #Randomizált fel és le eltolás
	timer.start(0.3)
	muzzle_flash.visible = true
	bullet_ins = bullet.instantiate()
	get_parent().add_child(bullet_ins)
	bullet_ins.global_position = $BulletPos.global_position
	bullet_ins.get_direction(face_right)

func _on_area_2d_area_entered(area):
	if str(area)[0] == "B":
		health -= 1
		healt_bar.frame += 1
		if health == 0:
			death()
	elif str(area)[0] == "F" or str(area)[0] == "E":
		health = 0
		death()
	elif str(area)[0] == "H":
		if health < 5:
			health += 1
			healt_bar.frame -= 1
			area.get_parent().get_parent().queue_free()

func _on_timer_timeout():
	timer.stop()
	muzzle_flash.visible = false

func death():
	is_dead = true
	healt_bar.frame = 5
	animated_sprite.play("death")
	animation_locked = true
	get_tree().get_root().get_node("Root").emit_signal("player_death", id)
