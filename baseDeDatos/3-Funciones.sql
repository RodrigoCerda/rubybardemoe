--MONTO DE VENTAS PERIODO
create or replace view ventas_periodo as
select to_char( fecha_venta,'mm-yyyy') as perido, sum(a.monto_final) as venta_total from venta as a
group by to_char( fecha_venta,'mm-yyyy');


--MONTO DE VENTAS PERIODO Y MESA
create or replace view ventas_periodo_mesa as
select to_char( fecha_venta,'mm-yyyy') as perido,id_mesa, sum(a.monto_final) as venta_total from venta as a
group by to_char( fecha_venta,'mm-yyyy'),id_mesa;

--MONTO DE VENTAS POR SECTOR Y PERIODO
create or replace view ventas_periodo_sector as
select to_char( A.fecha_venta,'mm-yyyy') as perido,B.ID_SECTOR,
SEC.PISO, SEC.DESCRIPCION ubicacion,
sum(a.monto_final) as venta_total from venta as a
INNER JOIN MESA AS B ON A.ID_MESA= B.ID_MESA
INNER JOIN SECTOR AS SEC ON B.ID_SECTOR= SEC.ID_SECTOR 
group by to_char( A.fecha_venta,'mm-yyyy'),B.ID_SECTOR,SEC.PISO, SEC.DESCRIPCION;

--MONTO DE VENTAS Y PROPINAS, POR EMPLEADO Y PERIODO
create or replace view ventas_periodo_empleado as
select to_char( A.fecha_venta,'mm-yyyy') as perido,a.rut_empleado,
b.nombre_empleado||' '|| b.apellido_paterno||' '|| b.apellido_materno as nombre_empleado, sum(a.monto_final) as venta_total ,
sum (a.monto_propina ) as propina_total
from venta as a
INNER JOIN EMPLEADO AS B ON A.RUT_EMPLEADO= B.RUT_EMPLEADO
group by to_char( a.fecha_venta,'mm-yyyy'),a.rut_empleado,
b.nombre_empleado, b.apellido_paterno,b.apellido_materno;

--MONTO DE VENTAS POR PERIODO,EMPLEADO, MESA Y SECTOR
create or replace view ventas_empleado_mesa as
select to_char( A.fecha_venta,'mm-yyyy') as perido,
EMP.RUT_EMPLEADO,EMP.nombre_empleado||' '|| EMP.apellido_paterno||' '|| EMP.apellido_materno as nombre_empleado,
b.id_mesa as numero_mesa,
SEC.PISO,B.ID_SECTOR, SEC.DESCRIPCION AS ubicacion,
sum(a.monto_final) as venta_total from venta as a
INNER JOIN EMPLEADO AS EMP ON A.RUT_EMPLEADO= EMP.RUT_EMPLEADO
INNER JOIN MESA AS B ON A.ID_MESA= B.ID_MESA
INNER JOIN SECTOR AS SEC ON B.ID_SECTOR= SEC.ID_SECTOR 
group by to_char( A.fecha_venta,'mm-yyyy'),B.ID_SECTOR,SEC.PISO, SEC.DESCRIPCION,EMP.RUT_EMPLEADO,
EMP.nombre_empleado, EMP.apellido_paterno,EMP.apellido_materno,b.id_mesa;

--entrega las ventas historicas agrupadas por periodo 
create or replace function ventas_periodo()
returns setof ventas_periodo as 
$BODY$
declare
reg record;
begin

for reg in select * from  ventas_periodo loop

	return next reg;
end loop;
return;
end;
$BODY$ language 'plpgsql' ;

--entrega las ventas historicas agrupadas por periodo y mesa
create or replace function ventas_periodo_mesa()
returns setof ventas_periodo_mesa as 
$BODY$
declare
reg record;
begin

for reg in select * from  ventas_periodo_mesa loop

	return next reg;
end loop;
return;
end;
$BODY$ language 'plpgsql' ;

--entrega las ventas historicas agrupadas por periodo y sector
create or replace function ventas_periodo_sector()
returns setof ventas_periodo_sector as 
$BODY$
declare
reg record;
begin

for reg in select * from  ventas_periodo_sector loop

	return next reg;
end loop;
return;
end;
$BODY$ language 'plpgsql' ;

--entrega las ventas historicas agrupadas por periodo y empleado, se puede consultar por todo el personal o por un empleado en particular
create or replace function ventas_periodo_empleado
(varchar)
returns setof ventas_periodo_empleado as 
$BODY$
declare
reg record;
begin

	if $1='' then
			for reg in select * from  ventas_periodo_empleado  loop

			return next reg;
		end loop;
	else
		for reg in select * from  ventas_periodo_empleado where rut_empleado=$1 loop

			return next reg;
		end loop;
	end if;
