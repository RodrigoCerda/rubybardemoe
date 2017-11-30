/*==============================================================*/
/* DBMS name:      PostgreSQL 9.x                               */
/* Created on:     31-10-2017 0:42:58                           */
/*==============================================================*/
drop schema public cascade;
create schema public;

/*==============================================================*/
/* Table: CARGO                                                 */
/*==============================================================*/
create table CARGO (
   ID_CARGO             SERIAL               not null,
   DESCRIPCION_CARGO    CHAR(256)            not null,
   SUELDO_BASE          NUMERIC              not null,
   CREATE_AT            DATE                 null,
   MODIFIED_AT          DATE                 null,
   constraint PK_CARGO primary key (ID_CARGO)
);

/*==============================================================*/
/* Index: CARGO_PK                                              */
/*==============================================================*/
create unique index CARGO_PK on CARGO (
ID_CARGO
);

/*==============================================================*/
/* Table: CATEGORIA                                             */
/*==============================================================*/
create table CATEGORIA (
   ID_CATEGORIA         SERIAL               not null,
   NOMBRE_CATEGORIA     CHAR(20)             not null,
   CREATE_AT            DATE                 null,
   MODIFIED_AT          DATE                 null,
   constraint PK_CATEGORIA primary key (ID_CATEGORIA)
);

/*==============================================================*/
/* Index: CATEGORIA_PK                                          */
/*==============================================================*/
create unique index CATEGORIA_PK on CATEGORIA (
ID_CATEGORIA
);

/*==============================================================*/
/* Table: COMUNA                                                */
/*==============================================================*/
create table COMUNA (
   ID_COMUNA            SERIAL               not null,
   ID_PROVINCIA         INT4                 null,
   NOMBRE_COMUNA        CHAR(300)            null,
   CREATE_AT            DATE                 null,
   MODIFIED_AT          DATE                 null,
   constraint PK_COMUNA primary key (ID_COMUNA)
);

/*==============================================================*/
/* Index: COMUNA_PK                                             */
/*==============================================================*/
create unique index COMUNA_PK on COMUNA (
ID_COMUNA
);

/*==============================================================*/
/* Index: ORGANIZA_FK                                           */
/*==============================================================*/
create  index ORGANIZA_FK on COMUNA (
ID_PROVINCIA
);

/*==============================================================*/
/* Table: DETALLEPAGO                                           */
/*==============================================================*/
create table DETALLEPAGO (
   ID_VENTA             INT4                 not null,
   ID_MEDIO_PAGO        INT4                 not null,
   MONTO                NUMERIC              not null,
   constraint PK_DETALLEPAGO primary key (ID_VENTA, ID_MEDIO_PAGO)
);

/*==============================================================*/
/* Index: DETALLEPAGO_PK                                        */
/*==============================================================*/
create unique index DETALLEPAGO_PK on DETALLEPAGO (
ID_VENTA,
ID_MEDIO_PAGO
);

/*==============================================================*/
/* Index: FORMAPAGO_FK                                          */
/*==============================================================*/
create  index FORMAPAGO_FK on DETALLEPAGO (
ID_MEDIO_PAGO
);

/*==============================================================*/
/* Index: POSEE_FK                                              */
/*==============================================================*/
create  index POSEE_FK on DETALLEPAGO (
ID_VENTA
);

/*==============================================================*/
/* Table: DETALLE_VENTA                                         */
/*==============================================================*/
create table DETALLE_VENTA (
   ID_VENTA             INT4                 not null,
   ID_PRODUCTO          INT4                 not null,
   CANTIDAD             NUMERIC              not null,
   constraint PK_DETALLE_VENTA primary key (ID_VENTA, ID_PRODUCTO)
);

/*==============================================================*/
/* Index: DETALLE_VENTA_PK                                      */
/*==============================================================*/
create unique index DETALLE_VENTA_PK on DETALLE_VENTA (
ID_VENTA,
ID_PRODUCTO
);

