-- =============================================================================
-- Sistema de Postulacion y Preseleccion de la Beca Comedor (DUBSS - UAGRM)
-- Script de creacion de la base de datos - PostgreSQL 18
-- Generado a partir del diseno logico de la base de datos (31 tablas).
-- =============================================================================

-- Requiere PostgreSQL 18 o superior (funcion uuidv7()).
-- Ejecutar conectado a la base de datos destino, p. ej.:
--   CREATE DATABASE beca_comedor ENCODING 'UTF8';

BEGIN;

-- -----------------------------------------------------------------------------
-- 1. Tipos enumerados
-- -----------------------------------------------------------------------------
CREATE TYPE estado_postulacion AS ENUM (
    'borrador', 'pendiente', 'devuelta', 'archivada', 'calificada', 'adjudicada', 'no_adjudicada');
CREATE TYPE estado_convocatoria AS ENUM (
    'BORRADOR', 'ABIERTA', 'CERRADA');
CREATE TYPE estado_beca AS ENUM (
    'VIGENTE', 'SUSPENDIDA', 'BAJA');
CREATE TYPE resultado_adjudicacion AS ENUM (
    'ADJUDICADA', 'NO_ADJUDICADA');
CREATE TYPE tipo_movimiento_beca AS ENUM (
    'BAJA', 'SUSPENSION', 'REACTIVACION', 'REEMPLAZO');
CREATE TYPE destinatarios_comunicado AS ENUM (
    'TODOS', 'FINALISTAS', 'ADJUDICADOS');
CREATE TYPE tipo_notificacion AS ENUM (
    'CAMBIO_ESTADO', 'FINALISTA', 'COMUNICADO', 'RESULTADO');

-- -----------------------------------------------------------------------------
-- 2. Tablas (en orden de dependencias)
--    Columnas comunes: codigo_<tabla> (UUID v7 publico), creado_en,
--    actualizado_en y eliminado_en (borrado logico).
-- -----------------------------------------------------------------------------

-- P1 - Cuentas y acceso

CREATE TABLE rol (
    id                        bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
    nombre                    varchar(50) NOT NULL,
    codigo_rol                uuid NOT NULL DEFAULT uuidv7() UNIQUE,
    creado_en                 timestamptz NOT NULL DEFAULT now(),
    actualizado_en            timestamptz NOT NULL DEFAULT now(),
    eliminado_en              timestamptz,
    CONSTRAINT pk_rol PRIMARY KEY (id)
);

CREATE TABLE usuario (
    id                        bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
    firebase_uid              varchar(128) NOT NULL,
    ci                        varchar(20) NOT NULL,
    correo                    varchar(150) NOT NULL,
    nombres                   varchar(100) NOT NULL,
    apellidos                 varchar(100) NOT NULL,
    activo                    boolean NOT NULL DEFAULT true,
    rol_id                    bigint NOT NULL REFERENCES rol(id) ON DELETE RESTRICT,
    codigo_usuario            uuid NOT NULL DEFAULT uuidv7() UNIQUE,
    creado_en                 timestamptz NOT NULL DEFAULT now(),
    actualizado_en            timestamptz NOT NULL DEFAULT now(),
    eliminado_en              timestamptz,
    CONSTRAINT pk_usuario PRIMARY KEY (id)
);

CREATE TABLE carrera (
    id                        bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
    nombre                    varchar(150) NOT NULL,
    facultad                  varchar(150) NOT NULL,
    codigo_carrera            uuid NOT NULL DEFAULT uuidv7() UNIQUE,
    creado_en                 timestamptz NOT NULL DEFAULT now(),
    actualizado_en            timestamptz NOT NULL DEFAULT now(),
    eliminado_en              timestamptz,
    CONSTRAINT pk_carrera PRIMARY KEY (id)
);

CREATE TABLE postulante (
    usuario_id                bigint NOT NULL REFERENCES usuario(id) ON DELETE RESTRICT,
    carrera_id                bigint NOT NULL REFERENCES carrera(id) ON DELETE RESTRICT,
    registro_universitario    varchar(20),
    telefono                  varchar(20),
    codigo_postulante         uuid NOT NULL DEFAULT uuidv7() UNIQUE,
    creado_en                 timestamptz NOT NULL DEFAULT now(),
    actualizado_en            timestamptz NOT NULL DEFAULT now(),
    eliminado_en              timestamptz,
    CONSTRAINT pk_postulante PRIMARY KEY (usuario_id)
);

-- P2 - Convocatoria y postulacion

CREATE TABLE gestion_academica (
    id                        bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
    etiqueta                  varchar(20) NOT NULL,
    fecha_inicio              date NOT NULL,
    fecha_fin                 date NOT NULL,
    codigo_gestion_academica  uuid NOT NULL DEFAULT uuidv7() UNIQUE,
    creado_en                 timestamptz NOT NULL DEFAULT now(),
    actualizado_en            timestamptz NOT NULL DEFAULT now(),
    eliminado_en              timestamptz,
    CONSTRAINT pk_gestion_academica PRIMARY KEY (id),
    CONSTRAINT ck_gestion_academica_1 CHECK (fecha_fin >= fecha_inicio)
);

