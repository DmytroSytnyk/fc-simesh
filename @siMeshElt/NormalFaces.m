function Normal=NormalFaces(this)
  % Normal (d+1)-by-d-by-nme 3D array
  %   
  d=this.d;
  [IndLocFaces,IndOpositePt]=getIndLocFaces(d);
  Normal=zeros(d+1,this.dim,this.nme);
  %this
  for i=1:d+1
    %A=-squeeze(this.gradBaCo(:,IndOpositePt(i),:));
    A=-squeeze(this.gradBaCo(:,i,:));
    A=permute(A,[2,3,1]);
    %whos
    Normal(i,:,:)=A; % direction normal exterieur non normalisee au i-eme (d-1)-simplex dans le d-simplex
    N2=sqrt(sum(squeeze(Normal(i,:,:)).^2,1));
    for j=1:this.dim
      Normal(i,j,:)=squeeze(Normal(i,j,:))./N2';
    end
  end
end