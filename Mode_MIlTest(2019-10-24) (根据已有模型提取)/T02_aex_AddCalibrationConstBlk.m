%%
% ����Ҫ�滻ģ���Ŀ����ⵥԪslx�ļ�
% ���б��ű�
%
% �Զ��Ѷ˿�������'_Co'��Inģ��ȫ������ Constant ģ�飻
% �Զ��Ѷ˿�������'_Co'��Outģ��ȫ������ Terminate ģ�飻
%
% Constant��ģ��ı�����ȡ��ԭInģ����
%  
% clear all 
%%
% busblk = gcb; 
mdl = bdroot;  
disp(['�滻ģ�� ',mdl,' ������_Co�궨ģ�鿪ʼ ...']);
%% ��ȡ���滻��ģ�����б�
% find_system(mdl,'SearchDepth',0,'BlockType','Outport')
oldblks = find_system(mdl,'SearchDepth',1,'regexp','on','blocktype','port');
oldblkHd = [];%ÿ������֮ǰ��Ҫ��գ���ֹ��ʷ��ϢӰ��
for blkIndex = 1:length(oldblks)
     oldblkHd(blkIndex) = get_param(oldblks{blkIndex},'Handle');
end
%% oldblkHd

%% �滻ģ��ΪConstantģ�鲢���ò���
for hdIndex = 1:length(oldblkHd)
        % �滻ģ��
        thisblkHd = oldblkHd(hdIndex);
        %hdIndex
        thisblkName = get_param(thisblkHd,'Name');
        blkParent = get_param(thisblkHd,'Parent');
        if strcmp(thisblkName(end-2:end),'_Co')
            blkType = get_param(thisblkHd,'BlockType');
            if strcmp(blkType,'Inport')
                repNames = replace_block(mdl,'Name',thisblkName,'Parent',blkParent,'Constant','noprompt');
                % �������� 
                set_param(repNames{1},'Value',thisblkName);
                % 
                modifyBlockSize(repNames{1});
            else
                repNames = replace_block(mdl,'Name',thisblkName,'Parent',blkParent,'Terminator','noprompt');   
            end
            disp(['���滻ģ�� ',thisblkName,' ...']);
        end   
end 
disp(['�滻������']);