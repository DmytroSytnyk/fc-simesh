function varargout=eval3Ds01(varargin)
  p = inputParser; 
  p.addParamValue('verbose',true,@islogical);
  p.parse(varargin{:});
  verbose=p.Results.verbose;
  if verbose,fprintf('*** Building the mesh file\n');end
  meshfile=fc_oogmsh.buildmesh3ds('demisphere5',30);
  if verbose,fprintf('*** Creating siMesh object by reading the mesh file\n');end
  Th=siMesh(meshfile);
  
  data1=@(x,y,z) 2;
  data2=2;
  data3=2*ones(Th.nq,1);
  data4=2*ones(1,Th.nq);
    
  if verbose,fprintf('*** Evaluating datas on mesh\n');end
  z1=Th.eval(data1);
  z2=Th.eval(data2);
  z3=Th.eval(data3);
  z4=Th.eval(data4);
  
  if verbose,fprintf('*** Check results\n');end
  res=0;
  E=max(abs(z2-z1));
  res=res+(E >1e-15);
  if verbose, if (E >1e-15),fprintf('  Test 1: failed with E=%g\n',E);else fprintf('  Test 1: OK\n');end;end
  E=max(abs(z3-z1));
  res=res+(E >1e-15);
  if verbose, if (E >1e-15),fprintf('  Test 2: failed with E=%g\n',E);else fprintf('  Test 2: OK\n');end;end
  res=0;
  E=sum(size(z1)~=size(z2)); % return 0 if same size
  res=res+(E >1e-15);
  if verbose, if (E >1e-15),fprintf('  Test 3: failed with size(z1)=[%s] and size(z2)=[%s]\n',num2str(size(z1)),num2str(size(z2)));else fprintf('  Test 3: OK\n');end;end
  if E==0
    E=max(abs(z4-z1));
    res=res+(E >1e-15);
    if verbose, if (E >1e-15),fprintf('  Test 4: failed with E=%g\n',E);else fprintf('  Test 4: OK\n');end;end
  end
  if nargout==1,varargout{1}=(res==0);end
end
