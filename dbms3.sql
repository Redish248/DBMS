db196 n3v2bBJz
db199 4EPDOl0S
---------------
1) Наполнение бд 
CREATE TABLE animals (
    animal_id NUMBER,
    animal_type VARCHAR2(50) NOT NULL,
    animal_name VARCHAR2(50) NOT NULL,
    CONSTRAINT animal_pk PRIMARY KEY (animal_id)
);

INSERT INTO animals (animal_id, animal_name, animal_type) values (1, 'Vasya', 'Cat');
INSERT INTO animals (animal_id, animal_name, animal_type) values (2, 'Taiga', 'Dog');
INSERT INTO animals (animal_id, animal_name, animal_type) values (3, 'Musia', 'Rabbit');
INSERT INTO animals (animal_id, animal_name, animal_type) values (4, 'Misty', 'Chinchilla');
INSERT INTO animals (animal_id, animal_name, animal_type) values (5, 'Lukas', 'Parrot');



INSERT INTO animals (animal_id, animal_name, animal_type) values (6, 'Kitten', 'Cat');
INSERT INTO animals (animal_id, animal_name, animal_type) values (7, 'Name', 'Dog');

export ORACLE_SID=s242361
export NOW=$( date '+%F_%H:%M:%S' )

2) Data Pump

CREATE OR REPLACE DIRECTORY DPUMP_DIR AS '/u01/rrn82/fastuser/dpump_dir1/';
GRANT READ, WRITE ON DIRECTORY DPUMP_DIR TO system;

CREATE OR REPLACE DIRECTORY DUMP_DIR AS '/u01/rrn82/fastuser/dump_dir2/';
GRANT READ, WRITE ON DIRECTORY DUMP_DIR TO system;

export NOW=$( date '+%Y%m%d_%H.%M')
expdp system/admin DIRECTORY=dpump_dir DUMPFILE=expdat1_$NOW.dmp logfile=logFile_$NOW.log FULL=y
impdp system/admin DIRECTORY=dpump_dir DUMPFILE=expdat1_$NOW.dmp logfile=logFile_$NOW.log FULL=y TABLE_EXISTS_ACTION=REPLACE

3) Автоматический периодический экспорт/импорт файлов.

exp system/admin OWNER=system FILE=/u01/rrn82/fastuser/dump_dir2/expdat2_$NOW.dmp LOG=/u01/rrn82/fastuser/dump_dir2/logFile_$NOW.log 
imp system/admin FROMUSER=system FILE=/u01/rrn82/fastuser/dump_dir2/expdat2_$NOW.dmp LOG=/u01/rrn82/fastuser/dump_dir2/logFile_$NOW.log IGNORE=y

4) cron

scp -r /u01/rrn82/fastuser/dpump_dir1/expdat1_${NOW}.dmp oracle@db199:/u01/rrn82/fastuser/dpump_dir1
scp -r /u01/rrn82/fastuser/dpump_dir1/logFile_${NOW}.log oracle@db199:/u01/rrn82/fastuser/dpump_dir1
0 0 * * * file.sh

scp -r /u01/rrn82/fastuser/dump_dir2/expdat2_${NOW}.dmp oracle@db199:/u01/rrn82/fastuser/dump_dir2
scp -r /u01/rrn82/fastuser/dump_dir2/logFile_${NOW}.log oracle@db199:/u01/rrn82/fastuser/dump_dir2


------
crontab -e
0 0 * * * exportAll.sh
exportAll.sh

cd $ORACLE_HOME/dbs
export NOW=$( date '+%Y%m%d_%H.%M')
expdp system/admin DIRECTORY=dpump_dir DUMPFILE=expdat1_$NOW.dmp logfile=logFile_$NOW.log FULL=y
scp -r /u01/rrn82/fastuser/dpump_dir1/expdat1_${NOW}.dmp oracle@db199:/u01/rrn82/fastuser/dpump_dir1
scp -r /u01/rrn82/fastuser/dpump_dir1/logFile_${NOW}.log oracle@db199:/u01/rrn82/fastuser/dpump_dir1
exp system/admin OWNER=system FILE=/u01/rrn82/fastuser/dump_dir2/expdat2_$NOW.dmp LOG=/u01/rrn82/fastuser/dump_dir2/logFile_$NOW.log 
scp -r /u01/rrn82/fastuser/dump_dir2/expdat2_${NOW}.dmp oracle@db199:/u01/rrn82/fastuser/dump_dir2
scp -r /u01/rrn82/fastuser/dump_dir2/logFile_${NOW}.log oracle@db199:/u01/rrn82/fastuser/dump_dir2

------
 0 * * * importAll.sh
importAll.sh

cd $ORACLE_HOME/dbs
export NOW=$( date '+%Y%m%d_%H.%M')
impdp system/admin DIRECTORY=dpump_dir DUMPFILE=expdat1_$NOW.dmp logfile=logFile_$NOW.log FULL=y
scp -r /u01/rrn82/fastuser/dump_dir2/logFile_${NOW}.log oracle@db199:/u01/rrn82/fastuser/dump_dir2


ls -lat | head -4 | tail -1 | awk '{print $9}' - лог
ls -lat | head -5 | tail -1 | awk '{print $9}' - дамп