function disp(self)
% FUNCTION disp, method function of the ooGmsh class.
%   Displays informations on the ooGmsh object.
%
% <COPYRIGHT>
  fprintf('  siMeshElt with properties:\n')
  warning off
  names = fieldnames(self);
  maxnamelen=max(cellfun(@numel,names));
  for i=1:numel(names)
    n=eval(sprintf('size(self.%s)',names{i}));
    S=fillwith(names{i},' ',maxnamelen+4);
    fprintf('%s: ',S)
    printProperty(self,names{i})
  end
  warning on
end

function S=fillwith(name,c,nmax)
  n=numel(name);
  S=[repmat(c,1,nmax-n),name];
end

function printProperty(self,name)
  type=eval(sprintf('class(self.%s)',name));
  n=eval(sprintf('size(self.%s)',name));
  if sum(n)==0
    fprintf('[]\n');
  elseif ((n(1)==1) && (n(2)==1))
    if strcmp(type,'struct')
      fprintf('(1x1 struct)\n');
    elseif strcmp(type,'cell')
      fprintf('(1x1 cell)\n');
    else
      value=eval(sprintf('self.%s',name));
      fprintf('%g %s\n',value,type);
    end
  else
    if (n(1)==1) && (n(2)<=5)
      value=eval(sprintf('self.%s',name));
      if isnumeric(value)
        fprintf('[ ');fprintf('%g ',value);fprintf('] ');
      end
    end
    fprintf('(%dx%d %s)\n',n(1),n(2),type);
  end
end