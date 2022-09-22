%___________________________________________________________________%
%  Histogram of Directional Gradient Generalized (HDGG)             %
%                                                                   %
%   demo version 1.0                                                %
%                                                                   %
%  Developed in MATLAB R2013                                        %
%                                                                   %
%  Author and programmer: Farid AYECHE                              %
%                                                                   %
%         e-Mail: ayeche_farid@yahoo.fr                             %
%                 ayeche_farid@univ-setif.dz                        %
%                                                                   %
%                                                                   %
%   Main paper:                                                     %
%                                                                   %
%   Novel Descriptors for Effective Recognition of Face 
%   and Facial Expressions                                          %
%   Revue d'Intelligence Artificielle , 2020                        %
%   https://doi.org/10.18280/ria.340501                             %
%                                                                   %
%___________________________________________________________________%


function [Feature_vector] = HDGG(Im)   % , I_magnit, I_angles
nwin_x = 8;%set here the number of HDGG windows per bound box
nwin_y = 8;

[L,C]=size(Im); % L num of lines ; C num of columns
angles = zeros(L, C);
magnit = zeros(L, C);
%Kirsch masks
    Kirsch=cell(8,1);
    Kirsch{1} = [-3 -3 5;-3 0 5;-3 -3 5];
    Kirsch{2} = [-3 5 5;-3 0 5;-3 -3 -3];
    Kirsch{3} = [5 5 5;-3 0 -3;-3 -3 -3];
    Kirsch{4} = [5 5 -3;5 0 -3;-3 -3 -3];
    Kirsch{5} = [5 -3 -3;5 0 -3;5 -3 -3];
    Kirsch{6} = [-3 -3 -3;5 0 -3;5 5 -3];
    Kirsch{7} = [-3 -3 -3;-3 0 -3;5 5 5];
    Kirsch{8} = [-3 -3 -3;-3 0 5;-3 5 5];
    Im = double(Im);
    I = zeros(size(Im, 1), size(Im, 2), 8);
    for i = 1 : size(Kirsch, 1)
        I(:,:,i) = conv2(Im, Kirsch{i},'same');
    end
    
   
    for i = 1 : L
        for j = 1 : C
            X = []; Y = [];            
            for k = 0 : 7 
              x = cos(k * pi/4) * I(i, j, k+1);
              y = sin(k * pi/4) * I(i, j, k+1);
              Y = [Y y]; X = [X x];
            end
            Gx = sum(X);
            Gy = sum(Y);
            G  = sqrt(Gx^2 + Gy^2);
            Th = atan2(Gy, Gx);
            magnit(i, j) = G;
            angles(i, j) = Th;
        end
    end     

B = 9;%set here the number of histogram bins

H=zeros(nwin_x*nwin_y*B,1); % column vector with zeros
m=sqrt(L/2);

step_x=floor(C/(nwin_x+1));
step_y=floor(L/(nwin_y+1));
cont=0;

for n=0:nwin_y-1
    for m=0:nwin_x-1
        cont=cont+1;
        angles2=angles(n*step_y+1:(n+2)*step_y,m*step_x+1:(m+2)*step_x); 
        magnit2=magnit(n*step_y+1:(n+2)*step_y,m*step_x+1:(m+2)*step_x);
        v_angles=angles2(:);    
        v_magnit=magnit2(:);
        K=max(size(v_angles));
        %assembling the histogram with 9 bins (range of 20 degrees per bin)
        bin = 0;
        H2=zeros(B,1);
        for ang_lim =  -pi+2*pi/B  : 2*pi/B  : pi
            bin = bin + 1;
            for k=1:K
                if v_angles(k)<ang_lim
                    H2(bin) = H2(bin) + v_magnit(k);
                    v_angles(k)=10000;
                end
            end
        end
                
        H2=H2/(norm(H2)+0.01);        
        H((cont-1)*B+1:cont*B,1)=H2;
    end
    
    Feature_vector = H;
    %I_magnit = [] magnit;
    %I_angles = angles;
end



    



