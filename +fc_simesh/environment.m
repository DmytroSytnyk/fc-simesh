function env=environment(varargin)
% FUNCTION env=fc_simesh.environment()
%   Retrieves the toolbox/package environment directories.
%
% <COPYRIGHT>
  [conffile,isFileExists]=fc_simesh.getLocalConfFile();
  if ~isFileExists
    fprintf('[fc-simesh] Trying to use default parameters!\n  -> Using fc_simesh.configure to configure.\n')
    fc_simesh.configure();
  end
  run(conffile);
  env.oogmsh_dir=oogmsh_dir; % fc-oogmsh toolbox path
  env.hypermesh_dir=hypermesh_dir; % fc-hypermesh toolbox path
  env.siplt_dir=siplt_dir; % fc-siplt toolbox path (if empty no graphics!)
  fullname=mfilename('fullpath');
  I=strfind(fullname,filesep);
  Path=fullname(1:(I(end-1)-1));
  env.Path=Path; % current toolbox path
end
