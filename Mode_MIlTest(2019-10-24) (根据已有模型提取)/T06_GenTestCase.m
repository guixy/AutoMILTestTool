%% �� Stateflow ģ�ͷ����������������
h = msgbox('��������ѡ�����޸ĺõ� Stateflow ģ�ͣ��������ɲ����������ݡ�');
uiwait(h);
%% ��ȡģ���ļ�
[TestCaseModel,workdir] = uigetfile('*.slx','ѡ�����޸ĺõ� Stateflow ģ��');
% ��ȡslx�ļ������� ��sys1_testObject��.slx
[~,current.TestCaseModel,~] = fileparts(TestCaseModel);
%% �������� Excel �ļ�
[testCasefileName,workdir] = uigetfile('*.xlsx','ѡ��Ҫд��� Excel �ļ�');
% ��ȡslx�ļ������� ��sys1_testObject��.slx
current.testCasefileName = fullfile(workdir,testCasefileName);
%%
[status,sheets,~] = xlsfinfo(current.testCasefileName);
%%
disp('��ǰ Excel �ڵ� sheet �б�')
disp(sheets);
prompt = {'Ҫ������һ�� sheet ( ��ǰ Excel �� sheet �����б�μ������ )'};
dlg_title = 'ѡ������� sheet ģ������';
num_lines = 1;
defaultans = {sheets{1}};
answer1 = inputdlg(prompt,dlg_title,[1,80;],defaultans);
waitfor(answer1);
if isempty(answer1)
    disp('T06���û�ȡ��ѡ��')
    return
end
%% �û������������ģ�͵Ļ�����Ϣ
% ��Ҫ������������� Simulink ģ��
prompt = {'�������� Stateflow ģ������','������������� Excel �ļ���','������������� sheet ���ƣ�'};
dlg_title = '��ȷ��������Ϣ';
num_lines = 1;
defaultans = {current.TestCaseModel,current.testCasefileName,answer1{1}};
answer = inputdlg(prompt,dlg_title,[1,80;],defaultans);
waitfor(answer)
if isempty(answer)
    disp('T06 :�û�ȡ�����β�����');
else
    %%
    disp('T06: ������ʼ��');
    testCaseModel = answer{1};%��NewTestCase.slx����������������ģ�ͣ�
    testCasefileName = answer{2};% fileName = '��Ԫ��֤���������Ͳ��Խ��.xlsx';
    newTestCaseName = answer{3};
    %% �����������
    TestCase = CreateTestCaseFromModel(testCaseModel);
    %% �Ѳ�������д��Excel
    WriteTest2Excel(testCasefileName,newTestCaseName,TestCase,2)
    %��Input������ģ�ͷ����������ź���������Input��
    %��Expected������ģ�ͷ����������ź��������� Expected��
    disp('T06: ������ɡ�');
end