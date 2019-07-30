function varargout=feval2D01(varargin)
  p = inputParser; 
  p.addParamValue('verbose',true,@islogical);
  p.parse(varargin{:});
  verbose=p.Results.verbose;
  if verbose,fprintf('*** Building the mesh file\n');end
  meshfile=fc_oogmsh.buildmesh2d('condenser11',50);
  if verbose,fprintf('*** Creating siMesh object by reading the mesh file\n');end
  Th=siMesh(meshfile);
  
  g1=@(x,y) cos(x).*sin(y);
  g2=@(q) cos(q(1,:)).*sin(q(2,:));

  function z=g3(x,y)
    z=cos(x).*sin(y);
  end
  
  function z=g4(q)
    z=cos(q(1,:)).*sin(q(2,:));
  end
  
  if verbose,fprintf('*** Computing functions on mesh\n');end
  z1=Th.feval(g1);
  z2=Th.feval(g2);
  z3=Th.feval(@g3);
  z4=Th.feval(@g4);
  
  if verbose,fprintf('*** Check results\n');end
  res=0;
  E=max(abs(z2-z1));
  res=res+(E >1e-15);
  if verbose, if (E >1e-15),fprintf('  Test 1: failed with E=%g\n',E);else fprintf('  Test 1: OK\n');end;end
  E=max(abs(z3-z1));
  res=res+(E >1e-15);
  if verbose, if (E >1e-15),fprintf('  Test 2: failed with E=%g\n',E);else fprintf('  Test 2: OK\n');end;end
  E=max(abs(z4-z1));
  res=res+(E >1e-15);
  if verbose, if (E >1e-15),fprintf('  Test 3: failed with E=%g\n',E);else fprintf('  Test 3: OK\n');end;end
  if nargout==1,varargout{1}=(res==0);end
end
