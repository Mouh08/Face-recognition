function results = NNClassifier(traindata, testdata, classes)

    hn = 16; % 3,...,16
    net = patternnet(hn);
    net.divideFcn = 'dividetrain'; %dividerand
    net.divideMode = 'sample'; %time
    net.divideParam.trainRatio = 1;
    net.divideParam.valRatio = [];
    net.divideParam.testRatio = [];
    Max_epochs    = 500; 
    
 
    net.trainParam.epochs = Max_epochs;
    tic()
        net = train(net,traindata',classes');
        prediction  = net(testdata')
       % perf = perform(net,testlabels,prediction);
        %prediction = vec2ind(prediction)
    time = toc()
    predclasses = round(prediction);
    
    

    results.CL_name = 'MLP Classifier';
    results.Classe  = predclasses;
    results.time    = time;


end

