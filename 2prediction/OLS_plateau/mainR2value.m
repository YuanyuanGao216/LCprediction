clear all
close all
clear all
m_list = [10,20,30,40,50];
Data = load('data_plus_s.txt');
for m_index = 1:length(m_list)
    Data = Data(1:50,:);
    [N,n] = size(Data);
    y = Data(40:N,:);
    y = 300-y;
    y = mean(y,1);
    See = 0;
    y_pred = zeros(n,1);
    R2_sub = zeros(n,1);
    m = m_list(m_index);
    fprintf('first %d trials:\n',m);
    for i = 1:n
        X = 1:m;
        Y = Data(1:m,i);
        Y = 300 - Y;
        log_X = log(X)';
        log_Y = log(Y+1);
        y0 = Data(40:N,i);
        bA = regress(log_Y,[ones(size(log_X)),log_X]);
        sApred = bA(1)+bA(2)*(log(1:50))';
        y_pred(i) = mean(sApred(40:50));
        y_pred(i) = exp(y_pred(i));
%         R2_sub(i) = R2;
    end
    y_pred = 300 - y_pred;
    y = 300-y;
    SSE = sum((y_pred-y').^2);
    SST = sum(y.^2)-sum(y)^2/n;
    R2 = 1-SSE/SST;
    fprintf('SSE = %f, SST = %f, R squared = %f\n',SSE,SST,R2)
end
