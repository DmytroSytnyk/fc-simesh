function ooTh=HyperCube(d,N,varargin)
% function ooTh=HyperCube(d,N,trans)
%   Build d-simplicial mesh of the hypercube [0,1]^d. Can be transform using 
%   optional parameter trans.
%
% Parameters:
%   d     : space dimension.
%   N     : numbers of discretisation in each space direction.
%           1-by-d array of integer or integer for same number in each space direction.
%   trans : (optional). Function used to transfrom vertices of hypercube mesh.
%   m_min : (optional). Create all the m-faces for  m_min<=m<=d  (default m_min=0).
%
% Return values:
%   Th    : ooMesh object
%
% Example:
%   Th=fc_simesh.HyperCube(2,50);
%   Th=mooMesh.HyperCube(2,[100,10],'trans',@(q) [20*q(1,:);2*q(2,:)-1]);
%   Th=mooMesh.HyperCube(2,[100,10],'trans',@(q) [20*q(1,:);(2*q(2,:)-1)+cos(2*pi*q(1,:))]);
%   Th=mooMesh.HyperCube(3,[10,100,10],'trans',@(q) [(2*q(1,:)-1);20*q(2,:);(2*q(3,:)-1)+cos(2*pi*q(2,:))]);
%
  p = inputParser; 
  p.addParamValue('trans', @(q) q, @(x) strcmp(class(x),'function_handle') ); % default - dim=-1 has
  p.addParamValue('m_min', 0, @(x) (x<=d) && (x>=0) );
  p.parse(varargin{:});
  trans=p.Results.trans;m_min=p.Results.m_min;
  
  ooTh=siMesh();
  ooTh.d=d;ooTh.dim=d;
  
  Oh=OrthMesh(d,N,'mapping',trans,'m_min',m_min); % from hypermesh toolbox
  Th=Oh.Mesh;
  ooElt=siMeshElt(d,d,1,Th.q,Th.me,1:Th.nq,Th.nq,[],[]);
  ooTh.AddsiMeshElt(ooElt);
  
  for i=1:numel(Oh.Faces)
    for j=1:numel(Oh.Faces{i})
      sTh=Oh.Faces{i}(j);
      ooElt=siMeshElt(d,sTh.m,j,sTh.q,sTh.me,sTh.toGlobal,Th.nq,[],[]);
      ooTh.AddsiMeshElt(ooElt);
    end
  end

  ooTh.set_colors();
  ooTh.setTags();
  ooTh.set_bbox();
  ooTh.sThphyslab=1;
end