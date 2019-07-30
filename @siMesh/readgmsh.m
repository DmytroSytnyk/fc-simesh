function self=readgmsh(self,gmsh_file,dim,d,isPhysLabel,trans)
%    p = inputParser; 
%    p=AddParamValue(p,'dim', 2, @isfloat ); % default - dim=-1 has
%                                         ;   % no effect
%    p=AddParamValue(p,'PhysLabel', true, @islogical ); % Physical Label or Geometrical Label                                          
%    p=Parse(p,varargin{:});
%    dim=p.Results.dim;
%    isPL=p.Results.PhysLabel;
  self.dim=dim;
  self.d=max(d);

  G=ooGmsh(gmsh_file);
  if ~isempty(trans) 
    switch nargin(trans)
      case 1
        G.q=trans(G.q);
      case 2
        G.q=trans(G.q(1,:),G.q(2,:));
      case 3
        G.q=trans(G.q(1,:),G.q(2,:),G.q(3,:));
      otherwise  
        error('trouble with trans option')
    end
    
  end
  if G.dim~=dim
    fprintf('  Mesh %s is a %d-dimensional mesh\n    Force dimension to %d\n',gmsh_file,G.dim,G.dim)
    dim=G.dim;
    d=dim:-1:dim-1;
  end
  
  assert(max(G.orders)==1);
  self.dim=dim;
  self.d=max(d);
  self.toGlobal=G.toGlobal;
  self.nq=length(G.toGlobal);
  self.toParent=G.toGlobal;
  self.toParents{1}=G.toGlobal;
  self.nqParents(1)=G.nq;
%    self.sElts=G.sElts; % for debugging
  for i=1:length(G.sElts)
    dd=EltTypeSimplex(G.sElts(i).type);
    if (~isempty(dd) )%&& (dd~=0))
      nme=size(G.sElts(i).me,2);
      if isempty(G.sElts(i).part_lab)
        if isPhysLabel
          mel=G.sElts(i).phys_lab;
        else
          mel=G.sElts(i).geo_lab;
        end
      else
        %mel=cellfun(@(x) x(1),G.sElts(i).part_lab);
        mel=G.sElts(i).part_lab(:,1);
      end
      self=AddsiMeshElts(self,dd,G.q,nme,G.sElts(i).me,mel,'geolab',G.sElts(i).geo_lab,'partlab',G.sElts(i).part_lab);
    end
  end
  self.d=max(self.sThsimp);
  self.sThphyslab=self.sThlab(self.find(self.d));
end


function d=EltTypeSimplex(elmtype)
  d=[];
  if ismember(elmtype,[15])
    d=0;return
  end
  if ismember(elmtype,[1,8])
    d=1;return
  end
  if ismember(elmtype,[2,9,10,15,21])
    d=2;return
  end
  if ismember(elmtype,[4,11])
    d=3;return
  end  
end

function elm_type=NumNodesByEltType()
        elm_type(1) = 2;   % 2-node line
        elm_type(2) = 3;   % 3-node triangle
        elm_type(3) = 4;   % 4-node quadrangle
        elm_type(4) = 4;   % 4-node tetrahedron
        elm_type(5) = 8;   % 8-node hexahedron
        elm_type(6) = 6;   % 6-node prism
        elm_type(7) = 5;   % 5-node pyramid
        elm_type(8) = 3;   % 3-node second order line
                        ;   % (2 nodes at vertices and 1 with edge)
        elm_type(9) = 6;   % 6-node second order triangle
                           % (3 nodes at vertices and 3 with edges)
        elm_type(10) = 9;   % 9-node second order quadrangle
                           % (4 nodes at vertices,
                           %  4 with edges and 1 with face)
        elm_type(11) = 10;   % 10-node second order tetrahedron
                           % (4 nodes at vertices and 6 with edges)
        elm_type(12) = 27;   % 27-node second order hexahedron
                           % (8 nodes at vertices, 12 with edges,
                           %  6 with faces and 1 with volume)
        elm_type(13) = 18;   % 18-node second order prism
                           % (6 nodes at vertices,
                           %  9 with edges and 3 with quadrangular faces)
        elm_type(14) = 14;   % 14-node second order pyramid
                           % (5 nodes at vertices,
                           %  8 with edges and 1 with quadrangular face)
        elm_type(15) = 1;   % 1-node point
        elm_type(16) = 8;   % 8-node second order quadrangle
                           % (4 nodes at vertices and 4 with edges)
        elm_type(17) = 20;   % 20-node second order hexahedron
                           % (8 nodes at vertices and 12 with edges)
        elm_type(18) = 15;   % 15-node second order prism
                           % (6 nodes at vertices and 9 with edges)
        elm_type(19) = 13;   % 13-node second order pyramid
                           % (5 nodes at vertices and 8 with edges)
        elm_type(20) = 9;   % 9-node third order incomplete triangle
                           % (3 nodes at vertices, 6 with edges)
        elm_type(21) = 10;   % 10-node third order triangle
                           % (3 nodes at vertices, 6 with edges, 1 with face)
        elm_type(22) = 12;   % 12-node fourth order incomplete triangle
                           % (3 nodes at vertices, 9 with edges)
        elm_type(23) = 15;   % 15-node fourth order triangle
                           % (3 nodes at vertices, 9 with edges, 3 with face)
        elm_type(24) = 15;   % 15-node fifth order incomplete triangle
                           % (3 nodes at vertices, 12 with edges)
        elm_type(25) = 21;   % 21-node fifth order complete triangle
                           % (3 nodes at vertices, 12 with edges, 6 with face)
        elm_type(26) = 4;   % 4-node third order edge
                           % (2 nodes at vertices, 2 internal to edge)
        elm_type(27) = 5;   % 5-node fourth order edge
                           % (2 nodes at vertices, 3 internal to edge)
        elm_type(28) = 6;   % 6-node fifth order edge
                           % (2 nodes at vertices, 4 internal to edge)
        elm_type(29) = 20;   % 20-node third order tetrahedron
                           % (4 nodes at vertices, 12 with edges,
                           %  4 with faces)
        elm_type(30) = 35;   % 35-node fourth order tetrahedron
                           % (4 nodes at vertices, 18 with edges,
                           %  12 with faces, 1 in volume)
        elm_type(31) = 56;   % 56-node fifth order tetrahedron
                           % (4 nodes at vertices, 24 with edges,
                           %  24 with faces, 4 in volume)
end