/*==============================================================*/
/* Index: CONFORMA2_FK                                          */
/*==============================================================*/
create  index CONFORMA2_FK on DETALLE_VENTA (
ID_PRODUCTO
);

/*==============================================================*/
/* Index: CONFORMA_FK                                           */
/*==============================================================*/
create  index CONFORMA_FK on DETALLE_VENTA (
ID_VENTA
);

/*==============================================================*/
/* Table: EMPLEADO                                              */
/*==============================================================*/
create table EMPLEADO (
   RUT_EMPLEADO         CHAR(11)             not null,
   ID_CARGO             INT4                 not null,
   NOMBRE_EMPLEADO      CHAR(256)            null,
   APELLIDO_PATERNO     CHAR(100)            null,
   APELLIDO_MATERNO     CHAR(100)            null,
   CREATE_AT            DATE                 null,
   MODIFIED_AT          DATE                 null,
   constraint PK_EMPLEADO primary key (RUT_EMPLEADO)
);

/*==============================================================*/
/* Index: EMPLEADO_PK                                           */
/*==============================================================*/
create unique index EMPLEADO_PK on EMPLEADO (
RUT_EMPLEADO
);

/*==============================================================*/
/* Index: AGRUPA_FK                                             */
/*==============================================================*/
create  index AGRUPA_FK on EMPLEADO (
ID_CARGO
);

/*==============================================================*/
/* Table: INGREDIENTE                                           */
/*==============================================================*/
create table INGREDIENTE (
   ID_INGREDIENTE       SERIAL               not null,
   NOMBRE_INGREDIENTE   CHAR(256)            not null,
   PRECIO_COSTO         NUMERIC              not null,
   STOCK                NUMERIC              null,
   CREATE_AT            DATE                 null,
   MODIFIED_AT          DATE                 null,
   constraint PK_INGREDIENTE primary key (ID_INGREDIENTE)
);

/*==============================================================*/
/* Index: INGREDIENTE_PK                                        */
/*==============================================================*/
create unique index INGREDIENTE_PK on INGREDIENTE (
ID_INGREDIENTE
);

/*==============================================================*/
/* Table: MARCA                                                 */
/*==============================================================*/
create table MARCA (
   ID_MARCA             SERIAL               not null,
   RUT_PROVEEDOR        CHAR(12)             null,
   ID_CATEGORIA         INT4                 null,
   NOMBRE_MARCA         CHAR(255)            null,
   CREATE_AT            DATE                 null,
   MODIFIED_AT          DATE                 null,
   constraint PK_MARCA primary key (ID_MARCA)
);

/*==============================================================*/
/* Index: MARCA_PK                                              */
/*==============================================================*/
create unique index MARCA_PK on MARCA (
ID_MARCA
);

/*==============================================================*/
/* Index: ENTREGA_FK                                            */
/*==============================================================*/
create  index ENTREGA_FK on MARCA (
RUT_PROVEEDOR
);

/*==============================================================*/
/* Index: CATEGORIZA_FK                                         */
/*==============================================================*/
create  index CATEGORIZA_FK on MARCA (
ID_CATEGORIA
);

/*==============================================================*/
/* Table: MARCA_INGREDIENTE                                     */
/*==============================================================*/
create table MARCA_INGREDIENTE (
   ID_INGREDIENTE       INT4                 not null,
   ID_MARCA             INT4                 not null,
   constraint PK_MARCA_INGREDIENTE primary key (ID_INGREDIENTE, ID_MARCA)
);

/*==============================================================*/
/* Index: PROVEE_PK                                             */
/*==============================================================*/
create unique index PROVEE_PK on MARCA_INGREDIENTE (
ID_INGREDIENTE,
ID_MARCA
);

