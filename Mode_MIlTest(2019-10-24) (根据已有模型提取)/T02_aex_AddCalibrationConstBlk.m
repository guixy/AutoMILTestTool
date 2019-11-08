%%
% 打开需要替换模块的目标待测单元slx文件
% 运行本脚本
%
% 自动把端口名包含'_Co'的In模块全部换成 Constant 模块；
% 自动把端口名包含'_Co'的Out模块全部换成 Terminate 模块；
%
% Constant的模块的变量名取自原In模块名
%  
% clear all 
%%
% busblk = gcb; 
mdl = bdroot;  
disp(['替换模型 ',mdl,' 的所有_Co标定模块开始 ...']);
%% 获取待替换的模块名列表
% find_system(mdl,'SearchDepth',0,'BlockType','Outport')
oldblks = find_system(mdl,'SearchDepth',1,'regexp','on','blocktype','port');
oldblkHd = [];%每次运行之前都要清空，防止历史信息影响
for blkIndex = 1:length(oldblks)
     oldblkHd(blkIndex) = get_param(oldblks{blkIndex},'Handle');
end
%% oldblkHd

%% 替换模块为Constant模块并设置参数
for hdIndex = 1:length(oldblkHd)
        % 替换模块
        thisblkHd = oldblkHd(hdIndex);
        %hdIndex
        thisblkName = get_param(thisblkHd,'Name');
        blkParent = get_param(thisblkHd,'Parent');
        if strcmp(thisblkName(end-2:end),'_Co')
            blkType = get_param(thisblkHd,'BlockType');
            if strcmp(blkType,'Inport')
                repNames = replace_block(mdl,'Name',thisblkName,'Parent',blkParent,'Constant','noprompt');
                % 设置属性 
                set_param(repNames{1},'Value',thisblkName);
                % 
                modifyBlockSize(repNames{1});
            else
                repNames = replace_block(mdl,'Name',thisblkName,'Parent',blkParent,'Terminator','noprompt');   
            end
            disp(['已替换模块 ',thisblkName,' ...']);
        end   
end 
disp(['替换结束。']);