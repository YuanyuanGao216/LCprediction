%% 


Model.ParIndex = [5 6 7 9 10];
Model.s =  21;
d = 8;
Data    =  ReadData('LCData');
Kernel.s    =  Model.s;
Kernel.type =  'RBF_kernel';
PIV         =  Model.ParIndex;
n           =  Data.n;
% X           =  Data.X;
% Y           =  Data.Y;
X_i         =  Data.X;
Y           =  Data.Y;
lPIV        =  length(PIV);
X           = zeros(n,lPIV);
Xmean       = zeros(1,lPIV);
Xstd        = zeros(1,lPIV);
for i = 1:lPIV
    X(:,i) = X_i(:,PIV(i));
    Xmean(i)    = Data.meanX(i);
    Xstd(i)     = Data.stdX(i);
end
Model      =  KPLS(X,Y,d,Kernel);
ypred      =  ApplyKPLSModel(X,X,Kernel,Model);
ystd       = Data.stdY;
ymean      = Data.meanY;
ypred0     =  ypred*diag(ystd) + ymean;
y0         =  Y*diag(ystd) + ymean;

X0         =  X*diag(Xstd) + ones(n,1)*Xmean;
SSE = sum((ypred0-y0).^2);
SST = sum(y0.^2)-sum(y0)^2/n;
R2 = 1-SSE/SST;
fprintf('SSE = %f, SST = %f, R squared = %f',SSE,SST,R2)
% e = Model.E*diag(ystd);
Xdata = 1:length(ypred);
% sigma = sqrt(sum(e.^2)/(25-6));
% t = 2.09302;
% err = zeros(1,25);
% for i = 1:n
%     err(i) = 2*t*sigma*sqrt(X0(i,:)*(X0'*X0)^(-1)*X0(i,:)');
% end
e = Y-ypred;
se_sqr = var(e);
se = sqrt(se_sqr);
se_rescale = se*diag(ystd);
% se = sqrt(sum((ypred-Y).^2)/length(Y));
err = repmat(1.96*se_rescale,1,length(Y));

% CI = [ypred0-1.96*e.^2/25;ypred0+1.96*e.^2/25];
% err = 2*2.06866*sqrt(sum(e.^2)/(25-2))*sqrt(1/25+((Xdata-ones(size(Xdata))*mean(Xdata)).^2)/(24*std(Xdata)^2));
% figure
% plot(1:length(ypred),ypred,'b*')
% hold on
% plot(1:length(ypred),Y,'ro')
% legend('true value','predicted value')
% 
% set(gca,'box','off','FontName','Times New Roman','FontSize',15)
% xlabel('Subject index','FontName','Times New Roman','FontSize',15)
% ylabel('Normalized plateau level','FontName','Times New Roman','FontSize',15)
figure('rend','painters','pos',[10 10 1200 400])
% hpred = semilogy(Xdata,ypred0);
% hold on
% horig = semilogy(Xdata,y0);
hpred = plot(Xdata,ypred0);
hold on
horig = plot(Xdata,y0);


set(horig                               ,...
    'LineStyle'         ,'none'         ,...
    'LineWidth'         ,2.0            ,...
    'Marker'            ,'x'            ,...
    'MarkerSize'        , 10             ,...
    'MarkerEdgeColor'   ,[.2,.2,.2]);
set(hpred                               ,...
    'LineStyle'         ,'none'         ,...
    'LineWidth'         ,2.0            ,...
    'Marker'            ,'o'            ,...
    'MarkerSize'        , 6             ,...
    'MarkerEdgeColor'   ,[.2,.2,.2]            );

hTitle = title('Prediction result trained on 2^{nd}, 3^{rd} and 7^{th} trials by KPLS');
hXLabel = xlabel('Subject index');
hYLabel = ylabel('proficiency plateau level');
set([hXLabel, hYLabel]                  ,...
    'FontName'      ,'Times New Roman'  ,...
    'FontSize'      ,15                 );
legend('predicted value','true value','Location','BestOutside');

set(gca,...
    'box','off',...
    'FontName','Times New Roman',...
    'FontSize',15,...
    'TickDir','out',...
    'TickLength',[.02 .02],...
    'YGrid','on',...
    'XColor',[.3 .3 .3],...
    'YColor',[.3 .3 .3],...
    'XTick',1:1:25,...
    'XTickLabelRotation',45,...
    'LineWidth',1,...
    'xlim', [0.5 17],...
    'ylim',[120 260]);

