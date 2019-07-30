function varargout=alldemos(varargin)
  p = inputParser; 
  p.KeepUnmatched=true; 
  p.addParamValue('stop',false,@islogical);
%    p.addParamValue('save',false,@islogical);
%    p.addParamValue('dir','./figures',@ischar);
  p.parse(varargin{:});
  stop=p.Results.stop;
%    dir=p.Results.dir;
%    mkdir(dir);
%    SaveOptions={'format','png', 'dir',dir,'tag',true,'verbose',true};

  List={'feval2D01','feval3D01','feval3Ds01', ...
        'feval2D02','feval3D02','feval3Ds02', ...
        'feval2D03','feval3D03','feval3Ds03', ...
        'eval2D01','eval3D01','eval3Ds01', ...
        'eval2D02','eval3D02','eval3Ds02', ...
        'eval2D03','eval3D03','eval3Ds03', ...
        'find2D','find3D','find3Ds', ...
        'get_mesh2D','get_mesh3D','get_mesh3Ds'};
      
  nL=length(List);
  valid=ones(1,nL);
  for i=1:nL
    command=sprintf('fc_simesh.demos.%s()',List{i});
    fprintf('[fc-simesh] Running %s\n',command)
    try 
      eval(command)
    catch
      valid(i)=0;
      if stop
        error('[fc-simesh] Stop! running %s FAILED!\n',command)
      else
        warning('[fc-simesh] Running %s FAILED!\n',command)
        
      end
    end
    %fc_tools.graphics.DisplayFigures();
%      pause(2)
%      if p.Results.save
%        fc_tools.graphics.SaveAllFigsAsFiles(List{i},SaveOptions{:})
%      end
  end
  if nargout==1,varargout{1}=valid;end
end
