extends Node3D


var top_material
var bottom_material

var colors = [
	Color.html("#970404"), 
	Color.html("#580195"), 
	Color.html("#D28D0D"), 
	Color.html("#0B5947"), 
	Color.html("#012C79")]


func _ready():
	top_material = $person/Person_Top.get_surface_override_material(0)
	bottom_material = $person/Person_Bottom.get_surface_override_material(0)
	top_material = top_material.duplicate()
	bottom_material = bottom_material.duplicate()
	top_material.albedo_color = colors.pick_random()
	bottom_material.albedo_color = colors.pick_random()
	$person/Person_Top.set_surface_override_material(0, top_material)
	$person/Person_Bottom.set_surface_override_material(0, bottom_material)


func _process(delta):
	pass
