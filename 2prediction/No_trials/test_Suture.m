

Kernel.type =  'RBF_kernel';
k           =  10;
R_sq         =  0;
best_i = 0;
best_j = 0;
for i=a:20:b  
    Model.s =  i;
    Kernel.s = Model.s;
    for j = 1:10
        Xtrain =  X(2:n,:);
        Ytrain =  Y(2:n,:);
        xtest      =  X(i,:);
        ytest      =  Y(i,:);
        xmean      =  mean(Xtrain);
        ymean      =  mean(Ytrain);
        ystd       =  std(Ytrain);
        xstd       =  std(Xtrain);
        X0         =  (Xtrain - ones(n-1,1)*xmean)/diag(xstd);
        Y0         =  (Ytrain - ones(n-1,1)*ymean)/diag(ystd);
        x0         =  (xtest  - xmean)/diag(xstd);
        y0         =  (ytest  - ymean)/diag(ystd);
        Model      =  KPLS(X0,Y0,j,Kernel);
        ypred      =  ApplyKPLSModel(X0,x0,Kernel,Model);
        ypred0     =  ypred*diag(ystd) + ymean;
        See     =  (y0 - ypred)^2/n;
        Sst(j)     =  y0^2/n;
        R_sq    =  1 - See/Sst;
        
    end
end
max(Model.R_sq)
