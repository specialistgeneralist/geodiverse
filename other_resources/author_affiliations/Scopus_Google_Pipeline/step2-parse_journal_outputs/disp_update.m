function disp_update(new_s)

persistent len_update

bs = char(double(sprintf('\b')).*ones(1,len_update));
fprintf('%s%s',bs,new_s);
len_update = numel(new_s);