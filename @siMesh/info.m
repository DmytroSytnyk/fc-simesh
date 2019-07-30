function info(self,varargin)
  % version simplifiée pour le moment
  p = inputParser; 
  p.addParamValue('variable',true,@islogical);
  p.addParamValue('verbose',0,@(x) ismember(x,0:1));
  p.parse(varargin{:});
  R=p.Results;
  if R.variable
    fprintf('Variable %s [%s object] :\n',inputname(1),class(self));
  end
  if R.verbose>0, fprintf('  dim=%d, d=%d\n',self.dim,self.d);end
  fprintf('  nq=%d, nme=%d\n',self.nq,self.get_nme());
  if R.verbose>0
    for d=self.d:-1:0
      I=self.find(d);
      if  isempty(I)
        fprintf('  %d-simplices : none\n',d);
      else
        fprintf('  %d-simplices : number %d, labels : ',d,length(I));
        fprintf('%d ',self.sThlab(I));fprintf('\n')
      end
    end
  end
end
