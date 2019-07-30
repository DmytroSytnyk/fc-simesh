function vol=ComputeVolVec(d,q,me)
  % d-simplex in R^n (d<=n)
  if d==0, vol=1;return;end
  nme=size(me,2);
  n=size(q,1);assert(d<=n && size(me,1)==d+1,'d=%d, dim=%d, me : %d-by-%d',d,n,size(me,1),size(me,2));
  A=zeros(d,n,nme);
  for i=1:d 
    A(i,:,:)=q(:,me(i+1,:))-q(:,me(1,:));
  end
  H=zeros(nme,d,d);
  for i=1:d
    H(:,i,i)=sum(reshape(A(i,:,:).*A(i,:,:),n,nme),1);
    for j=i+1:d
      H(:,i,j)=sum(reshape(A(i,:,:).*A(j,:,:),n,nme),1);
      H(:,j,i)=H(:,i,j);
    end
  end
  vol=sqrt(fc_simesh.tools.detVec(H)')/factorial(d);
end 

