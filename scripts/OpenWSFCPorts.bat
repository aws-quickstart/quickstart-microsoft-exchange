@echo =========  WSFC and SQL AlwaysON Ports  ===================
@echo Enabling SQLServer default instance port 1433
netsh advfirewall firewall add rule name="SQL Server" dir=in action=allow protocol=TCP localport=1433 
@echo Enabling Dedicated Admin Connection port 1434
netsh advfirewall firewall add rule name="SQL Admin Connection" dir=in action=allow protocol=TCP localport=1434
@echo Enabling conventional SQL Server Service Broker port 4022  
netsh advfirewall firewall add rule name="SQL Service Broker" dir=in action=allow protocol=TCP localport=4022
@echo Enabling AlwaysOn TCPIP End Point port 5022  
netsh advfirewall firewall add rule name="AlwaysOn TCPIP End Point" dir=in action=allow protocol=TCP localport=5022
@echo Enabling AlwaysOn AG Listener port 5023  
netsh advfirewall firewall add rule name="AlwaysOn AG Listener" dir=in action=allow protocol=TCP localport=5023
@echo Enabling Transact-SQL Debugger/RPC port 135 
netsh advfirewall firewall add rule name="SQL Debugger/RPC" dir=in action=allow protocol=TCP localport=135 