/*==============================================================*/
/* Index: PROVEE2_FK                                            */
/*==============================================================*/
create  index PROVEE2_FK on MARCA_INGREDIENTE (
ID_MARCA
);

/*==============================================================*/
/* Index: PROVEE_FK                                             */
/*==============================================================*/
create  index PROVEE_FK on MARCA_INGREDIENTE (
ID_INGREDIENTE
);

/*==============================================================*/
/* Table: MEDIO_PAGO                                            */
/*==============================================================*/
create table MEDIO_PAGO (
   ID_MEDIO_PAGO        SERIAL               not null,
   DESCRIPCION_MEDIO_PAGO CHAR(100)            not null,
   CREATE_AT            DATE                 null,
   MODIFIED_AT          DATE                 null,
   constraint PK_MEDIO_PAGO primary key (ID_MEDIO_PAGO)
);

/*==============================================================*/
/* Index: MEDIO_PAGO_PK                                         */
/*==============================================================*/
create unique index MEDIO_PAGO_PK on MEDIO_PAGO (
ID_MEDIO_PAGO
);

/*==============================================================*/
/* Table: MESA                                                  */
/*==============================================================*/
create table MESA (
   ID_MESA              SERIAL               not null,
   ID_SECTOR            INT4                 not null,
   CANTIDA_PERSONAS     INT4                 null,
   CREATE_AT            DATE                 null,
   MODIFIED_AT          DATE                 null,
   constraint PK_MESA primary key (ID_MESA)
);

/*==============================================================*/
/* Index: MESA_PK                                               */
/*==============================================================*/
create unique index MESA_PK on MESA (
ID_MESA
);

/*==============================================================*/
/* Index: PERTENECE_FK                                          */
/*==============================================================*/
create  index PERTENECE_FK on MESA (
ID_SECTOR
);

/*==============================================================*/
/* Table: PRODUCTO                                              */
/*==============================================================*/
create table PRODUCTO (
   ID_PRODUCTO          SERIAL               not null,
   NOMBRE_PRODUCTO      CHAR(256)            null,
   VALOR_UNITARIO       NUMERIC              null,
   CREATE_AT            DATE                 null,
   MODIFIED_AT          DATE                 null,
   constraint PK_PRODUCTO primary key (ID_PRODUCTO)
);

/*==============================================================*/
/* Index: PRODUCTO_PK                                           */
/*==============================================================*/
create unique index PRODUCTO_PK on PRODUCTO (
ID_PRODUCTO
);

/*==============================================================*/
/* Table: PROVEEDOR                                             */
/*==============================================================*/
create table PROVEEDOR (
   RUT_PROVEEDOR        CHAR(12)             not null,
   ID_COMUNA            INT4                 not null,
   RAZON_SOCIAL         CHAR(255)            not null,
   DIRECCION            CHAR(300)            null,
   NOMBRE_FANTASIA      CHAR(300)            null,
   FONO_CONTACTO        NUMERIC              null,
   MAIL_CONTACTO        CHAR(300)            null,
   CREATE_AT            DATE                 null,
   MODIFIED_AT          DATE                 null,
   constraint PK_PROVEEDOR primary key (RUT_PROVEEDOR)
);

/*==============================================================*/
/* Index: PROVEEDOR_PK                                          */
/*==============================================================*/
create unique index PROVEEDOR_PK on PROVEEDOR (
RUT_PROVEEDOR
);

/*==============================================================*/
/* Index: LOCALIZADO_FK                                         */
/*==============================================================*/
create  index LOCALIZADO_FK on PROVEEDOR (
ID_COMUNA
);

/*==============================================================*/
/* Table: PROVINCIA                                             */
/*==============================================================*/
create table PROVINCIA (
   ID_PROVINCIA         SERIAL               not null,
   ID_REGION            INT4                 null,
   NOMBRE_PROVINCIA     CHAR(255)            not null,
   CANT_COMUNAS         NUMERIC              null,
   CREATE_AT            DATE                 null,
   MODIFIED_AT          DATE                 null,
   constraint PK_PROVINCIA primary key (ID_PROVINCIA)
);

