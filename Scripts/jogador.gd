# jogador.gd (versão 8.7 - CÓDIGO COMPLETO)
extends CharacterBody2D

@export var velocidade = 150.0

@onready var animated_sprite = $AnimatedSprite2D
@onready var audio_pool_passos = $AudioPoolPassos
@onready var animacao_timer = $AnimacaoTimer

var ultima_direcao: Vector2 = Vector2.DOWN

var ui_inventario_instancia = null
const UIInventarioCena = preload("res://cenas/ui/ui_inventario.tscn")

func _physics_process(delta):
	if get_tree().paused:
		return

	var direcao = Vector2.ZERO
	if Input.is_action_pressed("mover_direita"):
		direcao.x = 1
	elif Input.is_action_pressed("mover_esquerda"):
		direcao.x = -1
	elif Input.is_action_pressed("mover_baixo"):
		direcao.y = 1
	elif Input.is_action_pressed("mover_cima"):
		direcao.y = -1
	
	if direcao != Vector2.ZERO:
		ultima_direcao = direcao
		
	velocity = direcao * velocidade
	move_and_slide()
	update_animation()

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		var deve_pausar = not get_tree().paused
		get_tree().paused = deve_pausar
		
		for player in audio_pool_passos.get_children():
			player.stream_paused = deve_pausar
		
		if deve_pausar:
			ui_inventario_instancia = UIInventarioCena.instantiate()
			add_child(ui_inventario_instancia)
		else:
			if ui_inventario_instancia and is_instance_valid(ui_inventario_instancia):
				ui_inventario_instancia.queue_free()
				ui_inventario_instancia = null

func update_animation():
	if not velocity.is_zero_approx():
		animacao_timer.stop()
		if ultima_direcao.y > 0:
			animated_sprite.play("andando_baixo")
		elif ultima_direcao.y < 0:
			animated_sprite.play("andando_cima")
		elif ultima_direcao.x != 0:
			animated_sprite.flip_h = ultima_direcao.x < 0
			animated_sprite.play("andando_direita")
	else:
		if animated_sprite.animation.begins_with("andando") and animacao_timer.is_stopped():
			animacao_timer.start()

func _on_animacao_timer_timeout():
	if velocity.is_zero_approx():
		if ultima_direcao.y > 0:
			animated_sprite.play("parado_baixo")
		elif ultima_direcao.y < 0:
			animated_sprite.play("parado_cima")
		elif ultima_direcao.x != 0:
			animated_sprite.flip_h = ultima_direcao.x < 0
			animated_sprite.play("parado_direita")

func tocar_som_de_passo():
	for player in audio_pool_passos.get_children():
		if not player.playing:
			player.play()
			return

func _on_animated_sprite_2d_frame_changed():
	if get_tree().paused:
		return
	if velocity.is_zero_approx():
		return
	if animated_sprite.animation.begins_with("andando"):
		if (animated_sprite.frame == 1 or animated_sprite.frame == 3):
			tocar_som_de_passo()
