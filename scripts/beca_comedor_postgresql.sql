-- =============================================================================
-- Sistema de Postulacion y Preseleccion de la Beca Comedor (DUBSS - UAGRM)
-- Script de creacion de la base de datos - PostgreSQL 18
-- Generado a partir del diseno logico de la base de datos (32 tablas).
-- Las 24 tablas ya implementadas replican exactamente las migraciones Flyway del backend
-- (projects/backend/comedor-uagrm-core/src/main/resources/db/migration); las 8 restantes
-- (nota_academica, parametro_modelo, lote_reprocesamiento, beca, movimiento_beca, planilla_asistencia, asistencia, cotejo_asistencia) siguen el diseno y se crearan en sus casos de uso.
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
    'BORRADOR', 'ABIERTA', 'CERRADA', 'PUBLICADA');
CREATE TYPE estado_beca AS ENUM (
    'VIGENTE', 'SUSPENDIDA', 'BAJA');
CREATE TYPE resultado_adjudicacion AS ENUM (
    'ADJUDICADA', 'NO_ADJUDICADA');
CREATE TYPE resultado_auditoria AS ENUM (
    'VALIDADO', 'OBSERVADO', 'NO_VALIDO');
CREATE TYPE tipo_movimiento_beca AS ENUM (
    'BAJA', 'SUSPENSION', 'REACTIVACION', 'REEMPLAZO');
CREATE TYPE destinatarios_comunicado AS ENUM (
    'TODOS', 'FINALISTAS', 'ADJUDICADOS');
CREATE TYPE tipo_notificacion AS ENUM (
    'SUCCESS', 'INFO', 'WARNING', 'ERROR');

-- -----------------------------------------------------------------------------
-- 2. Tablas (en orden de dependencias)
--    Columnas comunes: codigo_<tabla> (UUID v7 publico), creado_en,
--    actualizado_en y eliminado_en (borrado logico).
-- -----------------------------------------------------------------------------

-- P1 - Cuentas y acceso

CREATE TABLE rol (
    id                        bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
    codigo_rol                uuid NOT NULL DEFAULT uuidv7() UNIQUE,
    nombre                    varchar(50) NOT NULL,
    creado_en                 timestamptz NOT NULL DEFAULT now(),
    actualizado_en            timestamptz NOT NULL DEFAULT now(),
    eliminado_en              timestamptz,
    CONSTRAINT pk_rol PRIMARY KEY (id)
);

CREATE TABLE usuario (
    id                        bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
    codigo_usuario            uuid NOT NULL DEFAULT uuidv7() UNIQUE,
    rol_id                    bigint NOT NULL REFERENCES rol(id),
    ci                        varchar(20) NOT NULL,
    correo                    varchar(150) NOT NULL,
    nombres                   varchar(100) NOT NULL,
    apellidos                 varchar(100) NOT NULL,
    activo                    boolean NOT NULL DEFAULT true,
    creado_en                 timestamptz NOT NULL DEFAULT now(),
    actualizado_en            timestamptz NOT NULL DEFAULT now(),
    eliminado_en              timestamptz,
    password_hash             varchar(100) NOT NULL,
    intentos_fallidos         integer NOT NULL DEFAULT 0,
    bloqueos_consecutivos     integer NOT NULL DEFAULT 0,
    bloqueado_hasta           timestamptz,
    restablecimiento_token_hash varchar(64),
    restablecimiento_expira_en timestamptz,
    CONSTRAINT pk_usuario PRIMARY KEY (id)
);

CREATE TABLE sesion (
    id                        bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
    codigo_sesion             uuid NOT NULL DEFAULT uuidv7() UNIQUE,
    usuario_id                bigint NOT NULL REFERENCES usuario(id),
    token_hash                varchar(64) NOT NULL,
    expira_en                 timestamptz NOT NULL,
    revocada_en               timestamptz,
    creado_en                 timestamptz NOT NULL DEFAULT now(),
    actualizado_en            timestamptz NOT NULL DEFAULT now(),
    eliminado_en              timestamptz,
    CONSTRAINT pk_sesion PRIMARY KEY (id)
);

