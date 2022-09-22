%% COMPUTE EOH AND BUILD A DESCRIPTOR 
% [eoh] = edgeOrientationHistogram(im)
%
% Extract the MPEG-7 "Edge Orientation Histogram" descriptor
% 
% Input image should be a single-band image, but if it's a multiband (e.g. RGB) image
% only the 1st band will be used.
% Compute 4 directional edges and 1 non-directional edge
% The output "eoh" is a 4x4x5 matrix
%
% The image is split into 4x4 non-overlapping rectangular regions
% In each region, a 1x5 edge orientation histogram is computed (horizontal, vertical,
% 2 diagonals and 1 non-directional)
%
function [eh] = ehd(im) % t= Canny threshold
                              % s= standard deviation Gaussian filter 
                              % v= verbose

f2 = zeros(3,3,5);
f2(:,:,1) = [1 2 1;0 0 0;-1 -2 -1];      % Horizontal
f2(:,:,2) = [-1 0 1;-2 0 2;-1 0 1];      % Vertical
f2(:,:,3) = [2 2 -1;2 -1 -1; -1 -1 -1];  % 45
f2(:,:,4) = [-1 2 2; -1 -1 2; -1 -1 -1]; % 135
f2(:,:,5) = [-1 0 1;0 0 0;1 0 -1];       % No orientation



ys = size(im,1); % Row
xs = size(im,2); % Column
ys=uint16(ys);
xs=uint16(xs);



ys = size(im,1);
xs = size(im,2); 
ys=uint16(ys);
xs=uint16(xs);


im2 = zeros(ys,xs,5);
for i = 1:5
    im2(:,:,i) = abs(filter2(f2(:,:,i), im));    
end

[mmax, maxp] = max(im2,[],3);   % z maximums
im2 = maxp;
%im2(mmax==0)=5;

% ime = edge(im, 'canny', t, s)+0;  % Parametrizada
% tam=size(ime);


%Use canny filter
% im2 = im2.*ime;


eoh = zeros(4,4,6);
for j = 1:4
    for i = 1:4
        clip = im2(round((j-1)*ys/4+1):round(j*ys/4),round((i-1)*xs/4+1):round(i*xs/4));
        eoh(j,i,:) = permute(hist(clip(:), 0:5), [1 3 2]);
    end
end

eoh = eoh(:,:,2:6);

%% Sub images

%%  Build Descriptor

d1=[];
for i=1:4
    for j=1:4
        d1=[d1    eoh(i,j,1)  eoh(i,j,2) eoh(i,j,3) eoh(i,j,4) eoh(i,j,5)];
    end
end

d1=d1';

%% Normalization
tam1=size(d1);
norma=0;
for i=1:tam1(1,1)
    norma=norma+d1(i)*d1(i);
end
norma=sqrt(norma);
if norma ~= 0
    for i=1:tam1(1,1)
        d2(i)=d1(i)/norma;
    end
else
    d2=d1';
end
d2=d2';
%% Store
eh=[];
eh=[eh, d2];
               
                


    
