%% �ϲ���� TestHarness �ļ�
% ��¼��ǰ��·������
temp = pwd;
%% ѡ����Ҫ�ϲ��� harness ģ���ļ�
[testHarnessFileName,workdir] = uigetfile('*.slx','ѡ��Ҫ�ϲ��� TestHarness �ļ�','MultiSelect','on');
% 
if ~isempty(workdir)
    cd(workdir);
    % ʹ��now��Ϊģ������������
    slvnvmergeharness(['new_harness_model',num2str(now*10^10)],testHarnessFileName);
    % �ص�ԭ�ȵ�·��
    cd(temp);
end