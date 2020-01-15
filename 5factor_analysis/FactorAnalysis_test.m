

load('No_plateau_initial_no13.txt')
X                            =    No_plateau_initial_no13;
clear No_plateau_initial_no13;
[K,N]                       =       size(X);
Model.type                  =       'gaussian';
Model.n                     =       1;
Model.m                     =       7;
Sigma_KPCA                  =       3;
Model.Sigma_KPCA            =       Sigma_KPCA;
xmean                       =       mean(X);
xstd                        =       std(X);
X0                          =       (X-ones(K,1)*xmean)/diag(xstd);
Model                       =       KPCA(X0,Model);
T0                          =       Model.T;
Sigma_KPLS                  =       20 ;
Model.Sigma_KPLS            =       Sigma_KPLS;
Model                       =       KPLS(T0,X0,Model);
Model                       =       ApplyKPLSModel(T0,T0,Model);
e                           =       X0 - Model.Ypred;

% for all
e_all   = reshape(e,[3*K,1]);
y_all   = reshape(X0,[3*K,1]);
SSE     = e_all'*e_all;
SST     = sum((y_all - mean(y_all)).^2);
R2      = 1 - SSE/SST;
fprintf('for all: SSE = %.2f; SST = %.2f; R2 = %.2f\n', SSE,SST,R2)
% for plateau level:
e1      =   e(:,1);
y1      =   X0(:,1);
SSE     =   e1'*e1;
SST     =   sum(y1.^2);
R2      =   1-SSE/SST;
fprintf('for plateau level: SSE = %.2f; SST = %.2f; R2 = %.2f\n', SSE,SST,R2)

% for trials number:
e2      =   e(:,2);
y2      =   X0(:,2);
SSE     =   e2'*e2;
SST     =   sum(y2.^2);
R2      =   1-SSE/SST;
fprintf('for trials number: SSE = %.2f; SST = %.2f; R2 = %.2f\n', SSE,SST,R2)

% for initial proficiency level:
e3      =   e(:,3);
y3      =   X0(:,3);
SSE     =   e3'*e3;
SST     =   sum(y3.^2);
R2      =   1-SSE/SST;
fprintf('for initial proficiency level: SSE = %.2f; SST = %.2f; R2 = %.2f\n', SSE,SST,R2)
save('T_no13.txt','T0','-ascii')
