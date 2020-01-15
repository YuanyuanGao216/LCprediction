clear all
close all

m_list = [10,20,30,40,50];
% m_list = [10];
for m_index = 1:length(m_list)
    Data = ReadData('LCData');
    X = Data.X';
    [N,n] = size(X);
    y = Data.Y;
    See = 0;
    y_pred = zeros(n,1);
    R2_sub = zeros(n,1);
    m = m_list(m_index);
    fprintf('first %d trials:\n',m);
    for i = 1:n
        Y = X(1:m,i);
        Y = 300 - Y;
        log_X = log(1:m)';
        log_Y = log(Y);
        y0 = X(1:N,i);
        bA = regress(log_Y,[ones(size(log_X)),log_X]);
        sApred = bA(1)+bA(2)*(log(1:1000))';
        sApred = exp(sApred);
        sApred = 300 - sApred;
        idx = find(sApred>202,2);
        if numel(idx) == 0
            fprintf('%d\n',i)
%             y_pred(i) = idx(2);
            continue
        else
            y_pred(i) = idx(2);
        end
%         figure
%         %predicting plot
%         plot(1:m,X(1:m,i),'o');hold on;
%         plot((m+1):50,X(m+1:end,i),'x');hold on;
%         plot(1:50,sApred(1:50),'-');hold on;
%         axis([0 50 0 250])
    end
    if m_index == 1
        y([4 6 12],:) = [];
        y_pred([4 6 12],:) = [];
    elseif m_index == 2
        y(6,:) = [];
        y_pred(6,:) = [];
    end
    SSE = sum((y_pred-y).^2);
    SST = sum(y.^2)-sum(y)^2/n;
    R2 = 1-SSE/SST;
    fprintf('SSE = %f, SST = %f, R squared = %f\n',SSE,SST,R2)
end