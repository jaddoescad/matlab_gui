function stiffness_K = spring_analysis(mass_of_car, friction)

G = 70000000000;
diameter_of_coil = 0.05;
Ks=1.05;
Tow_solid = 	562490000;
deflection = 0.05;


[max_wishbone_tensile_force,max_wishbone_compressive_force, F_pushrod_max_vertical_load, acceleration_pushrod_force] = get_wishbone_forces(mass_of_car, friction);


stiffness_K =(F_pushrod_max_vertical_load-acceleration_pushrod_force)/deflection;
clash_allowance = 0.1*(F_pushrod_max_vertical_load/stiffness_K);
Fs = F_pushrod_max_vertical_load+(stiffness_K*clash_allowance);
wire_diameter = ((8*Fs*diameter_of_coil*Ks)/(3.141*Tow_solid))^(1/3);
active_coils =((wire_diameter^4)*G)/(8*(diameter_of_coil^3)*stiffness_K);
solid_length = active_coils*wire_diameter;
free_length = solid_length+(Fs/stiffness_K);
average_length = (solid_length+free_length)/2;
average_length = (solid_length+free_length)/2;
total_coils = active_coils+2;


log_file = 'Z:\groupABC_complete\Log\groupABC_LOG.TXT';

fid_log = fopen(log_file,'a+');
fprintf(fid_log,'***spring Analysis***\n');
 
fprintf(fid_log,strcat('wire_diameter of spring is =',32,num2str(wire_diameter),'. \n '));
fprintf(fid_log,strcat('average length of spring is =',32,num2str(average_length),'. \n '));
fprintf(fid_log,strcat('total number of coils of spring is =',32,num2str(total_coils),'. \n '));

fclose(fid_log);
end