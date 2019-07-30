function u=feval(self,fun,varargin)
% Eval fun on siMesh object and return an array with shape (self.nq,1)
%        corresponding on the evaluate of fun on each mesh vertices (if fun is not a 
%        list and not None)
%        
%        fun could be:
%          - a function handle
%          - a cell array of function handles

  if iscell(fun)
    assert(size(fun,1)==1,'fun must be an 1-by-m cell array, given %d-by-%d ',size(fun))
    m=length(fun);
    u=zeros(self.nq,m);
    for i=1:m
      assert(fc_tools.utils.isfunhandle(fun{i}),'%d-th cell must be a function handle',i)
      u(:,i)=self.feval(fun{i},varargin{:});
    end
    return 
  end
  
  assert(fc_tools.utils.isfunhandle(fun))
  assert( ismember(nargin(fun),[1,self.dim]) ,'Number of function arguments must be 1 or %d',self.dim)

  p = inputParser; 
  p.addParamValue('d',self.d,@isscalar);
  p.addParamValue('level',0,@isscalar); % mainly used with partition meshes?
  p.addParamValue('labels',[]);
  p.parse(varargin{:});
  R=p.Results;
  assert(ismember(R.level,0:length(self.nqParents)))
  
  if isempty(R.labels), idxlab=self.find(self.d);else idxlab=self.find(R.d,labels);end
  
  if R.level==0
    u=zeros(self.nq,1);
  else
    u=zeros(self.nqParents(R.level),1);
  end
  for i=idxlab
    u(self.sTh{i}.toParents{R.level+1})=self.sTh{i}.feval(fun);
  end
end