function out = encode_ofdm2(in, cplen)
% function out = encode_ofdm(in, cplen)
% encodes the incoming constellation symbols in into ofdm symbols
% ofdm sylmbol format is similar to 802.11
% in -> an array (row) of constellation symbols
% out -> an array (row) containing time samples of ofdm symbols

% Copyright Alamgir Mohammed almgir99@gmail.com
% length of FFT is 64, plus 16 for cyclic prefix

% if in is a column vector change it to a row
if(size(in,1) > 1 && size(in,2))
    in = in';
end;

% 48 constellation symbols per ofdm symbol
numofsym = floor(length(in)/48);  
%if odd number of constellation symbols, padd extra zeros
if numofsym*48 < length(in)
    in = [in, zeros(1,48-(length(in)-numofsym*48))];
    numofsym = numofsym+1;
end;

% length of cyclic prefix
%cplen = 64/4;
% length of total ofdm symbol
ofdmsymlen = 64 + cplen;

% prepare one ofdm symbol
asymbol = zeros(1,64);

% remember, matlab index starts at 1, 
asymbol(1) = 0; % dc component
pilotpos = [8, 22, 44, 58]; % bin position of pilot symbols (not used here)
pilotsym = 1; % pilot symbol itself (not used here)
asymbol(pilotpos) = pilotsym;

% bin position of data symbols
datapos1 = [39:43, 45:57, 59:64];
datapos2 = [2:7, 9:21, 23:27]; 

 % initilize the output array
out = zeros(1, numofsym*ofdmsymlen);
ainsym = zeros(1,48); 



wht = waitbar(0,'Transmitting, please wait ...');
% now form each OFDM symbol and place into the output array
for i=1:numofsym;
    
    ainsym(1:48) = in((i-1)*48+1:i*48); % copy 48 data symbols
    
    asymbol(datapos1) = ainsym(1:24); % first half of data symbols
    asymbol(datapos2) = ainsym(25:48); % second half of data symbols
    
    asymbol(pilotpos) = pilotsym; % insert pilot
    
    ofdmsym = ifft(asymbol); % perform IFFT
    
    ofdmsymcp = [ofdmsym(64-cplen+1:64), ofdmsym]; % insret cyclic prefix
    
    % copy the ofdm symbol formed to the output array
    out((i-1)*ofdmsymlen+1:i*ofdmsymlen)=ofdmsymcp;
    
    waitbar(i / numofsym); 
end;
close(wht);
