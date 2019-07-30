function sTh=getBoundMesh(self)
  assert(self.d==2)
  NumLocEdges=nchoosek(1:(self.d+1),self.d);
  GlobalListEdges=[reshape(self.me(NumLocEdges(:,1),:),3*self.nme,1),reshape(self.me(NumLocEdges(:,2),:),3*self.nme,1)];

  Edges2Elements=ones(3,1)*[1:self.nme];
  Edges2Elements=Edges2Elements(:);

  Edges2LocalNum=[1; 2 ;3]*ones(1,self.nme);
  Edges2LocalNum=Edges2LocalNum(:);

  [GlobalListEdgesSort,IS]=sort(GlobalListEdges,2);
  [e2q,IG,IE]=unique(GlobalListEdgesSort,'rows','first');   
  e2t=Edges2Elements(IG,:);
  [e2ql,IGl,IEf]=unique(GlobalListEdgesSort,'rows','last');
  e2tl=Edges2Elements(IGl,:);
  Id=find(IG==IGl);
  e2tl(Id)=0;
  e2t=[e2t e2tl];
  I=find(e2t(:,2)==0);
  me=e2q(I,:)';
  sTh=siMeshElt(self.dim,self.d-1,self.label,self.q,me,[],0,[],[]);
  sTh.color=self.color;
end