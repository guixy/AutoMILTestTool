#-*-coding:utf-8-*-
import matlab.engine
import os
import re
import time
class Mlab:
    #jobname='testall'
    #jenkinsdir='C:/Users/s981325/.jenkins/workspace/'
    #dir = jenkinsdir+jobname+'/Controller/'
    #dir=Mlab.jenkinsdir+Mlab.jobname+'/TestScript/'
    def __init__(self,model,workspace,eng,LibraryPath):
        self.model=model

        self.workspace=workspace
        self.eng = eng
        self.LibraryPath=LibraryPath
        self.eng.clear(nargout=0)


    def platform(self):


        self.eng.cd(os.getcwd())
        self.eng.addpath(self.workspace)
        self.eng.addpath(self.workspace + r'\Confiuration')
        self.eng.addpath(self.workspace + r'\Confiuration\Enum')
        self.eng.open_system(os.path.join(self.workspace, self.model), 'loadonly', nargout=0)
        a = self.eng.find_system(self.model, 'SearchDepth', 2)


        self.WriteTempM(a)
        time.sleep(3)
        self.eng.tempval(nargout=0)

        #eng.addpath(os.getcwd())

        self.eng.cd(self.workspace)
        myDIC=self.eng.Simulink.data.dictionary.open(self.model+'_DataDictionary.sldd')
        dDataSectObj = self.eng.getSection(myDIC, 'Design Data')

        self.eng.exportToFile(dDataSectObj, 'myDictionaryDesignData.m',nargout=0)
        #eng.aqaq(nargout=0)
        self.eng.myDictionaryDesignData(nargout=0)

        #eng.uiopen(os.path.join(self.workspace,self.model),1,nargout=0)
        '''try:
            os.rename(os.path.join(self.workspace, self.model+'_DataDictionaryManagement.m'), os.path.join(self.workspace, 'runDIC.m'))
            eng.myDictionaryDesignData(nargout=0)
            os.rename(os.path.join(os.path.join(self.workspace, 'runDIC.m')),os.path.join(self.workspace, self.model + '_DataDictionaryManagement.m'))
        except:
            eng.runDIC(nargout=0)
            os.rename(os.path.join(os.path.join(self.workspace, 'runDIC.m')),os.path.join(self.workspace, self.model + '_DataDictionaryManagement.m'))'''
        #eng.open_system(os.path.join(self.workspace,self.model),'loadonly',nargout=0)


        #eng.addpath(r'D:\工作\工作\脚本\matlab+python\Mode_MIlTest(2019-10-24) (根据已有模型提取)\Test_Model\SWC_SMG_DchaCtl\Confiuration')



        #这里的名字是自己选择的

        #eng.uiwait(a,nargout=0)

        #eng.T02_a_Extract(self.model,self.model+'/RE_'+self.model[4:]+'_10ms_sys/'+self.model[4:]+'_10ms',self.model[4:]+'_10ms',nargout=0)



        #eng.SWC_SMG_DchaCtl_DataDictionaryManagement(nargout=0)
        #print (1)



        #eng.quit()

    def WriteTempM(self,a):

        try:
            f = open('tempval.m', 'w')
            for i in a:
                if "RE_"+self.model[4:] in i and '_sys' in i:
                    b=re.split('/',i)
                    c=b[1]
                    #print(i+'/'+b[3:len(b)-5])
                    if len(b)==3:
                        if 'Subsystem' in i  or c[3:len(c)-5] in b[2]:
                            tem=i
                            tem2=b[2]
            txtt='global topMdName\nglobal subsystemPathName\nglobal subsystemName\n'
            f.write(txtt)
            txt="topMdName='"+self.model+"';"

            f.write(txt)
            f.write('\n')
            txt2="subsystemPathName='"+tem+"';"
            f.write(txt2)
            f.write('\n')
            txt3="subsystemName='"+tem2+"';"

            f.write(txt3)
            f.write('\n')
            f.close()
        except:
            f.close()
    def testa(self):
        eng = matlab.engine.start_matlab()
        self.WriteTempM()
        #eng.temp(nargout=0)
        # eng.addpath(os.getcwd())
        eng.addpath(self.workspace)
        eng.addpath(self.workspace + r'\Confiuration')
        eng.addpath(self.workspace + r'\Confiuration\Enum')
        eng.cd(self.workspace)
        eng.open_system( self.model, nargout=0)
        #print (eng.find_system('SWC_SMG_DchaCtl/RE_SMG_DchaCtl_10ms_sys','SearchDepth',1 ))
        a=eng.find_system(self.model,'SearchDepth',2 )


    def InitM(self):
        self.eng.cd(self.LibraryPath)
        print("开始运行T01_Init")
        self.eng.T01_Init(nargout=0)
        print("结束运行T01_Init")

        print("开始运行T02_a_Extract")
        self.eng.T02_a_Extract(nargout=0)
        print("结束运行T02_a_Extract")
        print("开始运行T02_b_ExtractParam")
        self.eng.T02_b_ExtractParam(nargout=0)
        print("结束运行T02_b_ExtractParam")
        self.eng.close_system(os.path.join(self.workspace, self.model),  nargout=0)
    def StaticCheck(self):
        print("开始运行T03_StdCheck")
        self.eng.T03_StdCheck(nargout=0)
        print("结束运行T03_StdCheck")
        print("开始运行T04_SLDVCheck")
        self.eng.T04_SLDVCheck(nargout=0)
    def InitCase(self):
        print('开始生成测试模板.......')

        self.eng.T05_GenTestCaseModel(nargout=0)
        list=os.listdir(self.LibraryPath+'/UnitTest/')
        a=0
        for i in list:
            if self.model[4:] in i:
                list2=os.listdir(self.LibraryPath+'/UnitTest/'+i)
                for j in list2:
                    if '001_Spec.xlsx'in j:

                        a=1
                        self.eng.T06_GenTestCase(nargout=0)
        if a==0:
            print("请从err.log查看具体错误信息")

    def GenerateCases(self):
        a=1
    def StartTest(self):
        print("开始运行T07_a_CreateHarness")
        self.eng.T07_a_CreateHarness(nargout=0)
        print("开始运行T07_aex_MergeHarness")
        self.eng.T07_aex_MergeHarness(nargout=0)
        print("开始运行T07_b_RunUnitTest")
        self.eng.T07_b_RunUnitTest(nargout=0)
        print("结束运行T07_b_RunUnitTest")
#a=Mlab('SWC_SMG_DchaCtl',r'D:\工作\工作\脚本\matlab+python\Mode_MIlTest(2019-10-24) (根据已有模型提取)\Test_Model\SWC_SMG_DchaCtl')
#a.testa()
'''a.platform()
a.InitM()
#a.StaticCheck()
a.InitCase()'''