function ind=find(this,varargin)
  switch nargin
    case 2
      % d=varargin{1}
      ind=find(this.sThsimp==varargin{1});
    case 3
      %ind=find((this.sThsimp==varargin{1}) & (this.sThlab==varargin{2}));
      I=find(this.sThsimp==varargin{1});
      [J,c]=intersect(this.sThlab(I),varargin{2}); % Add test if labels are OK
      ind=I(c);
%        if length(ind)<length(varargin{2})
%          str=sprintf(' %d,',setdiff(varargin{2},this.sThlab(I)));str(end)='.';
%          warning('labels not found for %d-simplex sub-meshes : %s',varargin{1},str);
%        end
    otherwise
      ind=[];
      warning('unknown number of arguments')
  end 
  %if isempty(ind), warning('Sub mesh not found ');end
end
