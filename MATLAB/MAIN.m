% =========================================================================
% =========================================================================
%                             COMPANY NAME     
% =========================================================================
% =========================================================================

% Developed by: Nathaniel Mailhot
% GROUP: ABC
% University of Ottawa
% Mechanical Engineering
% Latest Revision: 09/09/2017

% =========================================================================
% SOFTWARE DESCRIPTION
% =========================================================================


function varargout = MAIN(varargin)
% MAIN MATLAB code for MAIN.fig
%      MAIN, by itself, creates a new MAIN or raises the existing
%      singleton*.
%
%      H = MAIN returns the handle to a new MAIN or the handle to
%      the existing singleton*.
%
%      MAIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAIN.M with the given input arguments.
%
%      MAIN('Property','Value',...) creates a new MAIN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MAIN_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MAIN_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MAIN

% Last Modified by GUIDE v2.5 01-Dec-2018 21:22:50

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MAIN_OpeningFcn, ...
                   'gui_OutputFcn',  @MAIN_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end

% --- Outputs from this function are returned to the command line.
function varargout = MAIN_OutputFcn(hObject, eventdata, handles) %#ok
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% End initialization code - DO NOT EDIT

% =========================================================================
% =========================================================================
% --- Executes just before MAIN is made visible.
% =========================================================================
% =========================================================================

function MAIN_OpeningFcn(hObject, eventdata, handles, varargin) %#ok
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MAIN (see VARARGIN)

% Choose default command line output for MAIN
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

%Set the default values on the GUI. It is recommended to choose a valid set 
%of default values as a starting point when the program launches.
clc
default_friction_value= 0.7;
set(handles.Friction,'Value',default_friction_value);
set(handles.Friction_txt,'String',num2str(default_friction_value));




%Set the window title with the group identification:
set(handles.figure1,'Name','Group ABC // CADCAM 2017');

%Add the 'subfunctions' folder to the path so that subfunctions can be
%accessed
addpath('Subfunctions');

% =========================================================================

% --- Executes on button press in BTN_Generate.
function BTN_Generate_Callback(hObject, eventdata, handles) %#ok
% hObject    handle to BTN_Generate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if(isempty(handles))
    Wrong_File();
