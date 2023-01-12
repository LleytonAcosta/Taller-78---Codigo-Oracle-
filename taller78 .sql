-- tabla cuanta 
create table CUENTA (
   IDCUENTA             number(10)                  not null,
   SALDO                number(10,2)        null,
   constraint PK_CUENTA primary key (IDCUENTA)
)

ALTER TABLE CUENTA ADD CHECK (SALDO>=0);

--tabla movimiento
create table MOVIMIENTO (
   IDMOVIMIENTO         number(10)     not null,
   IDCUENTA             number(10)                  null,
   TIPOMOVIMIENTO       varchar2(2)           null,
   VALOR                number(10,2)        null,
   constraint PK_MOVIMIENTO primary key (IDMOVIMIENTO)
);


create sequence MOVIMIENTO_seq start with 1 increment by 1;
-- trigger
create or replace trigger MOVIMIENTO_seq_tr
 before insert on MOVIMIENTO for each row
 when (new.IDMOVIMIENTO is null)
begin
 select MOVIMIENTO_seq.nextval into :new.IDMOVIMIENTO from dual;
end;
/


create table TRANSFERENCIA (
   IDCUENTAORIGEN       number(10)                  null,
   IDCUENTADESTINO      number(10)                  null,
   IMPORTE              number(10,2)        null
)

alter table MOVIMIENTO
   add constraint FK_MOVIMIEN_FK3_CUENTA foreign key (IDCUENTA)
      references CUENTA (IDCUENTA);


alter table TRANSFERENCIA
   add constraint FK_cuentadestino_CUENTA foreign key (IDCUENTADESTINO)
      references CUENTA (IDCUENTA);

alter table TRANSFERENCIA
   add constraint FK_cuentaorigen_CUENTA foreign key (IDCUENTAORIGEN)
      references CUENTA (IDCUENTA);
      
      
      
      
      
      
      
      --- store porcedure
create or replace PROCEDURE PA_INSERTAR_TRANSACCIONAL
(
PIDCUENTAORIGEN INT,
PIDCUENTADESTINO INT,
PVALOR INT
)
AS
BEGIN 
        INSERT INTO TRANSFERENCIA values(PIDCUENTAORIGEN,PIDCUENTADESTINO,PVALOR);
        insert into MOVIMIENTO(IDCUENTA,TIPOMOVIMIENTO,VALOR) values(PIDCUENTADESTINO,'A',PVALOR);
        update CUENTA set SALDO=saldo+PVALOR where IDCUENTA=PIDCUENTADESTINO;
        insert into MOVIMIENTO(IDCUENTA,TIPOMOVIMIENTO,VALOR) values(PIDCUENTAORIGEN,'D',PVALOR);
        update CUENTA set SALDO=saldo-PVALOR where IDCUENTA=PIDCUENTAORIGEN;
        COMMIT;
        ROLLBACK;
END ;
--store procidure sin acid
CREATE OR REPLACE PROCEDURE PA_INSERTAR_NO_TRANSACCIONAL
(
PIDCUENTAORIGEN INT, PIDCUENTADESTINO INT,  PVALOR NUMERIC
)
AS
BEGIN
 insert into TRANSFERENCIA values(PIDCUENTAORIGEN,PIDCUENTADESTINO,PVALOR);
 insert into MOVIMIENTO(IDCUENTA,TIPOMOVIMIENTO,VALOR) values(PIDCUENTADESTINO,'A',PVALOR);
 update CUENTA set SALDO=saldo+PVALOR where IDCUENTA=PIDCUENTADESTINO;
 insert into MOVIMIENTO(IDCUENTA,TIPOMOVIMIENTO,VALOR) values(PIDCUENTAORIGEN,'D',PVALOR);
 update CUENTA set SALDO=saldo-PVALOR where IDCUENTA=PIDCUENTAORIGEN;
END;


--Ejecutar el Procedure
EXECUTE PA_INSERTAR_TRANSACCIONAL(1,2,10);



--Insertar Cuentas
INSERT INTO CUENTA VALUES(1,200);
INSERT INTO CUENTA VALUES(2,0);

delete from CUENTA where idcuenta=2;

Select idcuenta from CUENTA where idcuenta=1;

drop table transferencia;
drop table movimiento;
drop table cuenta;



   
      
      
      


      
      
      
      
      
      
      
      
      
      
      
      
      