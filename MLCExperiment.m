function [fitness] = MLCExperiment(dataset, skipMLC, relational_primitives)
    popSizes = [600, 1200, 1800];
    gens = 200;
    %popSizes = [100, 300, 600];
    %gens = 100;
    fitness = [];
    root = '/home/avillarreal/Documents/9semestre/concentracion/multilabel_GP_classifier';
    trainFile=strcat(root,'/multilabel_datasets/', dataset, '/', dataset, '-train.arff');
    testFile=strcat(root,'/multilabel_datasets/',dataset,'/',dataset,'-test.arff');
    xmlFile=strcat(root,'/multilabel_datasets/',dataset,'/',dataset,'.xml');
    if ~skipMLC
        for popSize = popSizes
           savefile=strcat(dataset,string(popSize),'-',string(relational_primitives), string(gens));
           [ind, state] = MLC(trainFile, xmlFile, testFile, gens, popSize, char(savefile), true); 
            fitness = [fitness, ind.fitness];
        end
    end
    savedgens = [0:20]*10;
    %savedgens=[0:10]*10;
    
    [X, Xlabels, Y, Ylabels]= file_loader(testFile, xmlFile);
    first = true;
    for popSize = popSizes
        plotFitness = [];
        for gen = savedgens 
           load(strcat(root, '/', dataset,string(popSize),'-',string(relational_primitives),string(gens),'/',string(gen),'.mat'));
           nvars = vars;
           vars.data.example=X;
           vars.data.result=Y;
           best = vars.state.bestsofar;
           [ind, state] = calcfitness(best,vars.params,vars.data, vars.state, 0);
           vars = nvars;
           plotFitness = [plotFitness, ind.fitness];
        end
        plot(savedgens, plotFitness,'-x');
        if first
            hold on
            first = false;
        end
    end
    hold off
    title(dataset);
    ylabel('hamming loss');
    xlabel('generation');
    legend('600', '1200', '1800');
end 

