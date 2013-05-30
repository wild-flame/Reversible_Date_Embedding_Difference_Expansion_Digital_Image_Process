function [wartermark]=decoder(watermarked_image,length_watermark)
%
%This function is used to decode the image. In case to decode the watermark
%we need to know the length of map and the length of the watermarked image
%in this case.
%
%TIPS: A more universal way is to save those details in the head of the payload,
%but since this project is just for demonstration use, there is no need to
%do these things.
%
% David Lin
% NATIONAL CHIAO TUNG UNIVERSITY 
%
x=watermarked_image;
[row,col]=size(x);
M=floor(col/2);     

%length_map=count_n
%length_watermark=200*100=20000

%% -------STEP1: Mark the ID-------- %%
% This is used to ruturn a martrix to mark each of pixel that is we are here to mark the ID

%ID=1:U
%ID=2:Ne_bar
%ID=3:Ne
%ID=4:M
%ID=5;N
%ID=0:Error or Unknown. (NOT USED IN THIS CASE)
%
count_ne_bar=0;count_u=0;count_m=0;count_ne=0;count_n=0;count_total=0;ID=zeros(row,M);
for i=1:row
    for k=1:M
        count_total = count_total + 1;
        %1. This case is U. 
        if (abs(x(i,2*k-1) - x(i,2*k)) > 3 || ((x(i,2*k-1) + x(i,2*k)) * 1/2) >= 254)     
        count_u =count_u + 1;
        ID(i,k) = 1; 
        %2. This case is N
        elseif (abs(x(i,2*k-1) - x(i,2*k)) > 1)
            count_n=count_n + 1;
            ID(i,k) = 5; 
        %3.This case is M
        else 
        count_m=count_m + 1;
        ID(i,k) = 4; %m
        end
    end
end

%% STEP2:Draw the location map from M
count = 1; map=[]
for i=1:row
    for k=1:M
        if(x(i,2*k-1)-x(i,2*k)==0)
            map(count) = 0;
            count=count+1;
        end
        if(x(i,2*k-1)-x(i,2*k)==1)
            map(count) = 1;
            count=count+1;
        end
        if count > count_n
           break; 
        end
    end
end

%% STEP3: Use map to recover Ne and Ne_bar
    %2_1 This case is N_e_bar
count=1;
for i=1:row
    for k=1:M
        if ID(i,k) == 5; 
            if map(count) == 0
            ID(i,k) = 2; %ne_bar
            count=count+1;
            elseif map(count) == 1
            ID(i,k) = 3; %ne
             count=count+1;
            end      
        end
    end
end

%% STEP4: Recorver the data.
if (length_watermark+count_n)<=count_m
    count = 1; d_payload = []
    for i=1:row
        for k=1:M
             if ID(i,k) == 4;
             d_payload(count) = x(i,2*k-1) - x(i,2*k)
            end
        end
    end 
end

%% STEP4: Get the watermark form the image.
watermark = d_payload(1,count_n+1:count_n+20000);


