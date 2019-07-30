function Ba=barycenters(self,varargin)
  % Barycenters of selected elements
  p = inputParser; 
  p.addParamValue('d',self.d,@isscalar);
  p.addParamValue('labels',[]); % select labels to draw
  p.parse(varargin{:});
  R=p.Results;
  if isempty(R.labels), idxlab=self.find(R.d);else idxlab=self.find(R.d,R.labels);end
  if isempty(idxlab), return;end
  j=1;
  Ba=zeros(self.dim,length(idxlab));
  for ilab=[idxlab]
    Ba(:,j)=mean(self.sTh{ilab}.barycenters(),2);
    j=j+1;
  end
end