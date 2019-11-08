%% SLDV 检查
disp('T04: 操作开始。');
modelName = current.subsystemFileName;
detectDesignErrs(modelName,configParam);
disp('T04: 操作完成。');