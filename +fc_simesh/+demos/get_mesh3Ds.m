function varargout=get_mesh3Ds(varargin)
  p = inputParser; 
  p.addParamValue('verbose',true,@islogical);
  p.parse(varargin{:});
  verbose=p.Results.verbose;
  if verbose,fprintf('*** Building the mesh file\n');end
  meshfile=fc_oogmsh.buildmesh3ds('demisphere5',30);
  if verbose,fprintf('*** Creating siMesh object by reading the mesh file\n');end
  Th=siMesh(meshfile);
  
  [q,me,toGlobal]=Th.get_mesh();
  [q2,me2,toGlobal2]=Th.get_mesh('d',2,'labels',[10:13]);
  [q1,me1,toGlobal1]=Th.get_mesh('d',1);
  
  if verbose,fprintf('*** Check results\n');end
  res=0;
  E=norm(q(:,toGlobal2)-q2,Inf);
  res=res+(E >1e-15);
  if verbose, if (E >1e-15),fprintf('  Test 1: failed with E=%g\n',E);else fprintf('  Test 1: OK\n');end;end
  E=norm(q(:,toGlobal1)-q1,Inf);
  res=res+(E >1e-15);
  if verbose, if (E >1e-15),fprintf('  Test 2: failed with E=%g\n',E);else fprintf('  Test 2: OK\n');end;end
  if nargout==1,varargout{1}=(res==0);end
end
