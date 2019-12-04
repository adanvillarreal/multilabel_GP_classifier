function ind=MLChamming(ind,params,data,terminals,varsvals)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
X=data.example;
Y=data.result;

nsamples=size(X,1);
nclasses=length(data.classes);
ndimensions=length(ind.tree.kids);
prediction=zeros(nsamples,ndimensions);

for d=1:ndimensions
    if ndimensions==1
        outstr=ind.str(6:end-1); % remove initial "root(" and final ")"
    else
        outstr=tree2str(ind.tree.kids{d});
    end
    for i=params.numvars:-1:1
        outstr=strrep(outstr,['X',sprintf('%d',i)],['X(:,',sprintf('%d',i),')']);
    end
    try
        res=eval(outstr);
    catch % because of the "nesting 32" error of matlab
        res=str2num(evaluate_tree(ind.tree.kids{d},X));
    end
    if length(res)<nsamples
        res=res*ones(nsamples,1);
    end
    if params.relational_primitives
        prediction(:,d)=res;
    else
        prediction(:,d)= res > 0;
    end
end
try
    diff=round(abs(prediction-Y));
    ind.result=prediction;
    ind.fitness=sum(diff(:))/(nsamples*nclasses);
   % if treelevel(ind.tree) == 2
   %     disp(treelevel(ind.tree));
   %     disp(ind.fitness);
   % end
catch
    disp('fail');
end

end
