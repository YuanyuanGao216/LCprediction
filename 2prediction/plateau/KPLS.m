function KPLS = KPLS(X,Y,n,Kernelfun)
[N,ny]    =     size(Y);
KM        =     KernelMatrix(X,Kernelfun);
KPLS.G    =     KM.G;
G         =     KM.G;
G0        =     G;
Y0        =     Y;
T         =     zeros(N,n);
U         =     zeros(N,n);
Q         =     zeros(ny,n);
V         =     zeros(ny,n);
S         =     zeros(n,n);
flag      =     0;
C_XY      =     Y0'*G0*Y0;
KPLS.C_XY =     C_XY;
KPLS.K    =     KM.K;
for i = 1:n
    e         =     100;
    v         =     C_XY(1,:)';
    v0        =     v/norm(v);
    k         = 1;
    while e > 1e-10 
        v     =     C_XY*v0;
        s     =     norm(v);
        v     =     v/s;
        e     =     norm(v-v0);
        v0    =     v;
        k     =     k + 1;
        if k > 500
            flag = 1;
            n    = i-1;
            break
        end
    end
    if flag == 1
        break
    end
    V(:,i)    =     v;
    u         =     Y*v;
    u         =     u/norm(u);
    t         =     G*u;
    t         =     t/norm(t);
    q         =     Y'*t;
    U(:,i)    =     u;
    T(:,i)    =     t;
    Q(:,i)    =     q;
    S(i,i)    =     s;
    Y         =     Y-t*q';
    tau1      =     t'*G;
    tau2      =     t*tau1;
    tau3      =     tau1*t;
    G         =     G  - tau2 - tau2' + t*tau3*t';
    if i < n
        C_XY = Y'*G*Y;
    end
end
KPLS.U        =  U(:,1:n);
KPLS.T        =  T(:,1:n);
KPLS.V        =  V(:,1:n);
KPLS.Q        =  Q(:,1:n);
KPLS.S        =  S(1:n,1:n);
KPLS.B        =  (U(:,1:n)/(T(:,1:n)'*G0*U(:,1:n)))*T(:,1:n)'*Y0;
KPLS.Ypred    =  G0*KPLS.B;
KPLS.E        =  Y0 - KPLS.Ypred;
KPLS.R2       =  1 - (sum(KPLS.E.^2))/N;
KPLS.n        =  n;
KPLS.flag     =  flag;