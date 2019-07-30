function  vtuWrite(Th,FileName,varargin)
% function  vtkWrite(FileName,Th,varargin)
%   Write mesh Th and U in a VTK file.
%
% Parameters:
%   FileName : VTK file name,
%   Th : a 2D or 3D mesh
%   U  : an array of cells which contains all the values to save in VTK file,
%   names : an array of cells which contains all the names of the values to save in VTK file.
%
% Samples:
%   % Save scalar values
%   Th=GetMesh3DOpt('sphere-1-10.mesh','fromet','medit');
%   U=cos(Th.q(1,:).^2+Th.q(2,:).^2+Th.q(3,:).^2);
%   V=cos(Th.q(1,:).^2+Th.q(2,:).^2+Th.q(3,:).^2);
%   vtkWrite('sample01.vtk',Th,{U,V},{'u','v'})
%
%   % Save vector values
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

  fid=fopen(FileName,'w');
  fprintf(fid,'<VTKFile type="UnstructuredGrid" version="0.1" byte_order="BigEndian">\n');
  fprintf(fid,'\t<UnstructuredGrid>\n');
  fprintf(fid,'\t\t<Piece NumberOfPoints="%d" NumberOfCells="%d">\n',Th.nq,Th.nme);
  %>>> Write Points
  fprintf(fid,'\t\t\t<Points>\n');
  dim=Th.dim;
  fprintf(fid,'\t\t\t\t<DataArray type="Float32" NumberOfComponents="%d" Format="ascii">\n',dim);
  format=['\t\t\t\t\t',repmat('%.16f ',1,dim),'\n']; 
  fprintf(fid,format,Th.q);
  fprintf(fid,'\t\t\t\t</DataArray>\n');
  fprintf(fid,'\t\t\t</Points>\n');
  %<<<
  %>>> Write Cells
  fprintf(fid,'\t\t\t<Cells>\n');
  fprintf(fid,'\t\t\t\t<DataArray type="Int32" Name="connectivity" Format="ascii">\n');
  d=size(Th.me,1);
  if d==4,type=10;end % VTK_TETRA (=10)
  if d==3,type=5;end % VTK_TRIANGLE (=5)
  format=['\t\t\t\t\t',repmat('%d ',1,dim),'\n'];
  fprintf(fid,format,Th.me-1);
  fprintf(fid,'\t\t\t\t</DataArray>\n');
  fprintf(fid,'\t\t\t\t<DataArray type="Int32" Name="offsets" Format="ascii">\n');
  d=size(Th.me,1);
  format='\t\t\t\t\t%%d\n';
  offset=d*[1:Th.nme]';
  fprintf(fid,'\t\t\t\t\t%d\n',offset);
  fprintf(fid,'\t\t\t\t</DataArray>\n');
  fprintf(fid,'\t\t\t\t<DataArray type="Int32" Name="types" Format="ascii">\n');
  d=size(Th.me,1);
  format='\t\t\t\t\t%%d\n';
  fprintf(fid,'\t\t\t\t\t%d\n',type*ones(Th.nme,1));
  fprintf(fid,'\t\t\t\t</DataArray>\n');
  fprintf(fid,'\t\t\t</Cells>\n');
  %<<<
  fprintf(fid,'\t\t\t<PointData Scalars="scalars">\n');
  if ~isempty(U)
    assert(iscell(U) & iscell(names));
    assert(length(U)==length(names));
    n=length(U);
    for i=1:n
      vtuWriteValues(Th,fid,U{i},names{i});
    end
  end
  fprintf(fid,'\t\t\t</PointData>\n');
  fprintf(fid,'\t\t</Piece>\n');
  fprintf(fid,'\t</UnstructuredGrid>\n');
  fprintf(fid,'</VTKFile>\n');
  fclose(fid); 
end


function vtuWriteValues(Th,fid,U,name)
  assert(isnumeric(U));
  if length(U)==Th.nq
    sel=@(X) X;
  elseif length(U)==Th.nqParent
    sel=@(X) X(Th.toParent);
  elseif length(U)==Th.nqGlobal
    sel=@(X) X(Th.toGlobal);
  else
    whos
    assert(0)
  end
  d=size(U,2);
  nq=Th.nq;
  assert(d<=3);
  if d==1
    fprintf(fid,'\t\t\t\t<DataArray type="Float32" Name="%s" Format="ascii">\n',name);
    fprintf(fid,'\t\t\t\t\t%.16f\n',sel(U));
    fprintf(fid,'\t\t\t\t</DataArray>\n');
  else
    X=zeros(3,nq);for i=1:d, X(i,:)=sel(U(:,i));end
    fprintf(fid,'\t\t\t\t<DataArray type="Float32" Name="%s" NumberOfComponents="3" Format="ascii">\n',name);
    fprintf(fid,'\t\t\t\t\t%.16f %.16f %.16f\n',X);
    fprintf(fid,'\t\t\t\t</DataArray>\n');
  end
  fprintf(fid,'\n');
end