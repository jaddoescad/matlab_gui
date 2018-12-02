function wishbone_analysis(mass_of_car, friction)
E = 200000;
wishbone_outer_diameter = 15;

[min_acceleration_load,Max_vertical_load,Max_braking_load,Max_cornering_load, braking_front_wheel_load] = get_wheel_loads(mass_of_car, friction);
[max_wishbone_tensile_force,max_wishbone_compressive_force, F_pushrod_max_vertical_load, acceleration_pushrod_force]= get_wishbone_forces(mass_of_car, friction);

Applied_force_across_wishbone_arm = max_wishbone_compressive_force; %changeable
Tensile_force_on_wishbone_arm = max_wishbone_tensile_force; %changeable
max_vertical_load = Max_vertical_load;

reaction_vertical_load = max_vertical_load/2;
Length_of_wishbone_arm = 453.06;
Safety_factor = 1.6;
yield_strength = 305;




buckling_wishbone_inner_diameter = buckling_analysis(E, Applied_force_across_wishbone_arm, Length_of_wishbone_arm, Safety_factor,wishbone_outer_diameter);
axial_wishbone_inner_diameter = axial_analysis(E, yield_strength, Safety_factor, wishbone_outer_diameter, Tensile_force_on_wishbone_arm);
bending_wishbone_inner_diameter = bending_analysis(wishbone_outer_diameter, Length_of_wishbone_arm, Safety_factor,reaction_vertical_load, yield_strength);

minimum_wishbone_inner_diameter = min([buckling_wishbone_inner_diameter, axial_wishbone_inner_diameter , bending_wishbone_inner_diameter]);
thickness = wishbone_outer_diameter-minimum_wishbone_inner_diameter;


shaft_file = 'Z:\\groupABC_complete\\SolidWorks\\Equations\\wishbone_bottom_front_equations.txt';
log_file = 'Z:\groupABC_complete\Log\groupABC_LOG.TXT';

fid = fopen(shaft_file,'w+t');
fid_log = fopen(log_file,'a+');
fprintf(fid_log,'***Wishbone Analysis***\n');
 
if thickness > 0.1 && thickness < wishbone_outer_diameter/2
fprintf(fid,strcat('"thick"=',num2str(thickness),'\n'));
fprintf(fid_log,strcat('for a safety factor of 1.6, thickness of wishbone must be =',32,num2str(thickness),'. \n '));
fclose(fid);
fclose(fid_log);
else
fprintf(fid_log,'safety factor of 1.6 could not be reached\n');
fclose(fid);
fclose(fid_log);
end
end


function wishbone_inner_diameter = buckling_analysis(E, Applied_force_across_wishbone_arm, Length_of_wishbone_arm, Safety_factor,wishbone_outer_diameter )
I = (Safety_factor*Applied_force_across_wishbone_arm*(Length_of_wishbone_arm^2))/((pi()^2)*E);
wishbone_inner_diameter = 2*((((-I)/pi())+((wishbone_outer_diameter/2))^4)^(1/4));
end

function wishbone_inner_diameter = axial_analysis(E, yield_strength, Safety_factor, wishbone_outer_diameter, Tensile_force_on_wishbone_arm)
A =Tensile_force_on_wishbone_arm*Safety_factor/yield_strength;
wishbone_inner_diameter = 2*(((-A/pi())+((wishbone_outer_diameter/2)^2))^(1/2));
end

function wishbone_inner_diameter = bending_analysis(wishbone_outer_diameter, Length_of_wishbone_arm, Safety_factor,reaction_vertical_load, yield_strength)
yield_strength=yield_strength*1000;

M = Length_of_wishbone_arm*(reaction_vertical_load*2);
wishbone_inner_diameter = 2*((wishbone_outer_diameter/2)^4-((2*M*(wishbone_outer_diameter/2))/(pi()*(yield_strength/Safety_factor))))^(1/4);
end
