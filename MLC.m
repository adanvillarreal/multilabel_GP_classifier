function [v,b]= MLC(arfffile, xmlfile, arfftest, generations, popSize, savename, relational_primitives)
    x = 3;
    p = resetparams;
    p.relational_primitives=relational_primitives;
    p.MLC = 1;
    [X, Xlabels, Y, Ylabels]= file_loader(arfffile, xmlfile);
    dlmwrite('mlc_x.txt',X,'delimiter',' ');
    dlmwrite('mlc_y.txt',Y,'delimiter',' ');

    data = struct('example', X, 'result', Y);

    p.datafilex=strcat(pwd,'/mlc_x.txt');
    p.datafiley=strcat(pwd,'/mlc_y.txt');
    p.Ylabels=Ylabels;
    p.data.result=Y;
    p.lowerisbetter=1;
    p.data.example=X;
    p=setterminals(p, 'rand');

    n = size(X, 1);
    p.dims = size(Ylabels, 2);
    p.calcfitness='MLChamming';

    p.rst=0;
    p.rst_rss=0.5; % use 50% of samples each time
    p.rst_rsr=1; % change every generation
    p.rst_ri=0; % probability of choosing to use the entire data set is null

    p=setoperators(p,'crossover',2,2,'mutation',1,1);
    p.operatorprobstype='fixed';
    p.minprob=0;
    if relational_primitives
        p = setfunctions(p, 'gt', 2, 'le', 2, 'and', 2, 'or', 2, 'not', 1, 'xor', 2, 'eq', 2);
    else
         p=setfunctions(p,'plus',2,'minus',2,'times',2,'kozadivide',2, 'myneg', 1, 'myif', 3); %logartimo, raiz
    end
    p.MLC = 1;
    p.savetofile = 'every10';
    % p.inicdynlimit=4;

    p.initpoptype='fullinit';
    p.elitism='halfelitism';
    p.depthnodes='1';
    p.dynamiclevel=1;
    p.realmaxlevel=8;
    p.inicdynlevel=5;
    p.inicmaxlevel=8;
    p.savedir=savename;

    displaystatus('\nRunning algorithm...\n');

    [vars, best] =gplab(generations, popSize, p);
    disp(vars);

    [X, Xlabels, Y, Ylabels]= file_loader(arfftest, xmlfile);
    vars.data.example=X;
    vars.data.result=Y;

    [ind, state] = calcfitness(best,vars.params,vars.data, vars.state, 0);
    drawtree(ind.tree);
    v = ind;
    b = state;
end
