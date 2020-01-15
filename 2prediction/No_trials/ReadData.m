function Data = ReadData(data,max_trial)
if strcmp(data,'LCData')
    load('X.txt');
    load('Y.txt');
%     X = X';    
    index = Y > max_trial;
    Y = Y(index);
    X = X(index,:);
    [n,N]     = size(X);
    meanX     = mean(X);
    stdX      = std(X);
    X0        = (X - ones(n,1)*meanX)/diag(stdX);
    meanY     = mean(Y);
    stdY      = std(Y);
    Y0        = (Y - ones(n,1)*meanY)/diag(stdY);
    M         = length(meanY);
    [temp,M]  = size(Y);
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
Data.index = index;