function results = RFClassifier(training, test, label )

%**************************** RF Classifier ********************************

   iNumBags       = 60;
   str_method     = 'classification' ;
   tic
       BaggedEnsemble = TreeBagger(iNumBags,training, label', 'OOBPred', 'On', 'Method', str_method); %generic_random_forests(X,Y,60,'classification')
       rf             = predict(BaggedEnsemble,test);
   time = toc;
   rf = str2num(rf{1});
   
   results.CL_name = 'Random Forest Classifier';
   results.Classe  = rf;
   results.time    = time;
end

