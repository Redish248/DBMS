ssh -p 2222 s242361@helios.cs.ifmo.ru
ssh oracle@db196
n3v2bBJz
cd $ORACLE_HOME/dbs
startup PFILE=inits242361.ora
-------------


1) Задать значения необходимых для конфигурации переменных окружения.

mkdir -p /u01/app/oracle/product/11.2.0/dbhome_1

export ORACLE_BASE=/u01/app/oracle
export ORACLE_HOME=/u01/app/oracle/product/11.2.0/dbhome_1
export ORACLE_SID=s242361
export PATH=$PATH:$ORACLE_HOME/bin
export LD_LIBRARY_PATH=$ORACLE_HOME/lib:/lib:/usr/lib:/usr/local/lib
export NLS_LANG=American_America.UTF8
export NLS_SORT=AMERICAN
export NLS_DATE_LANGUAGE=AMERICAN

2) Задать метод аутентификации администратора (файл).

cd $ORACLE_HOME/dbs
orapwd file=orapws242361

пароль admin

3) Создать конфигурационные файлы, необходимые для инициализации и запуска экземпляра Oracle.

cd $ORACLE_BASE
mkdir ­-p admin/orcl/adump
mkdir flash_recovery_area
mkdir /u01/rrn82

cd $ORACLE_HOME/dbs
touch inits242361.ora


db_name='fastuser'
memory_target=1G
sga_target=640M
processes=150
audit_file_dest='/u01/app/oracle/admin/orcl/adump' 
audit_trail ='db' 
db_block_size=8192
db_domain=''
db_recovery_file_dest='/u01/app/oracle/flash_recovery_area' 
db_recovery_file_dest_size=2G 
diagnostic_dest='/u01/app/oracle' 
dispatchers='(PROTOCOL=TCP) (SERVICE=ORCLXDB)' 
open_cursors=300
remote_login_passwordfile='EXCLUSIVE' 
undo_tablespace='UNDOTBS1' 
control_files = (ora_control1, ora_control2) 
compatible ='11.2.0'

chown oracle:oinstall /u01/rrn82
chmod 775 /u01/rrn82 
cd /u01/rrn82
mkdir logs
mkdir fastuser 
cd fastuser 
mkdir node01 node02 node03 node04

4) Запустить экземпляр Oracle.

sqlplus /nolog
SQL> connect / as sysdba;
SQL> create SPFILE from PFILE='$ORACLE_HOME/dbs/inits242361.ora';
SQL> startup nomount;

5) Создать новую базу данных.

CREATE DATABASE fastuser
USER SYS IDENTIFIED BY admin
USER SYSTEM IDENTIFIED BY admin
LOGFILE GROUP 1 ('/u01/rrn82/logs/redo01a.log') SIZE 10M,
GROUP 2 ('/u01/rrn82/logs/redo02a.log') SIZE 10M,
GROUP 3 ('/u01/rrn82/logs/redo03a.log') SIZE 10M,
GROUP 4 ('/u01/rrn82/logs/redo04a.log') SIZE 10M
MAXLOGFILES 5
MAXLOGMEMBERS 5
MAXLOGHISTORY 10
MAXDATAFILES 50
CHARACTER SET UTF8
NATIONAL CHARACTER SET UTF8
EXTENT MANAGEMENT LOCAL
DATAFILE
'/u01/rrn82/fastuser/node03/ezuki71.dbf' SIZE 100M REUSE AUTOEXTEND ON,
'/u01/rrn82/fastuser/node04/apugi49.dbf' SIZE 100M REUSE AUTOEXTEND ON,
'/u01/rrn82/fastuser/node03/emoku91.dbf' SIZE 100M REUSE AUTOEXTEND ON MAXSIZE
UNLIMITED
SYSAUX DATAFILE '/u01/rrn82/fastuser/node02/sug48.dbf' SIZE 100M REUSE AUTOEXTEND ON MAXSIZE
UNLIMITED
DEFAULT TABLESPACE users
DATAFILE '/u01/rrn82/fastuser/node01/usukaho493.dbf'
SIZE 50M REUSE AUTOEXTEND ON MAXSIZE UNLIMITED
DEFAULT TEMPORARY TABLESPACE temp
TEMPFILE '/u01/rrn82/fastuser/temp01.dbf' SIZE 100M REUSE
UNDO TABLESPACE UNDOTBS1
DATAFILE '/u01/rrn82/fastuser/undotbs01.dbf' SIZE 100M REUSE AUTOEXTEND ON MAXSIZE UNLIMITED;

6) Создать дополнительные табличные пространства.

CREATE TABLESPACE FAST_WHITE_SOUP
DATAFILE 	'/u01/rrn82/fastuser/node03/fastwhitesoup01.dbf' SIZE 10M,
'/u01/rrn82/fastuser/node01/fastwhitesoup02.dbf' SIZE 10M,
'/u01/rrn82/fastuser/node04/fastwhitesoup03.dbf' SIZE 10M,
'/u01/rrn82/fastuser/node04/fastwhitesoup04.dbf' SIZE 10M;
CREATE TABLESPACE TALL_WHITE_ROLE
DATAFILE 	'/u01/rrn82/fastuser/node03/tallwhiterole01.dbf' SIZE 10M;

7) Сформировать представления словаря данных.

cd $ORACLE_HOME/rdbms/admin
sqlplus /nolog
SQL> connect / as sysdba
SQL> @catalog.sql
SQL> @catproc.sql

8) Проверка базы.

CREATE TABLE person (
    person_id NUMBER,
    first_name VARCHAR2(50) NOT NULL,
    last_name VARCHAR2(50) NOT NULL,
    CONSTRAINT person_pk PRIMARY KEY (person_id)
);

INSERT INTO person (person_id, first_name, last_name) values (1, 'Ira', 'Redkina');

SELECT * from person;

commit;