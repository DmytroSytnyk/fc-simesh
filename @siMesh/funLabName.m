function labName=funLabName(self,d)
  if self.d==d
    if fc_tools.comp.isOctave()
      labName=@(i) ['\Omega_{',num2str(i),'}'];
    else
      %labName=@(i) ['$\Omega_{',num2str(i),'}$'];
      labName=@(i) ['\Omega_{',num2str(i),'}'];
    end
    return;
  elseif self.d==(d+1)
  if fc_tools.comp.isOctave()
      labName=@(i) ['\Gamma_{',num2str(i),'}'];
    else
      %labName=@(i) ['$\Gamma_{',num2str(i),'}$'];
      labName=@(i) ['\Gamma_{',num2str(i),'}'];
    end
    return;
  elseif self.d==(d+2)
    if fc_tools.comp.isOctave()
      labName=@(i) ['\partial\Gamma_{',num2str(i),'}'];
    else
      %labName=@(i) ['$\partial\Gamma_{',num2str(i),'}$'];
      labName=@(i) ['\partial\Gamma_{',num2str(i),'}'];
    end
    return
  elseif self.d==(d+3)
    if fc_tools.comp.isOctave()
      labName=@(i) ['\partial^2\Gamma_{',num2str(i),'}'];
    else
      %labName=@(i) ['$\partial\Gamma_{',num2str(i),'}$'];
      labName=@(i) ['\partial^2\Gamma_{',num2str(i),'}'];
    end
    return
  end
  labName=[];
  return
end