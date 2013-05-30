function myimshow(x,str)
%%%%
%function myimshow(x,str)
%eg. myimshow(x,'Original Image');
%To show the image as well as the size of the image
%%%%
[row,col]=size(x);
imshow(x);title(str);   
xlabel(['Size : ',num2str(row),'*',num2str(col)]);