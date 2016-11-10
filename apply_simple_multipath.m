function [out, h] = apply_simple_multipath(sig, npath, delays, pdb)
%function [out] = apply_simple_multipath(sig, delays, pdb)
%apply simple  multipath channel,
% no doppler fading (static channel)
% only frequncy selective fading due to multipath

% based on the "two-ray Rayleigh Fading model" from Rapaport - chapter 5
% Copyright Alamgir Mohammed almgir99@gmail.com
% sig -> input signal
% pdb  -> power of the paths in dBs
% delays -> delays of the paths (LOS path has delay 0)

totpower = 0;
len = length(sig); %length of the signal 
if length(delays) < npath
    npath = length(delays);
end;

for pathcount=1:length(delays);   
    %power of a path in linear scale
    power = 10^(pdb(pathcount)/10);
    
    %the path gain is a Rayleigh variable, but does not change over time
    gains(pathcount) = sqrt(power)*abs(randn(1,1)+j*randn(1,1)); % static channel
     
    %random phase
    gains(pathcount) = gains(pathcount)*exp(j*2*pi*rand(1,1));
    totpower = totpower + abs(gains(pathcount));
end;
    

%make room for output signal
out = zeros(1, length(sig)+max(delays)); 

%combine all paths
for pathcount=1:npath
    delay = delays(pathcount);
    out(1+delay:len+delay) = out(1+delay:len+delay) + ...
        sig.*gains(pathcount);
end;

%adjust power
out = out.*sqrt(1/totpower);

%channel impulse response (for testing purpose)
h = zeros(1,npath);
for pathcount=1:length(delays)
    delay = delays(pathcount);
    h(1+delay) = gains(pathcount);
end;
