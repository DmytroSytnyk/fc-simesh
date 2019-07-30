function ul=getLocalData(self,u)
  if length(u)==self.nqGlobal
    ul=u(self.toGlobal);
  elseif length(u)==self.nqParent
    ul=u(self.toParent);
  else
    assert(length(u)==self.nq);
    ul=u;
  end
end