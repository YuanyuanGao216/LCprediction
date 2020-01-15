function Model = ApplyKPCAModel(Xref,Xtest,Model)

kernel       = Model.type;
kerneloption = Model.Sigma_KPCA;
A            = Model.A;

nxpca  = size(Xref,1);
nxtest = size(Xtest,1);
Ktest  = svmkernel(Xtest,kernel,kerneloption,Xref); 
K      = svmkernel(Xref,kernel,kerneloption); 

% centering in features spaces
onetest = ones(nxtest,nxpca)/nxpca;

% projection on eigenvector
feature    = (Ktest - onetest*K)*A;
Model.t    = feature;
