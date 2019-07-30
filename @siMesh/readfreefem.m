% self=readfreefem(self,cFileName,dim,d)
%   Reading a 2D FreeFem mesh
%
% Parameter :
%   cFileName : mesh filename
%   dim: space dimension
%   d: array of size of d-simplices for the mesh ([2 1] most of the time) 
% Output :
%   an ooMesh structure
%

function self=readfreefem(self,cFileName,dim,d)
  if fc_tools.comp.isOctave()
    self=readfreefem_Octave(self,cFileName,dim,d);
  else
    self=readfreefem_Matlab(self,cFileName,dim,d);
  end
end

function self=readfreefem_Matlab(self,cFileName,dim,d)
%
  self.dim=dim;
  self.d=max(d);
  assert(self.d==2,'d=2 for a freefem mesh');

  [fid,message]=fopen(cFileName,'r');
  if ( fid == -1 ), error([message,' : ',cFileName]); end
    n=textscan(fid,'%d %d %d',1); % n(1) -> number of vertices
			% n(2) -> number of triangles
			% n(3) -> number of boundary edges
    
    self.nq=n{1};
    R=textscan(fid,'%f %f %d',n{1});
    q=[R{1},R{2}]';
    ql=R{3}';
    R=textscan(fid,'%d %d %d %d',n{2});
    me=[R{1},R{2},R{3}]';
    mel=R{4}';
    self=AddsiMeshElts(self,max(d),q,size(me,2),me,mel);
    R=textscan(fid,'%d %d %d',n{3});
    be=[R{1},R{2}]';
    bel=R{3}';
    self=AddsiMeshElts(self,min(d),q,size(be,2),be,bel);
  fclose(fid);
  if(dim>2)
    q=[q;zeros(dim-2,size(q,2))];
  end
end

function self=readfreefem_Octave(self,cFileName,dim,d)
%
  self.dim=dim;
  self.d=max(d);
  assert(self.d==2,'d=2 for a freefem mesh');

  [fid,message]=fopen(cFileName,'r');
  if ( fid == -1 ), error([message,' : ',cFileName]); end
    n=fscanf(fid,'%d',3); % n(1) -> number of vertices
                        % n(2) -> number of triangles
                        % n(3) -> number of boundary edges
    
    self.nq=n(1);
    R=fscanf(fid,'%f %f %f',[3,n(1)]);
    ql=R(3,:);
    q=R(1:2,:);
    R=fscanf(fid,'%d %d %d %d',[4,n(2)]);
    me=R(1:3,:);
    mel=R(4,:);
    self=AddsiMeshElts(self,max(d),q,size(me,2),me,mel);
    R=fscanf(fid,'%d %d %d',[3,n(3)]);
    be=R(1:2,:);
    bel=R(3,:)';
    self=AddsiMeshElts(self,min(d),q,size(be,2),be,bel);
  fclose(fid);
  if(dim>2)
    q=[q;zeros(dim-2,size(q,2))];
  end

end

