extends CharacterBody2D

@export var id:int = 1
const speed:float = 150
const air_speed:float = 0.7
const sand_speed:float = 0.3
const jump_velocity:float = -250
var health:int = 5

@onready var animated_sprite:AnimatedSprite2D = $AnimatedSprite2D
@onready var head_collision:CollisionShape2D = $Head
@onready var body_collision:CollisionShape2D = $Body
@onready var bullet_position:Marker2D = $BulletPos
@onready var muzzle_flash:Sprite2D = $MuzzleFlash
@onready var timer:Timer = $MuzzleFlash/Timer
@onready var head_area:CollisionShape2D = $Area2D/Head
@onready var health_bar:Sprite2D = $HealthBar
@onready var bullet:PackedScene = preload("res://Prefabs/bullet.tscn")

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var animation_locked:bool = false
var direction:Vector2 = Vector2.ZERO
var was_in_air:bool = false
var is_crouched:bool = false
var is_dead:bool = false
var can_fall:bool = true
var face_right:bool = true
var can_shoot:bool = true
var ladder_count:int = 0
var sand_count:int = 0
var bullet_pos:Vector2 = Vector2(15.5, -2.5)
var muzzle_pos:Vector2 = Vector2(19, -2.5)

func _physics_process(delta):
	if is_dead:
		head_collision.disabled = true
		if is_on_floor():
			can_fall = false
			body_collision.disabled = true
	
	# Handle jump.
	if Input.is_action_just_pressed("Up" + str(id)) and is_on_floor() and !is_crouched and !is_dead and ladder_count == 0:
		jump()
	
	if Input.is_action_just_pressed("Down" + str(id)) and is_on_floor() and !is_dead and ladder_count == 0:
		crouch(true)
	if Input.is_action_just_released("Down" + str(id)) and is_on_floor() and !is_dead and ladder_count == 0:
		crouch(false)
	
	if Input.is_action_just_pressed("Shoot" + str(id)) and !is_dead and can_shoot:
		shoot()
	
	movement(delta)

func movement(delta):
	direction = Input.get_vector("Left" + str(id), "Right" + str(id), "Up" + str(id), "Down" + str(id))
	var new_speed:float = speed
	if !is_on_floor():
		new_speed = speed * air_speed
	elif sand_count > 0:
		new_speed = speed * sand_speed
	else:
		new_speed = speed
	if direction and !is_crouched and !is_dead:
		velocity.x = direction.x * new_speed
	else:
		velocity.x = 0
	
	if direction and ladder_count != 0 and !is_dead:
		velocity.y = direction.y * new_speed
	else:
		if ladder_count != 0:
			velocity.y = 0
		# Add the gravity.
		if !is_on_floor() and ladder_count == 0:
			velocity.y += gravity * delta
			was_in_air = true
		else:
			was_in_air = false
			if !is_crouched:
				animation_locked = false
	
	if can_fall:
		move_and_slide()
	if !is_dead:
		update_animation()
		update_facing_direction()

func update_animation():
	if !animation_locked:
		if velocity.x != 0:
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

func jump():
	velocity.y = jump_velocity
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
	
	var rnd1:float = randf_range(-1, 0)
	var rnd2:float = randf_range(-0.1, 0.1)
	bullet_position.position = Vector2(bullet_pos.x, bullet_pos.y + rnd1)
	muzzle_flash.position = Vector2(muzzle_pos.x, muzzle_pos.y + rnd2)
	
	can_shoot = false
	muzzle_flash.visible = true
	var bullet_ins = bullet.instantiate()
	get_parent().add_child(bullet_ins)
	bullet_ins.global_position = $BulletPos.global_position
	bullet_ins.set_direction(face_right)

func _on_area_2d_area_entered(area):
	if area.is_in_group("bullet"):
		health = max(0, health - 1)
		health_bar.frame = 5 - health
		if health == 0:
			death()
	elif area.is_in_group("ladder"):
		ladder_count += 1
	elif area.is_in_group("slow_sand"):
		sand_count += 1
	elif area.is_in_group("fire") or area.is_in_group("explotion") or area.is_in_group("killzone"):
		health = 0
		death()
	elif area.is_in_group("health_pack"):
		if 0 < health and health < 5:
			health = min(5, health + 1)
			health_bar.frame = 5 - health
			area.get_parent().get_parent().queue_free()

func _on_area_2d_area_exited(area):
	if area.is_in_group("ladder"):
		ladder_count = max(0, ladder_count - 1)
	elif area.is_in_group("slow_sand"):
		sand_count = max(0, sand_count - 1)

func _on_timer_timeout():
	timer.stop()
	can_shoot = true
	muzzle_flash.visible = false

func death():
	is_dead = true
	health_bar.frame = 5
	animated_sprite.play("death")
	animation_locked = true
	get_tree().get_root().get_node("Root").emit_signal("player_death", id)