else
    %Get the design parameters from the interface (DO NOT PERFORM ANY DESIGN CALCULATIONS HERE)
    friction = get(handles.Friction,'Value');
    
    velocity = get(handles.velocity,'Value');
    mass_of_driver = get(handles.mass_of_driver,'Value');
    turning_radius = get(handles.Turning_Radius,'Value');
    %The design calculations are done within this function. This function is in the file Design_code.m
    total_mass_of_car = chassis_analysis(velocity, mass_of_driver);
    wishbone_analysis(total_mass_of_car, friction);
    pushrod_analysis(total_mass_of_car, friction);
    stiffness_K = spring_analysis(total_mass_of_car, friction);
    damper_analysis(total_mass_of_car, friction, stiffness_K);
    steering_shaft(total_mass_of_car, friction);
    u_joint(friction, total_mass_of_car);
    pinion_analysis(total_mass_of_car, friction);
    gear_bearing_analysis(friction,total_mass_of_car)
    rack_analysis(friction, total_mass_of_car);
    tierod_analysis(friction, total_mass_of_car);
   
    amount_of_steering_wheel_turn(turning_radius);
  
    
    %Show the results on the GUI.
    log_file = 'Z:\groupABC_complete\Log\groupABC_LOG.TXT';
    fid = fopen(log_file,'r'); %Open the log file for reading
    S=char(fread(fid)'); %Read the file into a string
    fclose(fid);
    set(handles.TXT_log,'String',S); %write the string into the textbox
    set(handles.TXT_path,'String',log_file); %show the path of the log file
    set(handles.TXT_path,'Visible','on');
end

% =========================================================================

% --- Executes on button press in BTN_Finish.
function BTN_Finish_Callback(hObject, eventdata, handles) %#ok
% hObject    handle to BTN_Finish (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close gcf

% =========================================================================

% --- Gives out a message that the GUI should not be executed directly from
% the .fig file. The user should run the .m file instead.
function Wrong_File()
clc
h = msgbox('You cannot run the MAIN.fig file directly. Please run the program from the Main.m file directly.','Cannot run the figure...','error','modal');
uiwait(h);
disp('You must run the MAIN.m file. Not the MAIN.fig file.');
disp('To run the MAIN.m file, open it in the editor and press ');
disp('the green "PLAY" button, or press "F5" on the keyboard.');
close gcf

% if(isempty(handles))
%     Wrong_File();
% else
%     value = round(str2double(get(hObject,'String')));
% 
%     %Apply basic testing to see if the value does not exceed the range of the
%     %slider (defined in the gui)
%     if(value<get(handles.Friction,'Min'))
%         value = get(handles.Friction,'Min');
%     end
%     if(value>get(handles.Friction,'Max'))
%         value = get(handles.Friction,'Max');
%     end
%     set(hObject,'String',value);
%     set(handles.Friction,'Value',value);
% end


% =========================================================================
% =========================================================================
% The functions below are created by the GUI. Do not delete any of them! 
% Adding new buttons and inputs will add more callbacks and createfcns.
% =========================================================================
% =========================================================================


function TXT_log_Callback(hObject, eventdata, handles) %#ok
% hObject    handle to TXT_log (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TXT_log as text
%        str2double(get(hObject,'String')) returns contents of TXT_log as a double

% --- Executes during object creation, after setting all properties.
function TXT_log_CreateFcn(hObject, eventdata, handles) %#ok
% hObject    handle to TXT_log (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on slider movement.
function Friction_Callback(hObject, eventdata, handles) %#ok
% hObject    handle to Friction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

if(isempty(handles))
    Wrong_File();
else
    value = get(hObject,'Value'); %Round the value to the nearest integer
    set(handles.Friction_txt,'String',num2str(value));
end

% --- Executes during object creation, after setting all properties.
function Friction_CreateFcn(hObject, eventdata, handles) %#ok
% hObject    handle to Friction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes during object creation, after setting all properties.
function Friction_txt_CreateFcn(hObject, eventdata, handles) %#ok
% hObject    handle to Friction_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% % --- Executes on slider movement.
% function Wishbone_thickness_Callback(hObject, eventdata, handles) %#ok
% % hObject    handle to Friction (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% % Hints: get(hObject,'Value') returns position of slider
% %        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
% 
% if(isempty(handles))
%     Wrong_File();
% else
%     value = round(get(hObject,'Value')); %Round the value to the nearest integer
%     set(handles.Friction_txt,'String',num2str(value));
% end


% --- Executes on slider movement.
function Turning_Radius_Callback(hObject, eventdata, handles)
% hObject    handle to Turning_Radius (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
if(isempty(handles))
    Wrong_File();
else
    value = round(get(hObject,'Value')); %Round the value to the nearest integer
    set(handles.Turning_radius_txt,'String',num2str(value));
end


% --- Executes during object creation, after setting all properties.
function Turning_Radius_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Turning_Radius (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function Turning_radius_txt_Callback(hObject, eventdata, handles)
% hObject    handle to Turning_radius_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Turning_radius_txt as text
%        str2double(get(hObject,'String')) returns contents of Turning_radius_txt as a double
if(isempty(handles))
    Wrong_File();
else
    value = round(str2double(get(hObject,'String')));

    %Apply basic testing to see if the value does not exceed the range of the
    %slider (defined in the gui)
    if(value<get(handles.Turning_Radius,'Min'))
        value = get(handles.Turning_Radius,'Min');
    end
    if(value>get(handles.Turning_Radius,'Max'))
        value = get(handles.Turning_Radius,'Max');
    end
    set(hObject,'String',value);
    set(handles.Turning_Radius,'Value',value);
end


% --- Executes during object creation, after setting all properties.
function Turning_radius_txt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Turning_radius_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Velocity_txt_Callback(hObject, eventdata, handles)
% hObject    handle to Velocity_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Velocity_txt as text
%        str2double(get(hObject,'String')) returns contents of Velocity_txt as a double
if(isempty(handles))
    Wrong_File();
else
    value = round(str2double(get(hObject,'String')));

    %Apply basic testing to see if the value does not exceed the range of the
    %slider (defined in the gui)
    if(value<get(handles.velocity,'Min'))
        value = get(handles.velocity,'Min');
    end
    if(value>get(handles.velocity,'Max'))
        value = get(handles.velocity,'Max');
    end
    set(hObject,'String',value);
    set(handles.velocity,'Value',value);
end

% --- Executes during object creation, after setting all properties.
function Velocity_txt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Velocity_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function mass_of_driver_txt_Callback(hObject, eventdata, handles)
% hObject    handle to mass_of_driver_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mass_of_driver_txt as text
%        str2double(get(hObject,'String')) returns contents of mass_of_driver_txt as a double
if(isempty(handles))
    Wrong_File();
else
    value = round(str2double(get(hObject,'String')));

    %Apply basic testing to see if the value does not exceed the range of the
    %slider (defined in the gui)
    if(value<get(handles.mass_of_driver,'Min'))
        value = get(handles.mass_of_driver,'Min');
    end
    if(value>get(handles.mass_of_driver,'Max'))
        value = get(handles.mass_of_driver,'Max');
    end
    set(hObject,'String',value);
    set(handles.mass_of_driver,'Value',value);
end

% --- Executes during object creation, after setting all properties.
function mass_of_driver_txt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mass_of_driver_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function mass_of_driver_Callback(hObject, eventdata, handles)
% hObject    handle to mass_of_driver (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
if(isempty(handles))
    Wrong_File();
else
    value = round(get(hObject,'Value')); %Round the value to the nearest integer
    set(handles.mass_of_driver_txt,'String',num2str(value));
end


% --- Executes during object creation, after setting all properties.
function mass_of_driver_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mass_of_driver (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function velocity_Callback(hObject, eventdata, handles)
% hObject    handle to velocity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
if(isempty(handles))
    Wrong_File();
else
    value = round(get(hObject,'Value')); %Round the value to the nearest integer
    set(handles.Velocity_txt,'String',num2str(value));
end



% --- Executes during object creation, after setting all properties.
function velocity_CreateFcn(hObject, eventdata, handles)
% hObject    handle to velocity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on mouse press over axes background.
function axes1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function Friction_txt_Callback(hObject, eventdata, handles)
% hObject    handle to Friction_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Friction_txt as text
%        str2double(get(hObject,'String')) returns contents of Friction_txt as a double
if(isempty(handles))
    Wrong_File();
else
    value = str2double(get(hObject,'String'));

    %Apply basic testing to see if the value does not exceed the range of the
    %slider (defined in the gui)
    if(value<get(handles.Friction,'Min'))
        value = get(handles.Friction,'Min');
    end
    if(value>get(handles.Friction,'Max'))
        value = get(handles.Friction,'Max');
    end
    set(hObject,'String',value);
    set(handles.Friction,'Value',value);
end


% --- Executes on selection change in popupmenu3.
function popupmenu3_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu3


% --- Executes during object creation, after setting all properties.
function popupmenu3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
