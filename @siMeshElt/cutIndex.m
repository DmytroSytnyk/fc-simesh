function idxme=cutIndex(self,P)
  idxme=1:self.nme;
  if isempty(P), return;end
  assert( isnumeric(P) && size(P,2)==4 );
  for i=1:size(P,1)
    idxme=setdiff(idxme,cutIndexPlan(self,P(i,:)));
  end
end

function idxme=cutIndexPlan(self,P)
    Point=[0;0;-P(4)]; %%%% BUG 
    idx=find(P(1:3)*(self.q-Point*ones(1,self.nq))<0);
    idxme=find(sum(ismember(self.me,idx),1)==0);
end