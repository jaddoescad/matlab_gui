function pinion_analysis(total_mass, friction)
Elastic_Coefficent =	191;
SF = 1.68;
Number_of_Wheels=	4;
gravity = 9.81;
Outer_Tie_Rod_Angle = 0.785;
Helix_Angle=0.2618;
Outer_Radius_Steering_Shaft = 0.015;
Number_of_Teeth_Pinion=21;
Module=1.428;
Outer_Radius_Steering_Shaft =0.015;
Sy_Aluminum_1100= 31;
Sy_StainlessSteel_4340=910;

Tangential_force = friction*total_mass/Number_of_Wheels*gravity/cos(Outer_Tie_Rod_Angle)/cos(Outer_Tie_Rod_Angle)/cos(Helix_Angle);
pinion_face_width = 1/((Sy_StainlessSteel_4340/SF/Elastic_Coefficent)^2/(Tangential_force*cos(Helix_Angle)*2.5*2.25*0.93*1.8)*0.95*1.5*0.8*Module*Number_of_Teeth_Pinion);
pinion_surface_fatigue_stress = Elastic_Coefficent*(Tangential_force*cos(Helix_Angle)*2.5*2.25*0.93*1.8/(pinion_face_width*Number_of_Teeth_Pinion*Module*0.8*0.95*1.5))^0.5;
end