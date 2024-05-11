-- liquibase formatted sql

-- changeset denis:1
CREATE TABLE IF NOT EXISTS "associations"
(
    "id_association" INTEGER GENERATED BY DEFAULT AS IDENTITY NOT NULL,
    "name"           VARCHAR(255)                             NOT NULL,
    "status"         INTEGER DEFAULT 1                        NOT NULL,
    CONSTRAINT "associations_pk" PRIMARY KEY ("id_association")
);

CREATE TABLE IF NOT EXISTS "users"
(
    "id_user"     INTEGER GENERATED BY DEFAULT AS IDENTITY NOT NULL,
    "email"       VARCHAR                                  NOT NULL,
    "username"    VARCHAR                                  NOT NULL,
    "password"    VARCHAR                                  NOT NULL,
    "status"      INTEGER DEFAULT 1                        NOT NULL,
    "scope"       INTEGER DEFAULT 1                        NOT NULL,
    "association" INTEGER                                  NOT NULL,
    "last_login"  TIMESTAMP WITHOUT TIME ZONE              NOT NULL,
    CONSTRAINT "users_pk" PRIMARY KEY ("id_user")
);
CREATE UNIQUE INDEX IF NOT EXISTS "associations_name_uindex" ON "associations" ("name");
CREATE UNIQUE INDEX IF NOT EXISTS "users_email_uindex" ON "users" ("email");
ALTER TABLE "users"
    ADD CONSTRAINT "users_associations_id_association_fk" FOREIGN KEY ("association") REFERENCES "associations" ("id_association") ON UPDATE NO ACTION ON DELETE NO ACTION;

-- changeset denis:2 context:dev
INSERT INTO associations (name)
VALUES ('Motoloup');

-- changeset denis:3
ALTER TABLE users
    ADD COLUMN IF NOT EXISTS profile_picture VARCHAR(2048) DEFAULT null;
ALTER TABLE associations
    ADD COLUMN IF NOT EXISTS picture VARCHAR(2048) DEFAULT null;

-- changeset loic:1
CREATE TABLE IF NOT EXISTS events
(
    id_event         INTEGER GENERATED BY DEFAULT AS IDENTITY NOT NULL
        CONSTRAINT events_pk
            PRIMARY KEY,
    name             VARCHAR(1000)                            NOT NULL,
    description      VARCHAR(1000),
    association      INTEGER                                  NOT NULL
        CONSTRAINT events_association_fk
            REFERENCES associations,
    image            VARCHAR(2048),
    status           INTEGER   DEFAULT 1                      NOT NULL,
    owner            INTEGER                                  NOT NULL
        CONSTRAINT events_owner_fk
            REFERENCES users ON DELETE CASCADE,
    start_date_time  TIMESTAMP                                NOT NULL,
    end_date_time    TIMESTAMP,
    create_date_time TIMESTAMP DEFAULT NOW()                  NOT NULL,
    update_date_time TIMESTAMP DEFAULT NOW()                  NOT NULL
);

-- changeset loic:2

CREATE TABLE IF NOT EXISTS users_participate_events
(
    id_participation INTEGER GENERATED BY DEFAULT AS IDENTITY NOT NULL
        CONSTRAINT users_participate_events_pk
            PRIMARY KEY,
    "user"           INTEGER                                  NOT NULL
        CONSTRAINT users_participate_events_user_fk
            REFERENCES users ON DELETE CASCADE,
    event            INTEGER                                  NOT NULL
        CONSTRAINT users_participate_events_event_fk
            REFERENCES events ON DELETE CASCADE,
    role             INTEGER                                  NOT NULL DEFAULT 1,
    joined_date_time TIMESTAMP                                NOT NULL DEFAULT NOW() NOT NULL,
    CONSTRAINT users_participate_events_unique_key
        UNIQUE ("user", event)
);

-- changeset denis:4
CREATE TABLE invitations (
    id_invitation INTEGER GENERATED BY DEFAULT AS IDENTITY NOT NULL PRIMARY KEY,
    role INTEGER NOT NULL,
    status INTEGER DEFAULT 1 NOT NULL,
    association INTEGER REFERENCES associations(id_association) NOT NULL,
    creator INTEGER REFERENCES users(id_user) NOT NULL,
    expiration TIMESTAMP,
    creation TIMESTAMP NOT NULL DEFAULT NOW(),
    uses INTEGER NOT NULL DEFAULT 0,
    max_uses INTEGER DEFAULT NULL
);

-- changeset loic:3 context:test
INSERT INTO associations (name) VALUES ('Test Association');
INSERT INTO users (email, username, password, association, last_login, scope) VALUES ('root@hollybike.fr', 'root', 'JDJhJDA2JG1BT3RML0R3RGdlV1g1RVQ0Z3c2LmVvZVBFVFpnMDI2Uy56M1lEVmpuaVk1dlBHYlpudm5p', 1, now(), 3);