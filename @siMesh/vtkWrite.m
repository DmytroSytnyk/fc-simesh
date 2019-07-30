function varargout=vtkWrite(Th,FileName,varargin)
  p = inputParser;
  p.addParamValue('Values',{},@(x) iscell(x) || isnumeric(x) );
  p.addParamValue('Names',{},@(x) (iscell(x) || ischar(x)));
  p.addParamValue('idxsTh',[],@isnumeric);
  p.parse(varargin{:});
  U=p.Results.Values;
  names=p.Results.Names;
  idxsTh=p.Results.idxsTh;
  if isempty(idxsTh)
    idxsTh=Th.find(Th.d);
  else
    assert(isempty(setdiff(idxsTh,1:Th.nsTh)))
  end
  
  [pathstr,fname,fext] = fileparts(FileName);
  if exist([pathstr,filesep,fname])~=7,  mkdir([pathstr,filesep,fname]);end
  pvdfile=[pathstr,filesep,fname,'.pvd'];
  fid=fopen(pvdfile,'w');
  fprintf(fid,'<?xml version="1.0"?>\n');
  fprintf(fid,'<VTKFile type="Collection" version="1.0" byte_order="LittleEndian" header_type="UInt64">\n');
  fprintf(fid,'\t<Collection>\n');
  vtufile=[pathstr,filesep,fname,filesep,fname];
  svtufile=[fname,filesep,fname];
  idxfile=0;
  for i=[idxsTh]
    fullvtufile=sprintf('%s_%d.vtu',vtufile,idxfile);
    smallvtufile=sprintf('%s_%d.vtu',svtufile,idxfile);
    Th.sTh{i}.vtuWrite(fullvtufile,varargin{:});
    fprintf(fid,'\t\t<DataSet part="0"  file="%s"/>\n',smallvtufile);
    idxfile=idxfile+1;
  end
  
  fprintf(fid,'\t</Collection>\n');
  fprintf(fid,'</VTKFile>');
  fclose(fid);
  fprintf(' Paraview file %s created\n',pvdfile);
  if nargout==1, varargout{1}=pvdfile;end
end