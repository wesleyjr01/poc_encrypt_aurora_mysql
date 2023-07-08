CREATE TABLE users
( 
  pk int(11) NOT NULL AUTO_INCREMENT,
  name VARCHAR(150),
  PRIMARY KEY (`pk`)
);

INSERT INTO users (name)
VALUES
	('John'),
	('Albert');


select * from users;