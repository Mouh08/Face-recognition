function [H, HDG_cell] = HDG(Im)
nwin_x = 8;%set here the number of HOG windows per bound box
nwin_y = 8;



[L,C] = size(Im); % L num of lines ; C num of columns

HDG_cell = cell(nwin_x, nwin_x);
%Kirsch masks
    Kirsch=cell(13,1);
    Kirsch{1}  = [-3 -3 5;-3 0 5;-3 -3 5];
    Kirsch{2}  = [-3 5 5;-3 0 5;-3 -3 -3];
    Kirsch{3}  = [5 5 5;-3 0 -3;-3 -3 -3];
    Kirsch{4}  = [5 5 -3;5 0 -3;-3 -3 -3];
    Kirsch{5}  = [5 -3 -3;5 0 -3;5 -3 -3];
    Kirsch{6}  = [-3 -3 -3;5 0 -3;5 5 -3];
    Kirsch{7}  = [-3 -3 -3;-3 0 -3;5 5 5];
    Kirsch{8}  = [-3 -3 -3;-3 0 5;-3 5 5];
    
    Kirsch{9}  = [1 2 1; 0 0 0; -1 -2 -1];      %East
    Kirsch{10} = [2 1 0; 1 0 -1; 0 -1 -2];      %North East
    Kirsch{11} = [1 0 -1; 2 0 -2; 1 0 -1];      %North
    Kirsch{12} = [0 -1 -2; 1 0 -1; 2 1 0];      %North West
    Kirsch{13} = [-1 -2 -1; 0 0 0; 1 2 1];      %West
    Kirsch{14} = [-2 -1 0; -1 0 1; 0 1 2];      %South West
    Kirsch{15} = [-1 0 1; -2 0 2; -1 0 1];      %South
    Kirsch{16} = [0 1 2; -1 0 1; -2 -1 0];      %South Eest
    
    Kirsch{17} = [1 1 1; 0 0 0; -1 -1 -1];      %East
    Kirsch{18} = [1 1 0; 1 0 -1; 0 -1 -1];      %North East
    Kirsch{19} = [1 0 -1; 1 0 -1; 1 0 -1];      %North
    Kirsch{20} = [0 -1 -1; 1 0 -1; 1 1 0];      %North West
    Kirsch{21} = [-1 -1 -1; 0 0 0; 1 1 1];      %West
    Kirsch{22} = [-1 -1 0; -1 0 1; 0 1 1];      %South West
    Kirsch{23} = [-1 0 1; -1 0 1; -1 0 1];      %South
    Kirsch{24} = [0 1 1; -1 0 1; -1 -1 0];      %South Eest
    
    Im = double(Im);
    I = zeros(size(Im, 1), size(Im, 2), 8);
    G = zeros(size(Im, 1), size(Im, 2), 8);
    Y = zeros(size(Im, 1), size(Im, 2), 8);
    for i = 1 : 8%size(Kirsch, 1)
    %     maskResponses.(['kirsch' num2str(i)]) = conv2(img,Kirsch{i},'same');
        I(:,:,i) = conv2(Im, Kirsch{i},'same');
        G(:,:,i) = conv2(Im, Kirsch{i+8},'same');
        Y(:,:,i) = conv2(Im, Kirsch{i+16},'same');
%         subplot(2,4,i); imshow(uint8(abs(maskResponses(:,:,i))));
    end


step_x = floor(C / (nwin_x + 1));
step_y = floor(L / (nwin_y + 1));
cont=0;


H = [];

for n=0:nwin_y-1
    
    for m=0:nwin_x-1
        cont=cont+1;
        I2 = I(n*step_y+1:(n+2)*step_y, m*step_x+1:(m+2)*step_x, :); 
        G2 = G(n*step_y+1:(n+2)*step_y, m*step_x+1:(m+2)*step_x, :); 
        Y2 = Y(n*step_y+1:(n+2)*step_y, m*step_x+1:(m+2)*step_x, :); 
       %*******************************************************
       B = zeros(8, 1); %B2 = zeros(8, 1); B3 = zeros(8, 1);
       for i = 1 : size(I2, 1)
           for j = 1 : size(I2, 2)
               for k = 1 : 8
                  % B(k) = B(k) + abs(I2(i, j, k));
                   B(k) = B(k) + abs(G2(i, j, k));
                   %B(k) = B(k) + abs(Y2(i, j, k));
               end
           end
       end
       %*******************************************************
        
        %B = [B1; B2; B3];
        B = B / norm(B, 2);
        
        %HDG_cell{n+1, m+1} = B';        
        
        H = [H; B];
        
    end
    
end


