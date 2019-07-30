Function CreateBall
  // Center Points of ball (cx,cy,cz) with radius r 
  // PhysLab is the physical label of the boundary
  // CenterLab 
  // h
  If( CenterLab < 0 )
    PFC = newp; Point(PFC) = {cx, cy, cz, h};
    Centerstore[]={Centerstore[],PFC};
  Else
    PFC = CenterLab;
  EndIf
  PF1 = newp;Point(PF1) = {cx+r, cy, cz, h};
  PF2 = newp;Point(PF2) = {cx,cy+r, cz, h};
  PF3 = newp;Point(PF3) = {cx,cy, cz+r, h};
  PF4 = newp;Point(PF4) = {cx-r, cy,cz, h};
  PF5 = newp;Point(PF5) = {cx,cy-r,cz, h};
  PF6 = newp;Point(PF6) = {cx,cy,cz-r, h};
  PC1 = newreg;Circle(PC1) = {PF1, PFC, PF2};
  PC2 = newreg;Circle(PC2) = {PF2, PFC, PF4};
  PC3 = newreg;Circle(PC3) = {PF4, PFC, PF5};
  PC4 = newreg;Circle(PC4) = {PF5, PFC, PF1};
  PC5 = newreg;Circle(PC5) = {PF1, PFC, PF6};
  PC6 = newreg;Circle(PC6) = {PF6, PFC, PF4};
  PC7 = newreg;Circle(PC7) = {PF4, PFC, PF3};
  PC8 = newreg;Circle(PC8) = {PF3, PFC, PF1};
  PC9 = newreg;Circle(PC9) = {PF5, PFC, PF6};
  PC10 = newreg;Circle(PC10) = {PF6, PFC, PF2};
  PC11 = newreg;Circle(PC11) = {PF2, PFC, PF3};
  PC12 = newreg;Circle(PC12) = {PF3, PFC, PF5};
  
  LL1=newreg;Line Loop(LL1) = {PC1,PC11,PC8};
  LL2=newreg;Line Loop(LL2) = {PC2,PC7,-PC11};
  LL3=newreg;Line Loop(LL3) =  {PC3,-PC12,-PC7};
  LL4=newreg;Line Loop(LL4) = {PC4,-PC8,PC12};
  LL5=newreg;Line Loop(LL5) =  {PC5,PC10,-PC1};
  LL6=newreg;Line Loop(LL6) = {-PC2,-PC10,PC6};
  LL7=newreg;Line Loop(LL7) = {-PC3,-PC6,-PC9};
  LL8=newreg;Line Loop(LL8) = {-PC4,PC9,-PC5};
  
  RS1=newreg;Ruled Surface(RS1) = {LL1};
  RS2=newreg;Ruled Surface(RS2) = {LL2};
  RS3=newreg;Ruled Surface(RS3) = {LL3};
  RS4=newreg;Ruled Surface(RS4) = {LL4};
  RS5=newreg;Ruled Surface(RS5) = {LL5};
  RS6=newreg;Ruled Surface(RS6) = {LL6};
  RS7=newreg;Ruled Surface(RS7) = {LL7};
  RS8=newreg;Ruled Surface(RS8) = {LL8};
  Physical Surface(PhysLab) = {RS1,RS2,RS3,RS4,RS5,RS6,RS7,RS8};
  
  SL1=newreg;Surface Loop (SL1) = {RS1,RS2,RS3,RS4,RS5,RS6,RS7,RS8};
  If( SurfVol == 1 )
    V1=newreg;Volume(V1) = {SL1};
    Physical Volume(PhysLab) = {V1};
    Vstore[]={Vstore[],V1};
  EndIf
Return
