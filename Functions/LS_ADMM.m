function O=LS_ADMM(T, Y, eps_o, mu, kmax)
Lam=zeros(size(T,1),size(Y,1));
YYT=Y*Y';
temp=inv((YYT+(1/mu)*(eye(size(Y,1)))));
TYT=T*Y';
Z=Lam;

for iter=1:kmax
    % O-update
    O=(TYT+(1/mu)*(Z+Lam))*temp;
    % Z-update
    Z=O-Lam;
    nz=norm(Z,'fro');
    if nz > eps_o
        Z=Z*(eps_o/nz);
    end
    % Lam-update
    Lam=Lam+Z-O;
end