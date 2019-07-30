function self=AddCopysiMeshElt(self,p1Elmt)
  I=intersect(p1Elmt.toGlobal,self.toGlobal); % On verifie que le p1Elmt appartient au P1Mesh
  if length(I)==length(p1Elmt.toGlobal)
    
    N=self.nsTh+1;
    self.nsTh=N;
    self.sTh{N}=p1Elmt.copy();
    
    self.sThsimp(N)=p1Elmt.d;
    self.sThlab(N)=p1Elmt.label;
  end
end