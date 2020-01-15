function Ypred = ApplyKPLSModel(Xtrain,Xtest,Kernelfun,Model)
Ktest   = kernel_matrix(Xtest,Kernelfun.type,Kernelfun.s,Xtrain);
K       = kernel_matrix(Xtrain,Kernelfun.type,Kernelfun.s);
nxpca   = size(Xtrain,1);
nxtest  = size(Xtest,1);
onepca  = ones(nxpca,nxpca)/nxpca;
onetest = ones(nxtest,nxpca)/nxpca;
Gtest   = Ktest - onetest * K - Ktest * onepca + onetest * K * onepca;
B       = Model.B;
Ypred   = Gtest*B;