/*==============================================================*/
/* Index: PROVINCIA_PK                                          */
/*==============================================================*/
create unique index PROVINCIA_PK on PROVINCIA (
ID_PROVINCIA
);

/*==============================================================*/
/* Index: REUNE_FK                                              */
/*==============================================================*/
create  index REUNE_FK on PROVINCIA (
ID_REGION
);

/*==============================================================*/
/* Table: RECETA                                                */
/*==============================================================*/
create table RECETA (
   ID_PRODUCTO          INT4                 not null,
   ID_INGREDIENTE       INT4                 not null,
   CANTIDAD             NUMERIC              null,
   constraint PK_RECETA primary key (ID_PRODUCTO, ID_INGREDIENTE)
);

/*==============================================================*/
/* Index: RECETA_PK                                             */
/*==============================================================*/
create unique index RECETA_PK on RECETA (
ID_PRODUCTO,
ID_INGREDIENTE
);

/*==============================================================*/
/* Index: CONTIENE_FK                                           */
/*==============================================================*/
create  index CONTIENE_FK on RECETA (
ID_PRODUCTO
);

/*==============================================================*/
/* Index: CONTIENE2_FK                                          */
/*==============================================================*/
create  index CONTIENE2_FK on RECETA (
ID_INGREDIENTE
);

/*==============================================================*/
/* Table: REGION                                                */
/*==============================================================*/
create table REGION (
   ID_REGION            SERIAL               not null,
   NOMBRE_REGION        CHAR(300)            not null,
   NRO_ROMANO           CHAR(5)              not null,
   CANT_PROVINCIAS      NUMERIC              null,
   CANT_COMUNAS         NUMERIC              null,
   CREATE_AT            DATE                 null,
   MODIFIED_AT          DATE                 null,
   constraint PK_REGION primary key (ID_REGION)
);

/*==============================================================*/
/* Index: REGION_PK                                             */
/*==============================================================*/
create unique index REGION_PK on REGION (
ID_REGION
);

/*==============================================================*/
/* Table: SECTOR                                                */
/*==============================================================*/
create table SECTOR (
   ID_SECTOR            SERIAL               not null,
   DESCRIPCION          CHAR(256)            null,
   PISO                 INT4                 null,
   CREATED_AT           DATE                 null,
   MODIFIED_AT          DATE                 null,
   constraint PK_SECTOR primary key (ID_SECTOR)
);

/*==============================================================*/
/* Index: SECTOR_PK                                             */
/*==============================================================*/
create unique index SECTOR_PK on SECTOR (
ID_SECTOR
);

/*==============================================================*/
/* Table: VENTA                                                 */
/*==============================================================*/
create table VENTA (
   ID_VENTA             SERIAL               not null,
   RUT_EMPLEADO         CHAR(11)             not null,
   ID_MESA              INT4                 not null,
   FECHA_VENTA          DATE                 not null,
   MONTO_NETO           NUMERIC              not null,
   MONTO_IMPUESTO       NUMERIC              not null,
   MONTO_DESCUENTO      NUMERIC              not null,
   MONTO_PROPINA        NUMERIC              null,
   MONTO_FINAL          NUMERIC              not null,
   CREATE_AT            DATE                 null,
   MODIFIED_AT          DATE                 null,
   constraint PK_VENTA primary key (ID_VENTA)
);

/*==============================================================*/
/* Index: VENTA_PK                                              */
/*==============================================================*/
create unique index VENTA_PK on VENTA (
ID_VENTA
);

/*==============================================================*/
/* Index: REALIZA_FK                                            */
/*==============================================================*/
create  index REALIZA_FK on VENTA (
RUT_EMPLEADO
);

