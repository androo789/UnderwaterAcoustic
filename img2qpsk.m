%image to qpsk
clear all;
img = imread('lena.gif');
img1d = reshape(img, 1, 256*256);

%now 1d array with each number in the range [0, 255]
img_b4 = dec2base(img1d, 4);

for i=1:length(img_b4)
    a = img_b4(i,:);
    img_b4d((i-1)*4+1:i*4) = a(:)-48;
end;

%process the image img_b4

%convert the data back to image
pimg = char(img_b4d+48);
for i=1:256*256;
    a = pimg((i-1)*4+1:i*4);
    pimg_q(i,:) = a;
end;

pimg_d = base2dec(pimg_q, 4);
pimg_u8 = cast(pimg_d, 'uint8');
pimg = reshape(pimg_u8, 256, 256);

imshow(pimg);

