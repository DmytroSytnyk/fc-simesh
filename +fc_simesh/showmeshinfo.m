function txt = showmeshinfo(trash,event)
pos = get(event,'Position');
dts = get(event.Target,'Tag');
txt = {dts};
% F.C. : no tex/latex interpreter for PointDataTip class
%
%  txt = {dts,...
%         ['X: ',num2str(pos(1))],...
%             ['Y: ',num2str(pos(2))]};
%  set(0,'ShowHiddenHandles','on');                       % Show hidden handles
%  a=findall(gcf,'Type','text')
%  set(a,'Interpreter','latex');          
%  %  hText = findobj('Type','text','Tag','DataTipMarker');  % Find the data tip text
%    set(0,'ShowHiddenHandles','off');                      % Hide handles again
%  %  set(hText,'Interpreter','tex');                        % Change the interpreter