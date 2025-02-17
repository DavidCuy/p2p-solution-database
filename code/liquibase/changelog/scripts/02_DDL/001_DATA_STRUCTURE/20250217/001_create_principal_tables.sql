--liquibase formatted sql
--changeset DavidCuy:1 labels:create-database-tables context: First-run-for-liquibase
--comment: Crea las tablas de la base de datos para el sistema P2P

CREATE TYPE p2p_schema.p2p_tx_status AS ENUM ('created', 'running', 'done', 'failure');

CREATE TABLE p2p_schema.users (
  id BIGINT GENERATED BY DEFAULT AS IDENTITY,
  name TEXT,
  unique_id TEXT,
  created_at TIMESTAMP DEFAULT NOW(),

  PRIMARY KEY(id)
);

CREATE TABLE p2p_schema.p2p_transaction  (
  id BIGINT GENERATED BY DEFAULT AS IDENTITY,
  source_id BIGINT,
  dest_id BIGINT,
  amount FLOAT,
  status p2p_tx_status DEFAULT 'created',
  created_at TIMESTAMP DEFAULT NOW(),

  PRIMARY KEY(id),
  CONSTRAINT fk_p2p_transaction_users FOREIGN KEY(source_id) REFERENCES users(id),
  CONSTRAINT fk_p2p_transaction_users FOREIGN KEY(dest_id) REFERENCES users(id)

);


--rollback DROP TABLE p2p_schema.p2p_transaction;
--rollback DROP TABLE p2p_schema.users;
--rollback DROP TYPE p2p_schema.p2p_tx_status;