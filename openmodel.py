from PyQt5.QtWidgets import  *
import sys

import shutil

from openui import Ui_MainWindow

from PyQt5.QtCore import *
from PyQt5.QtGui import *
import  os
import  re

import time
import TestOperation
import matlab.engine
import createcase
import xlrd

from openpyxl import load_workbook
from threading import Thread

class EmittingStr(QObject):
    textWritten = pyqtSignal(str) #定义一个发送str的信号
    def write(self, text):
      self.textWritten.emit(str(text))

class Oprate(QThread):
    sig = pyqtSignal()
    def __init__(self, parent=None):
        super(Oprate, self).__init__(parent)
    def run(self):
        self.sig.emit()






class basePage(QMainWindow,Ui_MainWindow):
    def __init__(self):
        super(basePage, self).__init__()
        self.setupUi(self)
        self.Select_btn.clicked.connect(self.SelectModelAndInitMatlab)

        self.Init_btn.toggle()

        self.Init_btn.clicked.connect(lambda :self.CheckBtn(1))
        self.Static_btn.clicked.connect(lambda :self.CheckBtn(2))
        self.InitCase_btn.clicked.connect(lambda :self.CheckBtn(3))
        self.GerCase_btn.clicked.connect(lambda :self.CheckBtn(4))
        self.barlabel = QLabel()
        self.statusBar.addPermanentWidget(self.barlabel)
        sys.stdout = EmittingStr(textWritten=self.outputWritten)
        self.Oprate=Oprate()
        self.Oprate.sig.connect(self.InitModel)
        self.creatcases=createcase.Ui_MainWindow()
        self.eng = matlab.engine.start_matlab()
        self.barlabel.setText('未选择模型' )



    def ChooseProDir(self):
        dir=QFileDialog.getExistingDirectory()
        dir=dir.replace('/','\\')
        #self.ProjectName_2.setText(dir)
        self.LibrP=dir

        if dir=='':

            sys.exit(0)



        #self.eng = matlab.engine.start_matlab('-desktop')
            #self.adds(dir,self.child0)
        #a.initUI()
    def SelectModelAndInitMatlab(self):
        dir1, file1 = QFileDialog.getOpenFileName(filter="*.slx")

        (filepath, tempfilename) = os.path.split(dir1)
        (filename, extension) = os.path.splitext(tempfilename)
        dir = filepath.replace('/', '\\')
        #self.Libr=os.path.
        self.modelname=filename[4:]
        if filename!="":
            self.barlabel.setText('选择的模型是：'+filename)
            self.TO = TestOperation.Mlab(filename, dir, self.eng,self.LibrP)


    def CheckBtn(self,num):
        self.Select_btn.setEnabled(False)
        self.Init_btn.setEnabled(False)
        self.Static_btn.setEnabled(False)
        self.InitCase_btn.setEnabled(False)
        self.GerCase_btn.setEnabled(False)
        if num==1:
            self.Num=1
            t = Thread(target=self.InitModel)
            t.start()
        elif num==2:
            t = Thread(target=self.StaticCheck)
            t.start()
            self.Num=2
        elif num==3:
            t = Thread(target=self.InitCase)
            t.start()
            self.Num=3
        elif num==4:
            #t = Thread(target=self.GerCases)
            #t.start()
            self.GerCases()
            self.Num=4

    def CheckNum(self):
        if self.Num==1:
            self.InitModel()
            self.Num = 0
        elif self.Num==2:
            self.StaticCheck()
            self.Num = 0
        elif self.Num==3:
            self.InitCase()
            self.Num = 0
        elif self.Num==4:
            self.GerCases()
            self.Num=0

    def InitModel(self):
        try:
            if self.barlabel.text()=="" :
                print("未选择模型！")
            else:
                print("初始化开始！")
                self.TO.platform()

                self.TO.InitM()
                print("初始化成功！")

            self.Select_btn.setEnabled(True)
            self.Init_btn.setEnabled(True)
            self.Static_btn.setEnabled(True)
            self.InitCase_btn.setEnabled(True)
            self.GerCase_btn.setEnabled(True)

        except:
            print("初始化失败！请从err.log查看具体错误信息！")
            self.Select_btn.setEnabled(True)
            self.Init_btn.setEnabled(True)
            self.Static_btn.setEnabled(True)
            self.InitCase_btn.setEnabled(True)
            self.GerCase_btn.setEnabled(True)

    def StaticCheck(self):
        try:

            self.TO.StaticCheck()
            self.Select_btn.setEnabled(True)
            self.Init_btn.setEnabled(True)
            self.Static_btn.setEnabled(True)
            self.InitCase_btn.setEnabled(True)
            self.GerCase_btn.setEnabled(True)
            print("静态测试成功！")
        except:
            print("静态测试失败！请从err.log查看具体错误信息！")
            self.Select_btn.setEnabled(True)
            self.Init_btn.setEnabled(True)
            self.Static_btn.setEnabled(True)
            self.InitCase_btn.setEnabled(True)
            self.GerCase_btn.setEnabled(True)

    def InitCase(self):
        try:
            self.TO.InitCase()
            self.Select_btn.setEnabled(True)
            self.Init_btn.setEnabled(True)
            self.Static_btn.setEnabled(True)
            self.InitCase_btn.setEnabled(True)
            self.GerCase_btn.setEnabled(True)
            print("初始化模板成功！")
        except:
            print("初始化模板失败！请从err.log查看具体错误信息！")
            self.Select_btn.setEnabled(True)
            self.Init_btn.setEnabled(True)
            self.Static_btn.setEnabled(True)
            self.InitCase_btn.setEnabled(True)
            self.GerCase_btn.setEnabled(True)

    def GerCases(self):
        try:

            self.di = QMainWindow()

            self.creatUI = self.creatcases

            self.creatUI.setupUi(self.di)

            self.creatUI.pushButton.clicked.connect(self.WriteXlSX)

            a,b=self.readXLSX()
            print(a)

            if a=='a':
                print('找不到测试用例模板')
                self.Select_btn.setEnabled(True)
                self.Init_btn.setEnabled(True)
                self.Static_btn.setEnabled(True)
                self.InitCase_btn.setEnabled(True)
                self.GerCase_btn.setEnabled(True)
            #b=['1','2','3']
            else:
                self.creatUI.comboBox.clear()

                self.creatUI.comboBox_2.clear()
                self.creatUI.comboBox.addItems(a)
                self.creatUI.comboBox_2.addItems(b)

                self.di.show()
                self.Select_btn.setEnabled(True)
                self.Init_btn.setEnabled(True)
                self.Static_btn.setEnabled(True)
                self.InitCase_btn.setEnabled(True)
                self.GerCase_btn.setEnabled(True)
        except:
                self.Select_btn.setEnabled(True)
                self.Init_btn.setEnabled(True)
                self.Static_btn.setEnabled(True)
                self.InitCase_btn.setEnabled(True)
                self.GerCase_btn.setEnabled(True)

    def readXLSX(self):

        #list = os.listdir(os.path.join(os.getcwd(), 'testLibrary/UnitTest/'))
        list = os.listdir( self.LibrP+'/UnitTest/')

        #workbook1111 = xlrd.open_workbook(os.path.join(os.getcwd(),'1.'))
        self.PATH=""
        for i in list:

            if self.modelname[4:] in i:
                #list2 = os.listdir(os.path.join(os.getcwd(), 'testLibrary/UnitTest/' + i))
                list2 = os.listdir( self.LibrP+'/UnitTest/' + i)
                for j in list2:
                    if '001_Spec.xlsx' in j and "~$"not in j:
                        #path=os.path.join(os.getcwd(), 'testLibrary/UnitTest/' + i)
                        path = self.LibrP+'/UnitTest/' + i
                        self.PATH=path+'/'+j
                        #print(self.PATH)

                        workbook1=xlrd.open_workbook(filename=self.PATH)
        if self.PATH!="":
            sheet = workbook1.sheets()[0]

            #sheet = workbook1.sheet_by_name(name)
            row = sheet.row_values(1)
            row1=sheet.row_values(0)
            n=0
            signales=[]
            self.singalesDIC={}
            for k1 in row1:
                if k1=='Input':
                    n=n+1
            self.N=10+n
            for k in range(11,11+n-1):
                print(row[k])
                signales.append(row[k])
                self.singalesDIC[row[k]]=k

            col=sheet.col_values(10)
            self.colDIC={}
            times=[]
            print(col)
            for k3 in range(1,len(col)):
                if isinstance(col[k3],float):

                    times.append(str(col[k3]))
                    self.colDIC[col[k3]]=k3

            workbook1.release_resources()
            print(signales,times)
            return signales,times
        else:
            return "a",'b'

    def WriteXlSX(self):

        i=self.creatUI.comboBox.currentIndex()
        txt=self.creatUI.comboBox.itemText(i)
        j = self.creatUI.comboBox_2.currentIndex()
        txt1 = self.creatUI.comboBox_2.itemText(j)
        inputVal=self.creatUI.inputVal.text()
        exVal=self.creatUI.expVal.text()
        if inputVal=="" or exVal=="":
            QMessageBox.about(self, "消息", "输入值或期望值为空！")
        else:
            '''workbook = xlrd.open_workbook(self.PATH)
            workbooknew = copy(workbook)
            ws = workbooknew.get_sheet(0)'''
            len(self.singalesDIC)
            tempp = re.split('.xlsx', self.PATH)[0]
            temp = tempp + '_' + txt + '.xlsx'
            if os.path.exists(temp):
                pass
            else:
                shutil.copyfile(self.PATH,temp)
            wb = load_workbook(temp)
            wb1 = wb.active
            #print(self.colDIC[float(txt1)], self.singalesDIC[txt])
            wb1.cell(self.colDIC[float(txt1)]+1, self.singalesDIC[txt]+1, inputVal)
            wb1.cell(self.colDIC[float(txt1)]+1, self.N+1, exVal)
            '''wb.write(self.colDIC[float(txt1)], self.singalesDIC[txt], self.creatUI.inputVal.text())
            wb.write(self.colDIC[float(txt1)], self.N, self.creatUI.expVal.text())'''

            wb.save(temp)
            print('填入'+txt+"在"+txt1+"时刻的值为："+inputVal+"   期望值为："+exVal)


    def outputWritten(self, text):
        cursor = self.textBrowser.textCursor()
        cursor.movePosition(QTextCursor.End)
        cursor.insertText(text)
        self.textBrowser.setTextCursor(cursor)
        self.textBrowser.ensureCursorVisible()
