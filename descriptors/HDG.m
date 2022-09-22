%___________________________________________________________________%
%          Histogram of Directional Gradient (HDG)                  %
%                                                                   %
%  Developed in MATLAB R2016a                                       %
%                                                                   %
%  Author and programmer: Farid AYECHE                              %
%                                                                   %
%         e-Mail: ayeche_farid@yahoo.fr                             %
%                 farid.ayeche@univ-setif.dz                        %
%                 ayeche.farid@gmail.com                            %
%                                                                   %
%                                                                   %
%   Main paper: Ayeche, Farid & Adel, Alti. (2021). HDG and HDGG:   %
%                an extensible feature extraction descriptor for    %
%                effective face and facial expressions recognition. %
%                Pattern Analysis and Applications.                 %
%                 24. 10.1007/s10044-021-00972-2.                   %
%                                                                   %
%___________________________________________________________________%



function [H] = HDG(Im)
nwin_x = 8;%set here the number of HOG windows per bound box
nwin_y = 8;

[L,C] = size(Im); % L num of lines ; C num of columns

HDG_cell = cell(nwin_x, nwin_x);

Kirsch    = cell(8,1);
Kirsch{1} = [-3  -3   5; -3  0   5; -3  -3   5];
Kirsch{2} = [-3   5   5; -3  0   5; -3  -3  -3];
Kirsch{3} = [ 5   5   5; -3  0  -3; -3  -3  -3];
Kirsch{4} = [ 5   5  -3;  5  0  -3; -3  -3  -3];
Kirsch{5} = [ 5  -3  -3;  5  0  -3;  5  -3  -3];
Kirsch{6} = [-3  -3  -3;  5  0  -3;  5   5  -3];
Kirsch{7} = [-3  -3  -3; -3  0  -3;  5   5   5];
Kirsch{8} = [-3  -3  -3; -3  0   5; -3   5   5];
    
Im = double(Im);
I = zeros(size(Im, 1), size(Im, 2), 8);


for i = 1 : size(Kirsch, 1)
    I(:,:,i) = conv2(Im, Kirsch{i},'same');
end

step_x = floor(C / (nwin_x + 1));
step_y = floor(L / (nwin_y + 1));

H = [];
for n=0:nwin_y-1    
   for m=0:nwin_x-1
       I2 = I(n*step_y+1:(n+2)*step_y, m*step_x+1:(m+2)*step_x, :); 
       %*******************************************************
       B = zeros(8, 1);
       for i = 1 : size(I2, 1)
           for j = 1 : size(I2, 2)
               for k = 1 : 8
                   B(k) = B(k) + abs(I2(i, j, k)); 
               end
           end
       end
       %*******************************************************               
       B = B / norm(B, 2);      
       H = [H; B];        
   end
end


