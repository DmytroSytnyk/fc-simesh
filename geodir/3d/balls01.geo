Include "options01_data.geo";
Include "shape_functions.geo";
// Include "partitions.geo";
Vstore[] = {}; // array of Volume labels
Centerstore[] = {};

h=1/(N);
cx=-0.4;cy=0;cz=0;r=0.2;PhysLab=10;isPhysical=1;CenterLab=-1;SurfVol=1;
Call CreateBall;
cx=+0.4;cy=0;cz=0;r=0.2;PhysLab=11;isPhysical=1;CenterLab=-1;SurfVol=1;
Call CreateBall;
cx=0;cy=-0.4;cz=0;r=0.2;PhysLab=12;isPhysical=1;CenterLab=-1;SurfVol=1;
Call CreateBall;
cx=0;cy=+0.4;cz=0;r=0.2;PhysLab=13;isPhysical=1;CenterLab=-1;SurfVol=1;
Call CreateBall;
h=1/(5*N);
cx=0;cy=0;cz=0;r=1.0;PhysLab=1;isPhysical=1;CenterLab=-1;SurfVol=0;
Call CreateBall;

// To make holes
Delete {
  Volume{Vstore[0]};
  Volume{Vstore[1]};
}

Volume(150) = {29, 59, 89, 119, 149};
Physical Volume(1) = {150};
