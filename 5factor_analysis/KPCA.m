function Model = KPCA(X,Model)

% Model = KPCA(X,kernel,kerneloption)
%   Diagonalizing the covariance matrix in feature space 
%   Eigenvalues are sorted in descending order

kernel                 = Model.type;
kerneloption           = Model.Sigma_KPCA;
tol                    = 1e-5; %tolerance on zeroness of eigenvalue
nx                     = size(X,1);
K                      = svmkernel(X,kernel,kerneloption);
oneM                   = ones(nx,nx)/nx;
Kt                     = K - oneM*K - K*oneM + oneM*K*oneM;
[~,S,L]                = svd(Kt);
S                      = diag(S);
indS                   = (find(abs(S)>=tol)); % keeping only eigval higher than tol
L                      = L(:,indS);
S                      = S(indS);
n                      = Model.n;
for i=1:n % normalizing eigenvector
    L(:,i)             = L(:,i)/sqrt(S(i));
end
onepca                 = ones(nx,nx)/nx;
A                      = (eye(nx) - onepca)*L(:,1:n);
Model.L                = L;
Model.S                = S;
Model.T                = ( K - onepca*K ) * A;
Model.A                = A;