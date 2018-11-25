%This function is the main "design" function.
function Design_code(thickness)
    %Check if the user tries to run this file directly
    if ~exist('axial_force','var')
        cd Z:\groupABC_complete\MATLAB\
        run Z:\groupABC_complete\MATLAB\MAIN.m; %Run Main.m instead
        return
    end
    

    shaft_file = 'Z:\\groupABC_complete\\SolidWorks\\Equations\\shaft.txt';
    fid = fopen(shaft_file,'w+t');
    fprintf(fid,strcat('"thick"=',num2str(new_diameter),'\n'));
    fclose(fid);
end