function results = MSVMClassifier(Training, Test, label)

    fun   = 'r'; 

    switch fun
      case 'l' ; fun = 'linear';     
      case 'r' ; fun = 'rbf'; 
      case 'p' ; fun = 'polynomial';   
      case 'g' ; fun = 'gaussian';
    end

    % Call train & test data
    xtrain = Training; ytrain = label; 
    xtest  = Test;
    
    tic
        % Train model
        Temp     = templateSVM('KernelFunction',fun,'KernelScale','auto');
        My_Model = fitcecoc(xtrain,ytrain,'Learners',Temp);
        % Test 
        pred2 = predict(My_Model,xtest);
    time = toc;
    
    results.CL_name = 'Multi Support Vector Machine Classifier';
    results.Classe  = pred2;
    results.time    = time;




