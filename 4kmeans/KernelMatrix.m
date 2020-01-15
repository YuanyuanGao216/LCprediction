function KM  =  KernelMatrix(Data,Model)
X          =    Data;
N          =    size(X,1);
type       =    Model.type;
pars       =    Model.Sigma_KPLS;
K          =    kernel_matrix(X,type,pars);
mean1      =    mean(K);
mean2      =    mean(mean1);
G          =    K;
for i      =  1:N
    G(i,:) = G(i,:) - mean1(i);
end
for i =  1:N
    G(:,i) = G(:,i) - mean1(i);
end
G          =    G + mean2;
G          =    (G+G')/2;
KM.m       =    mean1;
KM.K       =    K;
KM.G       =    G;
KM.N       =    N;



