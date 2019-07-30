classdef siMeshElt < handle
  
  properties %(SetAccess = protected)
    d =0;
    dim=0;
    nq=0;
    nme=0;
    q  = [];
    me = [];
    toGlobal=[];
    nqGlobal=0;
    toParent=[]; % pour remplacer toGlobal;
    nqParent=0;  % pour remplacer nqGlobal;
    nqParents = []; %  nqParents(i)  i=1: parent, i=2:parent of parent, ...
    toParents = {};  
    label=0;
    Tag='';
    color=[];
    vols = [];
    gradBaCo =[];
    geolab =[];
    partlab={};
    bbox=[];
    h=0;
  end
  
  methods
    function self = siMeshElt(dim,d,label,q,me,toGlobal,nqGlobal,geolab,partlab)
      % must add tests
      if nargin==0; return;end
      if nargin>0
        self.dim=dim;
        self.d=d;
        self.label=label;
        self.q=q;
        self.nq=size(q,2);
        self.me=me;
        self.nme=size(me,2);
        if size(toGlobal,2)==1,toGlobal=toGlobal';end
        self.toGlobal=toGlobal;
        self.nqGlobal=nqGlobal;
        self.toParent=toGlobal;
        self.nqParent=nqGlobal;
        self.nqParents(1)=nqGlobal;
        self.toParents{1}=toGlobal;
        self.geolab=geolab;
        self.partlab=partlab;
        self.vols=fc_simesh.tools.ComputeVolVec(self.d,self.q,self.me);
        self.gradBaCo=fc_simesh.tools.GradBaCo(self.d,self.q,self.me);
        self.h=fc_simesh.tools.GetMaxLengthEdges(self.q,self.me);
        self.bbox=zeros(1,2*dim); % bounding box
        for i=1:dim,self.bbox(2*i-1:2*i)=[min(q(i,:)),max(q(i,:))];end
        
      end
    end 
    
    function self=copy(selfor)
      self=siMeshElt();
      self.dim=selfor.dim;
      self.d=selfor.d;
      self.label=selfor.label;
      self.q=selfor.q;
      self.nq=selfor.nq;
      self.me=selfor.me;
      self.nme=selfor.nme;
      self.toGlobal=selfor.toGlobal;
      self.nqGlobal=selfor.nqGlobal;
      self.toParent=selfor.toGlobal;
      self.nqParent=selfor.nqGlobal;
      self.geolab=selfor.geolab;
      self.partlab=selfor.partlab;
      self.vols=selfor.vols;
      self.gradBaCo=selfor.gradBaCo;
      self.h=selfor.h;
      self.bbox=selfor.bbox;
    end
    
  end  
end