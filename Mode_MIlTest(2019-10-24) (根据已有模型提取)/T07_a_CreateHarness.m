%% ��ʼ��Ԫ����
temp = pwd;
%% ��ȡ��ǰ��ģ��

currentSystem = bdroot; % ϵͳģ����
%% �û�ѡ��Ҫģ��
% systemMdName,fullsystemMdName
answer = questdlg(['ѡ��ǰģ�� ',currentSystem,' ��� Y ȷ������� N ����ѡ��ģ�͡�'], ...
	'ѡ�� slx ģ�����ڲ�����ȡ', ...
	'Y','N','Cancle','Y');
switch answer
    case 'Y'
        currentFullPathName = which(currentSystem);
        [path,~,~] = fileparts(currentFullPathName);
        disp(['T02_b���û�ѡ���ļ�',currentFullPathName]);
    case 'N'
        % ��ȡ
        [currentSystem,path] = uigetfile('*.slx','ѡ��ģ��');
        if isequal(currentSystem,0)
           disp('T02_b���û�ȡ��ѡ��');
           return;
        end
        [~,currentSystem,~] = fileparts(currentSystem);% ȥ����׺��
        currentFullPathName = fullfile(path,currentSystem);
        disp(['T02_b���û�ѡ���ļ��� ', currentFullPathName]);
    case 'Cancle'
        disp('T02_b���û�ȡ��ѡ��ģ�͡�')
        return;
end
systemMdName = currentSystem; % ������׺��
systemMdPathName = currentFullPathName; % ����׺��
workdir = path;
%%
cd(workdir);
%% ��ȡģ���ļ�
current.subsystemFileName = systemMdName;
%% 
h = msgbox('��������ѡ��������� Excel �ļ�');
uiwait(h);
%% �������� Excel �ļ�
[testCasefileName,workdir] = uigetfile('*.xlsx','ѡ��Ҫд��� Excel �ļ�');
% ��ȡslx�ļ������� ��sys1_testObject��.slx
current.testCasefileName = fullfile(workdir,testCasefileName);
%%
[status,sheets,~] = xlsfinfo(current.testCasefileName);
disp('��ǰ Excel ���� sheet ���ƣ�');
disp(sheets')
%% ���棺�û������������ģ�͵Ļ�����Ϣ
% ��Ҫ������������� Simulink ģ��
prompt = {'������ϵͳ��','�������� Excel ���ƣ�','�������� sheet ���ƣ������ж���ÿո�ֿ���all��ʾȫ������'};
dlg_title = '��ȷ��ģ������������';
num_lines = 1;
defaultans = {current.subsystemFileName,current.testCasefileName,sheets{1}};

answer = inputdlg(prompt,dlg_title,[1,80;],defaultans);
waitfor(answer)
%%
if isempty(answer)
    disp('T07 :�û�ȡ�����β�����');
    return
end
    %%
    disp('T07_a: ������ʼ��');
    %% ��ȡ������Ϣ
    testComponent = answer{1};
    excelFilePath = answer{2};
    testDatasheetInputs = strtrim(answer{3}); % ��һ�пո�����    
    %%
    testDatasheets = strsplit(testDatasheetInputs,' '); 
    testDatasheets=strrep(testDatasheets,'''',''); % ����Ǵ������п��������������'��
    if strcmp(testDatasheets,'All') | strcmp(testDatasheets,'all')
        testDatasheets = sheets;
    end
    %% 2. ���� TestHarness
for testCaseIndex = 1:length(testDatasheets)
    testDatasheet = testDatasheets{testCaseIndex};
    testCaseName = testDatasheet;
    % �������е� test Case
    TestCase = GetExcelSignal(excelFilePath,testDatasheet,configParam);
    TestCase.Name = testCaseName;
    % ���һ����ȡ�����Ĳ�������
    [status,msg] = checkTestCase(TestCase);
   if (status ==0)
    % ���� TestHarness
    [modelHarnessPath,modelParamPath] = CreateTestHarness(testComponent,TestCase); 
   end
end
%%
 disp('T07_a: ������ɡ�');
 cd(temp);