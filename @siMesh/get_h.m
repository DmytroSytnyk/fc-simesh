function h=get_h(self)
  h=0;
  for i=1:self.nsTh
    h=max(h,self.sTh{i}.h);
  end
end