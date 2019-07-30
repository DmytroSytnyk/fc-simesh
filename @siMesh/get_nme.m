function nme=get_nme(self,varargin)
  p = inputParser;
  p.addParamValue('d',self.d);
  p.addParamValue('labels',[]);
  p.parse(varargin{:});
  R=p.Results;
  if isempty(R.labels), idxlab=self.find(R.d);else idxlab=self.find(R.d,R.labels);end
  nme=0;
  for ilab=[idxlab]
    nme=nme+self.sTh{ilab}.nme;
  end
end