function out = decode_ofdm2(in, chan, cplen)
%function out = decode_ofdm(in, chan)
% decodes the incoming ofdm symbols into constellation symbols
% in -> an array (row) of ofdm symbols
% chan -> the channel in freq domain
% out -> an array (row) constellation symbols

% Copyright Alamgir Mohammed almgir99@gmail.com
% length of FFT is 64, plus 16 for cyclic prefix
% channel is flat fading (same gain for all bins)

%cplen = 64/4;
ofdmsymlen = 64 + cplen;

numofsym = length(in)/ofdmsymlen;   
%if odd number of samples, padd extra zeros, or possibly error
if numofsym*ofdmsymlen < length(in)
    in = [in, zeros(length(in)-numofsym*ofdmsymlen,1)];
    numofsym = numofsym + 1;
end;

numofsym = cast(numofsym, 'int32');

datapos1 = [39:43, 45:57, 59:64];
datapos2 = [2:7, 9:21, 23:27];

out = zeros([1, numofsym*48]); %make the output array
constdata = zeros([1,48]); %constallation data for an ofdm symbol
decdata = zeros(1,48); %decoded constallation data for an ofdm symbol

ofdmsym = zeros(1,64);

whr = waitbar(0,'Receiving, please wait ...');
for i=1:numofsym;
   
    ofdmsym(:) = in((i-1)*ofdmsymlen+1+cplen:i*ofdmsymlen); % copy an ofdm symbol with skipping CP
    decsym = fft(ofdmsym); %convert to freq domain
    
    decdata(1:24) = decsym(datapos1);%first half of data symbols
    decdata(25:48) = decsym(datapos2);%second half of data symbols
    
    %estimate channel from the pilot tones
    %apply channel gain
    constdata = decdata./chan;
    
    %copy decoded data
    out((i-1)*48+1:i*48)=constdata;
    
    waitbar(i/numofsym);
end;
close(whr);