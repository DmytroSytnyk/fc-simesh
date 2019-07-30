function self=readtriangle(self, cFileName,dim)
% self=readtriangle(self,cFileName,dim)
% Reading a 2D triangle mesh
%
% To create a mesh triangle from triangle. At least, two files are
% needed .node, .ele. .poly is optional. Only for 2D meshes.
%
% .node file
%

  self.dim=dim;
    self.d=2;
  assert(self.d==2,'d=2 for a triangle mesh');

if(exist([cFileName,'.node'],'file'))
    fp=fopen([cFileName,'.node'],'r');
    n=fscanf(fp,'%d',4); %nq d coef ql
    self.nq=n(1);
    assert(n(2)==2);
    if isOctave()
        if(n(3)>0)
            cq=fscanf(fp,['%d%f%f',repmat('%f',[n(3),1]),'%d'],[4+n(3),n(1)]);
        else
            cq=fscanf(fp,'%d%f%f%d',[4,n(1)]);
        end
        q=cq([2 3],:);
        ql=cq(end,:);
    else
        if(n(3)>0)
            cq=textscan(fp,['%d%f%f',repmat('%f',[n(3),1]),'%d'],n(1));
        else
            cq=textscan(fp,'%d%f%f%d',n(1));
        end
        q=[cq{2}'; cq{3}'];
        ql=cq{end}';
    end
    fclose(fp);
else
    error('No file for nodes. Stop');
end

%
% .ele file
%
if(exist([cFileName,'.ele'],'file'))
    fp=fopen([cFileName,'.ele'],'r');
    n=fscanf(fp,'%d',3); %nme type coef
    nme=n(1);
    if isOctave()
        if(n(3)>0)
            cq=fscanf(fp,['%d%d%d%d',repmat('%f',[n(3),1])],[4+n(3),nme]);
        else
            cq=fscanf(fp,'%d%d%d%d',[4,nme]);
        end
        me=cq(2:4,:);
    else
        if(n(3)>0)
            cq=textscan(fp,['%d%d%d%d',repmat('%f',[n(3),1])],nme);
        else
            cq=textscan(fp,'%d%d%d%d',nme);
        end
        me=[cq{2}';cq{3}';cq{4}'];
    end
    fclose(fp);
else
    error('No file for elements. Stop');
end

%
% .poly file
%
if(exist([cFileName,'.poly'],'file'))
    fp=fopen([cFileName,'.poly'],'r');
    n=fscanf(fp,'%d',4); %0 d coef bel
    assert(n(2)==2);
    assert(n(1)==0);
    m=fscanf(fp,'%d',2); %nbe bel
    nbe=m(1);
    if isOctave()
        if(n(3)>0)
            cq=fscanf(fp,['%d%d%d',repmat('%f',[n(3),1]),'%d'],[n(3)+4,nbe]);
        else
            cq=fscanf(fp,'%d%d%d',[4,nbe]);
        end
        be=cq(2:3,:);
        bel=cq(end,:);
    else
        if(n(3)>0)
            cq=textscan(fp,['%d%d%d',repmat('%f',[n(3),1]),'%d'],nbe);
        else
            cq=textscan(fp,'%d%d%d%d',nbe);
        end
        be=[cq{2}';cq{3}'];
        bel=cq{end}';
    end
    fclose(fp);
else
    be=make_boundary(me,ql);
    nbe=size(be,2);
    bel=ones(1,nbe); % bel=1 - no .poly file
end
mel=zeros(nme,1); % 0 by default

self=AddooMeshElts(self,2,q,nme,me,mel);
self=AddooMeshElts(self,1,q,nbe,be,bel);
end

function [be,nbe]=make_boundary(me,qbel)
%
% qbel is used to identify boundary vertices.
% Each edge made of two boundary vertices is a boundary edge unless
% it belongs to two different mesh elements.
%
% To be improved (loop over nme)
%
nme=size(me,2);
be=zeros(2,3*nme); %preallocation
nbe=0;
for k=1:nme
    ql=qbel(me(:,k));
    if((ql(1)>0 && ql(2)>0)||(ql(1)>0 && ql(3)>0)||(ql(2)>0 && ql(3)>0))
        if(ql(1)==0)
            nbe=nbe+1;
            be(1,nbe)=me(2,k);be(2,nbe)=me(3,k);
        end
        if(ql(2)==0)
            nbe=nbe+1;
            be(1,nbe)=me(1,k);be(2,nbe)=me(3,k);
        end
        if(ql(3)==0)
            nbe=nbe+1;
            be(1,nbe)=me(1,k);be(2,nbe)=me(2,k);
        end
        if(prod(ql)~=0)
            nbe=nbe+1;
            be(1,nbe)=me(1,k);be(2,nbe)=me(2,k);
            nbe=nbe+1;
            be(1,nbe)=me(2,k);be(2,nbe)=me(3,k);
            nbe=nbe+1;
            be(1,nbe)=me(1,k);be(2,nbe)=me(3,k);
        end
    end
end
be=be(:,1:nbe);
bf=remove_duplicates(be');
be=bf';
end

function resu=remove_duplicates(be)
%remove duplicate lines in an array
c=sort(be,2);
[~,ia]=unique(c,'rows');
il=setdiff(1:size(c,1),ia);
resu=setdiff(c,c(il,:),'rows');
end