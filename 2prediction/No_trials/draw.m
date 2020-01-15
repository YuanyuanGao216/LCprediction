%% 

Model.ParIndex = [1 4];
%test_KPLS([1 4])
Model.s =  21;
d = 6;
max_trial = 0;
Data    =  ReadData('LCData',max_trial);
Kernel.s    =  Model.s;
Kernel.type =  'RBF_kernel';
PIV         =  Model.ParIndex;
n           =  Data.n;
% X           =  Data.X;
% Y           =  Data.Y;
X_i         =  Data.X;
Y           =  Data.Y;
lPIV        =  length(PIV);
X           = zeros(n,lPIV);
Xmean       = zeros(1,lPIV);
Xstd        = zeros(1,lPIV);
for i = 1:lPIV
    X(:,i) = X_i(:,PIV(i));
    Xmean(i)    = Data.meanX(i);
    Xstd(i)     = Data.stdX(i);
end
Model      =  KPLS(X,Y,d,Kernel);
ypred      =  ApplyKPLSModel(X,X,Kernel,Model);
ystd       = Data.stdY;
ymean      = Data.meanY;
ypred0     =  ypred*diag(ystd) + ymean;
y0         =  Y*diag(ystd) + ymean;

X0         =  X*diag(Xstd) + ones(n,1)*Xmean;
SSE = sum((ypred0-y0).^2);
SST = sum(y0.^2)-sum(y0)^2/n;
R2 = 1-SSE/SST;
fprintf('SSE = %f, SST = %f, R squared = %f\n',SSE,SST,R2)
