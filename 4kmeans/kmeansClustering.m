clc
clear all


% Example to demonstrate the working of the kmeans clustering algorithm

% Define the clustering problem
m  = 2;

oldfolder = cd('../data');
load No_plateau_initial_sut.txt
cd(oldfolder)

X     = No_plateau_initial_sut;
X([16 17],:) = [];%why delete #16?
[K,N] = size(X);
meanX     = mean(X);
stdX      = std(X);
X0        = (X - ones(K,1)*meanX)/diag(stdX);
X = X0;
%%   
% Determining the unknown clusters and the cluster centers
flag                         =  '_go_';
r                            =  1;
while strcmp(flag,'_go_')
    rng(s)
    Cold                     =  (-3)*ones(m,N) + 6*rand(m,N);
    Cnew                     =  zeros(size(Cold));
    error                    =  100;
    Index                    =  zeros(1,K);
    it                       =  0;
    while error > 1e-6
        for k=1:K
            dist = 50;
            for j=1:m
                if norm(Cold(j,:) - X(k,:)) < dist
                    dist     =  norm(Cold(j,:) - X(k,:));
                    Index(k) =  j;
                end
            end
        end
        for j=1:m
            xmean            = zeros(1,N);
            jk               = 0;
            for k=1:K
                if Index(k) == j
                    jk       =  jk + 1;
                    xmean    =  xmean + X(k,:);
                end
            end
            Cnew(j,:)        =  xmean/jk;
        end
        error                =  sum(sum((Cnew - Cold).^2));
        it                   =  it + 1;
        figure('position',[50 50 1200 700])
        for k=1:K
            if Index(k) == 1
                type = 'mo';
            elseif Index(k) == 2
                type = 'bo';
            elseif Index(k) == 3
                type = 'ro';
            end
            point            =  X(k,:);
            if N == 2
                plot(point(1),point(2),type,'MarkerSize',12,'LineWidth',2.0), hold on
            else
                subplot(122)
                plot(point(3),point(2),type,'MarkerSize',12,'LineWidth',2.0), hold on
                text(point(3),point(2),num2str(k))
                plot(Cold(:,3),Cold(:,2),'kx','LineWidth',3.0,'MarkerSize',24), hold on
                xlabel('initial proficiency level')
                ylabel('plateau level')
                set(gca,'box','off','FontName','Times New Roman','FontSize',24)
                
                subplot(121)
                plot(point(3),point(1),type,'MarkerSize',12,'LineWidth',2.0), hold on
                text(point(3),point(1),num2str(k))
                plot(Cold(:,3),Cold(:,1),'kx','LineWidth',3.0,'MarkerSize',24), hold on 
                xlabel('initial proficiency level')
                ylabel('trials number')
                set(gca,'box','off','FontName','Times New Roman','FontSize',24)
            end
        end

%         pause
        Cold                 =  Cnew;
    end
    Index1 = ones(1,15);
    Index1([2 10 11 13]) = 2;
    Index2 = ones(1,15).*2;
    Index2([2 10 11 13]) = 1;
    if isequal(Index, Index1) || isequal(Index, Index2) 
%     if menu('Results OK?','Yes','No') == 1
        flag                 =  'stop';
        figure
        plot(Index,'.k','MarkerSize',36)
        set(gca,'box','off','FontName','Times New Roman','FontSize',24)
        xlabel('Observation','FontName','Times New Roman','FontSize',36)
        ylabel('Cluster','FontName','Times New Roman','FontSize',36)
    else
        r                    =  r + 1;
        close all
    end
end