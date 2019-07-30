function obj=DeletesiMeshElt(self,idx)
  % idx : partition label
  obj=siMesh();
  obj.d=self.d;
  obj.dim=self.dim;
  %obj.nsTh=self.nsTh-1;
  obj.toGlobal=self.toGlobal;
  I=setdiff(1:self.nsTh,idx);
  for i=[I]
    obj=obj.AddCopysiMeshElt(self.sTh{i});
  end
  obj.set_colors();
  obj.setTags();
  obj.set_bbox();
  
  I=[];for i=1:obj.nsTh,I=[i,obj.sTh{i}.toGlobal];end
  [toGlobal,ia,ic]=unique(I);
  obj.nq=length(toGlobal);
  obj.toGlobal=1:obj.nq;
  J=1:obj.nq; 
  B=sparse(toGlobal,ones(1,obj.nq),J);
  for i=1:obj.nsTh
    obj.sTh{i}.toGlobal=full(B(obj.sTh{i}.toGlobal,1))';
    obj.sTh{i}.nqGlobal=obj.nq;
    obj.sTh{i}.toParent=obj.sTh{i}.toGlobal;
    obj.sTh{i}.nqParent=obj.nq;
  end
  
end