CREATE TABLE convocatoria (
    id                        bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
    gestion_id                bigint NOT NULL REFERENCES gestion_academica(id) ON DELETE RESTRICT,
    nombre                    varchar(150) NOT NULL,
    fecha_apertura            timestamptz NOT NULL,
    fecha_cierre              timestamptz NOT NULL,
    cupos                     integer,
    puntaje_minimo            numeric(5,2),
    estado                    estado_convocatoria NOT NULL DEFAULT 'BORRADOR',
    creado_por                bigint NOT NULL REFERENCES usuario(id) ON DELETE RESTRICT,
    codigo_convocatoria       uuid NOT NULL DEFAULT uuidv7() UNIQUE,
    creado_en                 timestamptz NOT NULL DEFAULT now(),
    actualizado_en            timestamptz NOT NULL DEFAULT now(),
    eliminado_en              timestamptz,
    CONSTRAINT pk_convocatoria PRIMARY KEY (id),
    CONSTRAINT ck_convocatoria_1 CHECK (fecha_cierre > fecha_apertura),
    CONSTRAINT ck_convocatoria_2 CHECK (cupos > 0),
    CONSTRAINT ck_convocatoria_3 CHECK (puntaje_minimo BETWEEN 0 AND 100)
);

CREATE TABLE tipo_documento (
    id                        bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
    nombre                    varchar(100) NOT NULL,
    descripcion               varchar(255),
    codigo_tipo_documento     uuid NOT NULL DEFAULT uuidv7() UNIQUE,
    creado_en                 timestamptz NOT NULL DEFAULT now(),
    actualizado_en            timestamptz NOT NULL DEFAULT now(),
    eliminado_en              timestamptz,
    CONSTRAINT pk_tipo_documento PRIMARY KEY (id)
);

CREATE TABLE convocatoria_documento (
    convocatoria_id           bigint NOT NULL REFERENCES convocatoria(id) ON DELETE RESTRICT,
    tipo_documento_id         bigint NOT NULL REFERENCES tipo_documento(id) ON DELETE RESTRICT,
    obligatorio               boolean NOT NULL DEFAULT true,
    codigo_convocatoria_documento uuid NOT NULL DEFAULT uuidv7() UNIQUE,
    creado_en                 timestamptz NOT NULL DEFAULT now(),
    actualizado_en            timestamptz NOT NULL DEFAULT now(),
    eliminado_en              timestamptz,
    CONSTRAINT pk_convocatoria_documento PRIMARY KEY (convocatoria_id, tipo_documento_id)
);

CREATE TABLE postulacion (
    id                        bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
    postulante_id             bigint NOT NULL REFERENCES postulante(usuario_id) ON DELETE RESTRICT,
    convocatoria_id           bigint NOT NULL REFERENCES convocatoria(id) ON DELETE RESTRICT,
    estado                    estado_postulacion NOT NULL DEFAULT 'borrador',
    fecha_envio               timestamptz,
    numero_envios             smallint NOT NULL DEFAULT 0,
    codigo_postulacion        uuid NOT NULL DEFAULT uuidv7() UNIQUE,
    creado_en                 timestamptz NOT NULL DEFAULT now(),
    actualizado_en            timestamptz NOT NULL DEFAULT now(),
    eliminado_en              timestamptz,
    CONSTRAINT pk_postulacion PRIMARY KEY (id),
    CONSTRAINT ck_postulacion_1 CHECK (numero_envios >= 0)
);

CREATE TABLE respuesta_socioeconomica (
    postulacion_id            bigint NOT NULL REFERENCES postulacion(id) ON DELETE RESTRICT,
    ingresos_familiares       numeric(12,2),
    dependientes              smallint,
    procedencia               varchar(150),
    patrimonio                varchar(255),
    estado_vulnerabilidad     varchar(50),
    promedio_academico        numeric(5,2),
    datos_extra               jsonb,
    codigo_respuesta_socioeconomica uuid NOT NULL DEFAULT uuidv7() UNIQUE,
    creado_en                 timestamptz NOT NULL DEFAULT now(),
    actualizado_en            timestamptz NOT NULL DEFAULT now(),
    eliminado_en              timestamptz,
    CONSTRAINT pk_respuesta_socioeconomica PRIMARY KEY (postulacion_id),
    CONSTRAINT ck_respuesta_socioeconomica_1 CHECK (promedio_academico BETWEEN 0 AND 100),
    CONSTRAINT ck_respuesta_socioeconomica_2 CHECK (ingresos_familiares >= 0),
    CONSTRAINT ck_respuesta_socioeconomica_3 CHECK (dependientes >= 0)
);

CREATE TABLE nota_academica (
    id                        bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
    postulacion_id            bigint NOT NULL REFERENCES postulacion(id) ON DELETE RESTRICT,
    periodo                   varchar(20) NOT NULL,
    promedio                  numeric NOT NULL,
    codigo_nota_academica     uuid NOT NULL DEFAULT uuidv7() UNIQUE,
    creado_en                 timestamptz NOT NULL DEFAULT now(),
    actualizado_en            timestamptz NOT NULL DEFAULT now(),
    eliminado_en              timestamptz,
    CONSTRAINT pk_nota_academica PRIMARY KEY (id)
);

