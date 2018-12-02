
function gear_bearing_analysis(friction,total_mass)

SF = 2.36;
Number_of_Wheels=	4;
gravity = 9.81;
Outer_Tie_Rod_Angle = 0.785;
Helix_Angle=0.2618;

Pressure_Angle	= 0.3491;
Tangential_force = friction*total_mass/Number_of_Wheels*gravity/cos(Outer_Tie_Rod_Angle)/cos(Outer_Tie_Rod_Angle)/cos(Helix_Angle);
radial_force = Tangential_force*tan(Pressure_Angle);
life = 90*10^6*(3.3/(radial_force))^3.33;
rated_capacity = radial_force*(life/(90*10^6))^0.3;

end