function pushrod_analysis(total_mass_of_car, friction)
Safety_factor = 1.6;
pushrod_length = 482;
E = 200000;
pushrod_outer_diameter = 15;
[max_wishbone_tensile_force,max_wishbone_compressive_force, F_pushrod_max_vertical_load,acceleration_pushrod_force]= get_wishbone_forces(total_mass_of_car, friction);
pushrod_moment_of_inertia = (Safety_factor*F_pushrod_max_vertical_load*(pushrod_length^2))/((pi()^2)*E);
pushrod_inner_diameter = 2*((((-pushrod_moment_of_inertia)/pi())+((pushrod_outer_diameter/2))^4)^(1/4));
thickness = pushrod_outer_diameter - pushrod_inner_diameter;

log_file = 'Z:\groupABC_complete\Log\groupABC_LOG.TXT';

fid_log = fopen(log_file,'a+');
fprintf(fid_log,'***Pushrod Analysis***\n');
 
if thickness > 0.1 && thickness < pushrod_outer_diameter/2
fprintf(fid_log,strcat('for a safety factor of 1.6, thickness of pushrod must be =',32,num2str(thickness),'. \n '));
fclose(fid_log);
else
fprintf(fid_log,'safety factor of 1.6 could not be reached\n');
fclose(fid_log);
end
end