CREATE TABLE carrera (
    id                        bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
    codigo_carrera            uuid NOT NULL DEFAULT uuidv7() UNIQUE,
    nombre                    varchar(150) NOT NULL,
    facultad                  varchar(150) NOT NULL,
    creado_en                 timestamptz NOT NULL DEFAULT now(),
    actualizado_en            timestamptz NOT NULL DEFAULT now(),
    eliminado_en              timestamptz,
    CONSTRAINT pk_carrera PRIMARY KEY (id)
);

CREATE TABLE postulante (
    usuario_id                bigint NOT NULL REFERENCES usuario(id),
    codigo_postulante         uuid NOT NULL DEFAULT uuidv7() UNIQUE,
    carrera_id                bigint NOT NULL REFERENCES carrera(id),
    registro_universitario    varchar(20) NOT NULL,
    telefono                  varchar(20) NOT NULL,
    creado_en                 timestamptz NOT NULL DEFAULT now(),
    actualizado_en            timestamptz NOT NULL DEFAULT now(),
    eliminado_en              timestamptz,
    CONSTRAINT pk_postulante PRIMARY KEY (usuario_id)
);

-- P2 - Convocatoria y postulacion

CREATE TABLE gestion_academica (
    id                        bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
    codigo_gestion_academica  uuid NOT NULL DEFAULT uuidv7() UNIQUE,
    etiqueta                  varchar(50) NOT NULL,
    fecha_inicio              date NOT NULL,
    fecha_fin                 date NOT NULL,
    creado_en                 timestamptz NOT NULL DEFAULT now(),
    actualizado_en            timestamptz NOT NULL DEFAULT now(),
    eliminado_en              timestamptz,
    CONSTRAINT pk_gestion_academica PRIMARY KEY (id),
    CONSTRAINT ck_gestion_academica_fechas CHECK ((fecha_fin > fecha_inicio))
);

CREATE TABLE convocatoria (
    id                        bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
    codigo_convocatoria       uuid NOT NULL DEFAULT uuidv7() UNIQUE,
    gestion_id                bigint NOT NULL REFERENCES gestion_academica(id),
    creado_por                bigint REFERENCES usuario(id),
    nombre                    varchar(150) NOT NULL,
    fecha_apertura            timestamptz NOT NULL,
    fecha_cierre              timestamptz NOT NULL,
    cupos                     integer,
    puntaje_minimo            numeric(5,2),
    estado                    estado_convocatoria NOT NULL,
    creado_en                 timestamptz NOT NULL DEFAULT now(),
    actualizado_en            timestamptz NOT NULL DEFAULT now(),
    eliminado_en              timestamptz,
    cantidad_finalistas       integer,
    CONSTRAINT pk_convocatoria PRIMARY KEY (id),
    CONSTRAINT ck_convocatoria_cantidad_finalistas CHECK (((cantidad_finalistas IS NULL) OR (cantidad_finalistas > 0))),
    CONSTRAINT ck_convocatoria_cupos CHECK (((cupos IS NULL) OR (cupos > 0))),
    CONSTRAINT ck_convocatoria_fechas CHECK ((fecha_cierre > fecha_apertura)),
    CONSTRAINT ck_convocatoria_puntaje_minimo CHECK (((puntaje_minimo IS NULL) OR ((puntaje_minimo >= (0)::numeric) AND (puntaje_minimo <= (100)::numeric))))
);

CREATE TABLE tipo_documento (
    id                        bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
    codigo_tipo_documento     uuid NOT NULL DEFAULT uuidv7() UNIQUE,
    nombre                    varchar(100) NOT NULL,
    descripcion               varchar(255),
    creado_en                 timestamptz NOT NULL DEFAULT now(),
    actualizado_en            timestamptz NOT NULL DEFAULT now(),
    eliminado_en              timestamptz,
    CONSTRAINT pk_tipo_documento PRIMARY KEY (id)
);

