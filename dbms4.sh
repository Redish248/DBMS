db199 4EPDOl0S

Этап 1. Сконфигурировать экземпляр Oracle ASM на выделенном сервере и настроить 
его на работу с базой данных, созданной при выполнении лабораторной работы №2:

crsctl stat res ora.cssd -t
type sqlplus

Узел db196
Имя сервиса: ASM.242361
ASM_POWER_LIMIT: 6.
Количество дисковых групп: 2.
Имена и размерности дисковых групп: bravecow[4], dangerouscrocodile[5].
В качестве хранилища данных (дисков) необходимо использовать файлы. 
Имена файлов должны строиться по шаблону $DISKGROUP_NAME$X, 
где $DISKGROUP_NAME - имя дисковой группы, 
а $X - порядковый номер файла в группе (нумерация начинается с нуля).
Путь к файлам ASM - /u01/$DISKGROUP_NAME/$DISK_FILE_NAME.

1) Хранилище ASM
export ORACLE_HOME=/u01/app/11.2.0/grid
export ORACLE_SID=+ASM.242361
export PATH=$ORACLE_HOME/bin:$PATH

2) Создадим файл параметров и файл паролей 
cd $ORACLE_HOME/dbs
touch init+ASM.242361.ora

instance_type=asm
ASM_POWER_LIMIT=6
ASM_DISKSTRING=(
    '/u01/bravecow/*',
    '/u01/dangerouscrocodile/*'
)
ASM_DISKGROUPS='bravecow', 'dangerouscrocodile'
remote_login_passwordfile=exclusive
_ASM_ALLOW_ONLY_RAW_DISKS=FALSE

orapwd file=init+ASM.242361 

3) Подготовим необходимые директории для дисковых групп
mkdir /u01/bravecow
mkdir /u01/dangerouscrocodile


/usr/sbin/mkfile -n 500m /u01/bravecow/bravecow0
/usr/sbin/mkfile -n 500m /u01/bravecow/bravecow1
/usr/sbin/mkfile -n 500m /u01/bravecow/bravecow2
/usr/sbin/mkfile -n 500m /u01/bravecow/bravecow3

/usr/sbin/mkfile -n 500m /u01/dangerouscrocodile/dangerouscrocodile0
/usr/sbin/mkfile -n 500m /u01/dangerouscrocodile/dangerouscrocodile1
/usr/sbin/mkfile -n 500m /u01/dangerouscrocodile/dangerouscrocodile2
/usr/sbin/mkfile -n 500m /u01/dangerouscrocodile/dangerouscrocodile3
/usr/sbin/mkfile -n 500m /u01/dangerouscrocodile/dangerouscrocodile4

4) chown oracle:dba ./bravecow
---
chown oracle:dba ./dangerouscrocodile

5) старт

crsctl start resource ora.cssd
crsctl stat resource ora.cssd -t

6) Через SQLPlus подключаемся к ASM и проверяем, что диски подключены
sqlplus / as sysasm
startup;
select path,mount_status from v$asm_disk;

7) Создаем дисковую группу 
create diskgroup bravecow normal redundancy disk
'/u01/bravecow/bravecow0', '/u01/bravecow/bravecow1', '/u01/bravecow/bravecow2',
'/u01/bravecow/bravecow3';
--
create diskgroup dangerouscrocodile normal redundancy disk
'/u01/dangerouscrocodile/dangerouscrocodile0', 
'/u01/dangerouscrocodile/dangerouscrocodile1', 
'/u01/dangerouscrocodile/dangerouscrocodile2',
'/u01/dangerouscrocodile/dangerouscrocodile3', 
'/u01/dangerouscrocodile/dangerouscrocodile4';

select group_number, name, total_mb, free_mb, state, type from v$asm_diskgroup;

8) Далее в отдельном терминале запускаем экземпляр базы данных и создаем табличное
пространство, которое будет храниться в ASM

create tablespace test_1 datafile '+bravecow'
size 10m autoextend on next 100m
extent management local
segment space management auto;
select tablespace_name from dba_data_files;
alter tablespace test_1 add datafile
'+bravecow'
size 10M autoextend on next 100M;
select file_name from dba_data_files where tablespace_name='TEST_1';


create tablespace test_2 datafile
'+dangerouscrocodile'
size 10m autoextend on next 100m
extent management local
segment space management auto;
select tablespace_name from dba_data_files;
alter tablespace test_2 add datafile
'+dangerouscrocodile'
size 10M autoextend on next 100M;
select file_name from dba_data_files where tablespace_name='TEST_2';

srvctl add asm -p /u01/app/11.2.0/grid/dbs/init+ASM.242361.ora

--------------------------------------------------------------------------------
Этап 2. Внести в конфигурацию ASM ряд изменений в приведённой ниже 
последовательности:

1) Удалить дисковую группу bravecow и добавить новую дисковую 
группу sadpanda[3]"; размер AU - 8 МБ.
begin
DROP DISKGROUP bravecow INCLUDING CONTENTS;
create diskgroup sadpanda normal redundancy disk
'/u01/sadpanda/sadpanda0',
'/u01/sadpanda/sadpanda1',
'/u01/sadpanda/sadpanda2' 
ATTRIBUTE 'AU_SIZE'='8M';
end;
/

/usr/sbin/mkfile  -n 500m /u01/sadpanda/sadpanda0
/usr/sbin/mkfile  -n 500m /u01/sadpanda/sadpanda1
/usr/sbin/mkfile  -n 500m /u01/sadpanda/sadpanda2

2) Удалить диск #1 из группы sadpanda.
alter diskgroup sadpanda drop disk sadpanda_0001;

3) Удалить дисковую группу sadpanda и добавить новую дисковую 
группу friendlykitten[4]"; размер AU - 16 МБ.
begin
DROP DISKGROUP sadpanda INCLUDING CONTENTS;
create diskgroup friendlykitten normal redundancy disk
'/u01/friendlykitten/friendlykitten0',
'/u01/friendlykitten/friendlykitten1',
'/u01/friendlykitten/friendlykitten2',
'/u01/friendlykitten/friendlykitten3' 
ATTRIBUTE 'AU_SIZE'='16M';
end;
/

/usr/sbin/mkfile  -n 500m /u01/friendlykitten/friendlykitten0
/usr/sbin/mkfile  -n 500m /u01/friendlykitten/friendlykitten1
/usr/sbin/mkfile  -n 500m /u01/friendlykitten/friendlykitten2
/usr/sbin/mkfile  -n 500m /u01/friendlykitten/friendlykitten2

4) Удалить диск #3 из группы friendlykitten.
alter diskgroup friendlykitten drop disk friendlykitten_0003;

5) Удалить диск #0 из группы friendlykitten.
alter diskgroup friendlykitten drop disk friendlykitten_0000;

6) Удалить диск #1 из группы friendlykitten.
alter diskgroup friendlykitten drop disk friendlykitten_0001;

7) Удалить диск #0 из группы friendlykitten.
alter diskgroup friendlykitten drop disk friendlykitten_0000;

8) Добавить новый диск в группу friendlykitten.
alter diskgroup friendlykitten add disk '/u01/friendlykitten/friendlykitten5';