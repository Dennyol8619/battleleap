extends Node2D

@onready var timer1:Timer = $Bridge1/Timer1
@onready var timer2:Timer = $Bridge2/Timer2
@onready var timer3:Timer = $Bridge3/Timer3
@onready var timer4:Timer = $Bridge4/Timer4
@onready var timer5:Timer = $Bridge5/Timer5
@onready var timer6:Timer = $Bridge6/Timer6
@onready var timer7:Timer = $Bridge7/Timer7
@onready var timer8:Timer = $Bridge8/Timer8
@onready var timer9:Timer = $Bridge9/Timer9

func _on_area_2d_body_entered1(body):
	if str(body)[0] == "P":
		timer1.start(1)

func _on_timer_timeout1():
	$Bridge1.queue_free()

func _on_area_2d_body_entered2(body):
	if str(body)[0] == "P":
		timer2.start(1)

func _on_timer_timeout2():
	$Bridge2.queue_free()
	
func _on_area_2d_body_entered3(body):
	if str(body)[0] == "P":
		timer3.start(1)

func _on_timer_timeout3():
	$Bridge3.queue_free()
	
func _on_area_2d_body_entered4(body):
	if str(body)[0] == "P":
		timer4.start(1)

func _on_timer_timeout4():
	$Bridge4.queue_free()
	
func _on_area_2d_body_entered5(body):
	if str(body)[0] == "P":
		timer5.start(1)

func _on_timer_timeout5():
	$Bridge5.queue_free()
	
func _on_area_2d_body_entered6(body):
	if str(body)[0] == "P":
		timer6.start(1)

func _on_timer_timeout6():
	$Bridge6.queue_free()
	
func _on_area_2d_body_entered7(body):
	if str(body)[0] == "P":
		timer7.start(1)

func _on_timer_timeout7():
	$Bridge7.queue_free()
	
func _on_area_2d_body_entered8(body):
	if str(body)[0] == "P":
		timer8.start(1)

func _on_timer_timeout8():
	$Bridge8.queue_free()
	
func _on_area_2d_body_entered9(body):
	if str(body)[0] == "P":
		timer9.start(1)

func _on_timer_timeout9():
	$Bridge9.queue_free()
