Data = load('data_plus_s.txt');
for i = 0:10:31
    data_1 = Data(i+1:i+10,:);
    mean_data_1 = mean(data_1);
    data_2 = Data(i+11:i+20,:);
    mean_data_2 = mean(data_2);
    [h,p] = ttest2(mean_data_1,mean_data_2);
    fprintf('i is %d: p = %.3f\n',i,p);
end