CREATE TABLE convocatoria_documento (
    convocatoria_id           bigint NOT NULL REFERENCES convocatoria(id),
    tipo_documento_id         bigint NOT NULL REFERENCES tipo_documento(id),
    codigo_convocatoria_documento uuid NOT NULL DEFAULT uuidv7() UNIQUE,
    obligatorio               boolean NOT NULL DEFAULT true,
    creado_en                 timestamptz NOT NULL DEFAULT now(),
    actualizado_en            timestamptz NOT NULL DEFAULT now(),
    eliminado_en              timestamptz,
    CONSTRAINT pk_convocatoria_documento PRIMARY KEY (convocatoria_id, tipo_documento_id)
);

CREATE TABLE postulacion (
    id                        bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
    codigo_postulacion        uuid NOT NULL DEFAULT uuidv7() UNIQUE,
    convocatoria_id           bigint NOT NULL REFERENCES convocatoria(id),
    postulante_id             bigint NOT NULL REFERENCES postulante(usuario_id),
    estado                    estado_postulacion NOT NULL,
    fecha_envio               timestamptz,
    numero_envios             smallint NOT NULL DEFAULT 0,
    creado_en                 timestamptz NOT NULL DEFAULT now(),
    actualizado_en            timestamptz NOT NULL DEFAULT now(),
    eliminado_en              timestamptz,
    CONSTRAINT pk_postulacion PRIMARY KEY (id)
);

CREATE TABLE respuesta_socioeconomica (
    postulacion_id            bigint NOT NULL REFERENCES postulacion(id),
    codigo_respuesta_socioeconomica uuid NOT NULL DEFAULT uuidv7() UNIQUE,
    ingresos_familiares       numeric(12,2),
    dependientes              smallint,
    patrimonio                varchar(255),
    procedencia               varchar(150),
    promedio_academico        numeric(5,2),
    estado_vulnerabilidad     varchar(50),
    datos_extra               jsonb,
    creado_en                 timestamptz NOT NULL DEFAULT now(),
    actualizado_en            timestamptz NOT NULL DEFAULT now(),
    eliminado_en              timestamptz,
    CONSTRAINT pk_respuesta_socioeconomica PRIMARY KEY (postulacion_id)
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
    codigo_documento_adjunto  uuid NOT NULL DEFAULT uuidv7() UNIQUE,
    postulacion_id            bigint NOT NULL REFERENCES postulacion(id),
    tipo_documento_id         bigint NOT NULL REFERENCES tipo_documento(id),
    nombre_archivo            varchar(255) NOT NULL,
    mime_type                 varchar(100) NOT NULL,
    storage_path              varchar(500) NOT NULL,
    tamano_bytes              bigint NOT NULL,
    subido_en                 timestamptz NOT NULL DEFAULT now(),
    creado_en                 timestamptz NOT NULL DEFAULT now(),
    actualizado_en            timestamptz NOT NULL DEFAULT now(),
    eliminado_en              timestamptz,
    CONSTRAINT pk_documento_adjunto PRIMARY KEY (id),
    CONSTRAINT ck_documento_adjunto_tamano CHECK ((tamano_bytes >= 0))
);

CREATE TABLE postulacion_historial (
    id                        bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
    codigo_postulacion_historial uuid NOT NULL DEFAULT uuidv7() UNIQUE,
    postulacion_id            bigint NOT NULL REFERENCES postulacion(id),
    usuario_id                bigint REFERENCES usuario(id),
    estado_anterior           estado_postulacion NOT NULL,
    estado_nuevo              estado_postulacion NOT NULL,
    motivo                    text,
    creado_en                 timestamptz NOT NULL DEFAULT now(),
    actualizado_en            timestamptz NOT NULL DEFAULT now(),
    eliminado_en              timestamptz,
    CONSTRAINT pk_postulacion_historial PRIMARY KEY (id)
);

-- P3 - Preseleccion con IA

