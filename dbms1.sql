SET SERVEROUTPUT ON FORMAT WRAPPED;

DECLARE	
    columnNumber VARCHAR2(128) := 'No.';
    constraintName VARCHAR2(128) := 'Имя ограничения';
    consType VARCHAR2(128) := 'Тип';
    columnName VARCHAR2(128) := 'Имя столбца';
    tableName VARCHAR2(128) := 'Имя таблицы';
    numberLenght NUMBER := 4;
    nameLenght NUMBER := 20;
    typeLenght NUMBER := 3;
    columnLenght NUMBER := 20;
    tableLenght NUMBER := 30;
    currentNumber NUMBER;
	constraintText VARCHAR2(128);
    typeText VARCHAR2(128);
    thisName VARCHAR2(128);
    thisTable VARCHAR2(128);
    referenceName VARCHAR2(128);
    referenceTable VARCHAR2(128);

    CURSOR KEYS_RES IS
        SELECT a.constraint_name AS CONS_NAME, 
                a.table_name AS TABLE_NAME, 
                a.column_name AS COLUMN_NAME, 
                b.constraint_type AS CONS_TYPE, 
                b.r_owner AS REF_OWNER, 
                b.r_constraint_name AS REF_CONS, 
                c_pk.table_name AS TABLE_FK, 
                c_pk.column_name AS COLUMN_FK
        FROM all_cons_columns a  
        JOIN all_constraints b ON ( a.owner = b.owner AND a.constraint_name = b.constraint_name )
        LEFT JOIN all_cons_columns c_pk ON ( c_pk.owner = b.r_owner AND c_pk.constraint_name = b.r_constraint_name)                              
        WHERE ( b.constraint_type = 'P' OR b.constraint_type = 'R' ) 
                and a.table_name IN ( SELECT TABLE_NAME FROM all_tables where owner = 'ISU_UCHEB');

BEGIN

	currentNumber := 1;
	dbms_output.put_line(RPAD(columnNumber, numberLenght) || ' ' 
                        || RPAD(constraintName, nameLenght) || ' ' 
                        || RPAD(consType, typeLenght) || ' ' 
                        || RPAD(columnName, columnLenght) || ' ' 
                        || RPAD(tableName, tableLenght) || ' ' 
                        || RPAD(tableName, tableLenght) || ' ' 
                        || RPAD(columnName, columnLenght));

    dbms_output.put_line(RPAD('-', numberLenght, '-') || ' ' 
                            || RPAD('-', nameLenght, '-') 
                            || ' ' || RPAD('-', typeLenght, '-') 
                            || ' ' || RPAD('-', columnLenght, '-')
                            || ' ' || RPAD('-', tableLenght, '-') 
                            || ' ' || RPAD('-', tableLenght, '-') 
                            || ' ' || RPAD('-', columnLenght, '-') );

    FOR ROW_RES IN KEYS_RES LOOP
        constraintText := TO_CHAR(ROW_RES.CONS_NAME);
        typeText := TO_CHAR(ROW_RES.CONS_TYPE);
        thisName := TO_CHAR(ROW_RES.COLUMN_NAME);
        thisTable := TO_CHAR(ROW_RES.TABLE_NAME);

        IF ROW_RES.TABLE_FK IS NOT NULL THEN
            referenceName := TO_CHAR(ROW_RES.COLUMN_FK);
            referenceTable := TO_CHAR(ROW_RES.TABLE_FK);
        ELSE
            referenceName := '';
            referenceTable := '';
        END IF;

        dbms_output.put_line(RPAD(currentNumber, numberLenght, ' ') || ' ' ||
                RPAD(constraintText, nameLenght, ' ') || ' ' ||
                RPAD(typeText, typeLenght, ' ') || ' ' ||
                RPAD(thisName, columnLenght, ' ') || ' ' ||
                RPAD(thisTable, tableLenght, ' ') || ' ' ||
                RPAD(referenceTable, tableLenght, ' ') || ' ' ||
                RPAD(referenceName, columnLenght, ' ') || ' ');

        currentNumber := currentNumber + 1;
    END LOOP;

END;
/