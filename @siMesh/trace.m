function sgu=trace(self,u,varargin)
  p = inputParser();
  p.addParamValue('d',self.d,@isscalar); %
  p.addParamValue('labels',[]);
  p.parse(varargin{:});
  R=p.Results;
  if isempty(R.labels), idxlab=self.find(R.d);else idxlab=self.find(R.d,R.labels);end
  if isempty(idxlab)
    sgu=[];
    return
    %error('No labels found')
  end
  assert(isnumeric(u))
  nlab=length(idxlab);
  sgu=cell(nlab,1);
  for i=1:nlab
    sgu{i}=self.sTh{idxlab(i)}.trace(u);
  end
  if nlab==1, sgu=sgu{1};end
end