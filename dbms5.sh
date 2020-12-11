Этап 2. Создать тестовые таблицы с записями и произвести следующие операции с БД:

-Создать нового пользователя greatblackdevourer.
alter session set "_ORACLE_SCRIPT"=true;
SQL 1> CREATE USER greatblackdevourer IDENTIFIED BY 12345;
User created.
SQL 1> GRANT CONNECT, RESOURCE TO greatblackdevourer;
Grant succeeded.
----------------------------------------------------------------------------------------------------------------------------------------






-Создать нового пользователя delightedpurplemutalisk.
SQL 1> CREATE USER delightedpurplemutalisk IDENTIFIED BY 123456;
User created.
SQL 1> GRANT CONNECT, RESOURCE TO delightedpurplemutalisk;
Grant succeeded.
----------------------------------------------------------------------------------------------------------------------------------------






-Закрыть все сессии на всех узлах кластера, запущенные от имени пользователя delightedpurplemutalisk.
Для выполнения данного пункта залогинемся на второй ноде из-под нового пользователя.
$ sqlplus
SQL*Plus: Release 11.2.0.1.0 Production on Sun Dec 20 18:20:54 2015

Copyright (c) 1982, 2009, Oracle.  All rights reserved.

Enter user-name: delightedpurplemutalisk
Enter password:

Connected to:
Oracle Database 11g Enterprise Edition Release 11.2.0.1.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options																																																																																																																																																																																																																																																																																																																																																						
SQL>

	Затем на первой ноде произведём поиск сессий данного юзера. 
SQL 1> SELECT inst_id, sid, serial# FROM gv$session WHERE username='DELIGHTEDPURPLEMUTALISK';

   INST_ID	  SID	 SERIAL#
---------- ---------- ----------
	 1	     56	    58499

Зная номер инстанса, номер сессии и порядковый номер можно выполнить административную команду разрыва сессии.
SQL 1> ALTER SYSTEM KILL SESSION '56,58499,@1';
ORA-00031: session marked for kill

SQL 1> SELECT status FROM gv$session WHERE username='DELIGHTEDPURPLEMUTALISK';

STATUS
--------
KILLED

	После этого все операции пользователя на второй ноде уже не будет доступны.
SQL 2> select * from dual;
select * from dual
*
ERROR at line 1:
ORA-00028: your session has been killed
----------------------------------------------------------------------------------------------------------------------------------------







-Создать новую сессию от имени пользователя delightedpurplemutalisk.
Элементарный вход в систему инициализирует сессию. Поэтому можно просто зайти в систему из-под данного пользователя. 
$ sqlplus
SQL*Plus: Release 11.2.0.1.0 Production on Sun Dec 20 18:20:54 2015

Copyright (c) 1982, 2009, Oracle.  All rights reserved.

Enter user-name: delightedpurplemutalisk
Enter password:

Connected to:
Oracle Database 11g Enterprise Edition Release 11.2.0.1.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options
SQL>

----------------------------------------------------------------------------------------------------------------------------------------






-Вывести состояние всех сессий БД, запущенных от имени пользователя delightedpurplemutalisk.
SQL 1> SELECT inst_id, sid, serial# FROM gv$session WHERE username='DELIGHTEDPURPLEMUTALISK';

   INST_ID	  SID	 SERIAL#
---------- ---------- ----------
	 1	     56	    41929
----------------------------------------------------------------------------------------------------------------------------------------






-Закрыть все сессии на всех узлах кластера, запущенные от имени пользователя greatblackdevourer.
Для выполнения данного пункта залогинемся на второй ноде из-под нового пользователя.
$ sqlplus
SQL*Plus: Release 11.2.0.1.0 Production on Sun Dec 20 18:20:54 2015

Copyright (c) 1982, 2009, Oracle.  All rights reserved.

Enter user-name: greatblackdevourer
Enter password:

Connected to:
Oracle Database 11g Enterprise Edition Release 11.2.0.1.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options
SQL>

	Затем на первой ноде произведём поиск сессий данного юзера. 
SQL 1> SELECT inst_id, sid, serial# FROM gv$session WHERE username='greatblackdevourer';

   INST_ID	  SID	 SERIAL#
---------- ---------- ----------
	 1	     56	    3888

Зная номер инстанса, номер сессии и порядковый номер можно выполнить административную команду разрыва сессии.
SQL 1> ALTER SYSTEM KILL SESSION '56,3888,@1';
ORA-00031: session marked for kill

SQL 1> SELECT status FROM gv$session WHERE username='greatblackdevourer';

STATUS
--------
KILLED

	После этого все операции пользователя на второй ноде уже не будет доступны.
