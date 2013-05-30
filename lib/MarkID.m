function ID=MarkID()
%% This function is used to ruturn a martrix to mark each of pixel's set.
%
%ID=1:U
%ID=2:Ne_bar
%ID=3:Ne
%ID=4:M
%ID=0:Error or Unknown. (NOT USED IN THIS CASE)
%

count_ne_bar=0;count_u=0;count_m=0;count_ne=0;count_n=0;count_total=0;ID=[];
%% 
for i=1:row
    for k=1:M
        count_total = count_total + 1;
        %1. This case is U. 
        if (abs(x(i,2*k-1) - x(i,2*k)) > 3 || ((x(i,2*k-1) + x(i,2*k)) * 1/2) >= 254 )     
        count_u =count_u + 1;
        ID(i,k) = 1; 
        %2. This case is N
        elseif (abs(x(i,2*k-1) - x(i,2*k)) > 0)
            count_n=count_n + 1;
        %3.This case is M
        else 
        count_m=count_m + 1;
        ID(i,k) = 4; %m
        end
    end
end

%% Use map to recover Ne and Ne_bar
    %2_1 This case is N_e_bar
            if (abs(x(i,2*k-1) - x(i,2*k)) > 1)  
            count_ne_bar=count_ne_bar + 1;
            ID(i,k) = 2; %ne_bar
            %2_2 This case is N_e
            else  
            count_ne=count_ne + 1;
            ID(i,k) = 3; %ne
            end      
        