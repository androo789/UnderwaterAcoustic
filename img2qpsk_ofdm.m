%image to qpsk
clear all;
%close all;
clc;

img = imread('lena.gif');
img1d = reshape(img, 1, 256*256);

%now 1d array with each number in the range [0, 255]
img_b4 = dec2base(img1d, 4);

for i=1:length(img_b4)
    a = img_b4(i,:);
    img_b4d((i-1)*4+1:i*4) = a(:)-48;
end;

%process the image img_b4
QAM = 4;
data = qammod(img_b4d, QAM);
NFFT = 64;
CPLEN = NFFT/4;
tsig = encode_ofdm(data,CPLEN);
pathdelays = [0, 3, 5, 6, 8];
pathgains =  [0, -2, -5, -8, -20 ];
[tsig_c, h] = apply_simple_multipath(tsig, pathdelays, pathgains);

%gausian nosie, snr=10dB
rsig = awgn(tsig_c, 20);

fsig = decode_ofdm(rsig, h(1), CPLEN);
img_b4d = qamdemod(fsig, 4);


%convert the data back to image
pimg = char(img_b4d+48);
for i=1:256*256;
    a = pimg((i-1)*4+1:i*4);
    pimg_q(i,:) = a;
end;

pimg_d = base2dec(pimg_q, 4);
pimg_u8 = cast(pimg_d, 'uint8');
pimg = reshape(pimg_u8, 256, 256);

figure;
imshow(pimg);

