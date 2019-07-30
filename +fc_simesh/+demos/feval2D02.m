function varargout=feval2D02(varargin)
  p = inputParser; 
  p.addParamValue('verbose',true,@islogical);
  p.parse(varargin{:});
  verbose=p.Results.verbose;
  if verbose,fprintf('*** Building the mesh file\n');end
  meshfile=fc_oogmsh.buildmesh2d('condenser11',50);
  if verbose,fprintf('*** Creating siMesh object by reading the mesh file\n');end
  Th=siMesh(meshfile);
  
  f=@(x,y) cos(2*x).*sin(3*y);

  function z=g(x,y,cx,cy)
    z=cos(cx*x).*sin(cy*y);
  end
  
  g1=@(x,y) g(x,y,2,3);
  g2=@(q) g(q(1,:),q(2,:),2,3);
  
  if verbose,fprintf('*** Computing functions on mesh\n');end
  z=Th.feval(f);
  z1=Th.feval(g1);
  z2=Th.feval(g2);

  
  if verbose,fprintf('*** Check results\n');end
  res=0;
  E=max(abs(z1-z));
  res=res+(E >1e-15);
  if verbose, if (E >1e-15),fprintf('  Test 2: failed with E=%g\n',E);else fprintf('  Test 2: OK\n');end;end
  E=max(abs(z2-z));
  res=res+(E >1e-15);
  if verbose, if (E >1e-15),fprintf('  Test 2: failed with E=%g\n',E);else fprintf('  Test 2: OK\n');end;end
  if nargout==1,varargout{1}=(res==0);end
end


