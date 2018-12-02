function total_mass_of_car = chassis_analysis(speed, mass_of_driver)
current_radius = 0.1;
target_safety_factor = 1.5;
full_radius = 12.5;
max_radius = 11.5;
min_radius = 0;
tolerance = 0.2;
increment = 0.3;
Force = 0;
count = 0;
mass_of_components = 250;



disp('starting fea...');

while count < 50
[mass_of_tubing,current_safety_factor] = get_lowest_vonmises(current_radius, Force, 0, full_radius);
[Force, mass] = get_impact_force(mass_of_driver, mass_of_tubing, speed, mass_of_components);
if current_safety_factor > target_safety_factor + tolerance && current_radius + 0.3 < max_radius
    current_radius = current_radius + increment;
elseif current_safety_factor < target_safety_factor + tolerance && current_radius - 0.3 > min_radius
    current_radius = current_radius - increment;
end
count = count + 1;
end

%plot
get_lowest_vonmises(current_radius, Force, 1, full_radius);
total_mass_of_car = mass;

shaft_file = 'Z:\\groupABC_complete\\SolidWorks\\Equations\\Frame_equations.txt';
fid = fopen(shaft_file,'w+t');
fprintf(fid,strcat('"thikness"=',num2str(full_radius-current_radius),'\n'));
fclose(fid);


log_file = 'Z:\groupABC_complete\Log\groupABC_LOG.TXT';

fid = fopen(log_file,'w+t');
fprintf(fid,'***Shaft Design***\n');

if current_safety_factor < target_safety_factor
    fprintf(fid, 'the chassis fails because lowest safety factor is below 1.5 \n')
end
fprintf(fid,strcat('minimum chassis safety factor =',32,num2str(current_safety_factor),'. \n '));
fprintf(fid,strcat('Impact Force =',32,num2str(Force*6/1000),' (kN). \n'));
fprintf(fid,strcat('thickness =',32,num2str(full_radius-current_radius),' (mm). \n'));
fprintf(fid,strcat('mass of driver =',32,num2str(mass_of_driver),' (kg). \n'));
fprintf(fid,strcat('mass of tubing =',32,num2str(mass_of_tubing),' (kg). \n'));
fprintf(fid,strcat('sprung mass =',32,num2str(mass),' (kg). \n'));
fprintf(fid,strcat('total mass of car =',32,num2str(mass),' (kg). \n '));


fclose(fid);

disp('finished fea');
end

function [node_force, mass] = get_impact_force(mass_of_driver, mass_car, speed, mass_of_components)
mass = mass_of_driver + mass_car + mass_of_components;
impact_time = 0.5;
acceleration = (speed-0)/impact_time;
impact_force = mass * acceleration;
node_force = impact_force /6;
end