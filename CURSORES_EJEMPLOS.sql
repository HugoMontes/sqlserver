-- ---------------------------------------------------------------------------------------------
-- NOTA: Los ejemplos fueron ejecutados en MICROSOFT SQL SERVER MANAGEMENT STUDIO
-- ---------------------------------------------------------------------------------------------
-- SET DATEFORMAT dmy;
-- exec PAA_RAP_INFORMACION_GENERAL_LOTES_PRODUCCION '01/01/2018', '20/06/2018';


-- ------------------------------------------------------
-- EJEMPLO 1 - CREAR Y ABRIR UN CURSOR
-- ------------------------------------------------------
-- declarar el cursor
declare cursor1 CURSOR
	for select top 20 * from personal;
-- abrir el curso
OPEN cursor1
-- navegar
FETCH NEXT FROM cursor1
-- cerrar el cursor
CLOSE cursor1
-- liberar de memoria
DEALLOCATE cursor1


-- ------------------------------------------------------
-- EJEMPLO 2 - ITERAR UN CURSOR
-- ------------------------------------------------------
-- declarar las variables para guardar los datos del cursor
DECLARE
	@nombre varchar(20),
    @paterno varchar(20),
    @materno varchar(20)
-- declara rel cursor
DECLARE personas cursor
	FOR SELECT TOP 20 NOMBRES_PERSONAL, AP_PATERNO_PERSONAL, AP_MATERNO_PERSONAL FROM PERSONAL
-- abrir el cursor
OPEN personas
-- navegar y cargar los datos del cursor a las variables
FETCH personas INTO @nombre, @paterno, @materno
-- obtener todos los datos del cursor
-- @@FETCH_STATUS devuelve cero si todo se ejecuto correctamente
WHILE(@@FETCH_STATUS=0)
BEGIN
	-- mostrar datos de las variables
	PRINT @nombre+' '+@paterno+' '+@materno
    -- cargar datos en las variables
	FETCH personas INTO @nombre, @paterno, @materno	
END
-- cerrar el cursor 
CLOSE personas
-- liberar de memoria
DEALLOCATE personas



-- ------------------------------------------------------
-- EJEMPLO 3 - SCROLL CURSOR
-- ------------------------------------------------------
-- declarar el cursor como scroll
declare cursor1 CURSOR SCROLL
	for select top 20 * from personal;
OPEN cursor1
-- Ir siguiente registro
FETCH NEXT FROM cursor1
-- Ir anterior registro
FETCH PRIOR FROM cursor1
-- Ir al primer registro
FETCH FIRST FROM cursor1
-- Ir al ultimo registro
FETCH LAST FROM cursor1
-- Cerrar y liberar el cursor
CLOSE cursor1
DEALLOCATE cursor1


-- ------------------------------------------------------
-- EJEMPLO 4 - ACTUALIZAR DATOS
-- ------------------------------------------------------
DECLARE
	@nombre varchar(20),
    @paterno varchar(20),
    @materno varchar(20)
-- Declarar el cursor para actualizar
DECLARE personas cursor 
	FOR SELECT TOP 20 NOMBRES_PERSONAL, AP_PATERNO_PERSONAL, AP_MATERNO_PERSONAL 
	FROM PERSONAL FOR UPDATE
OPEN personas
FETCH personas INTO @nombre, @paterno, @materno
WHILE(@@FETCH_STATUS=0)
BEGIN
	-- Actualizar los registros
	UPDATE personal set NOMBRES_PERSONAL = @nombre + ' - MODIFICADO' WHERE CURRENT OF personas
	FETCH personas INTO @nombre, @paterno, @materno	
END
-- Cerrar y liberar el cursor
CLOSE personas
DEALLOCATE personas


-- ---------------------------------------------------------
-- VERIFICAR LOS DATOS AFECTADOS
-- ---------------------------------------------------------
SELECT TOP 20 NOMBRES_PERSONAL, AP_PATERNO_PERSONAL, AP_MATERNO_PERSONAL FROM PERSONAL





-- --------------------------------------------
-- PROCEDIMIEINTO ALMACENADO
-- --------------------------------------------
-- Eliminar procedimiento si existe
IF OBJECT_ID('PERSONAL_ANTIGUO') IS NOT NULL
BEGIN
	DROP PROCEDURE PERSONAL_ANTIGUO