CREATE TABLE modelo_preseleccion (
    id                        bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
    codigo_modelo_preseleccion uuid NOT NULL DEFAULT uuidv7() UNIQUE,
    creado_por                bigint REFERENCES usuario(id),
    version                   varchar(50) NOT NULL,
    descripcion               varchar(255),
    activo                    boolean NOT NULL DEFAULT false,
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
    codigo_puntaje_postulacion uuid NOT NULL DEFAULT uuidv7() UNIQUE,
    modelo_id                 bigint NOT NULL REFERENCES modelo_preseleccion(id),
    postulacion_id            bigint NOT NULL REFERENCES postulacion(id),
    puntaje_total             numeric(5,2) NOT NULL,
    detalle                   jsonb,
    fecha_calculo             timestamptz NOT NULL,
    vigente                   boolean NOT NULL DEFAULT true,
    creado_en                 timestamptz NOT NULL DEFAULT now(),
    actualizado_en            timestamptz NOT NULL DEFAULT now(),
    eliminado_en              timestamptz,
    CONSTRAINT pk_puntaje_postulacion PRIMARY KEY (id),
    CONSTRAINT ck_puntaje_postulacion_total CHECK (((puntaje_total >= (0)::numeric) AND (puntaje_total <= (70)::numeric)))
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
    codigo_finalista          uuid NOT NULL DEFAULT uuidv7() UNIQUE,
    postulacion_id            bigint NOT NULL REFERENCES postulacion(id),
    posicion                  integer NOT NULL,
    plazo_entrega             date,
    notificado_en             timestamptz,
    documentacion_recibida_en timestamptz,
    creado_en                 timestamptz NOT NULL DEFAULT now(),
    actualizado_en            timestamptz NOT NULL DEFAULT now(),
    eliminado_en              timestamptz,
    CONSTRAINT pk_finalista PRIMARY KEY (id),
    CONSTRAINT ck_finalista_posicion CHECK ((posicion > 0))
);

CREATE TABLE auditoria_expediente (
    id                        bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
    codigo_auditoria_expediente uuid NOT NULL DEFAULT uuidv7() UNIQUE,
    finalista_id              bigint NOT NULL REFERENCES finalista(id),
    auditor_id                bigint NOT NULL REFERENCES usuario(id),
    fecha_auditoria           timestamptz NOT NULL DEFAULT now(),
    resultado                 resultado_auditoria NOT NULL,
    observaciones             varchar(500),
    puntaje_academico         numeric(5,2),
    creado_en                 timestamptz NOT NULL DEFAULT now(),
    actualizado_en            timestamptz NOT NULL DEFAULT now(),
    eliminado_en              timestamptz,
    clave_idempotencia        uuid,
    CONSTRAINT pk_auditoria_expediente PRIMARY KEY (id),
    CONSTRAINT ck_auditoria_expediente_puntaje_academico CHECK (((puntaje_academico >= (0)::numeric) AND (puntaje_academico <= (30)::numeric)))
);

CREATE TABLE adjudicacion (
    id                        bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
    codigo_adjudicacion       uuid NOT NULL DEFAULT uuidv7() UNIQUE,
    postulacion_id            bigint NOT NULL REFERENCES postulacion(id),
    resultado                 resultado_adjudicacion NOT NULL,
    puntaje_final             numeric(5,2),
    decidido_por              bigint NOT NULL REFERENCES usuario(id),
    fecha_adjudicacion        timestamptz NOT NULL DEFAULT now(),
    creado_en                 timestamptz NOT NULL DEFAULT now(),
    actualizado_en            timestamptz NOT NULL DEFAULT now(),
    eliminado_en              timestamptz,
    CONSTRAINT pk_adjudicacion PRIMARY KEY (id),
    CONSTRAINT ck_adjudicacion_puntaje_final CHECK (((puntaje_final IS NULL) OR ((puntaje_final >= (0)::numeric) AND (puntaje_final <= (100)::numeric))))
);

CREATE TABLE acta_adjudicacion (
    id                        bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
    codigo_acta_adjudicacion  uuid NOT NULL DEFAULT uuidv7() UNIQUE,
    convocatoria_id           bigint NOT NULL REFERENCES convocatoria(id),
    numero                    varchar(30) NOT NULL UNIQUE,
    storage_path              varchar(500) NOT NULL,
    generada_por              bigint NOT NULL REFERENCES usuario(id),
    generada_en               timestamptz NOT NULL DEFAULT now(),
    creado_en                 timestamptz NOT NULL DEFAULT now(),
    actualizado_en            timestamptz NOT NULL DEFAULT now(),
    eliminado_en              timestamptz,
    CONSTRAINT pk_acta_adjudicacion PRIMARY KEY (id)
);

