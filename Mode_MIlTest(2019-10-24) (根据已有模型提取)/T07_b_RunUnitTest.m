%% ��ʼ��Ԫ����
temp = pwd;
%% ��ȡ��ǰ��ģ��

currentSystem = bdroot; % ϵͳģ����
%% �û�ѡ��Ҫģ��
% systemMdName,fullsystemMdName
answer = questdlg(['ѡ�����е�ǰ TestHarness �ļ��� ',currentSystem,' ��� Y ȷ������� N ����ѡ��ģ�͡�'], ...
	'ѡ�� slx ģ�����ڲ�����ȡ', ...
	'Y','N','Cancle','Y');
switch answer
    case 'Y'
        currentFullPathName = which(currentSystem);
        [path,~,~] = fileparts(currentFullPathName);
        disp(['T07_b���û�ѡ���ļ�',currentFullPathName]);
    case 'N'
        % ��ȡ
        [currentSystem,path] = uigetfile('*.slx','ѡ��ģ��');
        if isequal(currentSystem,0)
           disp('T07_b���û�ȡ��ѡ��');
           return;
        end
        [~,currentSystem,~] = fileparts(currentSystem);% ȥ����׺��
        currentFullPathName = fullfile(path,currentSystem);
        disp(['T07_b���û�ѡ���ļ��� ', currentFullPathName]);
    case 'Cancle'
        disp('T07_b���û�ȡ��ѡ��ģ�͡�')
        return;
end
systemMdName = currentSystem; % ������׺��
systemMdPathName = currentFullPathName; % ����׺��
workdir = path;
%%
cd(workdir);
%% ��ȡģ���ļ�
current.harnessMdName = systemMdName;
%% ���棺�û������������ģ�͵Ļ�����Ϣ
% ��Ҫ������������� Simulink ģ��
prompt = {'Test Harnesss ģ�ͣ�','�Ƿ���д������������� Excel Y/N','�Ƿ񱨸����� Excel Y/N','�Ƿ����ɸ��Ƕ���ϢY/N','�Ƿ���ʾ Simulink Data Inspector(Y/N)'};
dlg_title = '��ȷ��ģ������������';
num_lines = 1;
defaultans = {current.harnessMdName,'Y','Y','Y','N'};

answer = inputdlg(prompt,dlg_title,[1,80;],defaultans);
waitfor(answer)
%%
if isempty(answer)
    disp('T07_b: �û�ȡ�����β�����');
    return
end
%%
disp('T07_b: ������ʼ��');
%% ��ȡ������Ϣ
testHarnessName = strtrim(answer{1});
fillResult = strtrim(answer{2});
reportResult = strtrim(answer{3});
needCoverage = strtrim(answer{4});
showInspector = strtrim(answer{5});
%% ���� Excel �ļ������ļ���
if strcmp(reportResult,'Y')
    reportdir = uigetdir(pwd,'ѡ��㱨�� Excel �ļ�����Ŀ¼');
    % ��ȡslx�ļ������� ��sys1_testObject��.slx
    reportFileName{1} = fullfile(reportdir,configParam.reportFileName{1});
    reportFileName{2} = fullfile(reportdir,configParam.reportFileName{2});
end
%% �������� Excel �ļ���
if strcmp(fillResult,'Y')
    [testCaseFileName,path] = uigetfile('.xlsx','ѡ������������ڵ� Excel �ļ�');
    % ��ȡslx�ļ������� ��sys1_testObject��.slx
    testCaseFilePathName = fullfile(path,testCaseFileName);
end

%% ��ʼ����
if strcmp(showInspector,'Y')
    Simulink.sdi.clear;
end
%% 2. �Զ����ԣ�
%Runmode = 1; %���е�ǰ����Ĳ�����������ͳ�Ƹ��Ƕȣ�
%Runmode = 2; %�������в�����������ͳ�Ƹ��Ƕȣ�
%Runmode = 3; %���е�ǰ����Ĳ���������ͳ�Ƹ��Ƕȣ�
%Runmode = 4; %���е�ǰ����Ĳ���������ͳ�Ƹ��Ƕȣ�
if strcmp(needCoverage,'Y')
    Runmode = 4;
else
    Runmode = 2;
end
testOut = RunTestCase(testHarnessName,Runmode) ;
%% �жϲ�������
for testIndex = 1:length(testOut)
    
        currentTestResult = testOut{testIndex};
        currentTestCaseName = currentTestResult.Name;
        testDatasheet = currentTestCaseName;
        testComponent = currentTestCaseName;
        
        load([currentTestCaseName,'.mat'])
        %% 3. �жϽ����
        % �Զ���
        TestCase = EvaluateSimOut(currentTestResult,TestCase);
        %% 4. ���½��
        if strcmp(fillResult,'Y')
            WriteResult2Excel(testCaseFilePathName,testDatasheet,TestCase);
        end
        %% ��ʾ�� SDI
        if strcmp(showInspector,'Y')
            ShowTestCaseInSDI(TestCase,'hold');
        end
       %% ������
        if strcmp(reportResult,'Y')
            ReportResult(reportFileName,testComponent,TestCase.Name,TestCase.Result);
        end
        % error([testCaseName,'�����������ݼ�������⡣���������Լ� checkTestCase.m �ļ�']);
%%
end
 disp('T07_b: ������ɡ�');
% cd(temp);