CREATE TABLE documento_adjunto (
    id                        bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
    postulacion_id            bigint NOT NULL REFERENCES postulacion(id) ON DELETE RESTRICT,
    tipo_documento_id         bigint NOT NULL REFERENCES tipo_documento(id) ON DELETE RESTRICT,
    nombre_archivo            varchar(255) NOT NULL,
    storage_path              varchar(500) NOT NULL,
    mime_type                 varchar(100) NOT NULL,
    tamano_bytes              bigint NOT NULL,
    subido_en                 timestamptz NOT NULL DEFAULT now(),
    codigo_documento_adjunto  uuid NOT NULL DEFAULT uuidv7() UNIQUE,
    creado_en                 timestamptz NOT NULL DEFAULT now(),
    actualizado_en            timestamptz NOT NULL DEFAULT now(),
    eliminado_en              timestamptz,
    CONSTRAINT pk_documento_adjunto PRIMARY KEY (id),
    CONSTRAINT ck_documento_adjunto_1 CHECK (tamano_bytes > 0)
);

CREATE TABLE postulacion_historial (
    id                        bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
    postulacion_id            bigint NOT NULL REFERENCES postulacion(id) ON DELETE RESTRICT,
    estado_anterior           estado_postulacion,
    estado_nuevo              estado_postulacion NOT NULL,
    usuario_id                bigint REFERENCES usuario(id) ON DELETE RESTRICT,
    motivo                    text,
    codigo_postulacion_historial uuid NOT NULL DEFAULT uuidv7() UNIQUE,
    creado_en                 timestamptz NOT NULL DEFAULT now(),
    actualizado_en            timestamptz NOT NULL DEFAULT now(),
    eliminado_en              timestamptz,
    CONSTRAINT pk_postulacion_historial PRIMARY KEY (id)
);

-- P3 - Preseleccion con IA

CREATE TABLE modelo_preseleccion (
    id                        bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
    version                   varchar(20) NOT NULL,
    descripcion               varchar(255),
    activo                    boolean NOT NULL DEFAULT false,
    creado_por                bigint REFERENCES usuario(id) ON DELETE RESTRICT,
    codigo_modelo_preseleccion uuid NOT NULL DEFAULT uuidv7() UNIQUE,
    creado_en                 timestamptz NOT NULL DEFAULT now(),
    actualizado_en            timestamptz NOT NULL DEFAULT now(),
    eliminado_en              timestamptz,
    CONSTRAINT pk_modelo_preseleccion PRIMARY KEY (id)
);

CREATE TABLE parametro_modelo (
    id                        bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
    modelo_id                 bigint NOT NULL REFERENCES modelo_preseleccion(id) ON DELETE RESTRICT,
    clave                     varchar(100) NOT NULL,
    ponderacion               numeric,
    valor                     jsonb,
    codigo_parametro_modelo   uuid NOT NULL DEFAULT uuidv7() UNIQUE,
    creado_en                 timestamptz NOT NULL DEFAULT now(),
    actualizado_en            timestamptz NOT NULL DEFAULT now(),
    eliminado_en              timestamptz,
    CONSTRAINT pk_parametro_modelo PRIMARY KEY (id)
);

CREATE TABLE puntaje_postulacion (
    id                        bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
    postulacion_id            bigint NOT NULL REFERENCES postulacion(id) ON DELETE RESTRICT,
    modelo_id                 bigint NOT NULL REFERENCES modelo_preseleccion(id) ON DELETE RESTRICT,
    puntaje_total             numeric(5,2) NOT NULL,
    detalle                   jsonb,
    fecha_calculo             timestamptz NOT NULL DEFAULT now(),
    vigente                   boolean NOT NULL DEFAULT true,
    codigo_puntaje_postulacion uuid NOT NULL DEFAULT uuidv7() UNIQUE,
    creado_en                 timestamptz NOT NULL DEFAULT now(),
    actualizado_en            timestamptz NOT NULL DEFAULT now(),
    eliminado_en              timestamptz,
    CONSTRAINT pk_puntaje_postulacion PRIMARY KEY (id),
    CONSTRAINT ck_puntaje_postulacion_1 CHECK (puntaje_total BETWEEN 0 AND 100)
);

CREATE TABLE lote_reprocesamiento (
    id                        bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
    convocatoria_id           bigint NOT NULL REFERENCES convocatoria(id) ON DELETE RESTRICT,
    modelo_id                 bigint NOT NULL REFERENCES modelo_preseleccion(id) ON DELETE RESTRICT,
    solicitado_por            bigint NOT NULL REFERENCES usuario(id) ON DELETE RESTRICT,
    estado                    varchar(20) NOT NULL DEFAULT 'PENDIENTE',
    total_postulaciones       integer NOT NULL DEFAULT 0,
    iniciado_en               timestamptz,
    terminado_en              timestamptz,
    codigo_lote_reprocesamiento uuid NOT NULL DEFAULT uuidv7() UNIQUE,
    creado_en                 timestamptz NOT NULL DEFAULT now(),
    actualizado_en            timestamptz NOT NULL DEFAULT now(),
    eliminado_en              timestamptz,
    CONSTRAINT pk_lote_reprocesamiento PRIMARY KEY (id),
    CONSTRAINT ck_lote_reprocesamiento_1
        CHECK (estado IN ('PENDIENTE', 'EN_PROCESO', 'COMPLETADO', 'FALLIDO')),
    CONSTRAINT ck_lote_reprocesamiento_2 CHECK (total_postulaciones >= 0)
);

