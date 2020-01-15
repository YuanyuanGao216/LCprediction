function Data = ReadData_sub(data,max_trial,ss_n)
if strcmp(data,'LCData')
    load('X.txt');
    load('Y.txt');
%     X = X';    
    index = Y > max_trial;
    Y = Y(index);
    X = X(index,:);
    [n,~]     = size(X);
    rng(1001);
    X_sub_index = randsample(1:n,ss_n);
    X_sub = X(X_sub_index,:);
    Y_sub = Y(X_sub_index,:);
    X = X_sub;
    Y = Y_sub;
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