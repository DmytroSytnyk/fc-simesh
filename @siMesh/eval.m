function u=eval(self,fun,varargin)
% Eval fun on siMesh object and return an array with shape (self.nq,1)
%        corresponding on the evaluate of fun on each mesh vertices (if fun is not a 
%        list and not None)
%        
%        fun could be:
%          - a scalar
%          - a function handle
%          - an array 
%          - a cell array where each element could be on of the previous type
  if isnumeric(fun)
    if size(fun,1)==self.nq && size(fun,2)==1
      u=fun;
      return
    end
    if size(fun,2)==self.nq && size(fun,1)==1
      u=fun.';
      return
    end
  end
  
  p = inputParser; 
  p.addParamValue('level',0);
  p.addParamValue('d',self.d,@isscalar);
  p.addParamValue('labels',[]);
  p.addParamValue('cell',false,@islogical);
  p.parse(varargin{:});
  R=p.Results;
  
  if iscell(fun)
    assert(size(fun,1)==1,'fun must be an 1-by-m cell array, given %d-by-%d ',size(fun))
    m=length(fun);
    if R.cell
      u=cell(m,1);
      for i=1:m
        u{i}=self.eval(fun{i},varargin{:});
      end
    else
      u=zeros(self.nq,m);
      for i=1:m
        u(:,i)=self.eval(fun{i},varargin{:});
      end
    end
    return
  end
  
%    if fc_tools.utils.isfunhandle(fun)
%      u=feval(self,fun,varargin{:});
%    return
%    
%    if isnumeric(fun)
%      u=NumericEvalOnVertices(self,fun,varargin{:})
%      return
%    end
%    
  assert(ismember(R.level,0:length(self.nqParents)))
  
  if isempty(R.labels), idxlab=self.find(self.d);else idxlab=self.find(R.d,R.labels);end
  
  if R.level==0
    u=zeros(self.nq,1);
  else
    u=zeros(self.nqParents(R.level),1);
  end
  for i=idxlab
    u(self.sTh{i}.toParents{R.level+1})=self.sTh{i}.eval(fun);
  end  
end
%  
%  function u=NumericEvalOnVertices(self,fun,varargin)
%    p = inputParser; 
%    p.addParamValue('level',0);
%    p.addParamValue('d',self.d,@isscalar);
%    p.addParamValue('labels',[]);
%    p.parse(varargin{:});
%    R=p.Results;
%  
%    assert(ismember(R.level,0:length(self.nqParents)))
%    
%    if isempty(labels), idxlab=self.find(self.d);else idxlab=self.find(R.d,labels);end
%    
%    if R.level==0
%      u=zeros(self.nq,1);
%    else
%      u=zeros(self.nqParents(R.level),1);
%    end
%    for i=idxlab
%      u(self.sTh{i}.toParents{R.level+1})=self.sTh{i}.eval(fun);
%    end  
%    
%  end
%  
%  
%  function u=scalarEval(self,fun,local,labels)
%    if isempty(labels), idxlab=self.find(self.d);else idxlab=self.find(self.d,labels);end
%    if isnumeric(fun)
%      Eval=@(i) fun;
%      
%      
%    else
%      Eval=@(i) self.sTh{i}.eval(fun);
%    end
%    if local
%      u=zeros(self.nq,1);
%      for i=idxlab%self.find(self.d)
%          u(self.sTh{i}.toParent)=Eval(i);%self.sTh{i}.eval(fun);
%      end
%    else
%      
%      u=zeros(self.nq,1);
%      for i=idxlab%self.find(self.d)
%          u(self.sTh{i}.toGlobal)=Eval(i);%self.sTh{i}.eval(fun);
%      end
%    end
%  end