-- P4 - Auditoria y adjudicacion

CREATE TABLE finalista (
    id                        bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
    postulacion_id            bigint NOT NULL REFERENCES postulacion(id) ON DELETE RESTRICT,
    posicion                  integer NOT NULL,
    notificado_en             timestamptz,
    plazo_entrega             date,
    documentacion_recibida_en timestamptz,
    codigo_finalista          uuid NOT NULL DEFAULT uuidv7() UNIQUE,
    creado_en                 timestamptz NOT NULL DEFAULT now(),
    actualizado_en            timestamptz NOT NULL DEFAULT now(),
    eliminado_en              timestamptz,
    CONSTRAINT pk_finalista PRIMARY KEY (id),
    CONSTRAINT ck_finalista_1 CHECK (posicion > 0)
);

CREATE TABLE auditoria_expediente (
    id                        bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
    finalista_id              bigint NOT NULL REFERENCES finalista(id) ON DELETE RESTRICT,
    auditor_id                bigint NOT NULL REFERENCES usuario(id) ON DELETE RESTRICT,
    resultado                 varchar(20) NOT NULL,
    observaciones             text,
    fecha_auditoria           timestamptz NOT NULL DEFAULT now(),
    codigo_auditoria_expediente uuid NOT NULL DEFAULT uuidv7() UNIQUE,
    creado_en                 timestamptz NOT NULL DEFAULT now(),
    actualizado_en            timestamptz NOT NULL DEFAULT now(),
    eliminado_en              timestamptz,
    CONSTRAINT pk_auditoria_expediente PRIMARY KEY (id),
    CONSTRAINT ck_auditoria_expediente_1
        CHECK (resultado IN ('VALIDADO', 'OBSERVADO', 'NO_VALIDO'))
);

CREATE TABLE adjudicacion (
    id                        bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
    postulacion_id            bigint NOT NULL REFERENCES postulacion(id) ON DELETE RESTRICT,
    resultado                 resultado_adjudicacion NOT NULL,
    puntaje_final             numeric(5,2),
    decidido_por              bigint NOT NULL REFERENCES usuario(id) ON DELETE RESTRICT,
    fecha_adjudicacion        timestamptz NOT NULL DEFAULT now(),
    codigo_adjudicacion       uuid NOT NULL DEFAULT uuidv7() UNIQUE,
    creado_en                 timestamptz NOT NULL DEFAULT now(),
    actualizado_en            timestamptz NOT NULL DEFAULT now(),
    eliminado_en              timestamptz,
    CONSTRAINT pk_adjudicacion PRIMARY KEY (id),
    CONSTRAINT ck_adjudicacion_1 CHECK (puntaje_final BETWEEN 0 AND 100)
);

CREATE TABLE acta_adjudicacion (
    id                        bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
    convocatoria_id           bigint NOT NULL REFERENCES convocatoria(id) ON DELETE RESTRICT,
    numero                    varchar(30) NOT NULL,
    storage_path              varchar(500) NOT NULL,
    generada_por              bigint NOT NULL REFERENCES usuario(id) ON DELETE RESTRICT,
    generada_en               timestamptz NOT NULL DEFAULT now(),
    codigo_acta_adjudicacion  uuid NOT NULL DEFAULT uuidv7() UNIQUE,
    creado_en                 timestamptz NOT NULL DEFAULT now(),
    actualizado_en            timestamptz NOT NULL DEFAULT now(),
    eliminado_en              timestamptz,
    CONSTRAINT pk_acta_adjudicacion PRIMARY KEY (id)
);

CREATE TABLE publicacion_resultado (
    id                        bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
    convocatoria_id           bigint NOT NULL REFERENCES convocatoria(id) ON DELETE RESTRICT,
    publicado_por             bigint NOT NULL REFERENCES usuario(id) ON DELETE RESTRICT,
    publicado_en              timestamptz NOT NULL DEFAULT now(),
    codigo_publicacion_resultado uuid NOT NULL DEFAULT uuidv7() UNIQUE,
    creado_en                 timestamptz NOT NULL DEFAULT now(),
    actualizado_en            timestamptz NOT NULL DEFAULT now(),
    eliminado_en              timestamptz,
    CONSTRAINT pk_publicacion_resultado PRIMARY KEY (id)
);

CREATE TABLE comunicado (
    id                        bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
    convocatoria_id           bigint REFERENCES convocatoria(id) ON DELETE RESTRICT,
    titulo                    varchar(150) NOT NULL,
    contenido                 text NOT NULL,
    destinatarios             destinatarios_comunicado NOT NULL,
    publicado_por             bigint NOT NULL REFERENCES usuario(id) ON DELETE RESTRICT,
    publicado_en              timestamptz NOT NULL DEFAULT now(),
    codigo_comunicado         uuid NOT NULL DEFAULT uuidv7() UNIQUE,
    creado_en                 timestamptz NOT NULL DEFAULT now(),
    actualizado_en            timestamptz NOT NULL DEFAULT now(),
    eliminado_en              timestamptz,
    CONSTRAINT pk_comunicado PRIMARY KEY (id)
);

