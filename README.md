# Documetación database lending

![Liquibase](https://img.shields.io/badge/Liquibase-2962FF.svg?style=for-the-badge&logo=Liquibase&logoColor=white)
![PostgresSQL](https://img.shields.io/badge/PostgreSQL-316192?style=for-the-badge&logo=postgresql&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-2CA5E0?style=for-the-badge&logo=docker&logoColor=white)

A continuación se muestra como realizar los cambios a nuestra base de datos relacional utilizando la consolad de liquibase.

# Como ejecutar

Para poder ejecutar los script de la base de datos, se tiene que realizar a través de liquibase, ya sea utilizando el un contenedor de docker o tener instalado en la computadora donde se ejecute el programa en una base de datos local o remota.

Independientemente de las opciones anteriores, primero se tiene que renombrar el archivo `liquibase.properties.example` a `liquibase.properties` o `liquibase.docker.properties`. Este archivo se encuentra en la ruta [./code/liquibase/changelog/](./code/liquibase/changelog/).

El contenido del archivo debe ser algo similar a lo siguiente:

```
classpath: [classpath]
url: jdbc:postgresql://[host]:[port]/[database]?currentSchema=[schema]
changeLogFile: changelog.xml
username: [username]
password: [password]
```

Donde se cambiarán los parámetros que se encuentra entre corchete por los valores reales, (consultar con el equipo los valores):

- classpath
- host
- port
- username
- password

### Opción docker

Para ejecutar los cambios de nuestros scripts en liquibase utilizando docker, realizamos los siguientes pasos:

1. Cambiarse al directorio [./code](./code/)
2. Renombrar el archivo `liquibase.properties.example` a `liquibase.docker.properties`
3. Modificar el archivo, `liquibase.docker.properties` con los siguientes campos:
   | Campo | Valor |
   | -- | -- |
   | `[classpath]` | `/liquibase/changelog` |
   | `[host]` | `host.docker.internal` |
4. Ejecutamos el siguiente comando

```
docker-compose up
```

### Opción liquibase-cli

1. Descargar liquibase-cli desde la [web oficial](https://www.liquibase.org/download)
2. Renombrar el archivo `liquibase.properties.example` a `liquibase.properties`
3. Modificar el archivo, `liquibase.docker.properties` con los siguientes campos:
   | Campo | Valor |
   | -- | -- |
   | `[classpath]` | `./liquibase/changelog` |
   | `[host]` | `localhost` |
4. Posicionarse en el directorio `code`
5. Configuracion

### Postgresql Docker-Compose

```docker
version: '3.7'

services:
  postgreSQL:
    image: postgres
    container_name: postgresql_container
    environment:
      POSTGRES_USER: mfsAdmin
      POSTGRES_PASSWORD: SElDyieNobNSa4b87cZg-UOBj1ekuB
      PGDATA: /data/postgresql
    volumes:
      - .data/postgresql:/data/postgresql
    ports:
      - "5416:5432"
    networks:
      - postgres
    restart: always
    hostname: postgres
    expose:
      - 5432
  pgadmin:
    container_name: pgadming_container
    image: dpage/pgadmin4
    environment:
      PGADMIN_DEFAULT_EMAIL: pgadmin4@pgadmin.org
      PGADMIN_DEFAULT_PASSWORD: admin
      PGADMIN_CONFIG_SERVER_MODE: 'False'
    volumes:
      - .data/pgadmin:/data/pgadmin
    ports:
      - "5050:80"
    restart: always
networks:
  postgres:
    name: my-shared-postgres-db-network
    driver: bridge
volumes:
  postgres:
    driver: local
```

6. Ejecutamos el siguiente comando

```
liquibase --defaults-file=./liquibase/changelog/liquibase.properties update
```

## Scripts SQL

Liquibase nos ofrece diferentes maneras de reflejar los cambios de versiones en nuestra base de datos. En las que destacan

- XML
- _SQL_
- YAML
- JSON

El proyecto está organizado de la siguiente manera, para su ejecución correcta y mejor entendimiento.

```text
| code/liquibase/scripts/
|   01_DCL/
|   02_DDL/
|       001_DROP_STRUCTURE
|       002_DATA_STRUCTURE
|       003_CONSTRAINTS
|   03_DML/
|   04_MISC/
```

Los scripts de base de datos deben ir en el directorio: [./code/liquibase/scripts](./code/liquibase/scripts/), de acuerdo con la siguiente definición:

* `./code/liquibase/scripts/01_DCL` Scripts relacionados con el lenguaje de control de datos. Proporciona la gestión de la base de datos que controla los accesos a los datos contenidos
* `./code/liquibase/scripts/02_DDL` Scripts relacionados con la generación de la estructura de datos, creación, modificación y eliminación de tablas.
* `./code/liquibase/scripts/03_DML` Scripts relacionados con la manipulación de datos, en esta carpeta se agregan aquellos scripts donde sólo se visualiza, edita, elimina datos de la estructura ya creada
* `./code/liquibase/scripts/04_MISC` Scripts miscelaneos relacionado con la base de datos, aquellos scrtips que no tienen que ver con ninguno de los anteriores como la instalación de extensiones usando lenguaje SQL

. Para todas las carpetas que se enlistaron anteriormente, la estructura interna deben estar dentro de una carpeta con la fecha en la que se realiza el cambio con el formato ISO, sin guión medio _%YYYY%MM%DD_.
Por ejemplo:

- `20230506`
- `20210101`
- `20251231`
- `20240229`

Para el caso particular de `02_DDL`, tiene 2 subcarpetas, en donde la distribución de los scripts quedan de la siguiente manera.

* `./code/liquibase/scripts/02_DDL/001_DROP_STRUCTURE` Scripts relacionados eliminación de elementos de la estructura de datos.
* `./code/liquibase/scripts/02_DDL/002_DATA_STRUCTURE` Scripts relacionados tablas, vistas, stored procedures, etc.
* `./code/liquibase/scripts/02_DDL/003_CONSTRAINTS` Scripts relacionados con llaves y restricciones de las tablas.

El formato de nombre de archivo debe ser similar a _[]-[Nombre de la elemento afectado]_ `<Numero consecutivo de agregacion de tabla (rellenar 4 espacios con 0 a la izquierda)>_<elemento_afectado>_<operacion>.sql` por ejemplo: `0001_clients_insert_data.sql`

```text
| code/liquibase/scripts/
|   01_DCL/
|     20250101/
|       0001_user_grant.sql
|       0002_database_revoke_access.sql
|   02_DDL/
|       001_DATA_STRUCTURE
|         20250101/
|           0001_initial_database.sql
|           0002_clients_create_table.sql
|           0003_users_create_table.sql
|         20250102/
|           0001_clients_alter_table.sql
|       002_CONSTRAINTS
|         20250101/
|           0001_initial_constraints.sql
|           0002_clients_create_pk_constraints.sql
|         20250102/
|           0001_clients_users_create_fk_constraints.sql
|           0002_clients_users_alter_fk_constraints.sql
|   03_DML/
|     20250101/
|       0001_clients_insert_data.sql
|     20250102/
|       0001_users_delete.sql
|   06_MISC/
|     20250101/
|       0001_install_plugin_aurora.sql
```


El formato de los comentarios son los siguientes:

- `changeset` es el número del cambio del desarrollado, si es tu primer cambio es el 1, y así sucesivamente
- `comment` una explicacion del porque del cambio
- `context` debe ir como una sola palabra, pueden usar guiones medios
- `labels` es el ticket donde se puede encontrar mas informacion
  ##Ejemplo con SQL
  `rollback` comandos a ejecutar para devolver el estado de la db al anterior de los cambios propuestos

```sql
--liquibase formatted sql
--changeset id-user:1 labels:important-label context: insert-data-values
--comment: Insert new info into Clients table

INSERT INTO Clients(firstname, lastname) VALUES ('John', 'Due')

--rollback DELETE FROM Clients WHERE id = (SELECT max(id) FROM Clients;
```

