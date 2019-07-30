classdef siMesh < handle 
  
  properties %(SetAccess = protected)
    d =0;
    dim=0;
    sTh={};
    nsTh=0;
    toGlobal=[];
    toParent=[];
%    nqGlobal=0;;
    sThsimp=[];
    sThlab=[];
    sThcolors=[];
    bbox=[]; % Bounding box
    sThgeolab=[];
    sThphyslab=[];
    sThpartlabs={};
    %sElts=[];
    % Ms=[];
    nq=0;
    nqParents = []; 
    toParents ={};
  end
  
  methods
  
    function self = siMesh(cFileName,varargin)
      if nargin==0, return;end
      if nargin>0
        assert(ischar(cFileName),'First parameter must be file name (char)')
        p = inputParser;
        p.addParamValue('dim', 2, @isfloat );
        p.addParamValue('d', [] );
        %p.addParamValue('perm',true); % permutation of local points : (false : as in (medit format))
        p.addParamValue('color',true);
        p.addParamValue('format','gmsh',@(x) ismember(x,{'medit','gmsh','freefem','triangle'}));
        p.addParamValue('isPhysLabel',true,@islogical);
        p.addParamValue('trans',[]);
        p.parse(varargin{:});
        R=p.Results;
        if isempty(R.d),  R.d=[R.dim:-1:(R.dim-1)];end
	switch R.format
	  case('medit')
          self.readMedit(cFileName,R.dim,R.d);
	  case('gmsh')
          self.readgmsh(cFileName,R.dim,R.d,R.isPhysLabel,R.trans);
	  case('freefem')
          self.readfreefem(cFileName,R.dim,R.d);
	  case('triangle')
          self.readtriangle(cFileName,R.dim);
      end
        if R.color, self.set_colors(); end
        self.setTags();
        self.set_bbox();
      end
    end 
    
    function self=set_bbox(self)
      self.bbox=self.sTh{1}.bbox;
      for k=2:self.nsTh
        bb=self.sTh{k}.bbox;
        for i=1:self.dim
          self.bbox(2*i-1)=min(self.bbox(2*i-1),bb(2*i-1));
          self.bbox(2*i)=max(self.bbox(2*i),bb(2*i));
        end
      end
    end
    
    function self=set_colors(self)
      self.sThcolors=zeros(self.nsTh,3);
      for d=0:self.d
        Ilab=self.find(d);
        if ~isempty(Ilab)
          self.sThcolors(Ilab,:)=fc_tools.graphics.selectColors(length(Ilab));
        end
        for jlab=Ilab
          self.sTh{jlab}.color=self.sThcolors(jlab,:);
        end
      end
    end
    
    function self=setTags(self)
      for i=1:self.nsTh
        Tag=sprintf('d:%d, label : %d\nnq=%d, nme=%d',self.sTh{i}.d,self.sTh{i}.label,self.sTh{i}.nq,self.sTh{i}.nme);
        self.sTh{i}.Tag=Tag;
      end
    end
    
  end % methods 
end % classdef
