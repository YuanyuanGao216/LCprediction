function Model = KPLS(X,Y,Model)
n         =     Model.m;
[N,ny]    =     size(Y);
KM        =     KernelMatrix(X,Model);
G         =     KM.G;
G0        =     G;
Y0        =     Y;
T         =     zeros(N,n);
U         =     zeros(N,n);
Q         =     zeros(ny,n);
V         =     zeros(ny,n);
S         =     zeros(n,n);
C_XY      =     Y0'*G0*Y0;
for i = 1:n
    e         =     100;
    v         =     C_XY(1,:)';
    v0        =     v/norm(v);
    k         =     0;
    while e > 1e-10 
        v     =     C_XY*v0;
        s     =     norm(v);
        v     =     v/s;
        e     =     norm(v-v0);
        v0    =     v;
        k     =     k + 1;
        if k > 500
            break
        end
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
Model.U        =  U(:,1:n);
Model.T        =  T(:,1:n);
Model.V        =  V(:,1:n);
Model.Q        =  Q(:,1:n);
Model.S        =  S(1:n,1:n);
Model.B        =  (U(:,1:n)/(T(:,1:n)'*G0*U(:,1:n)))*T(:,1:n)'*Y0;
Model.Ypred    =  G0*Model.B;
Model.E        =  Y0 - Model.Ypred;