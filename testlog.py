import subprocess
import os
cmd=os.getcwd()+'/bin/platform.exe >./console.log 2>&1'
f1=open('consolog.log','w+')
f2=open('err.log','w+')
startupinfo = subprocess.STARTUPINFO()
startupinfo.dwFlags = subprocess.CREATE_NEW_CONSOLE | subprocess.STARTF_USESHOWWINDOW
startupinfo.wShowWindow = subprocess.SW_HIDE
#p = subprocess.popen([],startupinfo = startupinfo)
process = subprocess.Popen(cmd,stdout=f1,stderr=f2,bufsize=1,startupinfo = startupinfo)
