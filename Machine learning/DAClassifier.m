function results  = DAClassifier(traindata, testdata, classes)

%************************Linar/Quadratic DA Classifier*********************

    tic
        da = ClassificationDiscriminant.fit(traindata,classes',...
            'discrimType','linear');

        prediction_da = da.predict(testdata);
    time = toc;

    results.CL_name = 'Linar/Quadratic DA Classifier';
    results.Classe  = prediction_da;
    results.time    = time;
end

