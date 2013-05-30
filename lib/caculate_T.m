function T = caculate_T(data_size,x)

[row,col]=size(x)
M=floor(col/2);
T=0;
while 1
    count_ne_bar=0;count_u=0;count_m=0;count_ne=0;count_n=0;count_total=0;ID=[];
    T=T+1;
for i=1:row
    for k=1:M
        count_total = count_total + 1;
        h(i,k) = abs(x(i,2*k-1) - x(i,2*k));
        if h(i,k) > 2 * T + 1 || ((x(i,2*k-1) + x(i,2*k)) * 1/2) >=  255 - T || ((x(i,2*k-1) + x(i,2*k)) * 1/2) < T 
        count_u =count_u + 1;
        ID(i,k) = 1; %u
        elseif h(i,k) > floor(T/2) 
        count_n=count_n + 1;
            if h(i,k) > floor(T)  
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
if count_m >= count_n && count_m - count_ne > data_size
    break;
end
end
str=sprintf('T=%d;count_ne_bar=%d;count_u=%d;count_m=%d;count_ne=%d;count_n=%d;count_total=%d',T,count_ne_bar,count_u,count_m,count_ne,count_n,count_total);
disp(str)