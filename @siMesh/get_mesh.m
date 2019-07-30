function [q,me,toglobal]=get_mesh(self,varargin)
  p = inputParser;
  p.addParamValue('d',self.d);
  p.addParamValue('labels',[]);
  p.parse(varargin{:});
  R=p.Results;
  if isempty(R.labels), idxlab=self.find(R.d);else idxlab=self.find(R.d,R.labels);end
   
  me=[];q=[];toglobal=[];
  if isempty(idxlab)
    if ~isempty(R.labels)
      warning('No labels index found with d=%d and labels=%s',R.d,num2str(R.labels))
    else
      warning('No labels index found with d=%d',R.d)
    end
    return
  end
   
  toglobal_loc=[];
  me=[];
  for ilab=[idxlab]
    sTh=self.sTh{ilab};
    toglobal_loc=[toglobal_loc,sTh.toParents{1}];
    me=[me,sTh.toParents{1}(sTh.me)];
  end
  [toglobal,IR,IL] = unique(toglobal_loc); % toglobal(IL)==toglobal_loc and toglobal==toglobal_loc(IR)
  nq=length(toglobal);
  idx=zeros(1,self.nq);
  idx(toglobal)=1:nq;
  q=zeros(self.dim,nq);
  for ilab=[idxlab]
    sTh=self.sTh{ilab};
    q(:,idx(sTh.toParents{1}))=sTh.q;
  end
  me=idx(me);
end