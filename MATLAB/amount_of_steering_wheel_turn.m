function amount_of_steering_wheel_turn(turning_radius)

rack_travel = 0.04;
wheel_base = 1.6;
radius_of_steering_wheel = 0.15;
track_width = 1.3;


Max_Angle_of_Tire = atan((wheel_base/(turning_radius-track_width/2)))*180/3.1415;
steering_ratio = 180/Max_Angle_of_Tire;
amount_of_steering_turn = rack_travel*steering_ratio/(2*3.1415*radius_of_steering_wheel);

end