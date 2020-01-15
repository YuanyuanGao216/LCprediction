clc
clear all
close all

% Example to demonstrate the working of the kmeans clustering algorithm

% Define the clustering problem

m  = 2 ;


load T.txt

X     = T;
[K,N] = size(X);

flag                         =  '_go_';
r                            =  1;
number = 0;
while strcmp(flag,'_go_') &&  number <10
    number  = number + 1;
    Cold                     =  (-0.04)*ones(m,N) + 0.08*rand(m,N);
    Cnew                     =  zeros(size(Cold));
    error                    =  100;
    Index                    =  zeros(1,K);
    it                       =  0;
    while error > 1e-4
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
                type = 'm+';
            elseif Index(k) == 2
                type = 'b*';
            elseif Index(k) == 3
                type = 'ro';
            end
            point            =  X(k,:);

            plot(point(1),zeros(size(point(1))),type,'MarkerSize',12,'LineWidth',2.0), hold on
            text(point(1),1,num2str(k))
            plot(Cold(1),zeros(size(Cold(1))),'kx','LineWidth',3.0,'MarkerSize',24)

        end

%         pause
        Cold                 =  Cnew;
    end
    Index1 = ones(1,15);
    Index1([2 10 11 13]) = 2;
    Index2 = ones(1,15).*2;
    Index2([2 10 11 13]) = 1;
%     if isequal(Index, Index1) || isequal(Index, Index2)
    if menu('Results OK?','Yes','No') == 1
        flag                 =  'stop';
        figure
        plot(Index,'.k','MarkerSize',36)
        set(gca,'box','off','FontName','Times New Roman','FontSize',24)
        xlabel('Observation','FontName','Times New Roman','FontSize',36)
        ylabel('Cluster','FontName','Times New Roman','FontSize',36)
        save('kmean_index.txt',Index,'-ascii')
    else
        r                    =  r + 1;
        close all
    end
end