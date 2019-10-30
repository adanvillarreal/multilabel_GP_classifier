function x = MLC(arfffile, xmlfile)
    x = 3;
    p = resetparams;
    p.MLC = 1;
    [X, Xlabels, Y, Ylabels]= file_loader(arfffile, xmlfile);
    dlmwrite('mlc_x.txt',X,'delimiter',' ')
    dlmwrite('mlc_y.txt',Y,'delimiter',' ')

    data = struct('example', X, 'result', Y);

    [n, p.dims] = size(X);

    p.calcfitness='M3GPaccuracy';
    %p.calcfitness='M3GPaccuracy_1class_nclusters';

    %p.calcfitness='KNNaccuracy';
    %p.KNNvoting='KNNweightedvoting';
    %p.KNNvoting='KNNbasicvoting';

    %p.calcfitness='DTaccuracy';

    p.lowerisbetter=0;


    p.rst=0;
    p.rst_rss=0.5; % use 50% of samples each time
    p.rst_rsr=1; % change every generation
    p.rst_ri=0; % probability of choosing to use the entire data set is null

    p=setoperators(p,'crossover',2,2,'mutation',1,1);
    p.operatorprobstype='fixed';
    p.minprob=0;

    p=setfunctions(p,'plus',2,'minus',2,'times',2,'kozadivide',2);
    p=setterminals(p,'rand');
    p.depthnodes='1';
    p.inicmaxlevel = 20;
    p.MLC = 1;

    displaystatus('\nRunning algorithm...\n');

    [pop, state] =gplab(100, 200, p);
    x = 3;
end
