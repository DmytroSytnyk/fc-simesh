function self = readMedit(self,cFileName,dim,d)
  %if isempty(d),  d=[dim:-1:(dim-1)];end
  self.dim=dim;
  self.d=max(d);
  [fid,message]=fopen(cFileName,'r');
  if ( fid == -1 ), error([message,' : ',cFileName]); end
  % mesh keyword list
  keywords={'Vertices','Edges','Triangles','Tetrahedra','EdgesP2','TrianglesP2'};
  keysimplices=[0:3,1,2]; % simplex dimension of keywords 
  readingFile =true; % true if inside the file
  while ( readingFile )
      text = fgetl ( fid );
      if ( text == -1 )
          readingFile=false;
      else
          [iskeyw,ik]=ismember(strtok(text),keywords);
          if iskeyw
            dd=keysimplices(ik);
            [nme,me,mel]=read_mesh_elements(fid,dd,1);
            if ik==1,q=me(1:dim,:);self.nq=nme;
            else % Hyp. Vertices always reads firstly
              if ismember(dd,d) && (ik<=4) 
                self=AddooMeshElts(self,dd,q,nme,me,mel);
              end
            end
          end
      end
  end
  if self.nsTh==0, error('  Trouble in reading mesh file %s\n    Really a medit file?\n',cFileName);end
  fclose(fid);        
end 