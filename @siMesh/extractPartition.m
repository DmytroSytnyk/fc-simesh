function obj=extractPartition(self,plabel)
  % label : partition label
  i=self.find(self.d,plabel);
  if isempty(i), obj=[];return; end
  obj=ooMesh();
  obj.d=self.d;
  obj.dim=self.dim;
  l=1; 
  obj.sTh{l}=self.sTh{i};
  obj.nsTh=1;
  obj.sThsimp(l)=obj.d;
  obj.sThlab(l)=plabel;
  q=obj.sTh{l}.q;
  nq=obj.sTh{l}.nq;
  obj.nq=obj.sTh{l}.nq;
  I=self.find(self.d-1);
  for k=1:length(I)
    i=I(k);
    if self.sTh{i}.label>0
      if sum(cellfun(@(x) size(x,1),self.sTh{i}.partlab)) == length(self.sTh{i}.partlab)
        partlab=cellfun(@(x) x(1),self.sTh{i}.partlab);
        P=find(partlab==label);
        if ~isempty(P)
          me=self.sTh{i}.me(:,P);
          mel=self.sTh{i}.label*int32(ones(1,length(P)));
          obj.AddElements(self.d-1,self.sTh{i}.q,length(mel),me,mel,self.sTh{i}.indve);
        end
      end
    else % fictif (ghost)
      Ql=self.sTh{i}.q(:,self.sTh{i}.me(:,1));
      % Check if all Ql points are in q? Un peu pourri comme methode! => a ameliorer
      isIn=true;r=1;nQl=size(Ql,2);
      while ((isIn)&&(r<=nQl))
        S=sqrt(sum((q-Ql(:,r)*ones(1,nq)).^2,1));
        A=find(S<1e-6);
        if isempty(A), isIn=false;end
        r=r+1;
      end
      if isIn
        obj.nsTh=obj.nsTh+1;
        obj.sTh{obj.nsTh}=self.sTh{i};
        obj.sThsimp(obj.nsTh)=self.d-1;
        obj.sThlab(obj.nsTh)=self.sTh{i}.label;
      end
    end
  end
end