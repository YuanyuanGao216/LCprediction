function R2_this_comb = test_KPLS(Result)
max_trial = 0;
Data    =  ReadData('LCData',max_trial);
a       =  1;
b       =  500;
R2_max  =  0;
R.s_min   = 0;
R.d_min   = 0;
for i=a:20:b  
    Model.ParIndex = Result;
    Model.s =  i;
    Model   =  CrossValidation(Data,Model);
    [r2_max,j] =  max(Model.R_sq);

    if r2_max > R2_max
        R2_max = r2_max;
        R.s_min   = i;
        R.d_min   = j;
    end
    warning off
end
R2_this_comb = R2_max;
fprintf('R2 = %f\t',R2_this_comb);
fprintf('%d %d\n',R.s_min,R.d_min);