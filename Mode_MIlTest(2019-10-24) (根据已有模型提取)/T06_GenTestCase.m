%% 从 Stateflow 模型仿真结果构造测试用例
h = msgbox('接下来请选择已修改好的 Stateflow 模型，用于生成测试用例数据。');
uiwait(h);
%% 获取模型文件
[TestCaseModel,workdir] = uigetfile('*.slx','选择已修改好的 Stateflow 模型');
% 提取slx文件名，如 【sys1_testObject】.slx
[~,current.TestCaseModel,~] = fileparts(TestCaseModel);
%% 测试用例 Excel 文件
[testCasefileName,workdir] = uigetfile('*.xlsx','选择要写入的 Excel 文件');
% 提取slx文件名，如 【sys1_testObject】.slx
current.testCasefileName = fullfile(workdir,testCasefileName);
%%
[status,sheets,~] = xlsfinfo(current.testCasefileName);
%%
disp('当前 Excel 内的 sheet 列表：')
disp(sheets);
prompt = {'要填入哪一个 sheet ( 当前 Excel 的 sheet 名称列表参见命令窗口 )'};
dlg_title = '选择填入的 sheet 模板名称';
num_lines = 1;
defaultans = {sheets{1}};
answer1 = inputdlg(prompt,dlg_title,[1,80;],defaultans);
waitfor(answer1);
if isempty(answer1)
    disp('T06：用户取消选择。')
    return
end
%% 用户输入测试用例模型的基本信息
% 需要构造测试用例的 Simulink 模型
prompt = {'测试用例 Stateflow 模型名：','测试用例保存的 Excel 文件：','测试用例保存的 sheet 名称：'};
dlg_title = '请确认以下信息';
num_lines = 1;
defaultans = {current.TestCaseModel,current.testCasefileName,answer1{1}};
answer = inputdlg(prompt,dlg_title,[1,80;],defaultans);
waitfor(answer)
if isempty(answer)
    disp('T06 :用户取消本次操作。');
else
    %%
    disp('T06: 操作开始。');
    testCaseModel = answer{1};%【NewTestCase.slx】：测试用例构造模型；
    testCasefileName = answer{2};% fileName = '单元验证测试用例和测试结果.xlsx';
    newTestCaseName = answer{3};
    %% 构造测试用例
    TestCase = CreateTestCaseFromModel(testCaseModel);
    %% 把测试用例写入Excel
    WriteTest2Excel(testCasefileName,newTestCaseName,TestCase,2)
    %【Input】：将模型仿真结果按照信号名称填入Input；
    %【Expected】：将模型仿真结果按照信号名称填入 Expected；
    disp('T06: 操作完成。');
end