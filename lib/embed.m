function [x,y] = embed(x,y,bit)

% function [x,y] = embed(x,y,bit)
% This function is used caculate the data after embed.
% bit is the "0" or "1" data that you need to embed.

x = double(x);
y = double(y);
l = floor(x/2 + y/2);
h = x - y;
h = 2 * h + bit;
h = double(h);
x = l + floor((h + 1)/2);
y = l - floor(h/2);