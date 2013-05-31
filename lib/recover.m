function [x,y,bit] = recover(x,y)
    
%This is used to recover the image

x = double(x);
y = double(y);
l = floor(x/2 + y/2);
h = x - y;
bit = mod(h,2);
h = (h - bit) / 2;
x = l + floor((h + 1)/2);
y = l - floor(h/2);
