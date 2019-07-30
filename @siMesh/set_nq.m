function obj=set_nq(obj)
  idxdom=obj.find(obj.d);
  if length(idxdom)==1
    obj.nq=obj.sTh{idxdom}.nq;
  elseif length(idxdom)>1
    toG=[];
    for idx=[idxdom]
      toG=[toG,obj.sTh{idx}.toGlobal];
    end
    obj.nq=length(unique(toG));
  else
    error('Unable to set nq')
  end
end