import datetime
import bpy
from mathutils import *
from math import *

#select object to rotate, set cursor to at pivot point, then go

def get_override(area_type, region_type):
    for area in bpy.context.screen.areas: 
        if area.type == area_type:             
            for region in area.regions:                 
                if region.type == region_type:                    
                    override = {'area': area, 'region': region} 
                    return override
    #error message if the area or region wasn't found
    raise RuntimeError("Wasn't able to find", region_type," in area ", area_type,
                        "\n Make sure it's open while executing script.")

def initialize_rotation(val, axis_tuple, override):
    last_rot = bpy.context.active_object.rotation_euler[:]
    last_loc = bpy.context.active_object.location[:]
    z_loc = 1 # assume input has z > 0

    while z_loc > 0:
        last_rot = bpy.context.active_object.rotation_euler[:]
        last_loc = bpy.context.active_object.location[:]
        bpy.ops.transform.rotate(override, value=val, axis=axis_tuple)
        z_loc = bpy.context.active_object.location[2]
    
    bpy.context.active_object.rotation_euler = last_rot
    bpy.context.active_object.location = last_loc

def start_rotation(val, axis_tuple, override):
    last_loc = bpy.context.active_object.location
    while last_loc.z > 0:
        bpy.data.scenes['Scene'].render.filepath = \
            '/Users/CyrusAnderson/Documents/blender-out/%s.png' % str(datetime.datetime.now())
        bpy.ops.render.render(write_still = True)
        bpy.ops.transform.rotate(override, value=val, axis=axis_tuple)

# fine-ness of steps (radians)
ds = 5*pi/180

# cursor to pivot
#tagPivot = 'Cube';
#bpy.context.scene.cursor_location = bpy.data.objects[tagPivot].location
bpy.context.scene.cursor_location = (0,0,0)

# loop over z, then x,y

init_rot = bpy.context.active_object.rotation_euler[:]
init_loc = bpy.context.active_object.location[:]

#we need to override the context of our operator    
ov = get_override('VIEW_3D', 'WINDOW')

#ehhh define these ones
last_rot = bpy.context.active_object.rotation_euler[:]
last_loc = bpy.context.active_object.location[:]

while last_rot[2] < init_rot[2] + 2*pi :
    # x
    initialize_rotation(val= -ds, axis_tuple= (1,0,0), override= ov)
    start_rotation(val= ds, axis_tuple= (1,0,0), override= ov)
    
    bpy.context.active_object.rotation_euler = last_rot
    bpy.context.active_object.location = last_loc

    # y
    initialize_rotation(val= -ds, axis_tuple= (0,1,0), override= ov)
    start_rotation(val= ds, axis_tuple= (0,1,0), override= ov)

    bpy.context.active_object.rotation_euler = last_rot
    bpy.context.active_object.location = last_loc

    bpy.ops.transform.rotate(ov, value= ds, axis= (0,0,1))

    last_rot = bpy.context.active_object.rotation_euler[:]
    last_loc = bpy.context.active_object.location[:]

bpy.context.active_object.rotation_euler = init_rot
bpy.context.active_object.location = init_loc
