function damper_analysis(mass_of_car, friction, wheel_rate_stiffness)


tire_stiffness = 110000;
unsprung_mass_perwheel = 17.25;
sprung_mass_per_wheel = (mass_of_car - unsprung_mass_perwheel)/4;

%analysis
Kr_ride_rate = wheel_rate_stiffness*tire_stiffness/(wheel_rate_stiffness+tire_stiffness);
sprung_frequency =(1/(2*pi()))*(Kr_ride_rate/sprung_mass_per_wheel)^(1/2);
unsprung_frequency = (((wheel_rate_stiffness+tire_stiffness)/unsprung_mass_perwheel)^(1/2))/(2*pi());

%damping ratio
high_speed_compression_damping_ratio = 0.8;
low_speed_compression_damping_ratio = 0.3;
compression_rebound_damping_ratio = 0.7;

motion_ratio = (wheel_rate_stiffness/tire_stiffness);
critical_damping_sprung_mass = (4*pi()*sprung_mass_per_wheel*(motion_ratio^(1/2))*sprung_frequency);
critical_damping_unsprung_mass =(4*pi()*unsprung_frequency*(motion_ratio^(1/2))*unsprung_mass_perwheel);
low_speed_compression_damping_coefficient = critical_damping_sprung_mass*low_speed_compression_damping_ratio;
low_speed_rebound_damping_coefficient = low_speed_compression_damping_coefficient*compression_rebound_damping_ratio;
high_speed_compression_damping_coefficient = critical_damping_unsprung_mass * high_speed_compression_damping_ratio;
high_speed_rebound_damping_coefficient = high_speed_compression_damping_coefficient*compression_rebound_damping_ratio;

%piston buckling
safety_factor = 2;
E=	200000000000;
length=0.12;
[max_wishbone_tensile_force,max_wishbone_compressive_force, F_pushrod_max_vertical_load, acceleration_pushrod_force] = get_wishbone_forces(mass_of_car, friction);
P_critical = F_pushrod_max_vertical_load*safety_factor;
min_diameter =((64*P_critical*((length)^2))/((pi()^3)*E))^(1/4);

damper_length = 0.12;
damper_diameter = 0.033;
high_speed_compression_orifice_diameter = 0.0016;
high_speed_rebound_orifice_diameter = 0.0018;

%high speed compression
com_number_of_orifice_num = 8*damper_length*(damper_diameter^2)*0.0331*((damper_diameter^2)-(high_speed_compression_orifice_diameter^2));
com_number_of_orifice_den = high_speed_compression_damping_coefficient*(high_speed_compression_orifice_diameter^4);
h_s_c_number_of_orifices = ceil(com_number_of_orifice_num/com_number_of_orifice_den);

%high speed rebound
rebound_number_of_orifice_num = 8*damper_length*(damper_diameter^2)*0.0331*((damper_diameter^2)-(high_speed_rebound_orifice_diameter^2));
rebound_number_of_orifice_den = high_speed_rebound_damping_coefficient*(high_speed_rebound_orifice_diameter^4);
h_s_r_number_of_orifices = ceil(rebound_number_of_orifice_num/rebound_number_of_orifice_den);

%logging damper
log_file = 'Z:\groupABC_complete\Log\groupABC_LOG.TXT';

fid_log = fopen(log_file,'a+');
fprintf(fid_log,'***Damper Analysis***\n');
 
fprintf(fid_log,strcat('the ride rate is =',32,num2str(Kr_ride_rate),'. \n '));
fprintf(fid_log,strcat('the sprung frequency is =',32,num2str(sprung_frequency),'. \n '));
fprintf(fid_log,strcat('the unsprung frequency is =',32,num2str(unsprung_frequency),'. \n '));


fprintf(fid_log,strcat('the minimum diameter is =',32,num2str(min_diameter),'. \n '));
fprintf(fid_log,strcat('the minimum number of orifices for high speed compression is =',32,num2str(h_s_c_number_of_orifices),'. \n '));
fprintf(fid_log,strcat('the minimum number of orifices for high speed rebound is =',32,num2str(h_s_r_number_of_orifices),'. \n '));



fclose(fid_log);

end