CREATE TABLE publicacion_resultado (
    id                        bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
    codigo_publicacion_resultado uuid NOT NULL DEFAULT uuidv7() UNIQUE,
    convocatoria_id           bigint NOT NULL REFERENCES convocatoria(id),
    publicado_por             bigint NOT NULL REFERENCES usuario(id),
    publicado_en              timestamptz NOT NULL DEFAULT now(),
    creado_en                 timestamptz NOT NULL DEFAULT now(),
    actualizado_en            timestamptz NOT NULL DEFAULT now(),
    eliminado_en              timestamptz,
    CONSTRAINT pk_publicacion_resultado PRIMARY KEY (id)
);

CREATE TABLE comunicado (
    id                        bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
    codigo_comunicado         uuid NOT NULL DEFAULT uuidv7() UNIQUE,
    convocatoria_id           bigint REFERENCES convocatoria(id),
    publicado_por             bigint NOT NULL REFERENCES usuario(id),
    titulo                    varchar(150) NOT NULL,
    contenido                 text NOT NULL,
    destinatarios             destinatarios_comunicado NOT NULL,
    publicado_en              timestamptz NOT NULL DEFAULT now(),
    creado_en                 timestamptz NOT NULL DEFAULT now(),
    actualizado_en            timestamptz NOT NULL DEFAULT now(),
    eliminado_en              timestamptz,
    CONSTRAINT pk_comunicado PRIMARY KEY (id)
);

CREATE TABLE notificacion (
    id                        bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
    codigo_notificacion       uuid NOT NULL DEFAULT uuidv7() UNIQUE,
    usuario_id                bigint NOT NULL REFERENCES usuario(id),
    titulo                    varchar(150) NOT NULL,
    mensaje                   text NOT NULL,
    tipo                      tipo_notificacion NOT NULL,
    leida                     boolean NOT NULL DEFAULT false,
    enviada_en                timestamptz,
    creado_en                 timestamptz NOT NULL DEFAULT now(),
    actualizado_en            timestamptz NOT NULL DEFAULT now(),
    eliminado_en              timestamptz,
    postulacion_id            bigint REFERENCES postulacion(id),
    comunicado_id             bigint REFERENCES comunicado(id),
    CONSTRAINT pk_notificacion PRIMARY KEY (id)
);

CREATE TABLE dispositivo_fcm (
    id                        bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
    codigo_dispositivo_fcm    uuid NOT NULL DEFAULT uuidv7() UNIQUE,
    usuario_id                bigint NOT NULL REFERENCES usuario(id),
    token                     varchar(512) NOT NULL,
    plataforma                varchar(20) NOT NULL,
    creado_en                 timestamptz NOT NULL DEFAULT now(),
    actualizado_en            timestamptz NOT NULL DEFAULT now(),
    eliminado_en              timestamptz,
    CONSTRAINT pk_dispositivo_fcm PRIMARY KEY (id)
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
    codigo_bitacora           uuid NOT NULL DEFAULT uuidv7() UNIQUE,
    usuario_id                bigint REFERENCES usuario(id),
    accion                    varchar(60) NOT NULL,
    entidad                   varchar(60),
    entidad_id                bigint,
    detalle                   jsonb,
    ip                        inet,
    creado_en                 timestamptz NOT NULL DEFAULT now(),
    actualizado_en            timestamptz NOT NULL DEFAULT now(),
    eliminado_en              timestamptz,
    CONSTRAINT pk_bitacora PRIMARY KEY (id)
);

-- -----------------------------------------------------------------------------
-- 3. Indices (los de las tablas implementadas replican las migraciones: unicos parciales que
--    respetan el borrado logico, y de rendimiento)
-- -----------------------------------------------------------------------------
CREATE UNIQUE INDEX uq_rol_nombre
    ON rol (nombre)
    WHERE (eliminado_en IS NULL);
