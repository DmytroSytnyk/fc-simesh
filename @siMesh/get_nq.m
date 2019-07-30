function nq=get_nq(self,varargin)
  p = inputParser;
  p.addParamValue('d',self.d);
  p.addParamValue('labels',[]);
  p.parse(varargin{:});
  R=p.Results;
  if isempty(R.labels) && R.d==self.d, nq=self.nq; return;end
  if isempty(R.labels), idxlab=self.find(R.d);else idxlab=self.find(R.d,R.labels);end
  if length(idxlab)==0, nq=0;return;end
  if length(idxlab)==1, nq=self.sTh{ilab}.nq;return;end
   
  me=[];q=[];toglobal=[]; 
  toglobal_loc=[];
  me=[];
  for ilab=[idxlab]
    sTh=self.sTh{ilab};
    toglobal_loc=[toglobal_loc,sTh.toParents{1}];
  end
  toglobal= unique(toglobal_loc); % toglobal(IL)==toglobal_loc and toglobal==toglobal_loc(IR)
  nq=length(toglobal);
end