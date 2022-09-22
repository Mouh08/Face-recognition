function results = NBClassifier(traindata, testdata, classes)

%****************************Naive Bayes classifier************************
    tic   
        naive = NaiveBayes.fit(traindata,classes);
        prediction_naive = naive.predict(testdata);
    time = toc;

    results.CL_name = 'Naive Bayaisian Classifier';
    results.Classe  = prediction_naive;
    results.time    = time;

end

