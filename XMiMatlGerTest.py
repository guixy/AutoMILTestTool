from PyQt5.QtWidgets import  *
import sys
import openmodel
if __name__ == '__main__':
    app = QApplication(sys.argv)

    a=openmodel.basePage()
    a.ChooseProDir()
    a.show()

    #进入程序的主循环，并通过exit函数确保主循环安全结束
    sys.exit(app.exec_())