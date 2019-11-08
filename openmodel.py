#-*-coding:utf-8-*-
import matlab.engine
import os
import shutil
import sys
class Mlab:
    #jobname='testall'
    #jenkinsdir='C:/Users/s981325/.jenkins/workspace/'
    #dir = jenkinsdir+jobname+'/Controller/'
    #dir=Mlab.jenkinsdir+Mlab.jobname+'/TestScript/'
    def __init__(self,model,modelfile,jobname,workspace):
        self.model=model
        self.modelfile=modelfile
        self.jobname=jobname
        self.workspace=workspace


    def platform(self):


        eng = matlab.engine.start_matlab("-desktop")
        self.WriteTempM()
        eng.temp(nargout=0)
        #eng.addpath(os.getcwd())
        eng.addpath(self.workspace)
        eng.addpath(self.workspace+r'\Confiuration')
        eng.addpath(self.workspace + r'\Confiuration\Enum')
        eng.cd(self.workspace)
        myDIC=eng.Simulink.data.dictionary.open(self.model+'_DataDictionary.sldd')
        dDataSectObj = eng.getSection(myDIC, 'Design Data')
        eng.exportToFile(dDataSectObj, 'myDictionaryDesignData.m',nargout=0)
        #eng.aqaq(nargout=0)
        eng.myDictionaryDesignData(nargout=0)

        #eng.uiopen(os.path.join(self.workspace,self.model),1,nargout=0)
        '''try:
            os.rename(os.path.join(self.workspace, self.model+'_DataDictionaryManagement.m'), os.path.join(self.workspace, 'runDIC.m'))
            eng.myDictionaryDesignData(nargout=0)
            os.rename(os.path.join(os.path.join(self.workspace, 'runDIC.m')),os.path.join(self.workspace, self.model + '_DataDictionaryManagement.m'))
        except:
            eng.runDIC(nargout=0)
            os.rename(os.path.join(os.path.join(self.workspace, 'runDIC.m')),os.path.join(self.workspace, self.model + '_DataDictionaryManagement.m'))'''
        #eng.open_system(os.path.join(self.workspace,self.model),'loadonly',nargout=0)
        eng.open_system(os.path.join(self.workspace, self.model), nargout=0)

        #eng.addpath(r'D:\工作\工作\脚本\matlab+python\Mode_MIlTest(2019-10-24) (根据已有模型提取)\Test_Model\SWC_SMG_DchaCtl\Confiuration')

        eng.cd('D:\工作\工作\脚本\matlab+python\Mode_MIlTest(2019-10-24) (根据已有模型提取)')
        eng.T01_Init(nargout=0)
        #这里的名字是自己选择的

        #eng.uiwait(a,nargout=0)
        #eng.T02_a_Extract(self.model,self.model+'/RE_'+self.model[4:]+'_10ms_sys/'+self.model[4:]+'_10ms',self.model[4:]+'_10ms',nargout=0)
        eng.T02_a_Extract(nargout=0)
        eng.T02_b_ExtractParam(nargout=0)
        eng.T03_StdCheck(nargout=0)
        eng.T04_SLDVCheck(nargout=0)

        #eng.SWC_SMG_DchaCtl_DataDictionaryManagement(nargout=0)
        #print (1)



        eng.quit()

    def OpenModel(self,eng,path):
        eng.ModelAdvisor.run(self.model, 'configuration', self.workspace + '/jenkins/standardCheck.mat')

    def WriteTempM(self):
        f=open('temp.m','w')
        txtt='global topMdName\nglobal subsystemPathName\nglobal subsystemName\n'
        f.write(txtt)
        txt="topMdName='"+self.model+"';"
        f.write(txt)
        f.write('\n')
        txt2="subsystemPathName='"+self.model+'/RE_'+self.model[4:]+'_10ms_sys/'+self.model[4:]+'_10ms'+"';"
        f.write(txt2)
        f.write('\n')
        txt3="subsystemName='"+self.model[4:]+'_10ms'+"';"
        f.write(txt3)
        f.write('\n')
        f.close()

a=Mlab('SWC_SMG_DchaCtl',1,1,r'D:\工作\工作\脚本\matlab+python\Mode_MIlTest(2019-10-24) (根据已有模型提取)\Test_Model\SWC_SMG_DchaCtl')
a.platform()