SQL 2> select * from dual;
select * from dual
*
ERROR at line 1:
ORA-00028: your session has been killed
----------------------------------------------------------------------------------------------------------------------------------------






-Создать новую сессию от имени пользователя greatblackdevourer.
Элементарный вход в систему инициализирует сессию. Поэтому можно просто зайти в систему из-под данного пользователя. 
$ sqlplus
SQL*Plus: Release 11.2.0.1.0 Production on Sun Dec 20 18:20:54 2015

Copyright (c) 1982, 2009, Oracle.  All rights reserved.

Enter user-name: greatblackdevourer
Enter password:

Connected to:
Oracle Database 11g Enterprise Edition Release 11.2.0.1.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options
SQL>
----------------------------------------------------------------------------------------------------------------------------------------





-Закрыть все сессии на всех узлах кластера, запущенные от имени пользователя delightedpurplemutalisk.
Для выполнения данного пункта залогинемся на второй ноде из-под нового пользователя.
$ sqlplus
SQL*Plus: Release 11.2.0.1.0 Production on Sun Dec 20 18:20:54 2015

Copyright (c) 1982, 2009, Oracle.  All rights reserved.

Enter user-name: delightedpurplemutalisk
Enter password:

Connected to:
Oracle Database 11g Enterprise Edition Release 11.2.0.1.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options
SQL>

	Затем на первой ноде произведём поиск сессий данного юзера. 
SQL 1> SELECT inst_id, sid, serial# FROM gv$session WHERE username='delightedpurplemutalisk';

   INST_ID	  SID	 SERIAL#
---------- ---------- ----------
	 1	     53	    5070

Зная номер инстанса, номер сессии и порядковый номер можно выполнить административную команду разрыва сессии.
SQL 1> ALTER SYSTEM KILL SESSION '53,5070,@1';
ORA-00031: session marked for kill

SQL 1> SELECT status FROM gv$session WHERE username='delightedpurplemutalisk';

STATUS
--------
KILLED

	После этого все операции пользователя на второй ноде уже не будет доступны.
SQL 2> select * from dual;
select * from dual
*
ERROR at line 1:
ORA-00028: your session has been killed
----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------







Этап 3. Осуществить "внештатную" остановку узла кластера angryarbiter0, проверив таким образом, что вся нагрузка будет перенесена на узел angryarbiter1 и целостность данных не будет нарушена.
При нормальной работе система видит две ноды, в чём можно убедиться сделав запрос. 
SQL 1> select inst_name from v$active_instances;

INST_NAME
--------------------------------------------------------------------------------
ol7-183-rac1.localdomain:cdbrac1
ol7-183-rac2.localdomain:cdbrac2


Произведём экстренное отключение второй ноды – отключим виртуальную машину прямо во время работы. 
После этого повторный запрос произведётся с некой задержкой (ожидание восстановления соединения, которое не произойдёт), после чего мы увидим, что система перераспределила всю работу на оставшуюся ноду. 
SQL 1> select inst_name from v$active_instances;

INST_NAME
--------------------------------------------------------------------------------
ol7-183-rac1.localdomain:cdbrac1

Проверим целостность данных запросом к базе данных:
SQL 1> select * from person;

	ID DATEBEGIN DATEEND   PARTICIP_COUNT
---------- --------- --------- --------------
	 0 01-JAN-10 01-DEC-10
	 1 01-JAN-11 01-DEC-11
	 2 01-JAN-12 01-DEC-12

Несмотря на потерю целой ноды данные по-прежнему активны и доступны для пользователя. 
После этого включим вторую ноду произведём логин в базу данных. RAC на лету подхватывает информацию о доступности новой ноды и вновь перераспределяет ресурсы на обработку. 
SQL 2> select inst_name from v$active_instances;

INST_NAME
------------------------------------------------------------
rac1.localdomain:ractp1
rac2.localdomain:ractp2

----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------







Этап 4. Выполнить ряд операций в следующей последовательности:

Добавить новый файл OCR (Oracle Cluster Repository) по пути /share/luckyghost/.

dd if=/dev/zero of=/share/luckyghost/test.ocr
chown oracle /share/luckyghost/test.ocr
chgrp oinstall /share/luckyghost/test.ocr
chmod 640 /share/luckyghost/test.ocr

ocrconfig -add /share/luckyghost/test.ocr

----------------------------------------------------------------------------------------------------------------------------------------





Заменить созданный на предыдущем шаге файл OCR файлом, находящимся по пути /share/horrifiedwraith/.

ocrconfig -replace /share/luckyghost/ -replacement /share/horrifiedwraith/


----------------------------------------------------------------------------------------------------------------------------------------

Удалить созданный файл OCR.
ocrconfig -delete /share/horrifiedwraith/