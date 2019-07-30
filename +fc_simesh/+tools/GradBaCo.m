function GradBaCo=GradBaCo(d,q,me)
  % d-simplex in R^n (d<=n)
  % Faire une seule fonction avec ComputeVolVec(d,q,me)?
  nme=size(me,2);
  n=size(q,1);assert(d<=n && size(me,1)==d+1);
  At=zeros(d,n,nme);I=zeros(d,n,nme);J=zeros(d,n,nme);
  L=0:(nme-1);
  for i=1:d 
    At(i,:,:)=q(:,me(i+1,:))-q(:,me(1,:));
    I(i,:,:)=repmat(L*d+i,[n,1]);
    for j=1:n
      J(i,j,:)=L*n+j;
    end
  end
  spAt=sparse(I(:),J(:),At(:),d*nme,n*nme);
  spH=spAt*spAt';
  Grad=[-ones(d,1),eye(d)];
  b=repmat(Grad,nme,1);
  X=spH\b;
  GradBaCo=spAt'*X;
  GradBaCo=reshape(GradBaCo,[n,nme,d+1]); % dimension n-by-nme-by-(d+1)
  %GradBaCo=permute(GradBaCo,[1,3,2]); % dimension (d+1)-by-n-by-nme
  GradBaCo=permute(GradBaCo,[2,3,1]); % dimension nme-by-(d+1)-by-n
end 

