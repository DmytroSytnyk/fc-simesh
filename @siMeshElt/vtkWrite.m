function  vtkWrite(self,FileName,varargin)
% function  vtkWrite(FileName,Th,U,names)
%   Write mesh element and U in a VTK file.
%
% Parameters:
%   FileName : VTK file name,
%   U  : an array of cells which contains all the values to save in VTK file,
%   names : an array of cells which contains all the names of the values to save in VTK file.
%
% Samples:
%   % Saving scalar values
%   Th=GetMesh3DOpt('sphere-1-10.mesh','format','medit');
%   U=cos(Th.q(1,:).^2+Th.q(2,:).^2+Th.q(3,:).^2);
%   V=cos(Th.q(1,:).^2+Th.q(2,:).^2+Th.q(3,:).^2);
%   vtkWrite('sample01.vtk',Th,{U',V'},{'u','v'})
%
%   % Saving vector values
%   U{1}=Th.q(1,:).^2+Th.q(2,:).^2+Th.q(3,:).^2;
%   U{2}=cos(U{1});
%   U{3}=sin(U{1});
%   vtkWrite('sample02.vtk',Th,{[U{1},U{2},U{3}]},{'U'})
%
  p = inputParser;
  p.addParamValue('Values',{},@(x) iscell(x) || isnumeric(x) );
  p.addParamValue('Names',{},@(x) (iscell(x) || ischar(x)));
  p.parse(varargin{:});
  U=p.Results.Values;
  names=p.Results.Names;
  %>>> [FC] : to improve
  if isnumeric(U), U={U};end  
  if ischar(names), names={names};end
  %<<<
  fid=fopen(FileName,'w');
  vtkWriteMesh(self,fid);
  if ~isempty(U)
    fprintf(fid,'POINT_DATA %d\n',self.nq);
    assert(iscell(U) & iscell(names));
    assert(length(U)==length(names));
    n=length(U);
    for i=1:n
      if size(U{i},2)==self.nq, U{i}=U{i}';end
      assert(size(U{i},1)==self.nq);
      vtkWriteValues(fid,U{i},names{i});
    end
  end
  fclose(fid);
end

function vtkWriteMesh(Th,fid)
  if ischar(fid), fid=fopen(fid,'w');end
  fprintf(fid,'# vtk DataFile Version 2.0\n');
  fprintf(fid,'Generated Volume Mesh\n');
  fprintf(fid,'ASCII\n');
  fprintf(fid,'DATASET UNSTRUCTURED_GRID\n');
  fprintf(fid,'POINTS %d float\n',Th.nq);
  if Th.d==3
    fprintf(fid,'%.16f %.16f %.16f\n',Th.q);
%      for i=1:Th.nq
%        fprintf(fid,'%g %g %g\n',Th.q(1,i),Th.q(2,i),Th.q(3,i));
%      end

    fprintf(fid,'CELLS %d %d\n',Th.nme,5*Th.nme);
    fprintf(fid,'4 %d %d %d %d\n',Th.me-1);
%      for k=1:Th.nme
%        fprintf(fid,'4 %d %d %d %d\n',Th.me(1,k)-1,Th.me(2,k)-1,Th.me(3,k)-1,Th.me(4,k)-1);
%      end
    fprintf(fid,'CELL_TYPES %d\n',Th.nme);
    fprintf(fid,'%d\n',10*ones(Th.nme,1));
%      for k=1:Th.nme
%        fprintf(fid,'10\n'); % 10 for tetrahedra
%      end
  else
    if size(Th.q,1)==2
      fprintf(fid,'%.16f %.16f 0\n',Th.q);
%        for i=1:Th.nq
%  	fprintf(fid,'%g %g 0\n',Th.q(1,i),Th.q(2,i));
%        end
    else
      fprintf(fid,'%.16f %.16f %.16f\n',Th.q);
%        for i=1:Th.nq
%  	fprintf(fid,'%g %g %g\n',Th.q(1,i),Th.q(2,i),Th.q(3,i));
%        end
    end

    fprintf(fid,'CELLS %d %d\n',Th.nme,4*Th.nme);
    fprintf(fid,'3 %d %d %d \n',Th.me-1);
%      for k=1:Th.nme
%        fprintf(fid,'3 %d %d %d \n',Th.me(1,k)-1,Th.me(2,k)-1,Th.me(3,k)-1);
%      end
    fprintf(fid,'CELL_TYPES %d\n',Th.nme);
    fprintf(fid,'%d\n',5*ones(Th.nme,1));
%      for k=1:Th.nme
%        fprintf(fid,'5\n'); % 5 for triangles
%      end
  end
  fprintf(fid,'\n');
end

function vtkWriteValues(fid,U,name)
  assert(isnumeric(U));
  d=size(U,2);
  nq=size(U,1);
  assert(d<=3);
  if d==1
    fprintf(fid,'SCALARS %s float 1\n',name);
    fprintf(fid,'LOOKUP_TABLE table_%s\n',name);
    fprintf(fid,'%.16f\n',U);
  else
    X=zeros(nq,3);for i=1:d, X(:,i)=U(:,i);end
    fprintf(fid,'VECTORS vectors float\n');
    format=[repmat('%.16f ',1,d),'\n'];
    fprintf(fid,format,X);
%      for i=1:nq
%        fprintf(fid,'%g ',X(i,:));fprintf(fid,'\n');
%      end
  end
  fprintf(fid,'\n');
end