function varargout=configure(varargin)
% FUNCTION fc_simesh.configure()
%   Configures the toolbox/package by setting <fc-oogmsh> and <HyperMesh> toolbox directory.
%   Theses informations will be stored in ... file.
%
% <COPYRIGHT>
  [conffile,isFileExists]=fc_simesh.getLocalConfFile();
  if isFileExists
    run(conffile);
  else
    fullname=mfilename('fullpath');
    I=strfind(fullname,filesep);
    Path=fullname(1:(I(end-1)-1));
    oogmsh_dir='';    % empty if pkg or toolbox in path
    hypermesh_dir=''; % empty if pkg or toolbox in path
    siplt_dir='';
  end
  p = inputParser;
  p.addParamValue('oogmsh_dir'   ,oogmsh_dir,@ischar);
  p.addParamValue('hypermesh_dir',hypermesh_dir,@ischar);
  p.addParamValue('siplt_dir',siplt_dir,@ischar);
  p.addParamValue('verbose', 1, @(x) ismember(x,0:2) ); % level of verbosity 
  p.addParamValue('graphics',true,@islogical);
  %p.addParamValue('force',false,@islogical); 
  p.parse(varargin{:});
  R=p.Results;verbose=R.verbose;
  
  oogmsh_dir=get_tbxpath('oogmsh','simesh',R.oogmsh_dir);
  hypermesh_dir=get_tbxpath('hypermesh','simesh',R.hypermesh_dir);
  siplt_dir='';
  if R.graphics
    siplt_dir=get_tbxpath('siplt','simesh',R.siplt_dir,'stop',false);
  end
  
  if isempty(siplt_dir)
    vprintf(verbose,1,'[fc-simesh] no graphics package installed\n')
  else
    if ~isdir(siplt_dir), error('[fc-simesh::configure] Not a directory :\n''siplt_dir''=%s\n', siplt_dir); end
  end
  
  vprintf(verbose,2,'[fc-simesh] Writing in %s\n',conffile);
  fid=fopen(conffile,'w');
  if (fid==0), error('[fc-simesh::configure] Unable to open file :\n   -> %s\n',conffile);end
  fprintf(fid,'%% Automaticaly generated with fc_simesh.configure()\n');
  fprintf(fid,'oogmsh_dir=''%s'';\n',oogmsh_dir);
  fprintf(fid,'hypermesh_dir=''%s'';\n',hypermesh_dir);
  fprintf(fid,'siplt_dir=''%s'';\n',siplt_dir);
  fclose(fid);
  vprintf(verbose,2,'[fc-simesh] configured with\n');
  vprintf(verbose,2,'   -> oogmsh_dir    =''%s'';\n',oogmsh_dir);
  vprintf(verbose,2,'   -> hypermesh_dir =''%s'';\n',hypermesh_dir);
  vprintf(verbose,2,'   -> siplt_dir     =''%s'';\n',siplt_dir);
  vprintf(verbose,2,'[fc-simesh] done\n');
  if nargout==1,varargout{1}=conffile;end
  rehash % 
end

%
% DO NOT MODIFY THIS FUNCTION: IT IS AUTOMATICALLY ADDED
%
function tbxpath=get_tbxpath(tbxname,tbxfrom,givenpath,varargin) % tbxname is the toolbox to 'include' in the toolbox <tbxfrom>
  p = inputParser;
  p.addParamValue('stop'   ,true,@islogical);
  p.addParamValue('verbose', 1, @(x) ismember(x,0:2) ); % level of verbosity 
  p.parse(varargin{:});
  stop=p.Results.stop;verbose=p.Results.verbose;
  tbxpath='';
  if ~isempty(givenpath) 
    if ~isdir(givenpath) 
      vprintf(verbose,2,'[fc-%s] The given path does not exists:\n   -> %s\n',tbxfrom,tbxname,givenpath)
      vprintf(verbose,2,'[fc-%s] Use fc_%s.configure(''fc_%s_dir'',<DIR>) to correct this issue\n\n',tbxfrom,tbxfrom,tbxname)
      if stop
        error(sprintf('fc-%s::configure',tbxfrom))
      else
        warning(sprintf('fc-%s::configure',tbxfrom))
      end
    end
    tbxpath=givenpath;
    addpath(tbxpath);rehash path;
    failed=false;
    try % check if the toolbox can be found
      eval(sprintf('fc_%s.version();',tbxname))
    catch
      vprintf(verbose,2,'[fc-%s] Unable to load the fc-%s toolbox/package in given path:\n  %s\n',tbxfrom,tbxname,tbxpath)
      if stop
        error(sprintf('fc-%s::configure',tbxfrom),'step 1')
%        else
%          warning(sprintf('fc-%s::configure',tbxfrom),'step 1')
      end
      failed=true;
    end
    rmpath(tbxpath);rehash path;
    if ~failed, return;end
  end
  failed=false;
  try % check if the toolbox is in current Matlab path
    eval(sprintf('fc_%s.version();',tbxname))
  catch
    vprintf(verbose,2,'[fc-%s] Unable to load the fc-%s toolbox/package in current path\n',tbxfrom,tbxname)
    failed=true;
  end
  if ~failed, return;end
  failed=false;
  fullname=mfilename('fullpath');
  I=strfind(fullname,filesep);
  Path=fullname(1:(I(end-2)-1));
  
  lstdir=dir(Path); % try to guess directory. I don't use dir command due to trouble with octave
  C=arrayfun(@(x) x.name,lstdir, 'UniformOutput', false);
  I=strfind(C,['fc-',tbxname]);
  i=find(cellfun(@(x) ~isempty(x),I)==1);
  if ~isempty(i)
    k=1;
    while k<=length(i)
      tbxpath=[Path,filesep,C{i(k)}];
      addpath(tbxpath);rehash path;
      try % check if the toolbox is in new current Matlab path
        eval(sprintf('fc_%s.version();',tbxname))
      catch
        failed=true;
        vprintf(verbose,2,'[fc-%s] Unable to load the fc-%s toolbox/package in guess path\n  %s\n',tbxfrom,tbxname,tbxpath)
        vprintf(verbose,2,'[fc-%s] Use fc_%s.configure(''fc_%s_dir'',<DIR>) to correct this issue\n\n',tbxfrom,tbxfrom,tbxname)
        if stop
          error(sprintf('fc-%s::configure',tbxfrom),'step 2')
%          else
%            warning(sprintf('fc-%s::configure',tbxfrom),'step 2')
        end
      end
      rmpath(tbxpath);rehash path;
      if ~failed
        vprintf(verbose,2,'[fc-%s] Loading the fc-%s toolbox/package in guess path\n  %s\n',tbxfrom,tbxname,tbxpath)
        return;
      end
      k=k+1;
    end
  else
    vprintf(verbose,2,'[fc-%s] Guess path does not exists:\n   -> %s\n',tbxfrom,tbxname,tbxpath)
    vprintf(verbose,2,'[fc-%s] Use fc_%s.configure(''fc_%s_dir'',<DIR>) to correct this issue\n\n',tbxfrom,tbxfrom,tbxname);
    if stop
      error(sprintf('fc-%s::configure',tbxfrom),'step 3')
%      else
%        warning(sprintf('fc-%s::configure',tbxfrom),'step 3')
    end
    failed=true;
  end
  if failed
      tbxpath='';
  else
    vprintf(verbose,2,'[fc-%s] fc-%s toolbox/package found in path:\n   -> %s\n',tbxfrom,tbxname,tbxpath)
  end
end

function vprintf(verbose,level,varargin)
  if verbose>=level, fprintf(varargin{:});end
end

