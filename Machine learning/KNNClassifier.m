function results = KNNClassifier(traindata, testdata, classes)

%**************************** KNN Classifier ********************************
    tic
        knn = ClassificationKNN.fit(traindata, classes');
        knn.NumNeighbors = 3;
        prediction_knn = knn.predict(testdata);
    time = toc;

    results.CL_name = 'K Nearist Neighaboor Classifier';
    results.Classe  = prediction_knn;
    results.time    = time;

end

