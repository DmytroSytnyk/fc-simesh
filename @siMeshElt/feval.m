function u=feval(self,fun,varargin)
  assert(fc_tools.utils.isfunhandle(fun))
  assert( ismember(nargin(fun),[1,self.dim]) ,'Number of function arguments must be 1 or %d',self.dim)
  p = inputParser;
  p.addParamValue('level',0,@isscalar); % mainly used with partition meshes?
  p.parse(varargin{:});
  R=p.Results;
  assert(ismember(R.level,0:length(self.nqParents)))
  
  if R.level>0
    u=zeros(self.nqParents(R.level),1);
    u(self.toParents{R.level})=EvalOnVertices(fun,self.q);  
  else
    u=EvalOnVertices(fun,self.q);
  end
end

function u=EvalOnVertices(fun,q)
  % return a nq-by-1 array
  if nargin(fun)==1
    u=fun(q).';
  else 
    dim=size(q,1);
    u=eval(['fun(q(1,:)',sprintf(',q(%d,:)',2:dim),').'';']) ;
  end
  if length(u)==1, u=u*ones(size(q,2),1);end
end