return;
end;
$BODY$ language 'plpgsql' ;

--muestra listado de ventas que realizan los empleados en cada mesa, se puede consultar de manera general o por un empleado específico
create or replace function ventas_empleado_mesa(varchar)
returns setof ventas_empleado_mesa as 
$BODY$
declare
reg record;
begin
	if $1='' then
		for reg in select * from  ventas_empleado_mesa loop

			return next reg;
		end loop;
	else
		for reg in select * from  ventas_empleado_mesa where  rut_empleado=$1 loop

			return next reg;
		end loop;
		
	end if;
return;
end;
$BODY$ language 'plpgsql' ;

--muestra un ranking de los empleados que mas venden durante un perido, se indica de cuantos es el ranking
create or replace function top_ventas_empleado (periodo text, posiciones int)
returns table (rut_empleado character ,nombre_empleado text, venta_total numeric, ranking bigint) as
$$
    select rut_empleado,nombre_empleado, venta_total,
    rank() OVER (PARTITION BY perido ORDER BY venta_total DESC) as posicion
    from  ventas_periodo_empleado
	where perido=$1
    limit $2;
$$
language 'sql' stable;


--muestra un ranking de la mesas que mas venden durante un perido, se indica de cuantos es el ranking
create or replace function top_ventas_mesa (periodo text, posiciones int)
returns table (periodo text, id_mesa int ,UBICACION CHARACTER, venta_total numeric, ranking bigint) as
$$
    select perido as periodo, B.id_mesa as numero_mesa,C.DESCRIPCION AS UBICACION
    ,venta_total,
    rank() OVER (PARTITION BY perido ORDER BY venta_total DESC) as posicion
    from  ventas_periodo_mesa AS A 
    INNER JOIN MESA AS B ON A.ID_MESA= B.ID_MESA
    INNER JOIN SECTOR AS C ON B.ID_SECTOR=C.ID_SECTOR
	where A.perido=$1
    limit $2;
$$
language 'sql' stable;

--muestra lista ordenada de los productos más vendidos durante un periodo 
create or replace function venta_productos_periodo (periodo text)
returns table (periodo text, codigo_producto int ,
               nombre_producto CHARACTER, cantidad_vendida numeric, 
               valor_unitario numeric, monto_total_producto numeric) as
$$
    select periodo_venta,codigo_producto,nombre_producto,
    cant_vendida,valor_unitario,monto_total_producto
    from (select to_char( A.fecha_venta,'mm-yyyy') as periodo_venta,
    b.id_producto as codigo_producto, 
    c.nombre_producto,sum(b.cantidad) as cant_vendida,  c.valor_unitario,
    sum(b.cantidad*c.valor_unitario) monto_total_producto
    from venta  as a
    inner join detalle_venta as b on a.id_venta=b.id_venta
    inner join producto as c on b.id_producto= c.id_producto
    where to_char( A.fecha_venta,'mm-yyyy')=$1--'01-2017'
    group by to_char( A.fecha_venta,'mm-yyyy'),
    c.valor_unitario,b.id_producto,c.nombre_producto) as venta_productos
    order by cant_vendida desc;
$$
language 'sql' stable;

--muestra lista de empleados y cargos
create or replace function Lista_empleados ()
returns table (rut_empleado character, nombre_empleado text, cargo character) as
$$
    select a.rut_empleado, 
    a.nombre_empleado||' '||a.apellido_paterno||' '|| a.apellido_materno as nombe_empleado,
    b.descripcion_cargo from  empleado as a
    inner join cargo as b on a.id_cargo=b.id_cargo;
$$
language 'sql' stable;

--muestra lista de proveedores
create or replace function Lista_proveedores ()
returns table (rut_proveedor character, razon_social character, 
               	direccion character, comuna character, mail_contacto character) as
$$
    select a.rut_proveedor, a.razon_social, a.direccion, b.nombre_comuna as comuna , a.mail_contacto from proveedor as a
	inner join comuna as b on a.id_comuna= b.id_comuna;
$$
language 'sql' stable;

--muestra lista de ingredientes, ordenados por stock de menor a mayor
create or replace function Lista_ingredientes ()
returns table (nombre_ingrediente character, precio_costo numeric, 
               	stock numeric) as
$$
    select nombre_ingrediente, precio_costo, stock from ingrediente
	order by stock asc;
$$
language 'sql' stable;

