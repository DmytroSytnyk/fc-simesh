function obj=extractSubElement(this,label)
  partlab=cellfun(@(x) x(1),this.partlab)
  I=find(partlab==label);
  me=this.me(:,I);
  
end