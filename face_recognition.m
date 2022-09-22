%___________________________________________________________________%
%  Face Recognition (FR)     source codes version 1.0               %
%                                                                   %
%  with proposed of two new discriptors :                                                                   %
%          1. HDG  (Histogram of Directional Gradient) and          %
%          2. HDGG (Histogram of Directional Gradient Generalized)  %                                                   %
%                                                                   %
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


clc
clear all 
close all

addpath('Machine learning');
addpath('dataset');
addpath('descriptors');

% fix the data
data = 'ORL';  % choose the datast :  'ORL', 'Yale'  or  'PIE'
switch data
    case 'ORL' ; 
        load('ORL_112x92.mat')
        m = 112;
        n = 92;
        nm_image_by_class = 10;         
    case 'Yale';
        load('Yale_64x64.mat')
        m = 64;
        n = 64;
        nm_image_by_class = 11; 
    case 'PIE';
        load('PIE_32x32.mat')
        m = 32;
        n = 32;
        nm_image_by_class = 170;
end    

[nb_images, taille_image] = size(fea);

% Feauters Extraction
descriptor = 'HDG'; % Choose the descriptor :  'HDG', 'HDGG', 'HOG' or 'LBP'
feauters = [];
for i = 1 : nb_images
     Im       =  fea(i, :);
     Im       =  reshape(Im, m, n);
     % Using the descriptor 
     switch descriptor         
         case 'HDG'
             H = HDG(Im);
         case 'HDGG'
             H = HDGG(Im);
         case 'HOG'
             H = HOG(Im);
         case 'LBP'
             H = LBP(Im, 1);
     end         
     % rassembler the feauters vectors
     feauters =  [feauters; H'];
     fprintf('\n Features Extraction :  %d / %d',i, nb_images);
end

% Machine Learning Preperation
fprintf('\n \n \n Machine Learning : Preperation.................');

classifier   = 'msvm'; % choose the classifier : 'knn', 'nb', 'dt', 'msvm', 'da', 'nn' or 'rf'

v            = fea; 
ri           = round(nb_images*rand(1,1)); 
Test         = feauters(ri, :);                          
Training     = feauters([1:ri-1 ri+1:end], : ); 
label(ri, :) = [];
v(ri, :)     = [];


% Recognition with Machine Leraning
fprintf('\n Machine Learning : Training & Test phases.................');
switch classifier ; 
    case 'knn'; 
        results = KNNClassifier( Training, Test, label);
    case 'nb'; 
        results = NBClassifier(  Training, Test, label);
    case 'dt'; 
        results = TREEClassifier(Training, Test, label);
    case 'msvm'; 
        results = MSVMClassifier(Training, Test, label);   
    case 'da';
        results = DAClassifier(  Training, Test, label);
    case 'nn'; 
        results = NNClassifier(  Training, Test, label);
    case 'rf'; 
        results = RFClassifier(  Training, Test, label); 
end 

       
% Display the results 
fprintf('\n \n \n ************************** Results ************************');
fprintf('\n Dataset               : %s '   ,  data);
fprintf('\n Discriptor            : %s '   ,  descriptor);
fprintf('\n Machine Learning      : %s '   ,  results.CL_name);
fprintf('\n Time                  : %f (s)',  results.time);
fprintf('\n Classe                : %d '   ,  results.Classe);
switch descriptor         
         case 'HDG'
             fprintf('\n length vector Feature : 8 x 8 x 8 = 512');
         case 'HDGG'
             fprintf('\n length vector Feature : 8 x 8 x 9 = 576');
         case 'HOG'
             fprintf('\n length vector Feature : 8 x 8 x 8 = 576');
         case 'LBP'
             fprintf('\n length vector Feature : 8 x 8 x 256 = 16384');
     end    
 fprintf('\n\n');
 
% Displya the face image
Classe  = results.Classe;
subplot(121); 
imshow(reshape(fea(ri, :), m, n), []);title('Looking for ...','FontWeight','bold','Fontsize',16,'color','red');

subplot(122);
for i = 1 : Classe     
     imshow(reshape(fea((i - 1) * nm_image_by_class + 1, :),m,n), [])
     drawnow;
end
subplot(122);
imshow(reshape(v((Classe - 1) * nm_image_by_class + 1, :), m, n), []);title('Found!','FontWeight','bold','Fontsize',16,'color','red');



% Disply image face feautre
figure,
subplot(121)
imshow(reshape(fea(ri, :), m, n), []);title('Looking for!','FontWeight','bold','Fontsize',16,'color','red');

subplot(122)
bar(feauters(ri, :)); title('Feature Histogram','FontWeight','bold','Fontsize',16,'color','red');
