function varargout = ofdm_txrx_gui(varargin)
% OFDM_TXRX_GUI MATLAB code for ofdm_txrx_gui.fig
%      OFDM_TXRX_GUI, by itself, creates a new OFDM_TXRX_GUI or raises the existing
%      singleton*.
%
%      H = OFDM_TXRX_GUI returns the handle to a new OFDM_TXRX_GUI or the handle to
%      the existing singleton*.
%
%      OFDM_TXRX_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in OFDM_TXRX_GUI.M with the given input arguments.
%
%      OFDM_TXRX_GUI('Property','Value',...) creates a new OFDM_TXRX_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ofdm_txrx_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ofdm_txrx_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ofdm_txrx_gui

% Last Modified by GUIDE v2.5 08-Apr-2015 20:44:09

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ofdm_txrx_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @ofdm_txrx_gui_OutputFcn, ...
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


% --- Executes just before ofdm_txrx_gui is made visible.
function ofdm_txrx_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ofdm_txrx_gui (see VARARGIN)

handles.tx_img_data = zeros(256, 256);
handles.rx_img_data = zeros(256, 256);
handles.numpath = 5;
handles.pathdelays = [0, 3, 5, 6, 8];
handles.pathgains =  [0, -2, -5, -8, -20 ];
handles.SNR = 20;


clc;

% Choose default command line output for ofdm_txrx_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ofdm_txrx_gui wait for user response (see UIRESUME)
% uiwait(handles.figOFDM_Demo);


% --- Outputs from this function are returned to the command line.
function varargout = ofdm_txrx_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pbSelectImage.
function pbSelectImage_Callback(hObject, eventdata, handles)
% hObject    handle to pbSelectImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[FileName,PathName] = uigetfile('*.gif','Select an image file');
if FileName ~= 0
    imgData=imread(FileName);
    handles.tx_img_data = imgData;
    subplot(handles.img_tx);
    imshow(handles.tx_img_data);
end;
% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function figOFDM_Demo_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figOFDM_Demo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in pbTransmit.
function pbTransmit_Callback(hObject, eventdata, handles)
% hObject    handle to pbTransmit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%transmit the image and
%show the receivec image
%set(gcs, 'Pointer', 'watch');
subplot(handles.img_rx);
handles.rx_img_data = do_tx_rx(handles.tx_img_data, handles.numpath, ...
    handles.pathdelays, handles.pathgains, handles.SNR);

imshow(handles.rx_img_data);
%set(gcs, 'Pointer', 'arrow');
% Update handles structure
guidata(hObject, handles);
    


% --- Executes on selection change in npathPopUp.
function npathPopUp_Callback(hObject, eventdata, handles)
% hObject    handle to npathPopUp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns npathPopUp contents as cell array
%        contents{get(hObject,'Value')} returns selected item from npathPopUp

val = get(hObject, 'Value');
str = get(hObject, 'String');
handles.numpath = str2double(str{val});
guidata(hObject, handles);
%handles.numpath
        

% --- Executes during object creation, after setting all properties.
function npathPopUp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to npathPopUp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edSNR_Callback(hObject, eventdata, handles)
% hObject    handle to edSNR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edSNR as text
%        str2double(get(hObject,'String')) returns contents of edSNR as a double

snr = str2double(get(hObject,'String'));
if snr > 0 && snr <= 200
    handles.SNR = snr;
end;
guidata(hObject, handles);
%handles.SNR

% --- Executes during object creation, after setting all properties.
function edSNR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edSNR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
