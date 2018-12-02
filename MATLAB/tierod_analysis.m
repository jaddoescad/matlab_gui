function tierod_analysis(friction, total_mass)

[acceleration_front_wheel_weight,Max_vertical_load,Max_braking_load,Max_cornering_load, braking_front_wheel_load] = get_wheel_loads(total_mass, friction);
Distance_to_Center_of_Cross = 0.0225;
SF = 2.36;
Number_of_Wheels=	4;
gravity = 9.81;
Outer_Tie_Rod_Angle = 0.785;
Helix_Angle=0.2618;
Outer_Radius_Steering_Shaft = 0.015;
Number_of_Teeth_Pinion=21;
Module=1.428;
Outer_Radius_Steering_Shaft =0.015;
Sy_Aluminum_1100= 31;
Outer_Tie_Rod_Angle =	0.785;
Inner_Tie_Rod_Angle =0.2618;
Outer_Radius_Tie_Rod =0.015;
Sy_Aluminum_1100= 31;
SF= 3.71;
Tangential_force = friction*total_mass/Number_of_Wheels*gravity/cos(Outer_Tie_Rod_Angle)/cos(Outer_Tie_Rod_Angle)/cos(Helix_Angle);
sum_of_forces_in_x = Tangential_force*cos(Helix_Angle)+braking_front_wheel_load*cos(Outer_Tie_Rod_Angle+Inner_Tie_Rod_Angle);
tie_rod_thickness = Outer_Radius_Tie_Rod-(Outer_Radius_Tie_Rod^2-((sum_of_forces_in_x/(Sy_Aluminum_1100*10^6/SF))/(3.1415)))^0.5;
tie_rod_buckling = sum_of_forces_in_x/(3.1415*(Outer_Radius_Tie_Rod^2-(Outer_Radius_Tie_Rod-tie_rod_thickness)^2))/10^6;

end