%% 合并多个 TestHarness 文件
% 记录当前的路径备用
temp = pwd;
%% 选择需要合并的 harness 模型文件
[testHarnessFileName,workdir] = uigetfile('*.slx','选择要合并的 TestHarness 文件','MultiSelect','on');
% 
if ~isempty(workdir)
    cd(workdir);
    % 使用now作为模型名避免重名
    slvnvmergeharness(['new_harness_model',num2str(now*10^10)],testHarnessFileName);
    % 回到原先的路径
    cd(temp);
end