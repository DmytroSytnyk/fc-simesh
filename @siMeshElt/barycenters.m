function Ba=barycenters(this)
  Ba=zeros(this.dim,this.nme);
  for i=1:this.d+1
    Ba=Ba+this.q(:,this.me(i,:));
  end
  Ba=Ba/(this.d+1);
end