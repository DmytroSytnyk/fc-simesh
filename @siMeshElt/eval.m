function u=eval(self,fun,varargin)
% Eval fun on siMeshElt object and return an array with shape (self.nq,1)
%        corresponding on the evaluate of fun on each mesh vertices (if fun is not a 
%        list and not None)
%        
%        fun could be:
%          - a scalar
%          - a function handle
%          - an array 
%          - a cell array where each element could be on of the previous type

  p = inputParser;
  p.addParamValue('level',0);
  p.parse(varargin{:});
  R=p.Results;
  
  if fc_tools.utils.isfunhandle(fun)
    u=feval(self,fun,'level',R.level);
    return
  end
  
  if isnumeric(fun)
    u=NumericEvalOnVertices(self,fun,R.level);
    return
  end
  
  if iscell(fun)
    u=CellEvalOnVertices(self,fun,R.level);
    return
  end
  Info=whos('fun');
  error('Mismatched parameter fun: class=''%s'', size=[%s]',Info.class,num2str(Info.size))
end

function u=NumericEvalOnVertices(self,fun,level)

  if isscalar(fun)
    if level>0
      u=zeros(self.nqParents(level),1);
      u(self.toParents{level})=fun*ones(self.nq,1);
    else
      u=fun*ones(self.nq,1);
    end
    return
  end
  if ( size(fun,1)==self.nq && size(fun,2)==1 ) 
    if level>0
       u=zeros(self.nqParents(level),1);
       u(self.toParents{level})=fun;
     else
       u=fun;
     end
     return
  end
  if ( size(fun,2)==self.nq && size(fun,1)==1 ) 
    if level>0
       u=zeros(self.nqParents(level),1);
       u(self.toParents{level})=fun;
     else
       u=fun.';
     end
     return
  end
  Info=whos('fun');
  error('Mismatched numerical parameter fun: size=[%s], must be [1 %d] or [%d 1]!',num2str(Info.size),self.nq,self.nq)
end

function u=CellEvalOnVertices(self,fun,level)
  assert(size(fun,1)==1,'fun must be an 1-by-n cell array, given %d-by-%d ',size(fun))
  m=size(fun,2);
  if level==0
    u=zeros(m,self.nq);
  else
    u=zeros(m,self.nqParents(level));
  end
  for i=1:m
    u(i,:)=eval(self,fun,'level',level);
  end
end
