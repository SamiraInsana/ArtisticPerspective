extends Resource
class_name PerspectiveSystem1vp
##this is a simple 1 vanishing point perspective system.\n
##it will be used as basis for perspective controllers to move objects\n
##in real life, 1 point perspective happens when objects are facing the viewer directly.\n
##in this situation, the z axis represents how far away from the screen the object is


@export var vanishing:Vector2 =Vector2(0,0)
	##this is the vanishing point and everything goes towards it as it distances itself from the screen
	##those coordinates correspond to GLOBAL COORDINATES
	
@export var origin:Vector2=Vector2(0,250)
	##this is the origin of the virtual axis. NOTE: in the origin, all objects will have 1 as their
	##scale, so plan it accordingly
	
@export var horizon_angle:float=0
	##this is the horizon's tilt angle. if you use larger than pi, it will look upside-down
	
var reference_distance=(origin-vanishing).length()
#distance between the vanishing and the origin. saving it because it is used many times

#those normalized vectors are the axis of the perspective system
var versor_z:Vector2=(origin-vanishing).normalized()
var versor_x:Vector2=Vector2(1,0).rotated(horizon_angle)
var versor_y:Vector2=Vector2(0,-1).rotated(horizon_angle)

@export var camera_focal:float=0.025
	##this is the focal lenght of the camera\n
	##you dont get THAT from the camera3d node, do you?? haha!\n
	##default value is the focal lenght of a human eye
	
@export var camera_distance:float=2
	##this is the distance between the camera and the ORIGIN POINT, wherever you placed it at the screen.
	
var focal_constant= (camera_distance-camera_focal)/camera_focal
#this is just a constant used to set the scale=1 at the origin. it is also used to resize things accordingly 
#in case you want to change the camera distance or focal lenght
	
	
func update_system():
	if origin==vanishing:
		printerr("origin is equal the vanishing, aborting operation")
		return
		
	##updates the values of stuff
	
	#get the normalized vectors for the axis
	versor_z=(origin-vanishing).normalized()
	versor_x=Vector2(1,0).rotated(horizon_angle)
	versor_y=Vector2(0,-1).rotated(horizon_angle)
	
	#update this thing. its the same calculation you've seen above
	reference_distance=(origin-vanishing).length()
	
func get_scale(virtual_coordinates:Vector3) ->float:
	#returns the scale of a object based in how far (virtual z) it is from the camera
	var scale= (camera_focal*focal_constant)/(camera_distance-camera_focal+virtual_coordinates.z)
	return scale
	
func get_distance_z(virtual_coordinates:Vector3)->Vector2:
	var scale=get_scale(virtual_coordinates)
	#returns the vector corresponding to the z distance in the global coordinates\n
	#the scale argument is optional if you want to save, like, 1 microsecond of calculation
	var distance=versor_z*reference_distance*scale
	return distance

func get_distance_x(virtual_coordinates:Vector3)->Vector2:
	var scale=get_scale(virtual_coordinates)
	#returns the vector corresponding to the x distance in the global coordinates
	#the scale argument is optional if you want to save, like, 1 microsecond of calculation
	var distance=versor_x*reference_distance*scale*virtual_coordinates.x/(camera_distance-camera_focal)
	return distance
	
func get_distance_y(virtual_coordinates:Vector3)->Vector2:
	var scale=get_scale(virtual_coordinates)
	#returns the vector corresponding to the y distance in the global coordinates
	#the scale argument is optional if you want to save, like, 1 microsecond of calculation
	var distance=versor_y*reference_distance*scale*virtual_coordinates.y/(camera_distance-camera_focal)
	return distance
	
func get_global_position(virtual_coordinates:Vector3)->Vector2:
	#returns the global coordinates of a object by suming the 3 axis vectors, starting from the vanishing point
	var scale:float=get_scale(virtual_coordinates)
	var distance_z:Vector2=versor_z*reference_distance*scale
	var distance_x:Vector2=versor_x*reference_distance*scale*virtual_coordinates.x/(camera_distance-camera_focal)
	var distance_y:Vector2=versor_y*reference_distance*scale*virtual_coordinates.y/(camera_distance-camera_focal)
	var coordinates:Vector2=vanishing+distance_z+distance_y+distance_x
	return coordinates
	

	
	
	
	
	
