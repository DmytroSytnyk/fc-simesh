function self=AddsiMeshElt(self,ooElmt)
  if ~isempty(self.sTh)
    I=intersect(ooElmt.toGlobal,self.toGlobal); % On verifie que le ooElmt appartient au ooMesh
    assert( length(I)==length(ooElmt.toGlobal) );
    N=self.nsTh+1;
  else
    N=1;
    self.toGlobal=ooElmt.toGlobal;
    self.nq=ooElmt.nq;
  end
    self.nsTh=N;
    self.sTh{N}=ooElmt;
    self.sThsimp(N)=ooElmt.d;
    self.sThlab(N)=ooElmt.label;
end