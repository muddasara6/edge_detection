function varargout = edge_detection(varargin)
% EDGE_DETECTION MATLAB code for edge_detection.fig
%      EDGE_DETECTION, by itself, creates a new EDGE_DETECTION or raises the existing
%      singleton*.
%
%      H = EDGE_DETECTION returns the handle to a new EDGE_DETECTION or the handle to
%      the existing singleton*.
%
%      EDGE_DETECTION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EDGE_DETECTION.M with the given input arguments.
%
%      EDGE_DETECTION('Property','Value',...) creates a new EDGE_DETECTION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before edge_detection_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to edge_detection_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help edge_detection

% Last Modified by GUIDE v2.5 03-Jan-2019 11:45:04

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @edge_detection_OpeningFcn, ...
                   'gui_OutputFcn',  @edge_detection_OutputFcn, ...
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
% End initialization code - DO NOT EDIT

% --- Executes just before edge_detection is made visible.
function edge_detection_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to edge_detection (see VARARGIN)

% Choose default command line output for edge_detection
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes edge_detection wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = edge_detection_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
set(handles.canny,'Enable','off')
set(handles.sobel,'Enable','off')
set(handles.roberts,'Enable','off')
set(handles.custom,'Enable','off')
set(handles.display,'Enable','off')
set(handles.reset,'Enable','off')