CREATE TABLE notificacion (
    id                        bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
    usuario_id                bigint NOT NULL REFERENCES usuario(id) ON DELETE RESTRICT,
    tipo                      tipo_notificacion NOT NULL,
    titulo                    varchar(150) NOT NULL,
    mensaje                   text NOT NULL,
    postulacion_id            bigint REFERENCES postulacion(id) ON DELETE RESTRICT,
    comunicado_id             bigint REFERENCES comunicado(id) ON DELETE RESTRICT,
    leida                     boolean NOT NULL DEFAULT false,
    enviada_en                timestamptz,
    codigo_notificacion       uuid NOT NULL DEFAULT uuidv7() UNIQUE,
    creado_en                 timestamptz NOT NULL DEFAULT now(),
    actualizado_en            timestamptz NOT NULL DEFAULT now(),
    eliminado_en              timestamptz,
    CONSTRAINT pk_notificacion PRIMARY KEY (id)
);

CREATE TABLE dispositivo_fcm (
    id                        bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
    usuario_id                bigint NOT NULL REFERENCES usuario(id) ON DELETE RESTRICT,
    token                     varchar(255) NOT NULL,
    plataforma                varchar(10) NOT NULL,
    codigo_dispositivo_fcm    uuid NOT NULL DEFAULT uuidv7() UNIQUE,
    creado_en                 timestamptz NOT NULL DEFAULT now(),
    actualizado_en            timestamptz NOT NULL DEFAULT now(),
    eliminado_en              timestamptz,
    CONSTRAINT pk_dispositivo_fcm PRIMARY KEY (id),
    CONSTRAINT ck_dispositivo_fcm_1 CHECK (plataforma IN ('ANDROID', 'IOS', 'WEB'))
);

-- P5 - Becados y asistencia

CREATE TABLE beca (
    id                        bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
    adjudicacion_id           bigint NOT NULL REFERENCES adjudicacion(id) ON DELETE RESTRICT,
    postulante_id             bigint NOT NULL REFERENCES postulante(usuario_id) ON DELETE RESTRICT,
    convocatoria_id           bigint NOT NULL REFERENCES convocatoria(id) ON DELETE RESTRICT,
    estado                    estado_beca NOT NULL DEFAULT 'VIGENTE',
    fecha_inicio              date NOT NULL,
    fecha_fin                 date,
    codigo_beca               uuid NOT NULL DEFAULT uuidv7() UNIQUE,
    creado_en                 timestamptz NOT NULL DEFAULT now(),
    actualizado_en            timestamptz NOT NULL DEFAULT now(),
    eliminado_en              timestamptz,
    CONSTRAINT pk_beca PRIMARY KEY (id),
    CONSTRAINT ck_beca_1 CHECK (fecha_fin IS NULL OR fecha_fin >= fecha_inicio)
);

CREATE TABLE movimiento_beca (
    id                        bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
    beca_id                   bigint NOT NULL REFERENCES beca(id) ON DELETE RESTRICT,
    tipo                      tipo_movimiento_beca NOT NULL,
    motivo                    text NOT NULL,
    beca_reemplazante_id      bigint REFERENCES beca(id) ON DELETE RESTRICT,
    registrado_por            bigint NOT NULL REFERENCES usuario(id) ON DELETE RESTRICT,
    fecha                     date NOT NULL DEFAULT CURRENT_DATE,
    codigo_movimiento_beca    uuid NOT NULL DEFAULT uuidv7() UNIQUE,
    creado_en                 timestamptz NOT NULL DEFAULT now(),
    actualizado_en            timestamptz NOT NULL DEFAULT now(),
    eliminado_en              timestamptz,
    CONSTRAINT pk_movimiento_beca PRIMARY KEY (id),
    CONSTRAINT ck_movimiento_beca_1
        CHECK ((tipo = 'REEMPLAZO') = (beca_reemplazante_id IS NOT NULL))
);

CREATE TABLE planilla_asistencia (
    id                        bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
    convocatoria_id           bigint NOT NULL REFERENCES convocatoria(id) ON DELETE RESTRICT,
    fecha_desde               date NOT NULL,
    fecha_hasta               date NOT NULL,
    storage_path              varchar(500) NOT NULL,
    generada_por              bigint NOT NULL REFERENCES usuario(id) ON DELETE RESTRICT,
    generada_en               timestamptz NOT NULL DEFAULT now(),
    codigo_planilla_asistencia uuid NOT NULL DEFAULT uuidv7() UNIQUE,
    creado_en                 timestamptz NOT NULL DEFAULT now(),
    actualizado_en            timestamptz NOT NULL DEFAULT now(),
    eliminado_en              timestamptz,
    CONSTRAINT pk_planilla_asistencia PRIMARY KEY (id),
    CONSTRAINT ck_planilla_asistencia_1 CHECK (fecha_hasta >= fecha_desde)
);

CREATE TABLE asistencia (
    id                        bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
    beca_id                   bigint NOT NULL REFERENCES beca(id) ON DELETE RESTRICT,
    fecha                     date NOT NULL,
    hora_registro             timestamptz NOT NULL DEFAULT now(),
    registrado_por            bigint NOT NULL REFERENCES usuario(id) ON DELETE RESTRICT,
    codigo_asistencia         uuid NOT NULL DEFAULT uuidv7() UNIQUE,
    creado_en                 timestamptz NOT NULL DEFAULT now(),
    actualizado_en            timestamptz NOT NULL DEFAULT now(),
    eliminado_en              timestamptz,
    CONSTRAINT pk_asistencia PRIMARY KEY (id)
);

