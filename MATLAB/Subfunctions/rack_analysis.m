function rack_analysis(friction, total_mass)
SF = 2;
Number_of_Wheels=	4;
gravity = 9.81;
Outer_Tie_Rod_Angle = 0.785;
Helix_Angle=0.2618;
Lower_Steering_Shaft_Angle=0.8;
Force_Pushed_by_Driver=100;
Upper_Steering_Shaft_Angle=0.626;
Rack_Diameter=0.048;
yield_strength_al_7075 = 99;

Pressure_Angle	= 0.3491;
Tangential_force = friction*total_mass/Number_of_Wheels*gravity/cos(Outer_Tie_Rod_Angle)/cos(Outer_Tie_Rod_Angle)/cos(Helix_Angle);
radial_force = Tangential_force*tan(Pressure_Angle);
sum_of_forces_in_y = radial_force*cos(Lower_Steering_Shaft_Angle)+Force_Pushed_by_Driver*cos(Upper_Steering_Shaft_Angle)*sin(Lower_Steering_Shaft_Angle);
bending_stress = ((sum_of_forces_in_y*Rack_Diameter/2)*0.024285/(3.1415/64*Rack_Diameter^4))/10^6;
rack_length = yield_strength_al_7075/SF*10^6*(3.1415/64*Rack_Diameter^4)/(0.024285*bending_stress*10^6*3.1415*Rack_Diameter^2/4);
rack_stress = bending_stress*10^6*3.1415*Rack_Diameter^2/4*rack_length*0.024285/(3.1415/64*Rack_Diameter^4)/10^6;
end