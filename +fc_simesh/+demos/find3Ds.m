function find3Ds()
  fprintf('****************************************\n')
  fprintf('Running fc_simesh.demos.find3Ds function\n')
  fprintf('****************************************\n')
  fprintf('*** Building the mesh file\n')
  meshfile=gmsh.buildmesh3ds('demisphere5',30);
  Th=siMesh(meshfile);
  fprintf('*** 1: print mesh\n')
  disp(Th)
  d=2;
  fprintf('*** 2: print labels of the %d-simplex elementary meshes\n',d)
  idx=Th.find(d);
  fprintf('d=%d, labels=%s\n',d,num2str(Th.sThlab(idx)))
  d=1;
  fprintf('*** 3: print labels of the %d-simplex elementary meshes\n',d)
  idx=Th.find(d);
  fprintf('d=%d, labels=%s\n',d,num2str(Th.sThlab(idx)))
  d=0;
  fprintf('*** 4: print labels of the %d-simplex elementary meshes\n',d)
  idx=Th.find(d);
  fprintf('d=%d, labels=%s\n',d,num2str(Th.sThlab(idx)))
  d=2;lab=10;
  fprintf('*** 5: print %d-simplex elementary meshes with label %d\n',d,lab)
  idx=Th.find(d,lab);
  fprintf('Th.sThlab(%d)=%d\n',idx,Th.sThlab(idx))
  fprintf('Th.sTh{%d} is the ',idx)
  disp(Th.sTh{idx})
  d=1;lab=5;
  fprintf('*** 6: print %d-simplex elementary meshes with label %d\n',d,lab)
  idx=Th.find(d,lab);
  fprintf('Th.sThlab(%d)=%d\n',idx,Th.sThlab(idx))
  fprintf('Th.sTh{%d} is the ',idx)
  disp(Th.sTh{idx})
  d=0;lab=13;
  fprintf('*** 7: print %d-simplex elementary meshes with label %d\n',d,lab)
  idx=Th.find(d,lab);
  fprintf('Th.sThlab(%d)=%d\n',idx,Th.sThlab(idx))
  fprintf('Th.sTh{%d} is the ',idx)
  disp(Th.sTh{idx})
  