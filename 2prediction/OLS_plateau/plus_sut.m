data = load('data.txt');
data(:,13) = [];
data = data/280*100;

oldfolder = cd('/Users/gaoyuanyuan/ownCloud/machine learning/predicting learning curve/Surgery/REPLY/second rebuttal');
num1 = xlsread('Learning Curve Scores.xlsx','Real_col','A1:G50');
num2 = xlsread('Learning Curve Scores.xlsx','Real_col','A1:G50');
cd(oldfolder)
num1 = num1/520*100;
num2 = num2/520*100;
data_plus_s = [data,num1,num2];

save('data_plus_s.txt','data_plus_s','-ascii');