/*==============================================================*/
/* Index: ASIGNADA_FK                                           */
/*==============================================================*/
create  index ASIGNADA_FK on VENTA (
ID_MESA
);

alter table COMUNA
   add constraint FK_COMUNA_ORGANIZA_PROVINCI foreign key (ID_PROVINCIA)
      references PROVINCIA (ID_PROVINCIA)
      on delete restrict on update restrict;

alter table DETALLEPAGO
   add constraint FK_DETALLEP_FORMAPAGO_MEDIO_PA foreign key (ID_MEDIO_PAGO)
      references MEDIO_PAGO (ID_MEDIO_PAGO)
      on delete restrict on update restrict;

alter table DETALLEPAGO
   add constraint FK_DETALLEP_POSEE_VENTA foreign key (ID_VENTA)
      references VENTA (ID_VENTA)
      on delete restrict on update restrict;

alter table DETALLE_VENTA
   add constraint FK_DETALLE__CONFORMA_VENTA foreign key (ID_VENTA)
      references VENTA (ID_VENTA)
      on delete restrict on update restrict;

alter table DETALLE_VENTA
   add constraint FK_DETALLE__CONFORMA2_PRODUCTO foreign key (ID_PRODUCTO)
      references PRODUCTO (ID_PRODUCTO)
      on delete restrict on update restrict;

alter table EMPLEADO
   add constraint FK_EMPLEADO_AGRUPA_CARGO foreign key (ID_CARGO)
      references CARGO (ID_CARGO)
      on delete restrict on update restrict;

alter table MARCA
   add constraint FK_MARCA_CATEGORIZ_CATEGORI foreign key (ID_CATEGORIA)
      references CATEGORIA (ID_CATEGORIA)
      on delete restrict on update restrict;

alter table MARCA
   add constraint FK_MARCA_ENTREGA_PROVEEDO foreign key (RUT_PROVEEDOR)
      references PROVEEDOR (RUT_PROVEEDOR)
      on delete restrict on update restrict;

alter table MARCA_INGREDIENTE
   add constraint FK_MARCA_IN_PROVEE_INGREDIE foreign key (ID_INGREDIENTE)
      references INGREDIENTE (ID_INGREDIENTE)
      on delete restrict on update restrict;

alter table MARCA_INGREDIENTE
   add constraint FK_MARCA_IN_PROVEE2_MARCA foreign key (ID_MARCA)
      references MARCA (ID_MARCA)
      on delete restrict on update restrict;

alter table MESA
   add constraint FK_MESA_PERTENECE_SECTOR foreign key (ID_SECTOR)
      references SECTOR (ID_SECTOR)
      on delete restrict on update restrict;

alter table PROVEEDOR
   add constraint FK_PROVEEDO_LOCALIZAD_COMUNA foreign key (ID_COMUNA)
      references COMUNA (ID_COMUNA)
      on delete restrict on update restrict;

alter table PROVINCIA
   add constraint FK_PROVINCI_REUNE_REGION foreign key (ID_REGION)
      references REGION (ID_REGION)
      on delete restrict on update restrict;

alter table RECETA
   add constraint FK_RECETA_CONTIENE_PRODUCTO foreign key (ID_PRODUCTO)
      references PRODUCTO (ID_PRODUCTO)
      on delete restrict on update restrict;

alter table RECETA
   add constraint FK_RECETA_CONTIENE2_INGREDIE foreign key (ID_INGREDIENTE)
      references INGREDIENTE (ID_INGREDIENTE)
      on delete restrict on update restrict;

alter table VENTA
   add constraint FK_VENTA_ASIGNADA_MESA foreign key (ID_MESA)
      references MESA (ID_MESA)
      on delete restrict on update restrict;

alter table VENTA
   add constraint FK_VENTA_REALIZA_EMPLEADO foreign key (RUT_EMPLEADO)
      references EMPLEADO (RUT_EMPLEADO)
      on delete restrict on update restrict;

