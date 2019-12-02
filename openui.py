# -*- coding: utf-8 -*-

# Form implementation generated from reading ui file 'openui.ui'
#
# Created by: PyQt5 UI code generator 5.13.1
#
# WARNING! All changes made in this file will be lost!


from PyQt5 import QtCore, QtGui, QtWidgets


class Ui_MainWindow(object):
    def setupUi(self, MainWindow):
        MainWindow.setObjectName("MainWindow")
        MainWindow.resize(591, 268)
        self.centralwidget = QtWidgets.QWidget(MainWindow)
        self.centralwidget.setObjectName("centralwidget")
        self.widget = QtWidgets.QWidget(self.centralwidget)
        self.widget.setGeometry(QtCore.QRect(150, 10, 411, 231))
        self.widget.setStyleSheet("QWidget{border:1px solid rgb(131, 131, 131)  }\n"
"QLabel{border:None}")
        self.widget.setObjectName("widget")
        self.label = QtWidgets.QLabel(self.widget)
        self.label.setGeometry(QtCore.QRect(4, 10, 61, 16))
        self.label.setObjectName("label")
        self.textBrowser = QtWidgets.QTextBrowser(self.widget)
        self.textBrowser.setGeometry(QtCore.QRect(0, 30, 411, 201))
        self.textBrowser.setObjectName("textBrowser")
        self.layoutWidget = QtWidgets.QWidget(self.centralwidget)
        self.layoutWidget.setGeometry(QtCore.QRect(10, 0, 121, 241))
        self.layoutWidget.setObjectName("layoutWidget")
        self.verticalLayout = QtWidgets.QVBoxLayout(self.layoutWidget)
        self.verticalLayout.setContentsMargins(0, 0, 0, 0)
        self.verticalLayout.setObjectName("verticalLayout")
        self.Select_btn = QtWidgets.QPushButton(self.layoutWidget)
        self.Select_btn.setObjectName("Select_btn")
        self.verticalLayout.addWidget(self.Select_btn)
        self.Init_btn = QtWidgets.QPushButton(self.layoutWidget)
        self.Init_btn.setObjectName("Init_btn")
        self.verticalLayout.addWidget(self.Init_btn)
        self.Static_btn = QtWidgets.QPushButton(self.layoutWidget)
        self.Static_btn.setObjectName("Static_btn")
        self.verticalLayout.addWidget(self.Static_btn)
        self.InitCase_btn = QtWidgets.QPushButton(self.layoutWidget)
        self.InitCase_btn.setObjectName("InitCase_btn")
        self.verticalLayout.addWidget(self.InitCase_btn)
        self.GerCase_btn = QtWidgets.QPushButton(self.layoutWidget)
        self.GerCase_btn.setObjectName("GerCase_btn")
        self.verticalLayout.addWidget(self.GerCase_btn)
        self.Start_btn = QtWidgets.QPushButton(self.layoutWidget)
        self.Start_btn.setObjectName("Start_btn")
        self.verticalLayout.addWidget(self.Start_btn)
        self.layoutWidget.raise_()
        self.widget.raise_()
        MainWindow.setCentralWidget(self.centralwidget)
        self.statusBar = QtWidgets.QStatusBar(MainWindow)
        self.statusBar.setObjectName("statusBar")
        MainWindow.setStatusBar(self.statusBar)

        self.retranslateUi(MainWindow)
        QtCore.QMetaObject.connectSlotsByName(MainWindow)

    def retranslateUi(self, MainWindow):
        _translate = QtCore.QCoreApplication.translate
        MainWindow.setWindowTitle(_translate("MainWindow", "XMiMatlGerTest"))
        self.label.setText(_translate("MainWindow", "控制台"))
        self.Select_btn.setText(_translate("MainWindow", "选择模型"))
        self.Init_btn.setText(_translate("MainWindow", "初始化"))
        self.Static_btn.setText(_translate("MainWindow", "静态测试"))
        self.InitCase_btn.setText(_translate("MainWindow", "初始化测试用例"))
        self.GerCase_btn.setText(_translate("MainWindow", "创建测试用例"))
        self.Start_btn.setText(_translate("MainWindow", "开始测试"))