CREATE TABLE cotejo_asistencia (
    id                        bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
    planilla_id               bigint NOT NULL REFERENCES planilla_asistencia(id) ON DELETE RESTRICT,
    realizado_por             bigint NOT NULL REFERENCES usuario(id) ON DELETE RESTRICT,
    fecha_cotejo              date NOT NULL DEFAULT CURRENT_DATE,
    total_registros           integer NOT NULL,
    coincidencias             integer NOT NULL,
    discrepancias             integer NOT NULL,
    observaciones             text,
    resultado                 varchar(20) NOT NULL,
    codigo_cotejo_asistencia  uuid NOT NULL DEFAULT uuidv7() UNIQUE,
    creado_en                 timestamptz NOT NULL DEFAULT now(),
    actualizado_en            timestamptz NOT NULL DEFAULT now(),
    eliminado_en              timestamptz,
    CONSTRAINT pk_cotejo_asistencia PRIMARY KEY (id),
    CONSTRAINT ck_cotejo_asistencia_1 CHECK (total_registros >= 0),
    CONSTRAINT ck_cotejo_asistencia_2 CHECK (coincidencias >= 0),
    CONSTRAINT ck_cotejo_asistencia_3 CHECK (discrepancias >= 0),
    CONSTRAINT ck_cotejo_asistencia_4
        CHECK (resultado IN ('CONFORME', 'CON_DISCREPANCIAS'))
);

-- P6 - Reportes y trazabilidad

CREATE TABLE bitacora (
    id                        bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
    usuario_id                bigint REFERENCES usuario(id) ON DELETE RESTRICT,
    accion                    varchar(60) NOT NULL,
    entidad                   varchar(60) NOT NULL,
    entidad_id                bigint,
    detalle                   jsonb,
    ip                        inet,
    codigo_bitacora           uuid NOT NULL DEFAULT uuidv7() UNIQUE,
    creado_en                 timestamptz NOT NULL DEFAULT now(),
    actualizado_en            timestamptz NOT NULL DEFAULT now(),
    eliminado_en              timestamptz,
    CONSTRAINT pk_bitacora PRIMARY KEY (id)
);

-- -----------------------------------------------------------------------------
-- 3. Restricciones de unicidad (indices parciales que respetan el borrado logico)
-- -----------------------------------------------------------------------------
CREATE UNIQUE INDEX uq_rol_nombre
    ON rol (nombre)
    WHERE eliminado_en IS NULL;
CREATE UNIQUE INDEX uq_usuario_firebase_uid
    ON usuario (firebase_uid)
    WHERE eliminado_en IS NULL;
CREATE UNIQUE INDEX uq_usuario_ci
    ON usuario (ci)
    WHERE eliminado_en IS NULL;
CREATE UNIQUE INDEX uq_usuario_correo
    ON usuario (correo)
    WHERE eliminado_en IS NULL;
CREATE UNIQUE INDEX uq_carrera_nombre
    ON carrera (nombre)
    WHERE eliminado_en IS NULL;
CREATE UNIQUE INDEX uq_postulante_registro
    ON postulante (registro_universitario)
    WHERE eliminado_en IS NULL;
CREATE UNIQUE INDEX uq_gestion_etiqueta
    ON gestion_academica (etiqueta)
    WHERE eliminado_en IS NULL;
CREATE UNIQUE INDEX uq_convocatoria_abierta_por_gestion
    ON convocatoria (gestion_id)
    WHERE estado = 'ABIERTA' AND eliminado_en IS NULL;
CREATE UNIQUE INDEX uq_postulacion_postulante_convocatoria
    ON postulacion (postulante_id, convocatoria_id)
    WHERE eliminado_en IS NULL;
CREATE UNIQUE INDEX uq_nota_postulacion_periodo
    ON nota_academica (postulacion_id, periodo)
    WHERE eliminado_en IS NULL;
CREATE UNIQUE INDEX uq_modelo_version
    ON modelo_preseleccion (version)
    WHERE eliminado_en IS NULL;
CREATE UNIQUE INDEX uq_modelo_activo
    ON modelo_preseleccion (activo)
    WHERE activo AND eliminado_en IS NULL;
CREATE UNIQUE INDEX uq_parametro_modelo_clave
    ON parametro_modelo (modelo_id, clave)
    WHERE eliminado_en IS NULL;
CREATE UNIQUE INDEX uq_puntaje_vigente
    ON puntaje_postulacion (postulacion_id)
    WHERE vigente AND eliminado_en IS NULL;
CREATE UNIQUE INDEX uq_finalista_postulacion
    ON finalista (postulacion_id)
    WHERE eliminado_en IS NULL;
CREATE UNIQUE INDEX uq_adjudicacion_postulacion
    ON adjudicacion (postulacion_id)
    WHERE eliminado_en IS NULL;
CREATE UNIQUE INDEX uq_acta_numero
    ON acta_adjudicacion (numero)
    WHERE eliminado_en IS NULL;
CREATE UNIQUE INDEX uq_publicacion_convocatoria
    ON publicacion_resultado (convocatoria_id)
    WHERE eliminado_en IS NULL;
