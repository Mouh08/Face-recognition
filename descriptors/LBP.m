function [H, LBP_Im] = LBP(Input_Im, R)

% %=======================================================================
% %=======================================================================
% This function computes the LBP transformation of the input image
% Input_Im. 
% The parameters of the LBP operator are (P = 8, R), 
% where P - the number of sampling points in the region with the radius R. 
% Radius R is the input parameter of the function.
% Possible values for R = 1, 2, 3, etc.
% If input image is COLOR, then the grayscale transformation is performed.
% %=======================================================================
% %=======================================================================

nwin_x = 8;%set here the number of HOG windows per bound box
nwin_y = 8;

if size(Input_Im, 3) == 3
    Input_Im = rgb2gray(Input_Im);
end;
L = 2*R + 1; %% The size of the LBP label
C = round(L/2);
Input_Im = uint8(Input_Im);
row_max = size(Input_Im,1)-L+1;
col_max = size(Input_Im,2)-L+1;
LBP_Im = zeros(row_max, col_max);
for i = 1:row_max
    for j = 1:col_max
        A = Input_Im(i:i+L-1, j:j+L-1);
        A = A - A(C,C);
        A(A >  0) = 1;
        A(A <= 0) = 0;
        LBP_Im(i,j) = A(C,L) + A(L,L)*2 + A(L,C)*4 + A(L,1)*8 + A(C,1)*16 + A(1,1)*32 + A(1,C)*64 + A(1,L)*128;
       
    end;
end;


step_x=floor(C/(nwin_x+1));
step_y=floor(L/(nwin_y+1));

H = [];
for n=0:nwin_y-1
    for m = 0 : nwin_x - 1
        I = LBP_Im(n*step_y+1:(n+2)*step_y,m*step_x+1:(m+2)*step_x);         
        H2 = zeros(256,1);
        for i = 1 : size(I, 1)            
            for j = 1 : size(I, 2)  
                    H2(I(i, j)) = H2(I(i, j)) + 1 ;% * angles2(k);  %90.30  -  92.72
            end
        end                               
        H = [H; H2];
    end
end