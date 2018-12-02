function [acceleration_front_wheel_weight,Max_vertical_load,Max_braking_load,Max_cornering_load, braking_front_wheel_load] = get_wheel_loads(total_mass_of_car, friction)

Total_Mass = total_mass_of_car;

Friction = friction; 

Wheel_Base = 1.6;
height_of_center_of_mass = 0.403;
Track_width = 1.3;
distance_front_to_cg = 0.961;
distance_back_to_cg = 0.639;
MFV = 3;
MFO = 1.3;
g = 9.81;

%MAX vertical load
front_wheel_weight  =(1/2)*(Total_Mass*g)*(distance_back_to_cg)/(Wheel_Base);
rear_wheel_weight = (1/2)*(Total_Mass*g)*(distance_front_to_cg)/(Wheel_Base);

%acceleration
acceleration_traction_force = (2*rear_wheel_weight*Friction)/(1-(height_of_center_of_mass*Friction/Wheel_Base));
acceleration_weight_transfer = (acceleration_traction_force*height_of_center_of_mass)/(Wheel_Base);
acceleration_front_wheel_weight = (2*front_wheel_weight-acceleration_weight_transfer)/(2);
acceleration_rear_wheel_weight = (2*rear_wheel_weight+acceleration_weight_transfer)/(2);

%braking
braking_traction_force = (g*Total_Mass)*(Friction);
braking_weight_transfer = (braking_traction_force*height_of_center_of_mass)/(Wheel_Base);
braking_front_wheel_load = (2*front_wheel_weight+braking_weight_transfer)/(2);
braking_rear_wheel_load = (2*rear_wheel_weight-braking_weight_transfer)/(2);

%cornering
cornering_weight_transfer = (braking_traction_force*height_of_center_of_mass)/Track_width;
cornering_front_wheel_load =((front_wheel_weight*2)+(cornering_weight_transfer*0.625))/2;

%multiplication_factor_loads
Max_vertical_load = front_wheel_weight * MFV;
Max_braking_load = braking_front_wheel_load*Friction*MFO;
Max_cornering_load = cornering_front_wheel_load*Friction*MFO;
min_acceleration_load = acceleration_front_wheel_weight*Friction*MFO;
end