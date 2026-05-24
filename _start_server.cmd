@echo off
cd /d "%~dp0"
start "arma2" /min "arma2oaserver.exe" -port=2315 "-config=dayz_1.origins.tavi\config.cfg" "-cfg=dayz_1.origins.tavi\basic.cfg" "-profiles=dayz_1.origins.tavi" -name=dayz_1.origins.tavi "-mod=@DayzOriginsP;@dayz_1.origins.tavi" -cpuCount=4 -maxMem=1578 -exThreads=1