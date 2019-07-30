function init(varargin)
% FUNCTION fc_simesh.init()
%   Initializes the toolbox/package .
%
% <COPYRIGHT>
  p = inputParser;
  p.KeepUnmatched=true;
  p.addParamValue('verbose', 1, @(x) ismember(x,0:2) ); % level of verbosity 
  p.addParamValue('without',{},@iscell); % to avoid recursion
  p.parse(varargin{:});
  R=p.Results;verbose=R.verbose;
  if isOctave()
    warning('off','Octave:shadowed-function')
    more off
  end
  env=fc_simesh.environment();
  
  if isdir(env.hypermesh_dir), addpath(env.hypermesh_dir);rehash path;end
  try
    fc_hypermesh.init(varargin{:})
  catch ME
    fprintf('[fc-simesh] Unable to load the fc-hypermesh package/toolbox!\n')
    %fprintf('[fc-simesh] Use fc_simesh.configure(''hypermesh_dir'',<DIR>) to correct this issue\n\n');
    rethrow(ME)
  end
  if isdir(env.oogmsh_dir), addpath(env.oogmsh_dir);rehash path;end
  try
    fc_oogmsh.init(varargin{:})
  catch ME
    fprintf('[fc-simesh] Unable to load the fc-oogmsh package/toolbox!\n')
    %fprintf('[fc-simesh] Use fc_simesh.configure(''oogmsh_dir'',<DIR>) to correct this issue\n\n');
    rethrow(ME)
  end
  graphics=true;
  if isempty(env.siplt_dir)
    fprintf('[fc-simesh] No graphical package/toolbox installed!\n')
    graphics=false;
  else
    if isdir(env.siplt_dir), addpath(env.siplt_dir);rehash path;end
      if ~ismember('fc-siplt',R.without)
      try
        fc_siplt.init(varargin{:},'without',{'fc-simesh'})
      catch ME
        fprintf('[fc-simesh] Unable to load the fc-siplt package/toolbox!\n')
        rethrow(ME)
      end
    end
  end
  
  if verbose==2
    fprintf('[fc-simesh] Using fc-simesh package/toolbox [%s]:\n',fc_simesh.version());
    fprintf('  -> %20s %s\n','fc-tools',fc_tools.version());
    fprintf('  -> %20s %s\n','fc-hypermesh',fc_hypermesh.version());
    fprintf('  -> %20s %s\n','fc-oogmsh',fc_oogmsh.version());
    fprintf('  -> %20s %s\n','fc-mesh',fc_mesh.version());
    if graphics
      fprintf('  -> %20s %s\n','fc-graphics4mesh',fc_graphics4mesh.version());
      fprintf('  -> %20s %s\n','fc-siplt',fc_siplt.version());
    end
  end
end  

function bool=isOctave()
  log=ver;bool=strcmp(log(1).Name,'Octave');
end
