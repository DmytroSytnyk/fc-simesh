function cl=get_cl(self)
% get characteristic length
  i=1:self.dim;
  cl=max(self.bbox(2*i)-self.bbox(2*i-1));
end