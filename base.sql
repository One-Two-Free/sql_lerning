CREATE database testdb

CREATE table publisher
(
	publisher_id integer PRIMARY KEY,
	org_name varchar(128) NOT NULL,
	address text NOT NULL
);

CREATE table book
(
	book_id integer PRIMARY KEY,
	title text NOT NULL,
	isbn varchar(32) NOT NULL,
	fk_publisher_id integer REFERENCES publisher(publisher_id) NOT NULL
);

CREATE TABLE author
(
	author_id int PRIMARY KEY,
	full_name text NOT NULL,
	rating real
);

CREATE TABLE book_author
(
	book_id REFERENCES book(book_id),
	author_id int REFERENCES author(author_id),
	
	CONSTRAINT book_author_pkey PRIMARY KEY(book_id, author_id) --composite key
);

DROP TABLE IF EXISTS book;
DROP TABLE IF EXISTS author;

INSERT INTO book
VALUES
(1, 'new name','014442674',1),
(2, 'new name2','0178992674',2);

INSERT INTO publisher
VALUES
(1, 'new name','014442674'),
(2, 'new name2','0178992674');

SELECT *
FROM book;
