function Model = CrossValidation(Data,Model)
Kernel.type =  'RBF_kernel';
Kernel.s    =  Model.s;
PIV         =  Model.ParIndex;
n           =  Data.n;
% X           =  Data.X;
% Y           =  Data.Y;
X_i         =  Data.X;
Y           =  Data.Y;
lPIV        =  length(PIV);
X           = zeros(n,lPIV);
for i = 1:lPIV
    X(:,i) = X_i(:,PIV(i));
end

k           =  8;

See          =  zeros(1,k);
Sst          =  zeros(1,k);
R_sq         =  zeros(1,k);
y_show       =  zeros(size(1:n));
ypred_show   =  zeros(size(1:n));
y_show_n     =  zeros(size(1:n));
ypred_show_n =  zeros(size(1:n));
for i=1:n%we are leaving ith data point out
    for j=8:8%for k-dimension LVS
        if i==1
            Xtrain =  X(2:n,:);
            Ytrain =  Y(2:n,:);
        elseif i==n
            Xtrain =  X(1:n-1,:);
            Ytrain =  Y(1:n-1,:);
        else 
            Xtrain =  [X(1:i-1,:);X(i+1:n,:)];
            Ytrain =  [Y(1:i-1,:);Y(i+1:n,:)];
        end
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
        See(j)     =  See(j) + (y0 - ypred)^2/n;
        Sst(j)     =  Sst(j) + y0^2/n;
        R_sq(j)    =  1 - See(j)/Sst(j);
    end
    y_show_n(i)      =  y0;
    ypred_show_n(i)  =  ypred;
    y_show(i)      =  ytest;
    ypred_show(i)  =  ypred0;
    % Determine the optimal See and n
end
Model.See           =  See;
Model.R_sq          =  R_sq;
Model.y_show_n      =  y_show_n;
Model.ypred_show_n  =  ypred_show_n;
Model.y_show        =  y_show;
Model.ypred_show    =  ypred_show;