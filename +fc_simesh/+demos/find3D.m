function find3D()
  fprintf('*************************\n')
  fprintf('Running find3D function\n')
  fprintf('*************************\n')
  fprintf('*** Building the mesh file\n')
  meshfile=gmsh.buildmesh3d('cylinder3dom',15);
  Th=siMesh(meshfile);
  fprintf('*** 1: print mesh\n')
  disp(Th)
  d=3;
  fprintf('*** 2: print labels of the %d-simplex elementary meshes\n',d)
  idx=Th.find(d);
  fprintf('d=%d, labels=%s\n',d,num2str(Th.sThlab(idx)))
  d=2;
  fprintf('*** 3: print labels of the %d-simplex elementary meshes\n',d)
  idx=Th.find(d);
  fprintf('d=%d, labels=%s\n',d,num2str(Th.sThlab(idx)))
  d=1;
  fprintf('*** 4: print labels of the %d-simplex elementary meshes\n',d)
  idx=Th.find(d);
  fprintf('d=%d, labels=%s\n',d,num2str(Th.sThlab(idx)))
  d=3;lab=10;
  fprintf('*** 5: print %d-simplex elementary meshes with label %d\n',d,lab)
  idx=Th.find(d,lab);
  fprintf('Th.sThlab(%d)=%d\n',idx,Th.sThlab(idx))
  fprintf('Th.sTh{%d} is the ',idx)
  disp(Th.sTh{idx})
  d=2;lab=112;
  fprintf('*** 6: print %d-simplex elementary meshes with label %d\n',d,lab)
  idx=Th.find(d,lab);
  fprintf('Th.sThlab(%d)=%d\n',idx,Th.sThlab(idx))
  fprintf('Th.sTh{%d} is the ',idx)
  disp(Th.sTh{idx})
  d=1;lab=120;
  fprintf('*** 7: print %d-simplex elementary meshes with label %d\n',d,lab)
  idx=Th.find(d,lab);
  fprintf('Th.sThlab(%d)=%d\n',idx,Th.sThlab(idx))
  fprintf('Th.sTh{%d} is the ',idx)
  disp(Th.sTh{idx})
  