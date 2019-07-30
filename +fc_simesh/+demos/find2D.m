function find2D()
  fprintf('*************************\n')
  fprintf('Running find2D function\n')
  fprintf('*************************\n')
  fprintf('*** Building the mesh file\n')
  meshfile=fc_oogmsh.buildmesh2d('condenser11',50);
  fprintf('*** Creating siMesh object by reading the mesh file\n')
  Th=siMesh(meshfile);
  fprintf('*** Print siMesh object\n')
  disp(Th)
  fprintf('*** Print labels of the 2-simplex elementary meshes\n')
  idx=Th.find(2);
  fprintf('d=2, labels=[%s]\n',num2str(Th.sThlab(idx)))
  fprintf('*** Print labels of the 1-simplex elementary meshes\n')
  idx=Th.find(1);
  fprintf('d=1, labels=[%s]\n',num2str(Th.sThlab(idx)))
  d=2;lab=6;
  fprintf('*** Print %d-simplex elementary meshes with label %d\n',d,lab)
  idx=Th.find(d,lab);
  fprintf('Th.sThlab(%d)=%d\n',idx,Th.sThlab(idx))
  fprintf('Th.sTh{%d} is the ',idx)
  disp(Th.sTh{idx})
  d=1;lab=101;
  fprintf('*** Print %d-simplex elementary meshes with label %d\n',d,lab)
  idx=Th.find(d,lab);
  fprintf('Th.sThlab(%d)=%d\n',idx,Th.sThlab(idx))
  fprintf('Th.sTh{%d} is the ',idx)
  disp(Th.sTh{idx})