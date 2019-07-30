function fullfile=get_geo(dim,d,geofile)
  [PATHSTR,NAME,EXT] = fileparts(geofile);
  assert(strcmp(EXT,'.geo') || isempty(EXT), 'Extension must be .geo in %s',geofile)
  if ~isempty(PATHSTR)
    assert(fc_tools.sys.isfileexists(geofile),'Unable to open geofile %s',geofile)
    fullfile=geofile;
    return
  end
  D=fc_simesh.get_geodirs(dim,d);
  for i=1:length(D)
    file=[D{i},filesep,NAME,'.geo'];
    if fc_tools.sys.isfileexists(file)
      fullfile=file;
      return
    end
  end
  fullfile=[];
  return
end
