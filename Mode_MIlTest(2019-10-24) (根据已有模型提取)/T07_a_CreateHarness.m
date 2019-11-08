%% 开始单元测试
temp = pwd;
%% 获取当前的模型

currentSystem = bdroot; % 系统模型名
%% 用户选择要模型
% systemMdName,fullsystemMdName
answer = questdlg(['选择当前模型 ',currentSystem,' 点击 Y 确定，点击 N 另外选择模型。'], ...
	'选择 slx 模型用于参数提取', ...
	'Y','N','Cancle','Y');
switch answer
    case 'Y'
        currentFullPathName = which(currentSystem);
        [path,~,~] = fileparts(currentFullPathName);
        disp(['T02_b：用户选择文件',currentFullPathName]);
    case 'N'
        % 获取
        [currentSystem,path] = uigetfile('*.slx','选择模型');
        if isequal(currentSystem,0)
           disp('T02_b：用户取消选择');
           return;
        end
        [~,currentSystem,~] = fileparts(currentSystem);% 去掉后缀名
        currentFullPathName = fullfile(path,currentSystem);
        disp(['T02_b：用户选择文件： ', currentFullPathName]);
    case 'Cancle'
        disp('T02_b：用户取消选择模型。')
        return;
end
systemMdName = currentSystem; % 不带后缀名
systemMdPathName = currentFullPathName; % 带后缀名
workdir = path;
%%
cd(workdir);
%% 获取模型文件
current.subsystemFileName = systemMdName;
%% 
h = msgbox('接下来请选择测试用例 Excel 文件');
uiwait(h);
%% 测试用例 Excel 文件
[testCasefileName,workdir] = uigetfile('*.xlsx','选择要写入的 Excel 文件');
% 提取slx文件名，如 【sys1_testObject】.slx
current.testCasefileName = fullfile(workdir,testCasefileName);
%%
[status,sheets,~] = xlsfinfo(current.testCasefileName);
disp('当前 Excel 存在 sheet 名称：');
disp(sheets')
%% 界面：用户输入测试用例模型的基本信息
% 需要构造测试用例的 Simulink 模型
prompt = {'待测子系统：','测试用例 Excel 名称：','测试用例 sheet 名称（可以有多个用空格分开，all表示全部）：'};
dlg_title = '请确定模型能正常运行';
num_lines = 1;
defaultans = {current.subsystemFileName,current.testCasefileName,sheets{1}};

answer = inputdlg(prompt,dlg_title,[1,80;],defaultans);
waitfor(answer)
%%
if isempty(answer)
    disp('T07 :用户取消本次操作。');
    return
end
    %%
    disp('T07_a: 操作开始。');
    %% 读取界面信息
    testComponent = answer{1};
    excelFilePath = answer{2};
    testDatasheetInputs = strtrim(answer{3}); % 万一有空格会出错    
    %%
    testDatasheets = strsplit(testDatasheetInputs,' '); 
    testDatasheets=strrep(testDatasheets,'''',''); % 如果是从命令行拷贝的输入则会有'号
    if strcmp(testDatasheets,'All') | strcmp(testDatasheets,'all')
        testDatasheets = sheets;
    end
    %% 2. 构造 TestHarness
for testCaseIndex = 1:length(testDatasheets)
    testDatasheet = testDatasheets{testCaseIndex};
    testCaseName = testDatasheet;
    % 读入已有的 test Case
    TestCase = GetExcelSignal(excelFilePath,testDatasheet,configParam);
    TestCase.Name = testCaseName;
    % 检查一下提取出来的测试用例
    [status,msg] = checkTestCase(TestCase);
   if (status ==0)
    % 构造 TestHarness
    [modelHarnessPath,modelParamPath] = CreateTestHarness(testComponent,TestCase); 
   end
end
%%
 disp('T07_a: 操作完成。');
 cd(temp);