clear all
close all

m_list = [10,20,30,40,50];
Data = load('data.txt');
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
    for i = 6:6
        X = 1:m;
        Y = Data(1:m,i);
        Y = 300 - Y;
        log_X = log(X)';
        log_Y = log(Y+1);
        y0 = Data(40:N,i);
%         bA = GetModels(log_X',log_Y,1);
%         [sApred,R2] = GetModelPrediction((log(1:50))',log_Y,log(y0),bA);
        bA = regress(log_Y,[ones(size(log_X)),log_X]);
        sApred = bA(1)+bA(2)*(log(1:50))';
        figure
        %predicting plot
        plot(X,Data(1:m,i),'o');hold on;
        plot((m+1):50,Data(m+1:end,i),'x');hold on;
        plot(1:50,300-(exp(sApred)-1),'-');hold on;
        axis([0 50 0 250])
%         figure
%         plot(log_X',log_Y,'o');hold on;
%         plot(log((m+1):50),log(300-Data(m+1:end,i)),'x');hold on;
%         plot((log(1:50))',sApred,'-');hold on;
    end
end