CREATE INDEX ix_usuario_rol_id
    ON usuario (rol_id)
    WHERE (eliminado_en IS NULL);
CREATE UNIQUE INDEX uq_usuario_ci
    ON usuario (ci)
    WHERE (eliminado_en IS NULL);
CREATE UNIQUE INDEX uq_usuario_correo
    ON usuario (correo)
    WHERE (eliminado_en IS NULL);
CREATE UNIQUE INDEX uq_usuario_restablecimiento_token_hash
    ON usuario (restablecimiento_token_hash)
    WHERE ((restablecimiento_token_hash IS NOT NULL) AND (eliminado_en IS NULL));
CREATE INDEX ix_sesion_usuario_id
    ON sesion (usuario_id)
    WHERE (eliminado_en IS NULL);
CREATE UNIQUE INDEX uq_sesion_token_hash
    ON sesion (token_hash)
    WHERE (eliminado_en IS NULL);
CREATE UNIQUE INDEX uq_carrera_nombre
    ON carrera (nombre)
    WHERE (eliminado_en IS NULL);
CREATE INDEX ix_postulante_carrera_id
    ON postulante (carrera_id)
    WHERE (eliminado_en IS NULL);
CREATE UNIQUE INDEX uq_postulante_registro_universitario
    ON postulante (registro_universitario)
    WHERE (eliminado_en IS NULL);
CREATE UNIQUE INDEX uq_gestion_academica_etiqueta
    ON gestion_academica (etiqueta)
    WHERE (eliminado_en IS NULL);
CREATE INDEX ix_convocatoria_gestion_id
    ON convocatoria (gestion_id)
    WHERE (eliminado_en IS NULL);
CREATE UNIQUE INDEX uq_convocatoria_abierta_por_gestion
    ON convocatoria (gestion_id)
    WHERE ((estado = 'ABIERTA') AND (eliminado_en IS NULL));
CREATE UNIQUE INDEX uq_tipo_documento_nombre
    ON tipo_documento (nombre)
    WHERE (eliminado_en IS NULL);
CREATE INDEX ix_convocatoria_documento_tipo_documento_id
    ON convocatoria_documento (tipo_documento_id)
    WHERE (eliminado_en IS NULL);
CREATE INDEX ix_postulacion_convocatoria_estado
    ON postulacion (convocatoria_id, estado)
    WHERE (eliminado_en IS NULL);
CREATE UNIQUE INDEX uq_postulacion_postulante_convocatoria
    ON postulacion (postulante_id, convocatoria_id)
    WHERE (eliminado_en IS NULL);
CREATE INDEX ix_documento_adjunto_postulacion_id
    ON documento_adjunto (postulacion_id)
    WHERE (eliminado_en IS NULL);
CREATE INDEX ix_documento_adjunto_tipo_documento_id
    ON documento_adjunto (tipo_documento_id)
    WHERE (eliminado_en IS NULL);
CREATE INDEX ix_postulacion_historial_postulacion_creado
    ON postulacion_historial (postulacion_id, creado_en)
    WHERE (eliminado_en IS NULL);
CREATE INDEX ix_postulacion_historial_usuario_id
    ON postulacion_historial (usuario_id)
    WHERE (eliminado_en IS NULL);
CREATE UNIQUE INDEX uq_modelo_preseleccion_activo
    ON modelo_preseleccion (activo)
    WHERE (activo AND (eliminado_en IS NULL));
CREATE UNIQUE INDEX uq_modelo_preseleccion_version
    ON modelo_preseleccion (version)
    WHERE (eliminado_en IS NULL);
CREATE INDEX ix_puntaje_postulacion_modelo_id
    ON puntaje_postulacion (modelo_id)
    WHERE (eliminado_en IS NULL);
CREATE INDEX ix_puntaje_postulacion_vigente_total
    ON puntaje_postulacion (puntaje_total DESC)
    WHERE (vigente AND (eliminado_en IS NULL));