CREATE UNIQUE INDEX uq_dispositivo_token
    ON dispositivo_fcm (token)
    WHERE eliminado_en IS NULL;
CREATE UNIQUE INDEX uq_beca_adjudicacion
    ON beca (adjudicacion_id)
    WHERE eliminado_en IS NULL;
CREATE UNIQUE INDEX uq_asistencia_beca_fecha
    ON asistencia (beca_id, fecha)
    WHERE eliminado_en IS NULL;

-- -----------------------------------------------------------------------------
-- 4. Indices de consulta
-- -----------------------------------------------------------------------------
CREATE INDEX ix_postulacion_convocatoria_estado
    ON postulacion (convocatoria_id, estado)
    WHERE eliminado_en IS NULL;
CREATE INDEX ix_puntaje_lista_priorizada
    ON puntaje_postulacion (puntaje_total DESC)
    WHERE vigente AND eliminado_en IS NULL;
CREATE INDEX ix_postulacion_historial_postulacion
    ON postulacion_historial (postulacion_id, creado_en);
CREATE INDEX ix_documento_adjunto_postulacion
    ON documento_adjunto (postulacion_id)
    WHERE eliminado_en IS NULL;
CREATE INDEX ix_beca_convocatoria_estado
    ON beca (convocatoria_id, estado)
    WHERE eliminado_en IS NULL;
CREATE INDEX ix_beca_postulante
    ON beca (postulante_id)
    WHERE eliminado_en IS NULL;
CREATE INDEX ix_notificacion_no_leidas
    ON notificacion (usuario_id, leida, creado_en DESC)
    WHERE eliminado_en IS NULL;
CREATE INDEX ix_bitacora_usuario_fecha
    ON bitacora (usuario_id, creado_en);
CREATE INDEX ix_bitacora_accion_fecha
    ON bitacora (accion, creado_en);

-- -----------------------------------------------------------------------------
-- 5. Actualizacion automatica de actualizado_en
-- -----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_set_actualizado_en() RETURNS trigger
LANGUAGE plpgsql AS $$
BEGIN
    NEW.actualizado_en := now();
    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_rol_actualizado_en BEFORE UPDATE ON rol
    FOR EACH ROW EXECUTE FUNCTION fn_set_actualizado_en();
CREATE TRIGGER trg_usuario_actualizado_en BEFORE UPDATE ON usuario
    FOR EACH ROW EXECUTE FUNCTION fn_set_actualizado_en();
CREATE TRIGGER trg_carrera_actualizado_en BEFORE UPDATE ON carrera
    FOR EACH ROW EXECUTE FUNCTION fn_set_actualizado_en();
CREATE TRIGGER trg_postulante_actualizado_en BEFORE UPDATE ON postulante
    FOR EACH ROW EXECUTE FUNCTION fn_set_actualizado_en();
CREATE TRIGGER trg_gestion_academica_actualizado_en BEFORE UPDATE ON gestion_academica
    FOR EACH ROW EXECUTE FUNCTION fn_set_actualizado_en();
CREATE TRIGGER trg_convocatoria_actualizado_en BEFORE UPDATE ON convocatoria
    FOR EACH ROW EXECUTE FUNCTION fn_set_actualizado_en();
CREATE TRIGGER trg_tipo_documento_actualizado_en BEFORE UPDATE ON tipo_documento
    FOR EACH ROW EXECUTE FUNCTION fn_set_actualizado_en();
CREATE TRIGGER trg_convocatoria_documento_actualizado_en BEFORE UPDATE ON convocatoria_documento
    FOR EACH ROW EXECUTE FUNCTION fn_set_actualizado_en();
CREATE TRIGGER trg_postulacion_actualizado_en BEFORE UPDATE ON postulacion
    FOR EACH ROW EXECUTE FUNCTION fn_set_actualizado_en();
CREATE TRIGGER trg_respuesta_socioeconomica_actualizado_en BEFORE UPDATE ON respuesta_socioeconomica
    FOR EACH ROW EXECUTE FUNCTION fn_set_actualizado_en();
CREATE TRIGGER trg_nota_academica_actualizado_en BEFORE UPDATE ON nota_academica
    FOR EACH ROW EXECUTE FUNCTION fn_set_actualizado_en();
CREATE TRIGGER trg_documento_adjunto_actualizado_en BEFORE UPDATE ON documento_adjunto
    FOR EACH ROW EXECUTE FUNCTION fn_set_actualizado_en();
CREATE TRIGGER trg_modelo_preseleccion_actualizado_en BEFORE UPDATE ON modelo_preseleccion
    FOR EACH ROW EXECUTE FUNCTION fn_set_actualizado_en();
CREATE TRIGGER trg_parametro_modelo_actualizado_en BEFORE UPDATE ON parametro_modelo
    FOR EACH ROW EXECUTE FUNCTION fn_set_actualizado_en();
CREATE TRIGGER trg_puntaje_postulacion_actualizado_en BEFORE UPDATE ON puntaje_postulacion
    FOR EACH ROW EXECUTE FUNCTION fn_set_actualizado_en();
CREATE TRIGGER trg_lote_reprocesamiento_actualizado_en BEFORE UPDATE ON lote_reprocesamiento
    FOR EACH ROW EXECUTE FUNCTION fn_set_actualizado_en();
