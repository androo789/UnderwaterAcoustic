%test script for ofdm encoder and decoder
clear all;
clc;
xf = 4;
ts = .1;

pathdelays = [0, 3, 5, 6, 8];
pathgains =  [0, -2, -5, -8, -20 ];

numsym = 256*256; %number of OFDM symbol
numofdata = numsym*48; % how many symbols
constsize = 4; %constellation size

intdata = randi([0,constsize-1],1, numofdata);
data = qammod(intdata, constsize);% constsize);

tsig = encode_ofdm2(data, 16);

[tsig_c, h] = apply_simple_multipath(tsig, pathdelays, pathgains);

%adjust power level
%tsig_p = tsig_c.*sqrt(0.5/var(tsig_c));
 
%apply gaussian noise, according to some SNR
rsig = awgn(tsig_c, 100);

clear tsig;
clear tsig_c;
clear tsig_p;

%downsample
%rsig = downsample(tsig2, xf);
fsig = decode_ofdm2(rsig, h(1), 16);

bdata = qamdemod(fsig, constsize);

%check errors
[num, rt] = symerr(intdata, bdata(1:length(intdata)));