CREATE UNIQUE INDEX uq_puntaje_postulacion_vigente
    ON puntaje_postulacion (postulacion_id)
    WHERE (vigente AND (eliminado_en IS NULL));
CREATE UNIQUE INDEX uq_finalista_postulacion
    ON finalista (postulacion_id)
    WHERE (eliminado_en IS NULL);
CREATE INDEX ix_auditoria_expediente_auditor_id
    ON auditoria_expediente (auditor_id)
    WHERE (eliminado_en IS NULL);
CREATE INDEX ix_auditoria_expediente_finalista_fecha
    ON auditoria_expediente (finalista_id, fecha_auditoria DESC)
    WHERE (eliminado_en IS NULL);
CREATE UNIQUE INDEX uq_auditoria_expediente_clave_idempotencia
    ON auditoria_expediente (finalista_id, clave_idempotencia)
    WHERE (clave_idempotencia IS NOT NULL);
CREATE INDEX ix_adjudicacion_decidido_por
    ON adjudicacion (decidido_por)
    WHERE (eliminado_en IS NULL);
CREATE UNIQUE INDEX uq_adjudicacion_postulacion
    ON adjudicacion (postulacion_id)
    WHERE (eliminado_en IS NULL);
CREATE INDEX ix_acta_adjudicacion_generada_por
    ON acta_adjudicacion (generada_por)
    WHERE (eliminado_en IS NULL);
CREATE UNIQUE INDEX uq_acta_adjudicacion_convocatoria
    ON acta_adjudicacion (convocatoria_id)
    WHERE (eliminado_en IS NULL);
CREATE UNIQUE INDEX uq_acta_adjudicacion_numero
    ON acta_adjudicacion (numero);
CREATE INDEX ix_publicacion_resultado_publicado_por
    ON publicacion_resultado (publicado_por)
    WHERE (eliminado_en IS NULL);
CREATE UNIQUE INDEX uq_publicacion_resultado_convocatoria
    ON publicacion_resultado (convocatoria_id)
    WHERE (eliminado_en IS NULL);
CREATE INDEX ix_comunicado_convocatoria_id
    ON comunicado (convocatoria_id)
    WHERE (eliminado_en IS NULL);
CREATE INDEX ix_comunicado_publicado_en
    ON comunicado (publicado_en DESC)
    WHERE (eliminado_en IS NULL);
CREATE INDEX ix_notificacion_comunicado_id
    ON notificacion (comunicado_id)
    WHERE ((comunicado_id IS NOT NULL) AND (eliminado_en IS NULL));
CREATE INDEX ix_notificacion_postulacion_id
    ON notificacion (postulacion_id, creado_en DESC)
    WHERE ((postulacion_id IS NOT NULL) AND (eliminado_en IS NULL));
CREATE INDEX ix_notificacion_usuario_creado
    ON notificacion (usuario_id, creado_en DESC)
    WHERE (eliminado_en IS NULL);
CREATE INDEX ix_dispositivo_fcm_usuario_id
    ON dispositivo_fcm (usuario_id)
    WHERE (eliminado_en IS NULL);
CREATE UNIQUE INDEX uq_dispositivo_fcm_token
    ON dispositivo_fcm (token)
    WHERE (eliminado_en IS NULL);
CREATE INDEX ix_bitacora_usuario_id
    ON bitacora (usuario_id);

-- Indices de las tablas pendientes (segun el diseno)
CREATE UNIQUE INDEX uq_nota_postulacion_periodo
    ON nota_academica (postulacion_id, periodo)
    WHERE eliminado_en IS NULL;
CREATE UNIQUE INDEX uq_parametro_modelo_clave
    ON parametro_modelo (modelo_id, clave)
    WHERE eliminado_en IS NULL;
CREATE UNIQUE INDEX uq_beca_adjudicacion
    ON beca (adjudicacion_id)
    WHERE eliminado_en IS NULL;
CREATE UNIQUE INDEX uq_asistencia_beca_fecha
    ON asistencia (beca_id, fecha)
    WHERE eliminado_en IS NULL;
