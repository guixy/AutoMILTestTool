%% 开始单元测试
temp = pwd;
%% 获取当前的模型

currentSystem = bdroot; % 系统模型名
%% 用户选择要模型
% systemMdName,fullsystemMdName
answer = questdlg(['选择运行当前 TestHarness 文件： ',currentSystem,' 点击 Y 确定，点击 N 另外选择模型。'], ...
	'选择 slx 模型用于参数提取', ...
	'Y','N','Cancle','Y');
switch answer
    case 'Y'
        currentFullPathName = which(currentSystem);
        [path,~,~] = fileparts(currentFullPathName);
        disp(['T07_b：用户选择文件',currentFullPathName]);
    case 'N'
        % 获取
        [currentSystem,path] = uigetfile('*.slx','选择模型');
        if isequal(currentSystem,0)
           disp('T07_b：用户取消选择');
           return;
        end
        [~,currentSystem,~] = fileparts(currentSystem);% 去掉后缀名
        currentFullPathName = fullfile(path,currentSystem);
        disp(['T07_b：用户选择文件： ', currentFullPathName]);
    case 'Cancle'
        disp('T07_b：用户取消选择模型。')
        return;
end
systemMdName = currentSystem; % 不带后缀名
systemMdPathName = currentFullPathName; % 带后缀名
workdir = path;
%%
cd(workdir);
%% 获取模型文件
current.harnessMdName = systemMdName;
%% 界面：用户输入测试用例模型的基本信息
% 需要构造测试用例的 Simulink 模型
prompt = {'Test Harnesss 模型：','是否填写测试用例结果到 Excel Y/N','是否报告结果到 Excel Y/N','是否生成覆盖度信息Y/N','是否显示 Simulink Data Inspector(Y/N)'};
dlg_title = '请确定模型能正常运行';
num_lines = 1;
defaultans = {current.harnessMdName,'Y','Y','Y','N'};

answer = inputdlg(prompt,dlg_title,[1,80;],defaultans);
waitfor(answer)
%%
if isempty(answer)
    disp('T07_b: 用户取消本次操作。');
    return
end
%%
disp('T07_b: 操作开始。');
%% 读取界面信息
testHarnessName = strtrim(answer{1});
fillResult = strtrim(answer{2});
reportResult = strtrim(answer{3});
needCoverage = strtrim(answer{4});
showInspector = strtrim(answer{5});
%% 报告 Excel 文件所在文件夹
if strcmp(reportResult,'Y')
    reportdir = uigetdir(pwd,'选择汇报的 Excel 文件所在目录');
    % 提取slx文件名，如 【sys1_testObject】.slx
    reportFileName{1} = fullfile(reportdir,configParam.reportFileName{1});
    reportFileName{2} = fullfile(reportdir,configParam.reportFileName{2});
end
%% 测试用例 Excel 文件名
if strcmp(fillResult,'Y')
    [testCaseFileName,path] = uigetfile('.xlsx','选择测试用例所在的 Excel 文件');
    % 提取slx文件名，如 【sys1_testObject】.slx
    testCaseFilePathName = fullfile(path,testCaseFileName);
end

%% 开始测试
if strcmp(showInspector,'Y')
    Simulink.sdi.clear;
end
%% 2. 自动测试；
%Runmode = 1; %运行当前激活的测试用例，不统计覆盖度；
%Runmode = 2; %运行所有测试用例，不统计覆盖度；
%Runmode = 3; %运行当前激活的测试用例，统计覆盖度；
%Runmode = 4; %运行当前激活的测试用例，统计覆盖度；
if strcmp(needCoverage,'Y')
    Runmode = 4;
else
    Runmode = 2;
end
testOut = RunTestCase(testHarnessName,Runmode) ;
%% 判断并报告结果
for testIndex = 1:length(testOut)
    
        currentTestResult = testOut{testIndex};
        currentTestCaseName = currentTestResult.Name;
        testDatasheet = currentTestCaseName;
        testComponent = currentTestCaseName;
        
        load([currentTestCaseName,'.mat'])
        %% 3. 判断结果；
        % 自定义
        TestCase = EvaluateSimOut(currentTestResult,TestCase);
        %% 4. 更新结果
        if strcmp(fillResult,'Y')
            WriteResult2Excel(testCaseFilePathName,testDatasheet,TestCase);
        end
        %% 显示到 SDI
        if strcmp(showInspector,'Y')
            ShowTestCaseInSDI(TestCase,'hold');
        end
       %% 报告结果
        if strcmp(reportResult,'Y')
            ReportResult(reportFileName,testComponent,TestCase.Name,TestCase.Result);
        end
        % error([testCaseName,'测试用例数据检查有问题。请检查数据以及 checkTestCase.m 文件']);
%%
end
 disp('T07_b: 操作完成。');
% cd(temp);