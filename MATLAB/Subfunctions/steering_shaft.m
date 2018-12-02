function steering_shaft(total_mass, friction)
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

Tangential_force = friction*total_mass/Number_of_Wheels*gravity/cos(Outer_Tie_Rod_Angle)/cos(Outer_Tie_Rod_Angle)/cos(Helix_Angle);
Torque = Tangential_force*Module*Number_of_Teeth_Pinion/1000;
thickness_steering_shaft = Outer_Radius_Steering_Shaft-((((Outer_Radius_Steering_Shaft*2)^4-(Torque*Outer_Radius_Steering_Shaft/(Sy_Aluminum_1100*10^6/SF)*32/3.1414))^0.25)/2);
torsional_stress = Torque*Outer_Radius_Steering_Shaft/(3.1415/32*((Outer_Radius_Steering_Shaft*2)^4-((Outer_Radius_Steering_Shaft-thickness_steering_shaft)*2)^4))/10^6;
%logging damper
log_file = 'Z:\groupABC_complete\Log\groupABC_LOG.TXT';

fid_log = fopen(log_file,'a+');
fprintf(fid_log,'***steering shaft analysis***\n');
 
fprintf(fid_log,strcat('the torsional stress of the steering shaft is =',32,num2str(torsional_stress),'. \n '));
end