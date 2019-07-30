function varargout=feval3D02(varargin)
  p = inputParser; 
  p.addParamValue('verbose',true,@islogical);
  p.parse(varargin{:});
  verbose=p.Results.verbose;
  if verbose,fprintf('*** Building the mesh file\n');end
  meshfile=fc_oogmsh.buildmesh3d('cylinderkey',15);
  if verbose,fprintf('*** Creating siMesh object by reading the mesh file\n');end
  Th=siMesh(meshfile);
  
  f=@(x,y,z) cos(2*x).*sin(3*y).*exp(pi*z);

  function w=g(x,y,z,cx,cy,cz)
    w=cos(cx*x).*sin(cy*y).*exp(cz*z);
  end
  
  g1=@(x,y,z) g(x,y,z,2,3,pi);
  g2=@(q) g(q(1,:),q(2,:),q(3,:),2,3,pi);
  
  if verbose,fprintf('*** Computing functions on mesh\n');end
  w=Th.feval(f);
  w1=Th.feval(g1);
  w2=Th.feval(g2);

  
  if verbose,fprintf('*** Check results\n');end
  res=0;
  E=max(abs(w1-w));
  res=res+(E >1e-15);
  if verbose, if (E >1e-15),fprintf('  Test 1: failed with E=%g\n',E);else fprintf('  Test 1: OK\n');end;end
  E=max(abs(w2-w));
  res=res+(E >1e-15);
  if verbose, if (E >1e-15),fprintf('  Test 2: failed with E=%g\n',E);else fprintf('  Test 2: OK\n');end;end
  if nargout==1,varargout{1}=(res==0);end
end


