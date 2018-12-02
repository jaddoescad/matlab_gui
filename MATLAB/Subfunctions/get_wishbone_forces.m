function [max_wishbone_tensile_force,max_wishbone_compressive_force, F_pushrod_max_vertical_load, acceleration_pushrod_force]= get_wishbone_forces(mass_of_car, friction)
[Min_acceleration_load,Max_vertical_load,Max_braking_load,Max_cornering_load,braking_front_wheel_load] = get_wheel_loads(mass_of_car, friction);
angle_1 =	0.6457718232; %(angle between pushrod and horizontal axis)
angle_2 =	0.3490658504 ;%(angle of one wishbone arm and horizontal axis)
angle_3 = 	2.443460953; %(angle of vector triangle of wishbone force triangle)
h5=151.25;
h6=228;

%compressive force
F_pushrod_max_vertical_load = (Max_vertical_load)/(sin(angle_1));
H_pushrod_max_vertical_load = F_pushrod_max_vertical_load*cos(angle_1);
max_wishbone_compressive_force = (H_pushrod_max_vertical_load*sin(angle_2)/(sin(angle_3)));

%tensile Force
F_pushrod_maximum_braking  = (braking_front_wheel_load)/(sin(angle_1));
H_pushrod_maximum_braking = F_pushrod_maximum_braking*cos(angle_1);
longitudinal_force_on_bottom_wishbone = ((h5+h6)/(h6))*(Max_braking_load);
wishbone_vertical_internal_force =(H_pushrod_maximum_braking*sin(angle_2)/(sin(angle_3)));
wishbone_longitudinal_force = (longitudinal_force_on_bottom_wishbone*sin(angle_2)/(sin(angle_3)));
max_wishbone_tensile_force = wishbone_vertical_internal_force+wishbone_longitudinal_force;

%minimum force on front pushrod from front acceleration
acceleration_pushrod_force = Min_acceleration_load/sin(angle_1);


end