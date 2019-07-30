function self=AddsiMeshElts(self,d,q,nme,me,mel,varargin)
  p = inputParser;
  p.addParamValue('geolab', [] );
  p.addParamValue('partlab', {} );
  p.parse(varargin{:});
  R=p.Results;
  labels=unique(mel);
  k=self.nsTh;
  nq=size(q,2);
  partlab={};
  geolab=[];
  if d==self.d
    %self.toGlobal=unique([self.toGlobal,unique(me)']);
    self.toParent=unique([self.toParent,unique(me)']);
    self.toGlobal=self.toParent;
    self.toParents{1}=self.toParent;
    self.nqParents(1)=size(q,2);
  end
  for i=1:length(labels)
    I=find(mel==labels(i));
    ME=me(:,I);
    if ~isempty(R.geolab), geolab=R.geolab(I);end
    if ~isempty(R.partlab), partlab=R.partlab(I);end
    indQ=unique(ME);
    Q=q(:,indQ);
    lQ=1:length(indQ);
    J=zeros(nq,1);
    J(indQ)=lQ;
    if(d==0) %correctif a faire si d=0 (programmation a l'arrache! To improve)
      MELoc=J(ME)';
    else
      MELoc=J(ME);
      end
    self.sTh{k+i}=siMeshElt(self.dim,d,labels(i),Q,MELoc,indQ',nq,geolab,partlab);
    self.sThsimp(k+i)=d;
    self.sThlab(k+i)=labels(i);
  end
  self.nsTh=self.nsTh+length(labels);
end
