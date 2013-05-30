clear all

%% testembed

X = [100,104,102,103,102,108,255,201];
Y = [100,100,101,100,101,108,254,201];
x = [X',Y'];
[row,col] = size(x);
M=floor(col/2); 

%Mark ID
%Step 1.
%USE ID to mark the node to different set. ID=1:U ID=2:Ne_bar ID=3:Ne,
%ID=4:M ID=0:Error or Unknown.
count_ne_bar=0;count_u=0;count_m=0;count_ne=0;count_n=0;count_total=0;ID=[];
for i=1:row
    for k=1:M
        count_total = count_total + 1;
        h(i,k) = abs(x(i,2*k-1) - x(i,2*k));
        if (abs(x(i,2*k-1) - x(i,2*k)) > 3 || ((x(i,2*k-1) + x(i,2*k)) * 1/2) >= 254 )       
        count_u =count_u + 1;
        ID(i,k) = 1; %u
        elseif (abs(x(i,2*k-1) - x(i,2*k)) > 0) 
            count_n=count_n + 1;
            if (abs(x(i,2*k-1) - x(i,2*k)) > 1) 
            count_ne_bar=count_ne_bar + 1;
            ID(i,k) = 2; %ne_bar
            else 
            count_ne=count_ne + 1;
            ID(i,k) = 3; %ne
            end
        else 
        count_m=count_m + 1;
        ID(i,k) = 4; %_m
        end
    end
end

%Step 2 Draw the Map
map = zeros(1,count_n);
count = 1; %to indicate where I'm writing
for i=1:row
    for k=1:M        
        if ID(i,k) == 2
            count=count+1;
        elseif ID(i,k) == 3
            map(count) = 1;
            count=count+1;
        end
    end
end

bits = [1,0];
%Thus payload = [Map, watermark]
payload = [map, bits];
payload = [payload, zeros(1,count_m+count_ne-length(payload))]; %match the size of the embedded image.
%myimshow(payload,'payload')


%Step 3.Watermark_Embeding

%%% ATTENTION 
%%% In this case M is for more larger than the data that we will
%%% embed, which means that we did not use Ne to embed payload.
%%% Otherwise the code would be diffenrent

count = 1; %to indicate where I'm writin
for i=1:row
    for k=1:M
        if (ID(i,k) == 4) % If that is in SET M
            [x(i,2*k-1),x(i,2*k)] = embed(x(i,2*k-1),x(i,2*k),payload(count));
            count = count + 1;
        end
    end
end
str=sprintf('We have embeded %d bits in M',count-1);
disp(str)

count;%to indicate where I'm writin
for i=1:row
    for k=1:M
        if (ID(i,k) == 3) % If that is in SET N
            [x(i,2*k-1),x(i,2*k)] = embed(x(i,2*k-1),x(i,2*k),payload(count));
            count = count + 1;
        end
    end
end
str=sprintf('We have embeded %d bits in M & Ne ',count-1);
disp(str);

%% ----------STEP5£ºDecoding------------ %%
disp(' ----------STEP5£ºDecoding------------ ')
%watermark=decoder(x,length(bits))

%function [wartermark]=decoder(watermarked_image,length_watermark)
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
%x=watermarked_image;

length_watermark=2
[d_row,d_col]=size(x);
M=floor(d_col/2);     

%length_map=count_n
%length_watermark=200*100=20000

% -------STEP1: Mark the ID-------- %%
% This is used to ruturn a martrix to mark each of pixel that is we are here to mark the ID

%ID=1:U
%ID=2:Ne_bar
%ID=3:Ne
%ID=4:M
%ID=5;N
%ID=0:Error or Unknown. (NOT USED IN THIS CASE)
%
d_count_ne_bar=0;d_count_u=0;d_count_m=0;d_count_ne=0;d_count_n=0;d_count_total=0;d_ID=zeros(d_row,M);
for i=1:d_row
    for k=1:M
        d_count_total = d_count_total + 1;
        d_h(i,k)=abs(x(i,2*k-1) - x(i,2*k));
        %1. This case is U. 
        if (abs(x(i,2*k-1) - x(i,2*k)) > 3 || ((x(i,2*k-1) + x(i,2*k)) * 1/2) >= 254)     
        d_count_u =d_count_u + 1;
        d_ID(i,k) = 1; 
        %3.This case is M
        elseif d_h(i,k) == 0 || d_h(i,k) == 1
        d_count_m=d_count_m + 1;
        d_ID(i,k) = 4; %m
        %2. This case is N
        else 
            d_count_n=d_count_n + 1;
            d_ID(i,k) = 5; 
        end
    end
end

% STEP2:Draw the location map from M
d_count = 1; d_map=[]
for i=1:d_row
    for k=1:M
        if(d_h(i,k)==0) && d_count <= d_count_n
            d_map(d_count) = 0;
            d_count=d_count+1;
        end
        if (d_h(i,k)==1) && d_count <= d_count_n
            d_map(d_count) = 1;
            d_count=d_count+1;
        end
    end
end

% STEP3: Use map to recover Ne and Ne_bar
    %2_1 This case is N_e_bar
d_count=1;
for i=1:d_row
    for k=1:M
        if d_ID(i,k) == 5; 
            if d_map(d_count) == 0
            d_ID(i,k) = 2; %ne_bar
            d_count_ne_bar = d_count_ne_bar + 1;
            d_count=d_count+1;
            elseif d_map(d_count) == 1
            d_ID(i,k) = 3; %ne
            d_count=d_count+1;
            d_count_ne = d_count_ne + 1;
            end 
        end
    end
end

% STEP4: Recorver the data.
count = 1; d_payload = []
for i=1:row
    for k=1:M
        if ID(i,k) == 4
            d_payload(count) = d_h(i,k);
            count=count+1;
        end
    end
end

count;
for i=1:row
    for k=1:M
        if ID(i,k) == 3
            d_payload(count) = d_h(i,k)-2;
            count=count+1;
        end
    end
end