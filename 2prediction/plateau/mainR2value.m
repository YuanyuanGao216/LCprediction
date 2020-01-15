
clc
%leave-one-out R2 value when we predict the no of trials to reach
%proficiency
CV_R2 = test_KPLS([4 8]);
fprintf('LOO R2 is %.2f\n',CV_R2);

