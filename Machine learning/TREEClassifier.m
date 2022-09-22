function results = TREEClassifier(traindata, testdata, classes)
%****************************Classification Tree***************************

    
    tic
        tree = ClassificationTree.fit(traindata,classes);
        prediction_tree = tree.predict(testdata);
    time = toc;
    
    results.CL_name = 'Decision Tree Classifier';
    results.Classe  = prediction_tree;
    results.time    = time;

end

