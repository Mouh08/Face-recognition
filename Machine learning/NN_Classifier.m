function [accuracy_nn, cmat] = NNClassifier(traindata, testdata, classes)
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here

    hn = 20; % 3,...,16
% Prepara a rede

    net = patternnet(hn,'traincgp');
    net.divideFcn = 'dividetrain'; %dividerand
    net.divideMode = 'sample'; %time
    net.divideParam.trainRatio = 1;
    net.divideParam.valRatio = [];
    net.divideParam.testRatio = [];
    
    % Visualiza a configuracao da rede
    %view(net)
    
    %labels
    [labels] = label_rn(traindata);
    
    % Treina a rede
    net = train(net,traindata,labels);
    % my_weights = getx(net); % pega os pesos da rede
    % net = setx(net,my_weights); % seleciona os novos pesos
    % save('my_network','net'); % salva toda a rede
   
nclasses = 7;

[m n] = size(testdata);

testlabels = zeros(nclasses,n);
% Teste da Parte 3, 1 e 2
testlabels(1,1:60)  = 1;
testlabels(2,61:120) = 1;
testlabels(3,121:180) = 1;
testlabels(4,181:240) = 1;
testlabels(5,241:300) = 1;
testlabels(6,301:360) = 1;
testlabels(7,361:420) = 1;

% Predicao da Rede Neural
prediction = net(testdata);
perf = perform(net,testlabels,prediction);
predclasses = vec2ind(prediction);

%matriz de confusao
cmat = confusionmat(classes,predclasses);
[mm,nn] = size(cmat);
cmat_diag = cmat.*eye(mm,nn);
trues = sum(sum(cmat_diag));
accuracy_nn = (trues/sum(sum(cmat))) * 100;

disp('******** Accuracy rate (%) - ARTIFICIAL NEURAL NETWORK *******');
disp(accuracy_nn);
    
end