END
GO
-- Crear el procedimiento
CREATE PROC PERSONAL_ANTIGUO
AS
DECLARE
	@nombre varchar(20),
    @paterno varchar(20),
    @materno varchar(20)
-- declara rel cursor
DECLARE personas cursor
	FOR SELECT TOP 20 NOMBRES_PERSONAL, AP_PATERNO_PERSONAL, AP_MATERNO_PERSONAL FROM PERSONAL
-- abrir el cursor
OPEN personas
-- navegar y cargar los datos del cursor a las variables
FETCH personas INTO @nombre, @paterno, @materno
-- obtener todos los datos del cursor
-- @@FETCH_STATUS devuelve cero si todo se ejecuto correctamente
WHILE(@@FETCH_STATUS=0)
BEGIN
	-- mostrar datos de las variables
	PRINT @nombre+' '+@paterno+' '+@materno
    -- cargar datos en las variables
	FETCH personas INTO @nombre, @paterno, @materno	
END
-- cerrar el cursor 
CLOSE personas
-- liberar de memoria
DEALLOCATE personas

exec PERSONAL_ANTIGUO



-- --------------------------------------------
-- PROCEDIMIENTO ALMACENADO PARAMETROS
-- --------------------------------------------
-- Eliminar procedimiento si existe
IF OBJECT_ID('PRIMEROS_PERSONAL_ANTIGUO') IS NOT NULL
BEGIN
	DROP PROCEDURE PRIMEROS_PERSONAL_ANTIGUO
END
GO
-- Crear el procedimiento
CREATE PROC PRIMEROS_PERSONAL_ANTIGUO
	@nro_personas integer
AS
DECLARE
	@nombre varchar(20),
    @paterno varchar(20),
    @materno varchar(20)
-- declara rel cursor
DECLARE personas cursor
	FOR SELECT TOP (@nro_personas) NOMBRES_PERSONAL, AP_PATERNO_PERSONAL, AP_MATERNO_PERSONAL FROM PERSONAL
-- abrir el cursor
OPEN personas
-- navegar y cargar los datos del cursor a las variables
FETCH personas INTO @nombre, @paterno, @materno
-- obtener todos los datos del cursor
-- @@FETCH_STATUS devuelve cero si todo se ejecuto correctamente
WHILE(@@FETCH_STATUS=0)
BEGIN
	-- mostrar datos de las variables
	PRINT @nombre+' '+@paterno+' '+@materno
    -- cargar datos en las variables
	FETCH personas INTO @nombre, @paterno, @materno	
END
-- cerrar el cursor 
CLOSE personas
-- liberar de memoria
DEALLOCATE personas

exec PRIMEROS_PERSONAL_ANTIGUO 50




-- --------------------------------------------
-- TABLA TEMPORAL
-- --------------------------------------------
-- Una tabla temporal permite almacenar informacion que se pueden obtener de una consulta compleja
-- y se eliminan automaticamente cuando se cierra la sesion.

-- CREAR LA TABLA TEMPORAL LOCAL EMPLEADOS
-- ACCESO PARA UN SOLO USUARIO: Disponibles para ser utilizadas por cada conexion actual. 
-- Eliminacion automatica de memoria cuando se cierra la conexion del usuario.
SELECT * INTO #EMPLEADOS_LOCAL FROM PERSONAL WHERE COD_PERSONAL between 0 and 50;
-- MOSTRAR DATOS DE LA TABLA TEMPORAL LOCAL
select * from #EMPLEADOS_LOCAL; 

-- CREAR LA TABLA TEMPORAL GLOBAL EMPLEADOS
-- ACCESO PARA VARIOS USUARIOS: Cualquier usuario con permisos puede acceder a la tabla.
SELECT * INTO ##EMPLEADOS_GLOBAL FROM PERSONAL WHERE COD_PERSONAL between 0 and 50;
-- MOSTRAR DATOS DE LA TABLA TEMPORAL LOCAL
select * from ##EMPLEADOS_GLOBAL; 

-- ELIMINAR TABLA PERSONAL
DROP TABLE #EMPLEADOS_LOCAL;
DROP TABLE ##EMPLEADOS_GLOBAL;