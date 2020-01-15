function Data = ReadData(data)
if strcmp(data,'LCData')
%     load('X.txt');
%     load('Y.txt');
    load('X_plus_s.txt');
    load('Y_plus_s.txt');
    X = X_plus_s;
    Y = Y_plus_s;

    [n,N]     = size(X);
    meanX     = mean(X);
    stdX      = std(X);
    X0        = (X - ones(n,1)*meanX)/diag(stdX);
    meanY     = mean(Y);
    stdY      = std(Y);
    Y0        = (Y - ones(n,1)*meanY)/diag(stdY);
    M         = length(meanY);
%     [temp,M]  = size(Y);
end
Data.X = X0;
Data.Y = Y0;
% Data.X = X;
% Data.Y = Y;
Data.n = n;
Data.M = M;
Data.N = N;
Data.meanY = meanY;
Data.stdY = stdY;
Data.stdX = stdX;
Data.meanX = meanX;