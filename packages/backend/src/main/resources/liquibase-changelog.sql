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
CREATE TABLE IF NOT EXISTS invitations (
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
INSERT INTO associations (name) VALUES ('Root Association');
INSERT INTO associations (name) VALUES ('Test Association 1');
INSERT INTO associations (name) VALUES ('Test Association 2');
INSERT INTO associations (name, status) VALUES ('Disabled Association', -1);

INSERT INTO users (email, username, password, association, last_login, scope) VALUES ('root@hollybike.fr', 'root', 'JDJhJDA2JHJwVWE4dWdyUi9URERJdWt4cll0VU9yLmRQSExWdTUzdlB4bWFQbktZanppZVd2V01vdFpX', 1, now(), 3);

INSERT INTO users (email, username, password, association, last_login, scope) VALUES ('user1@hollybike.fr', 'user1', 'JDJhJDA2JHJwVWE4dWdyUi9URERJdWt4cll0VU9yLmRQSExWdTUzdlB4bWFQbktZanppZVd2V01vdFpX', 2, now(), 1);
INSERT INTO users (email, username, password, association, last_login, scope) VALUES ('user2@hollybike.fr', 'user2', 'JDJhJDA2JHJwVWE4dWdyUi9URERJdWt4cll0VU9yLmRQSExWdTUzdlB4bWFQbktZanppZVd2V01vdFpX', 2, now(), 1);
INSERT INTO users (email, username, password, association, last_login, scope) VALUES ('user3@hollybike.fr', 'user3', 'JDJhJDA2JHJwVWE4dWdyUi9URERJdWt4cll0VU9yLmRQSExWdTUzdlB4bWFQbktZanppZVd2V01vdFpX', 3, now(), 1);
INSERT INTO users (email, username, password, association, last_login, scope) VALUES ('user4@hollybike.fr', 'user4', 'JDJhJDA2JHJwVWE4dWdyUi9URERJdWt4cll0VU9yLmRQSExWdTUzdlB4bWFQbktZanppZVd2V01vdFpX', 3, now(), 1);
INSERT INTO users (email, username, password, association, last_login, scope) VALUES ('user5@hollybike.fr', 'user5', 'JDJhJDA2JHJwVWE4dWdyUi9URERJdWt4cll0VU9yLmRQSExWdTUzdlB4bWFQbktZanppZVd2V01vdFpX', 4, now(), 1);


INSERT INTO users (email, username, password, association, last_login, scope, status) VALUES ('disabled1@hollybike.fr', 'disabled1', 'JDJhJDA2JHJwVWE4dWdyUi9URERJdWt4cll0VU9yLmRQSExWdTUzdlB4bWFQbktZanppZVd2V01vdFpX', 2, now(), 1, -1);
INSERT INTO users (email, username, password, association, last_login, scope, status) VALUES ('disabled2@hollybike.fr', 'disabled2', 'JDJhJDA2JHJwVWE4dWdyUi9URERJdWt4cll0VU9yLmRQSExWdTUzdlB4bWFQbktZanppZVd2V01vdFpX', 3, now(), 1, -1);
INSERT INTO users (email, username, password, association, last_login, scope, status) VALUES ('disabled3@hollybike.fr', 'disabled3', 'JDJhJDA2JHJwVWE4dWdyUi9URERJdWt4cll0VU9yLmRQSExWdTUzdlB4bWFQbktZanppZVd2V01vdFpX', 3, now(), 1, -1);


INSERT INTO users (email, username, password, association, last_login, scope) VALUES ('admin1@hollybike.fr', 'admin1', 'JDJhJDA2JHJwVWE4dWdyUi9URERJdWt4cll0VU9yLmRQSExWdTUzdlB4bWFQbktZanppZVd2V01vdFpX', 2, now(), 2);
INSERT INTO users (email, username, password, association, last_login, scope) VALUES ('admin2@hollybike.fr', 'admin2', 'JDJhJDA2JHJwVWE4dWdyUi9URERJdWt4cll0VU9yLmRQSExWdTUzdlB4bWFQbktZanppZVd2V01vdFpX', 3, now(), 2);
INSERT INTO users (email, username, password, association, last_login, scope) VALUES ('admin3@hollybike.fr', 'admin3', 'JDJhJDA2JHJwVWE4dWdyUi9URERJdWt4cll0VU9yLmRQSExWdTUzdlB4bWFQbktZanppZVd2V01vdFpX', 4, now(), 2);

INSERT INTO events (name, description, association, image, status, owner, start_date_time, end_date_time) VALUES ('Event 1 - Asso 1 - User 1 - PENDING', 'Description 1', 2, null, 1, 2, now(), now());
INSERT INTO events (name, description, association, image, status, owner, start_date_time, end_date_time) VALUES ('Event 2 - Asso 1 - User 1 - SCHEDULED', 'Description 2', 2, null, 2, 2, now(), now());
INSERT INTO events (name, description, association, image, status, owner, start_date_time, end_date_time) VALUES ('Event 3 - Asso 1 - User 1 - CANCELED', 'Description 3', 2, null, 3, 2, now(), now());
INSERT INTO events (name, description, association, image, status, owner, start_date_time, end_date_time) VALUES ('Event 4 - Asso 1 - User 1 - TERMINATED', 'Description 4', 2, null, 4, 2, now(), now());

INSERT INTO events (name, description, association, image, status, owner, start_date_time, end_date_time) VALUES ('Event 1 - Asso 1 - User 2 - PENDING', 'Description 1', 2, null, 1, 3, now(), now());
INSERT INTO events (name, description, association, image, status, owner, start_date_time, end_date_time) VALUES ('Event 2 - Asso 1 - User 2 - SCHEDULED', 'Description 2', 2, null, 2, 3, now(), now());

INSERT INTO events (name, description, association, image, status, owner, start_date_time, end_date_time) VALUES ('Event 1 - Asso 2 - User 3 - SCHEDULED', 'Description 1', 3, null, 2, 4, now(), now());

INSERT INTO events (name, description, association, image, status, owner, start_date_time, end_date_time) VALUES ('Event 1 - Asso 2 - User 4 - PENDING', 'Description 1', 3, null, 1, 5, now(), now());
INSERT INTO events (name, description, association, image, status, owner, start_date_time, end_date_time) VALUES ('Event 2 - Asso 2 - User 4 - SCHEDULED', 'Description 2', 3, null, 2, 5, now(), now());



-- changeset denis:5
CREATE EXTENSION unaccent;