--muestra lista de productos ordenados alfabeticamente
create or replace function Lista_productos ()
returns table (nombre_producto character, valor_unitario numeric) as
$$
    select nombre_producto, valor_unitario from producto
	order by nombre_producto asc;
$$
language 'sql' stable;


--muestra lista de ingredientes y el proveedor que lo entrega
create or replace function Lista_ingrediente_proveedor ()
returns table (nombre_ingrediente character, 
               	nombre_marca character,
               	nombre_proveedor character,
               	rut_proveedor character) as
$$
   select b.nombre_ingrediente,c.nombre_marca ,d.razon_social as nombre_proveedor,
    d.rut_proveedor from  marca_ingrediente as a
    inner join ingrediente as b on a.id_ingrediente= b.id_ingrediente
    inner join marca as c on a.id_marca= c.id_marca
    inner join proveedor as d on c.rut_proveedor= d.rut_proveedor;
$$
language 'sql' stable;


CREATE OR REPLACE FUNCTION proc_crear_empleado(
 IN rut_emp character varying, 
 IN cod_Cargo integer, 
 IN nombre character varying, 
 IN apellido_pat character varying, 
 IN apellido_mat character varying,
 OUT v_message character varying, 
 OUT v_end_code character varying, 
 OUT v_users_id bigint)
  RETURNS record AS
$BODY$
    DECLARE
      v_valida_cargo int DEFAULT 0;
      v_valida_rut int DEFAULT 0;
      v_userid int;
    BEGIN
     v_end_code = '99999';
          
     
     SELECT COUNT(1) INTO v_valida_cargo FROM cargo WHERE  id_cargo = cod_Cargo;
     IF v_valida_cargo = 0 THEN
        RAISE NOTICE 'codigo de cargo no existe ( % )', cod_Cargo ;
 v_message := 'codigo de cargo no existe:  "'|| cod_Cargo ;
        v_end_code := '10001';
        RETURN;
     END IF;
     
     
     SELECT COUNT(1) INTO v_valida_rut FROM empleado WHERE  rut_empleado = rut_emp;
     IF v_valida_rut > 0 THEN
        RAISE NOTICE 'Rut de empleado ya existe ( % )', rut_emp ;
 v_message := 'Empleado ya existe, revise rut:   "'|| rut_emp ;
        v_end_code := '10002';
        RETURN;
     END IF;
 
     
     INSERT INTO empleado (rut_empleado,id_cargo,nombre_empleado,apellido_paterno,apellido_materno,create_at,modified_at) 
          VALUES (  rut_emp,cod_Cargo,nombre,apellido_pat,apellido_mat, CURRENT_TIMESTAMP,CURRENT_TIMESTAMP);
 
     v_message := 'Empleado creado con exito';
 
     
     v_end_code := '00000';
     RETURN;
     
    END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
  
  
CREATE OR REPLACE FUNCTION proc_actualiza_empleado(
 IN rut_emp character varying, 
 IN cod_Cargo integer, 
 IN nombre character varying, 
 IN apellido_pat character varying, 
 IN apellido_mat character varying,
 OUT v_message character varying, 
 OUT v_end_code character varying, 
 OUT v_users_id bigint)
  RETURNS record AS
$BODY$
    DECLARE
      v_valida_cargo int DEFAULT 0;
      v_valida_rut int DEFAULT 0;
      v_userid int;
    BEGIN
     v_end_code = '99999';
           
     
     SELECT COUNT(1) INTO v_valida_rut FROM empleado WHERE  rut_empleado = rut_emp;
     IF v_valida_rut = 0 THEN
        RAISE NOTICE 'Rut de empleado no existe ( % )', rut_emp ;
 		v_message := 'Empleado no existe, revise rut:   "'|| rut_emp ;
        v_end_code := '10002';
        RETURN;
     END IF;
     
     
     SELECT COUNT(1) INTO v_valida_cargo FROM cargo WHERE  id_cargo = cod_Cargo;
     IF v_valida_cargo = 0 THEN
        RAISE NOTICE 'Codigo de cargo no existe ( % )', cod_Cargo ;
 		v_message := 'Codigo de cargo no existe:  "'|| cod_Cargo ;
        v_end_code := '10001';
        RETURN;
     END IF;
 
   
   
     UPDATE empleado 
     SET id_cargo= cod_Cargo,nombre_empleado=nombre,
     		apellido_paterno=apellido_pat,apellido_materno=apellido_mat
     WHERE rut_empleado= rut_emp;
 	 
     v_message := 'Empleado Modificado con exito';
 
     
     v_end_code := '00000';
     RETURN;
     
    END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
  