% --- Executes on button press in upload.
function upload_Callback(hObject, eventdata, handles)
% hObject    handle to upload (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% declare variable as global
global im
% get files from directory
[path, user_cance] = imgetfile();
% if statement for an error message if there is a problem uploading image
if user_cance
    msgbox(sprintf('Error'),'Error','Error');
    return
end
% read image from graphics file
im = imread(path);
ma = imread('signature.jpg');
% crop the image
ma2 = imcrop(ma, [5, 5, 100, 50]);
% get size of image and set its row and column 
[row, col, ~] = size(ma2);
% for loop creating the row and column
for i=1:1:row
    for j=1:1:col
        % used to present an image from brightness or greyscale ranges
        im(i,j,1:1) = min(ma2(i,j,1:1), im(i,j,1:1));
    end
end
% current axes to be set to image1
axes(handles.image1);
% display image
imshow(im);

% --- Executes on button press in display.
function display_Callback(hObject, eventdata, handles)
% hObject    handle to display (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im
global im2
global im3
% if statements to handle checkbox value
if handles.black_and_white.Value
    [numberOfColorChannels] = size(im);
    if numberOfColorChannels > 1
        % set image to rgb to gray
        im2 = rgb2gray(im);
        axes(handles.image2);
        imshow(im2);
    end
elseif handles.canny.Value
    % create canny edge detection to image
    im3 = edge(im2,'canny');
    axes(handles.image2);
    imshow(im3);
elseif handles.sobel.Value
    % create sobel edge detection to image
    im3 = edge(im2,'sobel');
    axes(handles.image2);
    imshow(im3);
elseif handles.roberts.Value
    % create roberts edge detection to image
    im3 = edge(im2,'roberts');
    axes(handles.image2);
    imshow(im3);
elseif handles.custom.Value 
    [row, col] = size(im2);   
    for x=2:row-8
        for y=8:col-8
            % set the brightness and grayscale ranged from 0 to 8
            im2(x,y) = abs(im(x,y) - im(x+3,y+4)) + abs(im(x+8,y+7) ...
                - im(x+6,y+2));
        end
    end
    axes(handles.image2);
    imshow(im2);
end

% --- Executes on button press in black_and_white.
function black_and_white_Callback(hObject, eventdata, handles)
% hObject    handle to black_and_white (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% checkbox for black and white edge detection 
if handles.black_and_white.Value
    % enables checkboxes or buttons
    set(handles.display,'Enable','on')
    set(handles.reset,'Enable','on')
    % disables checkboxes or buttons
    set(handles.canny,'Enable','off')
    set(handles.sobel,'Enable','off')
    set(handles.roberts,'Enable','off')
    set(handles.custom,'Enable','off')
else
    set(handles.display,'Enable','off')
    set(handles.black_and_white,'Enable','off')
    set(handles.canny,'Enable','on')
    set(handles.sobel,'Enable','off')
    set(handles.roberts,'Enable','off')
    set(handles.custom,'Enable','off')
end
% Hint: get(hObject,'Value') returns toggle state of black_and_white

% --- Executes on button press in canny.
function canny_Callback(hObject, eventdata, handles)
% hObject    handle to canny (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of canny

% checkbox for canny edge detection 
if handles.canny.Value
    set(handles.display,'Enable','on')
    set(handles.black_and_white,'Enable','off')
    set(handles.sobel,'Enable','off')
    set(handles.roberts,'Enable','off')
    set(handles.custom,'Enable','off')
else
    set(handles.display,'Enable','off')
    set(handles.canny,'Enable','off')
    set(handles.black_and_white,'Enable','off')
    set(handles.sobel,'Enable','on')
    set(handles.roberts,'Enable','off')
    set(handles.custom,'Enable','off')
end

% --- Executes on button press in sobel.
function sobel_Callback(hObject, eventdata, handles)
% hObject    handle to sobel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of sobel

% checkbox for sobel edge detection 
if handles.sobel.Value
    set(handles.display,'Enable','on')
    set(handles.black_and_white,'Enable','off')
    set(handles.canny,'Enable','off')
    set(handles.roberts,'Enable','off')
    set(handles.custom,'Enable','off')
else
    set(handles.display,'Enable','off')
    set(handles.sobel,'Enable','off')
    set(handles.black_and_white,'Enable','off')
    set(handles.canny,'Enable','off')
    set(handles.roberts,'Enable','on')
    set(handles.custom,'Enable','off')
end

% --- Executes on button press in roberts.
function roberts_Callback(hObject, eventdata, handles)
% hObject    handle to roberts (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of roberts

% checkbox for roberts edge detection 
if handles.roberts.Value
    set(handles.display,'Enable','on')
    set(handles.black_and_white,'Enable','off')
    set(handles.sobel,'Enable','off')
    set(handles.canny,'Enable','off')
    set(handles.custom,'Enable','off')
else
    set(handles.display,'Enable','off')
    set(handles.roberts,'Enable','off')
    set(handles.black_and_white,'Enable','off')
    set(handles.sobel,'Enable','off')
    set(handles.canny,'Enable','off')
    set(handles.custom,'Enable','on')
end

% --- Executes on button press in custom.
function custom_Callback(hObject, eventdata, handles)
% hObject    handle to custom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of custom

% checkbox for custom edge detection 
if handles.custom.Value
    set(handles.reset,'Enable','on')
    set(handles.display,'Enable','on')
    set(handles.black_and_white,'Enable','off')
    set(handles.sobel,'Enable','off')
    set(handles.roberts,'Enable','off')
    set(handles.canny,'Enable','off')
else
    set(handles.display,'Enable','off')
    set(handles.custom,'Enable','off')
    set(handles.black_and_white,'Enable','off')
    set(handles.sobel,'Enable','off')
    set(handles.roberts,'Enable','off')
    set(handles.canny,'Enable','off')
end

% --- Executes on button press in reset.
function reset_Callback(hObject, eventdata, handles)
% hObject    handle to reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)7

% resets everything back to its original form
% reset checkboxes
set(handles.black_and_white,'value',0);
set(handles.canny,'value',0);
set(handles.sobel,'value',0);
set(handles.roberts,'value',0);
set(handles.custom, 'value',0);
set(handles.black_and_white,'Enable','on');
set(handles.canny,'Enable','off');
set(handles.sobel,'Enable','off');
set(handles.roberts,'Enable','off');
set(handles.custom,'Enable','off');
global im
axes(handles.image2);
imshow(im);

% --- Executes on button press in exit.
function exit_Callback(hObject, eventdata, handles)
% hObject    handle to exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% clears workspace, closes all figures, and clears command window.
clc;
close all;