CREATE INDEX ix_beca_convocatoria_estado
    ON beca (convocatoria_id, estado)
    WHERE eliminado_en IS NULL;
CREATE INDEX ix_beca_postulante
    ON beca (postulante_id)
    WHERE eliminado_en IS NULL;

-- -----------------------------------------------------------------------------
-- 5. Actualizacion de actualizado_en
--    La mantiene la aplicacion (Hibernate, @UpdateTimestamp); las migraciones no crean
--    triggers en la base.
-- -----------------------------------------------------------------------------

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
-- 7. Vista materializada de indicadores BI (CU-12), una fila por (convocatoria, mes).
--    Se refresca por lote cada noche: REFRESH MATERIALIZED VIEW CONCURRENTLY mv_indicadores_convocatoria;
--    (igual a la migracion V20261114100000; la asistencia se agrega con el CU-10)
-- -----------------------------------------------------------------------------
CREATE MATERIALIZED VIEW mv_indicadores_convocatoria AS
SELECT d.convocatoria_id,
       c.gestion_id,
       d.mes,
       CAST(sum(d.postulaciones_recibidas) AS integer) AS postulaciones_recibidas,
       CAST(sum(d.finalistas) AS integer)              AS finalistas,
       CAST(sum(d.adjudicadas) AS integer)             AS adjudicadas,
       now()                                           AS calculado_en
FROM (
    SELECT po.convocatoria_id,
           CAST(date_trunc('month', po.fecha_envio AT TIME ZONE 'America/La_Paz') AS date) AS mes,
           count(*)           AS postulaciones_recibidas,
           CAST(0 AS bigint)  AS finalistas,
           CAST(0 AS bigint)  AS adjudicadas
    FROM postulacion po
    WHERE po.fecha_envio IS NOT NULL AND po.eliminado_en IS NULL
    GROUP BY po.convocatoria_id, 2

    UNION ALL

    SELECT po.convocatoria_id,
           CAST(date_trunc('month', f.creado_en AT TIME ZONE 'America/La_Paz') AS date) AS mes,
           CAST(0 AS bigint),
           count(*),
           CAST(0 AS bigint)
    FROM finalista f
    JOIN postulacion po ON po.id = f.postulacion_id AND po.eliminado_en IS NULL
    WHERE f.eliminado_en IS NULL
    GROUP BY po.convocatoria_id, 2

    UNION ALL

    SELECT po.convocatoria_id,
           CAST(date_trunc('month', a.fecha_adjudicacion AT TIME ZONE 'America/La_Paz') AS date) AS mes,
           CAST(0 AS bigint),
           CAST(0 AS bigint),
           count(*)
    FROM adjudicacion a
    JOIN postulacion po ON po.id = a.postulacion_id AND po.eliminado_en IS NULL
    WHERE a.resultado = 'ADJUDICADA' AND a.eliminado_en IS NULL
      AND EXISTS (SELECT 1 FROM publicacion_resultado pr
                  WHERE pr.convocatoria_id = po.convocatoria_id AND pr.eliminado_en IS NULL)
    GROUP BY po.convocatoria_id, 2
) d
JOIN convocatoria c ON c.id = d.convocatoria_id AND c.eliminado_en IS NULL
GROUP BY d.convocatoria_id, c.gestion_id, d.mes
WITH DATA;

-- Necesario para REFRESH MATERIALIZED VIEW CONCURRENTLY, y la consulta por convocatoria y mes.
CREATE UNIQUE INDEX uq_mv_indicadores_convocatoria_mes ON mv_indicadores_convocatoria (convocatoria_id, mes);
-- La consulta del dashboard filtra por gestion.
CREATE INDEX ix_mv_indicadores_convocatoria_gestion ON mv_indicadores_convocatoria (gestion_id);

-- -----------------------------------------------------------------------------
-- 8. Datos iniciales del catalogo de roles
-- -----------------------------------------------------------------------------
INSERT INTO rol (nombre) VALUES
    ('POSTULANTE'), ('ADMINISTRADOR_DUBSS'), ('DIRECTIVO'), ('PERSONAL_COMEDOR');

COMMIT;
