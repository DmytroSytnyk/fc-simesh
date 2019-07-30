function varargout=eval3Ds03(varargin)
  p = inputParser; 
  p.addParamValue('verbose',true,@islogical);
  p.parse(varargin{:});
  verbose=p.Results.verbose;
  if verbose,fprintf('*** Building the mesh file\n');end
  meshfile=fc_oogmsh.buildmesh3ds('demisphere5',30);
  if verbose,fprintf('*** Creating siMesh object by reading the mesh file\n');end
  Th=siMesh(meshfile);
  fu=@(x,y,z) cos(3*x).*sin(4*y).*z;
  u=Th.feval(fu);
  % f : R^2 -> R^3
  f={@(x,y,z) cos(2*x).*sin(3*y).*exp(z), 1 ,u,@(q) cos(4*q(1,:)).*sin(5*q(2,:)).*exp(q(3,:))};
  
  g={@(x,y,z) cos(2*x).*sin(3*y).*exp(z), @(x,y,z) 1 ,fu, @(x,y,z) cos(4*x).*sin(5*y).*exp(z)};

  if verbose,fprintf('*** Computing functions on mesh\n');end
  V1=Th.eval(f);
  V2=Th.feval(g);
  
  if verbose,fprintf('*** Check results\n');end
  res=0;
  E=sum(size(V1)~=size(V2)); % return 0 if same size
  res=res+(E >1e-15);
  if verbose, if (E >1e-15),fprintf('  Test 1: failed with size(V1)=[%s] and size(V2)=[%s]\n',num2str(size(V1)),num2str(size(V2)));else fprintf('  Test 1: OK\n');end;end
  if E==0
    E=norm(V1-V2,Inf);
    res=res+(E >1e-15);
    if verbose, if (E >1e-15),fprintf('  Test 2: failed with E=%g\n',E);else fprintf('  Test 2: OK\n');end;end
  end
  if nargout==1,varargout{1}=(res==0);end
end


