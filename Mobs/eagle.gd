extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const ATTACK_DURATION = 2.0  # Adjust as needed

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var player
var chase = false
var attacking = false
var attack_timer = 0.0

func _physics_process(delta):
	get_node("AnimatedSprite2D").play("Idle")
	
	# Handle diving and attacking
	if chase:
		player = get_node("../Player/Player")  # Adjust path as needed
		var direction = (player.position - self.position).normalized()
		velocity.x = direction.x * SPEED
		velocity.y = direction.y * SPEED  # Adjust to move vertically towards the player if needed

		# Attack behavior
		if not attacking:
			attacking = true
			attack_timer = 0.0
			get_node("AnimatedSprite2D").play("Attack")
	else:
		velocity.x = 0

	# Handle attack duration
	if attacking:
		attack_timer += delta
		if attack_timer >= ATTACK_DURATION:
			attacking = false
			await get_node("AnimatedSprite2D").animation_finished
			death()
	
	move_and_slide()

func _on_player_detection_body_entered(body):
	if body.name == "Player":
		chase = true

func _on_player_detection_body_exited(body):
	if body.name == "Player":
		chase = false



func _on_player_collision_body_entered(body):
	if body.name == "Player":
		# Deal damage to the player and die
		Game.playerHP -= 2  # Adjust damage as needed
		death()

func _on_player_death_body_entered(body):
	get_node("AnimatedSprite2D").play("Death")
	if body.name == "Player":
		death()

func death():
	Game.Gold += 5
	Utils.saveGame()
	get_node("AnimatedSprite2D").play("Death")
	await get_node("AnimatedSprite2D").animation_finished
	self.queue_free()




