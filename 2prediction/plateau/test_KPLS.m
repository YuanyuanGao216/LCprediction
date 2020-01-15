function R2_this_comb = test_KPLS(Result)
%%  Modeling without LOO


Data    =  ReadData('LCData');
% a       =  1;
% b       =  500;
R2_max  =  0;
R.s_min   = 0;
R.d_min   = 0;
        
for i=1:1  
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
fprintf('%d %d',R.s_min,R.d_min)