CREATE TRIGGER trg_finalista_actualizado_en BEFORE UPDATE ON finalista
    FOR EACH ROW EXECUTE FUNCTION fn_set_actualizado_en();
CREATE TRIGGER trg_auditoria_expediente_actualizado_en BEFORE UPDATE ON auditoria_expediente
    FOR EACH ROW EXECUTE FUNCTION fn_set_actualizado_en();
CREATE TRIGGER trg_adjudicacion_actualizado_en BEFORE UPDATE ON adjudicacion
    FOR EACH ROW EXECUTE FUNCTION fn_set_actualizado_en();
CREATE TRIGGER trg_acta_adjudicacion_actualizado_en BEFORE UPDATE ON acta_adjudicacion
    FOR EACH ROW EXECUTE FUNCTION fn_set_actualizado_en();
CREATE TRIGGER trg_publicacion_resultado_actualizado_en BEFORE UPDATE ON publicacion_resultado
    FOR EACH ROW EXECUTE FUNCTION fn_set_actualizado_en();
CREATE TRIGGER trg_comunicado_actualizado_en BEFORE UPDATE ON comunicado
    FOR EACH ROW EXECUTE FUNCTION fn_set_actualizado_en();
CREATE TRIGGER trg_notificacion_actualizado_en BEFORE UPDATE ON notificacion
    FOR EACH ROW EXECUTE FUNCTION fn_set_actualizado_en();
CREATE TRIGGER trg_dispositivo_fcm_actualizado_en BEFORE UPDATE ON dispositivo_fcm
    FOR EACH ROW EXECUTE FUNCTION fn_set_actualizado_en();
CREATE TRIGGER trg_beca_actualizado_en BEFORE UPDATE ON beca
    FOR EACH ROW EXECUTE FUNCTION fn_set_actualizado_en();
CREATE TRIGGER trg_movimiento_beca_actualizado_en BEFORE UPDATE ON movimiento_beca
    FOR EACH ROW EXECUTE FUNCTION fn_set_actualizado_en();
CREATE TRIGGER trg_planilla_asistencia_actualizado_en BEFORE UPDATE ON planilla_asistencia
    FOR EACH ROW EXECUTE FUNCTION fn_set_actualizado_en();
CREATE TRIGGER trg_asistencia_actualizado_en BEFORE UPDATE ON asistencia
    FOR EACH ROW EXECUTE FUNCTION fn_set_actualizado_en();
CREATE TRIGGER trg_cotejo_asistencia_actualizado_en BEFORE UPDATE ON cotejo_asistencia
    FOR EACH ROW EXECUTE FUNCTION fn_set_actualizado_en();

-- -----------------------------------------------------------------------------
-- 6. Tablas de solo insercion (append-only): bitacora y postulacion_historial
--    El rol de la aplicacion (app_user) no puede modificar ni eliminar filas.
-- -----------------------------------------------------------------------------
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'app_user') THEN
        REVOKE UPDATE, DELETE ON bitacora, postulacion_historial FROM app_user;
    END IF;
END;
$$;

-- -----------------------------------------------------------------------------
-- 7. Vista materializada de indicadores BI (CU-12), refrescada por lotes:
--    REFRESH MATERIALIZED VIEW mv_indicadores_convocatoria;
-- -----------------------------------------------------------------------------
CREATE MATERIALIZED VIEW mv_indicadores_convocatoria AS
SELECT
    g.id                AS gestion_id,
    g.etiqueta          AS gestion,
    c.id                AS convocatoria_id,
    c.nombre            AS convocatoria,
    (SELECT count(*) FROM postulacion p
      WHERE p.convocatoria_id = c.id AND p.estado <> 'borrador'
        AND p.eliminado_en IS NULL)                       AS postulaciones_recibidas,
    (SELECT count(*) FROM finalista f JOIN postulacion p ON p.id = f.postulacion_id
      WHERE p.convocatoria_id = c.id AND f.eliminado_en IS NULL) AS finalistas,
    (SELECT count(*) FROM adjudicacion a JOIN postulacion p ON p.id = a.postulacion_id
      WHERE p.convocatoria_id = c.id AND a.resultado = 'ADJUDICADA'
        AND a.eliminado_en IS NULL)                       AS becas_adjudicadas,
    (SELECT count(*) FROM beca b
      WHERE b.convocatoria_id = c.id AND b.estado = 'VIGENTE'
        AND b.eliminado_en IS NULL)                       AS becas_vigentes,
    (SELECT count(*) FROM asistencia s JOIN beca b ON b.id = s.beca_id
      WHERE b.convocatoria_id = c.id AND s.eliminado_en IS NULL) AS asistencias_registradas,
    now()               AS actualizado_en
FROM convocatoria c
JOIN gestion_academica g ON g.id = c.gestion_id
WHERE c.eliminado_en IS NULL;

CREATE UNIQUE INDEX uq_mv_indicadores_convocatoria ON mv_indicadores_convocatoria (convocatoria_id);

-- -----------------------------------------------------------------------------
-- 8. Datos iniciales del catalogo de roles
-- -----------------------------------------------------------------------------
INSERT INTO rol (nombre) VALUES
    ('POSTULANTE'), ('ADMINISTRADOR_DUBSS'), ('DIRECTIVO'), ('PERSONAL_COMEDOR');

COMMIT;
