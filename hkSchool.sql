
-- Database: happykidsschool
CREATE DATABASE IF NOT EXISTS happykidsschool
    WITH
    OWNER = steph;

-- Connexion with database happykidsschool
\c happykidsschool;

-- SCHEMA: hkshool
CREATE SCHEMA IF NOT EXISTS hkshool
    AUTHORIZATION steph;

-- Change: the search_path to hkschool
SET search_path TO hkschool;

-- Table: Parents
CREATE TABLE IF NOT EXISTS Parents
(
    id SERIAL,
    firstName VARCHAR(50) NOT NULL,
    lastName VARCHAR(100) NOT NULL,
    sex CHAR(1) NOT NULL,
    address TEXT NOT NULL,
    tel VARCHAR(20) NOT NULL,
    email VARCHAR(255),
    CONSTRAINT pk_Parents PRIMARY KEY (id),
    CONSTRAINT un_email_Parents UNIQUE (email),
    CONSTRAINT un_tel_Parents UNIQUE (tel),
    CONSTRAINT chk_sex_Parents CHECK (sex IN('M','F'))
);

-- Table: Students
CREATE TABLE IF NOT EXISTS Students
(
    id SERIAL,
    idParents INTEGER NOT NULL,
    firstName VARCHAR(50) NOT NULL,
    lastName VARCHAR(100) NOT NULL,
    sex CHAR(1) NOT NULL,
    dateNaiss DATE NOT NULL,
    dateIns DATE DEFAULT CURRENT_DATE,
    CONSTRAINT pk_Students PRIMARY KEY (id),
    CONSTRAINT fk_Students_idParents FOREIGN KEY (idParents)
        REFERENCES Parents (id),
    CONSTRAINT chk_sex_Students CHECK (sex IN('M','F'))
);

-- Table: Teachers
CREATE TABLE IF NOT EXISTS Teachers
(
    id SERIAL,
    firstName VARCHAR(50) NOT NULL,
    lastName VARCHAR(100) NOT NULL,
    sex CHAR(1) NOT NULL,
    address TEXT NOT NULL,
    tel VARCHAR(20) NOT NULL,
    email VARCHAR(255),
    dateNaiss DATE NOT NULL,
    dateEmbauche DATE DEFAULT CURRENT_DATE,
    CONSTRAINT pk_Teachers PRIMARY KEY (id),
    CONSTRAINT un_email_Teachers UNIQUE (email),
    CONSTRAINT un_tel_Teachers UNIQUE (tel),
    CONSTRAINT chk_sex_Teachers CHECK (sex IN('M','F'))
);

-- Table: Class
CREATE TABLE IF NOT EXISTS Class
(
    id SERIAL,
    class VARCHAR(10) NOT NULL,
    type CHAR(1) NOT NULL,
    CONSTRAINT pk_Class PRIMARY KEY (id),
    CONSTRAINT chk_Class_Class CHECK (class IN('1er Annee','2eme Annee','3eme Annee','4eme Annee','5eme Annee','6eme Annee')),
    CONSTRAINT chk_type_Class CHECK (type IN('A','B','C','D'))
);

-- Table: StudentsClass
CREATE TABLE IF NOT EXISTS StudentsClass
(
    idStudents INTEGER NOT NULL,
    idClass INTEGER NOT NULL,
    anneeAcademique VARCHAR(9) NOT NULL,
    CONSTRAINT pk_StudentsClass PRIMARY KEY (idStudents, idClass, anneeAcademique),
    CONSTRAINT fk_StudentsClass_idClass FOREIGN KEY (idClass)
        REFERENCES Class (id),
    CONSTRAINT fk_StudentsClass_idStudents FOREIGN KEY (idStudents)
        REFERENCES Students (id)
);

-- Table: ClassTeachers
CREATE TABLE IF NOT EXISTS ClassTeachers
(
    idClass INTEGER NOT NULL,
    idTeachers INTEGER NOT NULL,
    anneeAcademique VARCHAR(9) NOT NULL,
    CONSTRAINT pk_ClassTeachers PRIMARY KEY (idClass, idTeachers, anneeAcademique),
    CONSTRAINT fk_ClassTeachers_idClass FOREIGN KEY (idClass)
        REFERENCES Class (id),
    CONSTRAINT fk_ClassTeachers_idTeachers FOREIGN KEY (idTeachers)
        REFERENCES Teachers (id)
);

-- Table: typeEvaluation
CREATE TABLE IF NOT EXISTS typeEvaluation
(
    id SERIAL,
    categories VARCHAR(20) NOT NULL,
    CONSTRAINT pk_typeEvaluation PRIMARY KEY (id),
    CONSTRAINT chk_categories CHECK (categories IN('1er Trimestre','2eme Trimestre','3eme Trimestre'))
);

-- Table: typeMatiere
CREATE TABLE IF NOT EXISTS typeMatiere
(
    id SERIAL,
    categories VARCHAR(50) NOT NULL,
    CONSTRAINT pk_typeMatiere PRIMARY KEY (id)
);

-- Table: Matiere
CREATE TABLE IF NOT EXISTS Matiere
(
    id SERIAL,
    idTypeMatiere INTEGER,
    name VARCHAR(100) NOT NULL,
    coeff real NOT NULL,
    detail TEXT NOT NULL DEFAULT 'Aucun detail',
    CONSTRAINT pk_Matiere PRIMARY KEY (id),
    CONSTRAINT fk_Matiere_idTypeMatiere FOREIGN KEY (idTypeMatiere)
        REFERENCES typeMatiere (id),
    CONSTRAINT chk_coeff CHECK (coeff BETWEEN 1 AND 4)
);

-- Table: Note
CREATE TABLE IF NOT EXISTS Note
(
    idStudents INTEGER NOT NULL,
    idMatiere INTEGER NOT NULL,
    idTypeEvaluation INTEGER NOT NULL,
    dateNote date DEFAULT CURRENT_DATE,
    nombreDePoint numeric NOT NULL,
    anneeAcademique VARCHAR(9) NOT NULL,
    commentaire VARCHAR(255) NOT NULL DEFAULT 'OK',
    CONSTRAINT pk_Note PRIMARY KEY (idStudents, idMatiere, idTypeEvaluation, anneeAcademique),
    CONSTRAINT fk_Note_idMatiere FOREIGN KEY (idMatiere)
        REFERENCES Matiere (id),
    CONSTRAINT fk_Note_idStudents FOREIGN KEY (idStudents)
        REFERENCES Students (id),
    CONSTRAINT fk_Note_idTypeEvaluation FOREIGN KEY (idTypeEvaluation)
        REFERENCES typeEvaluation (id),
    CONSTRAINT chk_nombreDePoint CHECK (nombreDePoint BETWEEN 0 AND 100)
);


-- Insertion on all tables

-- INSERT: Parents
INSERT INTO Parents (firstName, lastName, sex, address, tel, email) VALUES
('chery', 'stephania', 'F', 'Sous les Manguiers #18 Petit-goave, Haiti', '+509 3333 3000', 'cherystephania@gmail.com'),
('baptistin', 'nickson', 'M', 'Rue Bijoux #54, Petit-goave, Haiti', '+509 3333 3001', 'baptistinnickson@gmail.com'),
('toussaint', 'johane', 'F', 'Ruelle Foucault #85 Petit-goave, Haiti', '+509 3333 3002', 'toussaintjohane@gmail.com'),
('policier', 'evans', 'M', 'Avenue Gaston #12 Petit-goave, Haiti', '+509 3333 3003', 'policierevans@gmail.com'),
('jean-louis', 'hermite', 'F', 'Rue Benoit #38 Petit-goave, Haiti', '+509 3333 3004', 'jean-louishermite@gmail.com');

-- INSERT: Students
INSERT INTO Students (idParents, firstName, lastName, sex, dateNaiss, dateIns) VALUES
(1, 'altidor', 'don mitchell', 'M', TO_DATE('2001-06-12','YYYY-MM-DD'), TO_DATE('2020-02-22','YYYY-MM-DD')),
(2, 'bazile', 'meranda', 'F', TO_DATE('1998-04-13','YYYY-MM-DD'), TO_DATE('2020-02-18','YYYY-MM-DD')),
(3, 'pierre', 'fabrison', 'M', TO_DATE('2000-04-27','YYYY-MM-DD'), TO_DATE('2020-03-22','YYYY-MM-DD')),
(4, 'sarilus', 'christina', 'F', TO_DATE('1999-08-29','YYYY-MM-DD'), TO_DATE('2020-03-15','YYYY-MM-DD')),
(5, 'joseph', 'rolix', 'M', TO_DATE('1998-07-13','YYYY-MM-DD'), TO_DATE('2020-04-24','YYYY-MM-DD')),
(5, 'saintilus', 'sofia', 'F', TO_DATE('2000-05-23','YYYY-MM-DD'), TO_DATE('2020-05-09','YYYY-MM-DD')),
(4, 'pierre', 'louvinx', 'M', TO_DATE('1999-11-13','YYYY-MM-DD'), TO_DATE('2020-03-29','YYYY-MM-DD')),
(3, 'chery', 'lovelie', 'F', TO_DATE('2001-05-03','YYYY-MM-DD'), TO_DATE('2020-06-18','YYYY-MM-DD')),
(2, 'desire', 'junior', 'M', TO_DATE('2002-12-31','YYYY-MM-DD'), TO_DATE('2020-05-25','YYYY-MM-DD')),
(1, 'verne', 'eudwinia', 'F', TO_DATE('2008-08-30','YYYY-MM-DD'), TO_DATE('2020-04-24','YYYY-MM-DD'));

-- INSERT: Teachers
INSERT INTO Teachers (firstName, lastName, sex, address, tel, email, dateNaiss, dateEmbauche) VALUES
('chery', 'nathacha', 'F', 'Sous les Manguiers #20 Petit-goave, Haiti', '+509 4149 4400', 'cherynathacha@gmail.com', TO_DATE('1975-03-23','YYYY-MM-DD'), TO_DATE('2020-02-22','YYYY-MM-DD')),
('pierre', 'junior', 'M', 'Ruelle Maranatha #47 Petit-goave, Haiti', '+509 4149 4401', 'pierrejunior@gmail.com', TO_DATE('1990-06-12','YYYY-MM-DD'), TO_DATE('2020-09-14','YYYY-MM-DD')),
('jean', 'mirlande', 'F', 'Rue Republicaine #26 Petit-goave, Haiti', '+509 4149 4402', 'jeanmirlande@gmail.com', TO_DATE('1996-07-27','YYYY-MM-DD'), TO_DATE('2020-05-18','YYYY-MM-DD')),
('jacques', 'cadet', 'M', 'Rue Faustin #87 Petit-goave, Haiti', '+509 4149 4403', 'jacquescadet@gmail.com', TO_DATE('1994-01-29','YYYY-MM-DD'), TO_DATE('2020-04-25','YYYY-MM-DD')),
('cajuste', 'nadia', 'F', 'Avenue Gaston #67 Petit-goave, Haiti', '+509 4149 4404', 'cajustenadia@gmail.com', TO_DATE('1997-08-10','YYYY-MM-DD'), TO_DATE('2020-02-27','YYYY-MM-DD'));

-- INSERT: Class
INSERT INTO Class (class, type) VALUES 
('1er Annee', 'A'),
('2eme Annee', 'A'),
('3eme Annee', 'A'),
('4eme Annee', 'A'),
('5eme Annee', 'A');

-- INSERT: StudentsClass
INSERT INTO StudentsClass (idStudents, idClass, anneeAcademique) VALUES
(1, 1, '2020-2021'),
(2, 1, '2020-2021'),
(3, 2, '2020-2021'),
(4, 2, '2020-2021'),
(5, 3, '2020-2021'),
(6, 3, '2020-2021'),
(7, 4, '2020-2021'),
(8, 4, '2020-2021'),
(9, 5, '2020-2021'),
(10, 5, '2020-2021');

-- INSERT: ClassTeachers
INSERT INTO ClassTeachers (idClass, idTeachers, anneeAcademique) VALUES
(1, 1, '2020-2021'),
(2, 2, '2020-2021'),
(3, 3, '2020-2021'),
(4, 4, '2020-2021'),
(5, 5, '2020-2021');

-- INSERT: typeEvaluation
INSERT INTO typeEvaluation (categories) VALUES
('1er Trimestre'),
('2eme Trimestre'),
('3eme Trimestre');

-- INSERT: typeMatiere
INSERT INTO typeMatiere (categories) VALUES
('Sciences'),
('Langues'),
('Sciences sociales'),
('Arts'),
('Sport et education physique'),
('Technologie');

-- INSERT: Matiere
INSERT INTO Matiere (idTypeMatiere, name, coeff) VALUES
(1, 'Sciences experimentale', 3), 
(3, 'Histoire', 2), 
(3, 'Geographie', 2), 
(2, 'Creole', 2), 
(2, 'Francais', 2), 
(2, 'Anglais', 2), 
(2, 'Espagnol', 2), 
(4, 'Musique', 1), 
(4, 'Dessin', 1), 
(5, 'Education physique', 1), 
(6, 'Informatique', 1), 
(1, 'Mathematiques', 3);

-- INSERT: Note

-- 1er Trimestre

INSERT INTO Note (idStudents, idMatiere, idTypeEvaluation, dateNote, nombreDePoint, anneeAcademique) VALUES
(1, 1, 1, TO_DATE('2020-12-15','YYYY-MM-DD'), 80, '2020-2021'),
(1, 2, 1, TO_DATE('2020-12-15','YYYY-MM-DD'), 85, '2020-2021'),
(2, 1, 1, TO_DATE('2020-12-15','YYYY-MM-DD'), 70, '2020-2021'),
(2, 2, 1, TO_DATE('2020-12-15','YYYY-MM-DD'), 50, '2020-2021'),
(3, 1, 1, TO_DATE('2020-12-15','YYYY-MM-DD'), 65, '2020-2021'),
(3, 2, 1, TO_DATE('2020-12-15','YYYY-MM-DD'), 90, '2020-2021'),
(4, 1, 1, TO_DATE('2020-12-15','YYYY-MM-DD'), 77, '2020-2021'),
(4, 2, 1, TO_DATE('2020-12-15','YYYY-MM-DD'), 54, '2020-2021'),
(5, 1, 1, TO_DATE('2020-12-15','YYYY-MM-DD'), 95, '2020-2021'),
(5, 2, 1, TO_DATE('2020-12-15','YYYY-MM-DD'), 45, '2020-2021'),
(6, 1, 1, TO_DATE('2020-12-15','YYYY-MM-DD'), 78, '2020-2021'),
(6, 2, 1, TO_DATE('2020-12-15','YYYY-MM-DD'), 98, '2020-2021'),
(7, 1, 1, TO_DATE('2020-12-15','YYYY-MM-DD'), 67, '2020-2021'),
(7, 2, 1, TO_DATE('2020-12-15','YYYY-MM-DD'), 69, '2020-2021'),
(8, 1, 1, TO_DATE('2020-12-15','YYYY-MM-DD'), 83, '2020-2021'),
(8, 2, 1, TO_DATE('2020-12-15','YYYY-MM-DD'), 73, '2020-2021'),
(9, 1, 1, TO_DATE('2020-12-15','YYYY-MM-DD'), 55, '2020-2021'),
(9, 2, 1, TO_DATE('2020-12-15','YYYY-MM-DD'), 43, '2020-2021'),
(10, 1, 1, TO_DATE('2020-12-15','YYYY-MM-DD'), 59, '2020-2021'),
(10, 2, 1, TO_DATE('2020-12-15','YYYY-MM-DD'), 82, '2020-2021');

INSERT INTO Note (idStudents, idMatiere, idTypeEvaluation, dateNote, nombreDePoint, anneeAcademique) VALUES
(1, 3, 1, TO_DATE('2020-12-16','YYYY-MM-DD'), 78, '2020-2021'),
(1, 4, 1, TO_DATE('2020-12-16','YYYY-MM-DD'), 45, '2020-2021'),
(2, 3, 1, TO_DATE('2020-12-16','YYYY-MM-DD'), 68, '2020-2021'),
(2, 4, 1, TO_DATE('2020-12-16','YYYY-MM-DD'), 90, '2020-2021'),
(3, 3, 1, TO_DATE('2020-12-16','YYYY-MM-DD'), 87, '2020-2021'),
(3, 4, 1, TO_DATE('2020-12-16','YYYY-MM-DD'), 88, '2020-2021'),
(4, 3, 1, TO_DATE('2020-12-16','YYYY-MM-DD'), 95, '2020-2021'),
(4, 4, 1, TO_DATE('2020-12-16','YYYY-MM-DD'), 54, '2020-2021'),
(5, 3, 1, TO_DATE('2020-12-16','YYYY-MM-DD'), 55, '2020-2021'),
(5, 4, 1, TO_DATE('2020-12-16','YYYY-MM-DD'), 78, '2020-2021'),
(6, 3, 1, TO_DATE('2020-12-16','YYYY-MM-DD'), 69, '2020-2021'),
(6,	4, 1, TO_DATE('2020-12-16','YYYY-MM-DD'), 60, '2020-2021'),
(7,	3, 1, TO_DATE('2020-12-16','YYYY-MM-DD'), 50, '2020-2021'),
(7,	4, 1, TO_DATE('2020-12-16','YYYY-MM-DD'), 70, '2020-2021'),
(8,	3, 1, TO_DATE('2020-12-16','YYYY-MM-DD'), 98, '2020-2021'),
(8,	4, 1, TO_DATE('2020-12-16','YYYY-MM-DD'), 83, '2020-2021'),
(9,	3, 1, TO_DATE('2020-12-16','YYYY-MM-DD'), 49, '2020-2021'),
(9,	4, 1, TO_DATE('2020-12-16','YYYY-MM-DD'), 55, '2020-2021'),
(10, 3,	1, TO_DATE('2020-12-16','YYYY-MM-DD'), 79, '2020-2021'),
(10, 4,	1, TO_DATE('2020-12-16','YYYY-MM-DD'), 68, '2020-2021');

INSERT INTO Note (idStudents, idMatiere, idTypeEvaluation, dateNote, nombreDePoint, anneeAcademique) VALUES
(1,	5, 1, TO_DATE('2020-12-17','YYYY-MM-DD'), 89, '2020-2021'),
(1,	6, 1, TO_DATE('2020-12-17','YYYY-MM-DD'), 59, '2020-2021'),
(2,	5, 1, TO_DATE('2020-12-17','YYYY-MM-DD'), 70, '2020-2021'),
(2,	6, 1, TO_DATE('2020-12-17','YYYY-MM-DD'), 72, '2020-2021'),
(3,	5, 1, TO_DATE('2020-12-17','YYYY-MM-DD'), 78, '2020-2021'),
(3,	6, 1, TO_DATE('2020-12-17','YYYY-MM-DD'), 77, '2020-2021'),
(4,	5, 1, TO_DATE('2020-12-17','YYYY-MM-DD'), 98, '2020-2021'),
(4,	6, 1, TO_DATE('2020-12-17','YYYY-MM-DD'), 80, '2020-2021'),
(5,	5, 1, TO_DATE('2020-12-17','YYYY-MM-DD'), 82, '2020-2021'),
(5,	6, 1, TO_DATE('2020-12-17','YYYY-MM-DD'), 88, '2020-2021'),
(6,	5, 1, TO_DATE('2020-12-17','YYYY-MM-DD'), 74, '2020-2021'),
(6,	6, 1, TO_DATE('2020-12-17','YYYY-MM-DD'), 69, '2020-2021'),
(7,	5, 1, TO_DATE('2020-12-17','YYYY-MM-DD'), 64, '2020-2021'),
(7,	6, 1, TO_DATE('2020-12-17','YYYY-MM-DD'), 75, '2020-2021'),
(8,	5, 1, TO_DATE('2020-12-17','YYYY-MM-DD'), 57, '2020-2021'),
(8,	6, 1, TO_DATE('2020-12-17','YYYY-MM-DD'), 59, '2020-2021'),
(9,	5, 1, TO_DATE('2020-12-17','YYYY-MM-DD'), 78, '2020-2021'),
(9,	6, 1, TO_DATE('2020-12-17','YYYY-MM-DD'), 59, '2020-2021'),
(10, 5,	1, TO_DATE('2020-12-17','YYYY-MM-DD'), 98, '2020-2021'),
(10, 6,	1, TO_DATE('2020-12-17','YYYY-MM-DD'), 78, '2020-2021');

INSERT INTO Note (idStudents, idMatiere, idTypeEvaluation, dateNote, nombreDePoint, anneeAcademique) VALUES
(1,	7, 1, TO_DATE('2020-12-18','YYYY-MM-DD'), 88, '2020-2021'),
(1,	8, 1, TO_DATE('2020-12-18','YYYY-MM-DD'), 57, '2020-2021'),
(2, 7, 1, TO_DATE('2020-12-18','YYYY-MM-DD'), 49, '2020-2021'),
(2, 8, 1, TO_DATE('2020-12-18','YYYY-MM-DD'), 89, '2020-2021'),
(3, 7, 1, TO_DATE('2020-12-18','YYYY-MM-DD'), 89, '2020-2021'),
(3, 8, 1, TO_DATE('2020-12-18','YYYY-MM-DD'), 99, '2020-2021'),
(4, 7, 1, TO_DATE('2020-12-18','YYYY-MM-DD'), 70, '2020-2021'),
(4, 8, 1, TO_DATE('2020-12-18','YYYY-MM-DD'), 70, '2020-2021'),
(5, 7, 1, TO_DATE('2020-12-18','YYYY-MM-DD'), 60, '2020-2021'),
(5, 8, 1, TO_DATE('2020-12-18','YYYY-MM-DD'), 88, '2020-2021'),
(6, 7, 1, TO_DATE('2020-12-18','YYYY-MM-DD'), 67, '2020-2021'),
(6, 8, 1, TO_DATE('2020-12-18','YYYY-MM-DD'), 90, '2020-2021'),
(7, 7, 1, TO_DATE('2020-12-18','YYYY-MM-DD'), 65, '2020-2021'),
(7, 8, 1, TO_DATE('2020-12-18','YYYY-MM-DD'), 55, '2020-2021'),
(8, 7, 1, TO_DATE('2020-12-18','YYYY-MM-DD'), 59, '2020-2021'),
(8, 8, 1, TO_DATE('2020-12-18','YYYY-MM-DD'), 60, '2020-2021'),
(9, 7, 1, TO_DATE('2020-12-18','YYYY-MM-DD'), 68, '2020-2021'),
(9, 8, 1, TO_DATE('2020-12-18','YYYY-MM-DD'), 87, '2020-2021'),
(10, 7,	1, TO_DATE('2020-12-18','YYYY-MM-DD'), 89, '2020-2021'),
(10, 8,	1, TO_DATE('2020-12-18','YYYY-MM-DD'), 69, '2020-2021');

INSERT INTO Note (idStudents, idMatiere, idTypeEvaluation, dateNote, nombreDePoint, anneeAcademique) VALUES
(1, 9, 1, TO_DATE('2020-12-19','YYYY-MM-DD'), 90, '2020-2021'),
(1, 10, 1, TO_DATE('2020-12-19','YYYY-MM-DD'), 93, '2020-2021'),
(2, 9, 1, TO_DATE('2020-12-19','YYYY-MM-DD'), 95, '2020-2021'),
(2, 10, 1, TO_DATE('2020-12-19','YYYY-MM-DD'), 53, '2020-2021'),
(3, 9, 1, TO_DATE('2020-12-19','YYYY-MM-DD'), 79, '2020-2021'),
(3, 10, 1, TO_DATE('2020-12-19','YYYY-MM-DD'), 83, '2020-2021'),
(4, 9, 1, TO_DATE('2020-12-19','YYYY-MM-DD'), 80, '2020-2021'),
(4, 10, 1, TO_DATE('2020-12-19','YYYY-MM-DD'), 73, '2020-2021'),
(5, 9, 1, TO_DATE('2020-12-19','YYYY-MM-DD'), 67, '2020-2021'),
(5, 10, 1, TO_DATE('2020-12-19','YYYY-MM-DD'), 83, '2020-2021'),
(6, 9, 1, TO_DATE('2020-12-19','YYYY-MM-DD'), 87, '2020-2021'),
(6, 10, 1, TO_DATE('2020-12-19','YYYY-MM-DD'), 73, '2020-2021'),
(7, 9, 1, TO_DATE('2020-12-19','YYYY-MM-DD'), 62, '2020-2021'),
(7, 10, 1, TO_DATE('2020-12-19','YYYY-MM-DD'), 97, '2020-2021'),
(8,	9, 1, TO_DATE('2020-12-19','YYYY-MM-DD'), 85, '2020-2021'),
(8, 10, 1, TO_DATE('2020-12-19','YYYY-MM-DD'), 47, '2020-2021'),
(9,	9, 1, TO_DATE('2020-12-19','YYYY-MM-DD'), 81, '2020-2021'),
(9, 10, 1, TO_DATE('2020-12-19','YYYY-MM-DD'), 90, '2020-2021'),
(10, 9, 1, TO_DATE('2020-12-19','YYYY-MM-DD'), 54, '2020-2021'),
(10, 10, 1, TO_DATE('2020-12-19','YYYY-MM-DD'), 75, '2020-2021');

INSERT INTO Note (idStudents, idMatiere, idTypeEvaluation, dateNote, nombreDePoint, anneeAcademique) VALUES
(1, 11, 1, TO_DATE('2020-12-20','YYYY-MM-DD'), 67, '2020-2021'),
(1, 12, 1, TO_DATE('2020-12-20','YYYY-MM-DD'), 68, '2020-2021'),
(2, 11, 1, TO_DATE('2020-12-20','YYYY-MM-DD'), 73, '2020-2021'),
(2, 12, 1, TO_DATE('2020-12-20','YYYY-MM-DD'), 76, '2020-2021'),
(3, 11, 1, TO_DATE('2020-12-20','YYYY-MM-DD'), 79, '2020-2021'),
(3, 12, 1, TO_DATE('2020-12-20','YYYY-MM-DD'), 89, '2020-2021'),
(4, 11, 1, TO_DATE('2020-12-20','YYYY-MM-DD'), 92, '2020-2021'),
(4, 12, 1, TO_DATE('2020-12-20','YYYY-MM-DD'), 74, '2020-2021'),
(5, 11, 1, TO_DATE('2020-12-20','YYYY-MM-DD'), 89, '2020-2021'),
(5, 12, 1, TO_DATE('2020-12-20','YYYY-MM-DD'), 82, '2020-2021'),
(6, 11, 1, TO_DATE('2020-12-20','YYYY-MM-DD'), 72, '2020-2021'),
(6, 12, 1, TO_DATE('2020-12-20','YYYY-MM-DD'), 90, '2020-2021'),
(7, 11, 1, TO_DATE('2020-12-20','YYYY-MM-DD'), 56, '2020-2021'),
(7, 12, 1, TO_DATE('2020-12-20','YYYY-MM-DD'), 93, '2020-2021'),
(8, 11, 1, TO_DATE('2020-12-20','YYYY-MM-DD'), 68, '2020-2021'),
(8, 12, 1, TO_DATE('2020-12-20','YYYY-MM-DD'), 87, '2020-2021'),
(9, 11, 1, TO_DATE('2020-12-20','YYYY-MM-DD'), 58, '2020-2021'),
(9, 12, 1, TO_DATE('2020-12-20','YYYY-MM-DD'), 87, '2020-2021'),
(10, 11, 1, TO_DATE('2020-12-20','YYYY-MM-DD'), 68, '2020-2021'),
(10, 12, 1, TO_DATE('2020-12-20','YYYY-MM-DD'), 85, '2020-2021');


-- 2eme Trimestre

INSERT INTO Note (idStudents, idMatiere, idTypeEvaluation, dateNote, nombreDePoint, anneeAcademique) VALUES
(1, 1, 2, TO_DATE('2021-04-15','YYYY-MM-DD'), 50, '2020-2021'),
(1, 2, 2, TO_DATE('2021-04-15','YYYY-MM-DD'), 65, '2020-2021'),
(2, 1, 2, TO_DATE('2021-04-15','YYYY-MM-DD'), 90, '2020-2021'),
(2, 2, 2, TO_DATE('2021-04-15','YYYY-MM-DD'), 80, '2020-2021'),
(3, 1, 2, TO_DATE('2021-04-15','YYYY-MM-DD'), 75, '2020-2021'),
(3, 2, 2, TO_DATE('2021-04-15','YYYY-MM-DD'), 50, '2020-2021'),
(4, 1, 2, TO_DATE('2021-04-15','YYYY-MM-DD'), 67, '2020-2021'),
(4, 2, 2, TO_DATE('2021-04-15','YYYY-MM-DD'), 94, '2020-2021'),
(5, 1, 2, TO_DATE('2021-04-15','YYYY-MM-DD'), 65, '2020-2021'),
(5, 2, 2, TO_DATE('2021-04-15','YYYY-MM-DD'), 85, '2020-2021'),
(6, 1, 2, TO_DATE('2021-04-15','YYYY-MM-DD'), 58, '2020-2021'),
(6, 2, 2, TO_DATE('2021-04-15','YYYY-MM-DD'), 68, '2020-2021'),
(7, 1, 2, TO_DATE('2021-04-15','YYYY-MM-DD'), 57, '2020-2021'),
(7, 2, 2, TO_DATE('2021-04-15','YYYY-MM-DD'), 89, '2020-2021'),
(8, 1, 2, TO_DATE('2021-04-15','YYYY-MM-DD'), 63, '2020-2021'),
(8, 2, 2, TO_DATE('2021-04-15','YYYY-MM-DD'), 43, '2020-2021'),
(9, 1, 2, TO_DATE('2021-04-15','YYYY-MM-DD'), 85, '2020-2021'),
(9, 2, 2, TO_DATE('2021-04-15','YYYY-MM-DD'), 73, '2020-2021'),
(10, 1, 2, TO_DATE('2021-04-15','YYYY-MM-DD'), 89, '2020-2021'),
(10, 2, 2, TO_DATE('2021-04-15','YYYY-MM-DD'), 62, '2020-2021');

INSERT INTO Note (idStudents, idMatiere, idTypeEvaluation, dateNote, nombreDePoint, anneeAcademique) VALUES
(1, 3, 2, TO_DATE('2021-04-16','YYYY-MM-DD'), 56, '2020-2021'),
(1, 4, 2, TO_DATE('2021-04-16','YYYY-MM-DD'), 87, '2020-2021'),
(2, 3, 2, TO_DATE('2021-04-16','YYYY-MM-DD'), 47, '2020-2021'),
(2, 4, 2, TO_DATE('2021-04-16','YYYY-MM-DD'), 75, '2020-2021'),
(3, 3, 2, TO_DATE('2021-04-16','YYYY-MM-DD'), 47, '2020-2021'),
(3, 4, 2, TO_DATE('2021-04-16','YYYY-MM-DD'), 87, '2020-2021'),
(4, 3, 2, TO_DATE('2021-04-16','YYYY-MM-DD'), 76, '2020-2021'),
(4, 4, 2, TO_DATE('2021-04-16','YYYY-MM-DD'), 58, '2020-2021'),
(5, 3, 2, TO_DATE('2021-04-16','YYYY-MM-DD'), 65, '2020-2021'),
(5, 4, 2, TO_DATE('2021-04-16','YYYY-MM-DD'), 87, '2020-2021'),
(6, 3, 2, TO_DATE('2021-04-16','YYYY-MM-DD'), 57, '2020-2021'),
(6, 4, 2, TO_DATE('2021-04-16','YYYY-MM-DD'), 87, '2020-2021'),
(7, 3, 2, TO_DATE('2021-04-16','YYYY-MM-DD'), 57, '2020-2021'),
(7, 4, 2, TO_DATE('2021-04-16','YYYY-MM-DD'), 76, '2020-2021'),
(8, 3, 2, TO_DATE('2021-04-16','YYYY-MM-DD'), 45, '2020-2021'),
(8, 4, 2, TO_DATE('2021-04-16','YYYY-MM-DD'), 54, '2020-2021'),
(9, 3, 2, TO_DATE('2021-04-16','YYYY-MM-DD'), 76, '2020-2021'),
(9, 4, 2, TO_DATE('2021-04-16','YYYY-MM-DD'), 46, '2020-2021'),
(10, 3, 2, TO_DATE('2021-04-16','YYYY-MM-DD'), 67, '2020-2021'),
(10, 4, 2, TO_DATE('2021-04-16','YYYY-MM-DD'), 76, '2020-2021');

INSERT INTO Note (idStudents, idMatiere, idTypeEvaluation, dateNote, nombreDePoint, anneeAcademique) VALUES
(1, 5, 2, TO_DATE('2021-04-17','YYYY-MM-DD'), 79, '2020-2021'),
(1, 6, 2, TO_DATE('2021-04-17','YYYY-MM-DD'), 79, '2020-2021'),
(2, 5, 2, TO_DATE('2021-04-17','YYYY-MM-DD'), 40, '2020-2021'),
(2, 6, 2, TO_DATE('2021-04-17','YYYY-MM-DD'), 82, '2020-2021'),
(3, 5, 2, TO_DATE('2021-04-17','YYYY-MM-DD'), 38, '2020-2021'),
(3, 6, 2, TO_DATE('2021-04-17','YYYY-MM-DD'), 87, '2020-2021'),
(4, 5, 2, TO_DATE('2021-04-17','YYYY-MM-DD'), 68, '2020-2021'),
(4, 6, 2, TO_DATE('2021-04-17','YYYY-MM-DD'), 60, '2020-2021'),
(5, 5, 2, TO_DATE('2021-04-17','YYYY-MM-DD'), 52, '2020-2021'),
(5, 6, 2, TO_DATE('2021-04-17','YYYY-MM-DD'), 48, '2020-2021'),
(6, 5, 2, TO_DATE('2021-04-17','YYYY-MM-DD'), 84, '2020-2021'),
(6, 6, 2, TO_DATE('2021-04-17','YYYY-MM-DD'), 79, '2020-2021'),
(7, 5, 2, TO_DATE('2021-04-17','YYYY-MM-DD'), 74, '2020-2021'),
(7, 6, 2, TO_DATE('2021-04-17','YYYY-MM-DD'), 55, '2020-2021'),
(8, 5, 2, TO_DATE('2021-04-17','YYYY-MM-DD'), 87, '2020-2021'),
(8, 6, 2, TO_DATE('2021-04-17','YYYY-MM-DD'), 79, '2020-2021'),
(9, 5, 2, TO_DATE('2021-04-17','YYYY-MM-DD'), 57, '2020-2021'),
(9, 6, 2, TO_DATE('2021-04-17','YYYY-MM-DD'), 79, '2020-2021'),
(10, 5, 2, TO_DATE('2021-04-17','YYYY-MM-DD'), 68, '2020-2021'),
(10, 6, 2, TO_DATE('2021-04-17','YYYY-MM-DD'), 68, '2020-2021');

INSERT INTO Note (idStudents, idMatiere, idTypeEvaluation, dateNote, nombreDePoint, anneeAcademique) VALUES
(1, 7, 2, TO_DATE('2021-04-18','YYYY-MM-DD'), 56, '2020-2021'),
(1, 8, 2, TO_DATE('2021-04-18','YYYY-MM-DD'), 85, '2020-2021'),
(2, 7, 2, TO_DATE('2021-04-18','YYYY-MM-DD'), 45, '2020-2021'),
(2, 8, 2, TO_DATE('2021-04-18','YYYY-MM-DD'), 77, '2020-2021'),
(3, 7, 2, TO_DATE('2021-04-18','YYYY-MM-DD'), 54, '2020-2021'),
(3, 8, 2, TO_DATE('2021-04-18','YYYY-MM-DD'), 64, '2020-2021'),
(4, 7, 2, TO_DATE('2021-04-18','YYYY-MM-DD'), 63, '2020-2021'),
(4, 8, 2, TO_DATE('2021-04-18','YYYY-MM-DD'), 54, '2020-2021'),
(5, 7, 2, TO_DATE('2021-04-18','YYYY-MM-DD'), 65, '2020-2021'),
(5, 8, 2, TO_DATE('2021-04-18','YYYY-MM-DD'), 45, '2020-2021'),
(6, 7, 2, TO_DATE('2021-04-18','YYYY-MM-DD'), 64, '2020-2021'),
(6, 8, 2, TO_DATE('2021-04-18','YYYY-MM-DD'), 35, '2020-2021'),
(7, 7, 2, TO_DATE('2021-04-18','YYYY-MM-DD'), 76, '2020-2021'),
(7, 8, 2, TO_DATE('2021-04-18','YYYY-MM-DD'), 46, '2020-2021'),
(8, 7, 2, TO_DATE('2021-04-18','YYYY-MM-DD'), 76, '2020-2021'),
(8, 8, 2, TO_DATE('2021-04-18','YYYY-MM-DD'), 45, '2020-2021'),
(9, 7, 2, TO_DATE('2021-04-18','YYYY-MM-DD'), 42, '2020-2021'),
(9, 8, 2, TO_DATE('2021-04-18','YYYY-MM-DD'), 78, '2020-2021'),
(10, 7, 2, TO_DATE('2021-04-18','YYYY-MM-DD'), 76, '2020-2021'),
(10, 8, 2, TO_DATE('2021-04-18','YYYY-MM-DD'), 58, '2020-2021');

INSERT INTO Note (idStudents, idMatiere, idTypeEvaluation, dateNote, nombreDePoint, anneeAcademique) VALUES
(1, 9, 2, TO_DATE('2021-04-19','YYYY-MM-DD'), 40, '2020-2021'),
(1, 10, 2, TO_DATE('2021-04-19','YYYY-MM-DD'), 73, '2020-2021'),
(2, 9, 2, TO_DATE('2021-04-19','YYYY-MM-DD'), 55, '2020-2021'),
(2, 10, 2, TO_DATE('2021-04-19','YYYY-MM-DD'), 58, '2020-2021'),
(3, 9, 2, TO_DATE('2021-04-19','YYYY-MM-DD'), 49, '2020-2021'),
(3, 10, 2, TO_DATE('2021-04-19','YYYY-MM-DD'), 52, '2020-2021'),
(4, 9, 2, TO_DATE('2021-04-19','YYYY-MM-DD'), 60, '2020-2021'),
(4, 10, 2, TO_DATE('2021-04-19','YYYY-MM-DD'), 67, '2020-2021'),
(5, 9, 2, TO_DATE('2021-04-19','YYYY-MM-DD'), 67, '2020-2021'),
(5, 10, 2, TO_DATE('2021-04-19','YYYY-MM-DD'), 53, '2020-2021'),
(6, 9, 2, TO_DATE('2021-04-19','YYYY-MM-DD'), 47, '2020-2021'),
(6, 10, 2, TO_DATE('2021-04-19','YYYY-MM-DD'), 55, '2020-2021'),
(7, 9, 2, TO_DATE('2021-04-19','YYYY-MM-DD'), 52, '2020-2021'),
(7, 10, 2, TO_DATE('2021-04-19','YYYY-MM-DD'), 67, '2020-2021'),
(8, 9, 2, TO_DATE('2021-04-19','YYYY-MM-DD'), 75, '2020-2021'),
(8, 10, 2, TO_DATE('2021-04-19','YYYY-MM-DD'), 47, '2020-2021'),
(9, 9, 2, TO_DATE('2021-04-19','YYYY-MM-DD'), 61, '2020-2021'),
(9, 10, 2, TO_DATE('2021-04-19','YYYY-MM-DD'), 80, '2020-2021'),
(10, 9, 2, TO_DATE('2021-04-19','YYYY-MM-DD'), 84, '2020-2021'),
(10, 10, 2, TO_DATE('2021-04-19','YYYY-MM-DD'), 85, '2020-2021');

INSERT INTO Note (idStudents, idMatiere, idTypeEvaluation, dateNote, nombreDePoint, anneeAcademique) VALUES
(1, 11, 2, TO_DATE('2021-04-20','YYYY-MM-DD'), 40, '2020-2021'),
(1, 12, 2, TO_DATE('2021-04-20','YYYY-MM-DD'), 65, '2020-2021'),
(2, 11, 2, TO_DATE('2021-04-20','YYYY-MM-DD'), 35, '2020-2021'),
(2, 12, 2, TO_DATE('2021-04-20','YYYY-MM-DD'), 45, '2020-2021'),
(3, 11, 2, TO_DATE('2021-04-20','YYYY-MM-DD'), 30, '2020-2021'),
(3, 12, 2, TO_DATE('2021-04-20','YYYY-MM-DD'), 62, '2020-2021'),
(4, 11, 2, TO_DATE('2021-04-20','YYYY-MM-DD'), 51, '2020-2021'),
(4, 12, 2, TO_DATE('2021-04-20','YYYY-MM-DD'), 35, '2020-2021'),
(5, 11, 2, TO_DATE('2021-04-20','YYYY-MM-DD'), 65, '2020-2021'),
(5, 12, 2, TO_DATE('2021-04-20','YYYY-MM-DD'), 54, '2020-2021'),
(6, 11, 2, TO_DATE('2021-04-20','YYYY-MM-DD'), 23, '2020-2021'),
(6, 12, 2, TO_DATE('2021-04-20','YYYY-MM-DD'), 56, '2020-2021'),
(7, 11, 2, TO_DATE('2021-04-20','YYYY-MM-DD'), 65, '2020-2021'),
(7, 12, 2, TO_DATE('2021-04-20','YYYY-MM-DD'), 52, '2020-2021'),
(8, 11, 2, TO_DATE('2021-04-20','YYYY-MM-DD'), 45, '2020-2021'),
(8, 12, 2, TO_DATE('2021-04-20','YYYY-MM-DD'), 53, '2020-2021'),
(9, 11, 2, TO_DATE('2021-04-20','YYYY-MM-DD'), 56, '2020-2021'),
(9, 12, 2, TO_DATE('2021-04-20','YYYY-MM-DD'), 43, '2020-2021'),
(10, 11, 2, TO_DATE('2021-04-20','YYYY-MM-DD'), 43, '2020-2021'),
(10, 12, 2, TO_DATE('2021-04-20','YYYY-MM-DD'), 54, '2020-2021');


-- 3eme Trimestre

INSERT INTO Note (idStudents, idMatiere, idTypeEvaluation, dateNote, nombreDePoint, anneeAcademique) VALUES
(1, 1, 3, TO_DATE('2021-07-15','YYYY-MM-DD'), 60, '2020-2021'),
(1, 2, 3, TO_DATE('2021-07-15','YYYY-MM-DD'), 55, '2020-2021'),
(2, 1, 3, TO_DATE('2021-07-15','YYYY-MM-DD'), 80, '2020-2021'),
(2, 2, 3, TO_DATE('2021-07-15','YYYY-MM-DD'), 60, '2020-2021'),
(3, 1, 3, TO_DATE('2021-07-15','YYYY-MM-DD'), 75, '2020-2021'),
(3, 2, 3, TO_DATE('2021-07-15','YYYY-MM-DD'), 70, '2020-2021'),
(4, 1, 3, TO_DATE('2021-07-15','YYYY-MM-DD'), 77, '2020-2021'),
(4, 2, 3, TO_DATE('2021-07-15','YYYY-MM-DD'), 54, '2020-2021'),
(5, 1, 3, TO_DATE('2021-07-15','YYYY-MM-DD'), 85, '2020-2021'),
(5, 2, 3, TO_DATE('2021-07-15','YYYY-MM-DD'), 65, '2020-2021'),
(6, 1, 3, TO_DATE('2021-07-15','YYYY-MM-DD'), 78, '2020-2021'),
(6, 2, 3, TO_DATE('2021-07-15','YYYY-MM-DD'), 58, '2020-2021'),
(7, 1, 3, TO_DATE('2021-07-15','YYYY-MM-DD'), 77, '2020-2021'),
(7, 2, 3, TO_DATE('2021-07-15','YYYY-MM-DD'), 59, '2020-2021'),
(8, 1, 3, TO_DATE('2021-07-15','YYYY-MM-DD'), 53, '2020-2021'),
(8, 2, 3, TO_DATE('2021-07-15','YYYY-MM-DD'), 73, '2020-2021'),
(9, 1, 3, TO_DATE('2021-07-15','YYYY-MM-DD'), 55, '2020-2021'),
(9, 2, 3, TO_DATE('2021-07-15','YYYY-MM-DD'), 43, '2020-2021'),
(10, 1, 3, TO_DATE('2021-07-15','YYYY-MM-DD'), 59, '2020-2021'),
(10, 2, 3, TO_DATE('2021-07-15','YYYY-MM-DD'), 62, '2020-2021');

INSERT INTO Note (idStudents, idMatiere, idTypeEvaluation, dateNote, nombreDePoint, anneeAcademique) VALUES
(1, 3, 3, TO_DATE('2021-07-16','YYYY-MM-DD'), 78, '2020-2021'),
(1, 4, 3, TO_DATE('2021-07-16','YYYY-MM-DD'), 45, '2020-2021'),
(2, 3, 3, TO_DATE('2021-07-16','YYYY-MM-DD'), 68, '2020-2021'),
(2, 4, 3, TO_DATE('2021-07-16','YYYY-MM-DD'), 50, '2020-2021'),
(3, 3, 3, TO_DATE('2021-07-16','YYYY-MM-DD'), 87, '2020-2021'),
(3, 4, 3, TO_DATE('2021-07-16','YYYY-MM-DD'), 68, '2020-2021'),
(4, 3, 3, TO_DATE('2021-07-16','YYYY-MM-DD'), 85, '2020-2021'),
(4, 4, 3, TO_DATE('2021-07-16','YYYY-MM-DD'), 54, '2020-2021'),
(5, 3, 3, TO_DATE('2021-07-16','YYYY-MM-DD'), 55, '2020-2021'),
(5, 4, 3, TO_DATE('2021-07-16','YYYY-MM-DD'), 78, '2020-2021'),
(6, 3, 3, TO_DATE('2021-07-16','YYYY-MM-DD'), 69, '2020-2021'),
(6, 4, 3, TO_DATE('2021-07-16','YYYY-MM-DD'), 60, '2020-2021'),
(7, 3, 3, TO_DATE('2021-07-16','YYYY-MM-DD'), 50, '2020-2021'),
(7, 4, 3, TO_DATE('2021-07-16','YYYY-MM-DD'), 70, '2020-2021'),
(8, 3, 3, TO_DATE('2021-07-16','YYYY-MM-DD'), 68, '2020-2021'),
(8, 4, 3, TO_DATE('2021-07-16','YYYY-MM-DD'), 75, '2020-2021'),
(9, 3, 3, TO_DATE('2021-07-16','YYYY-MM-DD'), 69, '2020-2021'),
(9, 4, 3, TO_DATE('2021-07-16','YYYY-MM-DD'), 55, '2020-2021'),
(10, 3, 3, TO_DATE('2021-07-16','YYYY-MM-DD'), 79, '2020-2021'),
(10, 4, 3, TO_DATE('2021-07-16','YYYY-MM-DD'), 68, '2020-2021');

INSERT INTO Note (idStudents, idMatiere, idTypeEvaluation, dateNote, nombreDePoint, anneeAcademique) VALUES
(1, 5, 3, TO_DATE('2021-07-17','YYYY-MM-DD'), 67, '2020-2021'),
(1, 6, 3, TO_DATE('2021-07-17','YYYY-MM-DD'), 69, '2020-2021'),
(2, 5, 3, TO_DATE('2021-07-17','YYYY-MM-DD'), 70, '2020-2021'),
(2, 6, 3, TO_DATE('2021-07-17','YYYY-MM-DD'), 72, '2020-2021'),
(3, 5, 3, TO_DATE('2021-07-17','YYYY-MM-DD'), 78, '2020-2021'),
(3, 6, 3, TO_DATE('2021-07-17','YYYY-MM-DD'), 77, '2020-2021'),
(4, 5, 3, TO_DATE('2021-07-17','YYYY-MM-DD'), 78, '2020-2021'),
(4, 6, 3, TO_DATE('2021-07-17','YYYY-MM-DD'), 70, '2020-2021'),
(5, 5, 3, TO_DATE('2021-07-17','YYYY-MM-DD'), 82, '2020-2021'),
(5, 6, 3, TO_DATE('2021-07-17','YYYY-MM-DD'), 58, '2020-2021'),
(6, 5, 3, TO_DATE('2021-07-17','YYYY-MM-DD'), 54, '2020-2021'),
(6, 6, 3, TO_DATE('2021-07-17','YYYY-MM-DD'), 69, '2020-2021'),
(7, 5, 3, TO_DATE('2021-07-17','YYYY-MM-DD'), 64, '2020-2021'),
(7, 6, 3, TO_DATE('2021-07-17','YYYY-MM-DD'), 75, '2020-2021'),
(8, 5, 3, TO_DATE('2021-07-17','YYYY-MM-DD'), 77, '2020-2021'),
(8, 6, 3, TO_DATE('2021-07-17','YYYY-MM-DD'), 59, '2020-2021'),
(9, 5, 3, TO_DATE('2021-07-17','YYYY-MM-DD'), 78, '2020-2021'),
(9, 6, 3, TO_DATE('2021-07-17','YYYY-MM-DD'), 59, '2020-2021'),
(10, 5, 3, TO_DATE('2021-07-17','YYYY-MM-DD'), 78, '2020-2021'),
(10, 6, 3, TO_DATE('2021-07-17','YYYY-MM-DD'), 78, '2020-2021');

INSERT INTO Note (idStudents, idMatiere, idTypeEvaluation, dateNote, nombreDePoint, anneeAcademique) VALUES
(1, 7, 3, TO_DATE('2021-07-18','YYYY-MM-DD'), 88, '2020-2021'),
(1, 8, 3, TO_DATE('2021-07-18','YYYY-MM-DD'), 57, '2020-2021'),
(2, 7, 3, TO_DATE('2021-07-18','YYYY-MM-DD'), 49, '2020-2021'),
(2, 8, 3, TO_DATE('2021-07-18','YYYY-MM-DD'), 57, '2020-2021'),
(3, 7, 3, TO_DATE('2021-07-18','YYYY-MM-DD'), 79, '2020-2021'),
(3, 8, 3, TO_DATE('2021-07-18','YYYY-MM-DD'), 67, '2020-2021'),
(4, 7, 3, TO_DATE('2021-07-18','YYYY-MM-DD'), 70, '2020-2021'),
(4, 8, 3, TO_DATE('2021-07-18','YYYY-MM-DD'), 70, '2020-2021'),
(5, 7, 3, TO_DATE('2021-07-18','YYYY-MM-DD'), 60, '2020-2021'),
(5, 8, 3, TO_DATE('2021-07-18','YYYY-MM-DD'), 58, '2020-2021'),
(6, 7, 3, TO_DATE('2021-07-18','YYYY-MM-DD'), 67, '2020-2021'),
(6, 8, 3, TO_DATE('2021-07-18','YYYY-MM-DD'), 70, '2020-2021'),
(7, 7, 3, TO_DATE('2021-07-18','YYYY-MM-DD'), 65, '2020-2021'),
(7, 8, 3, TO_DATE('2021-07-18','YYYY-MM-DD'), 55, '2020-2021'),
(8, 7, 3, TO_DATE('2021-07-18','YYYY-MM-DD'), 59, '2020-2021'),
(8, 8, 3, TO_DATE('2021-07-18','YYYY-MM-DD'), 60, '2020-2021'),
(9, 7, 3, TO_DATE('2021-07-18','YYYY-MM-DD'), 68, '2020-2021'),
(9, 8, 3, TO_DATE('2021-07-18','YYYY-MM-DD'), 67, '2020-2021'),
(10, 7, 3, TO_DATE('2021-07-18','YYYY-MM-DD'), 67, '2020-2021'),
(10, 8, 3, TO_DATE('2021-07-18','YYYY-MM-DD'), 79, '2020-2021');

INSERT INTO Note (idStudents, idMatiere, idTypeEvaluation, dateNote, nombreDePoint, anneeAcademique) VALUES
(1, 9, 3, TO_DATE('2021-07-19','YYYY-MM-DD'), 80, '2020-2021'),
(1, 10, 3, TO_DATE('2021-07-19','YYYY-MM-DD'), 73, '2020-2021'),
(2, 9, 3, TO_DATE('2021-07-19','YYYY-MM-DD'), 65, '2020-2021'),
(2, 10, 3, TO_DATE('2021-07-19','YYYY-MM-DD'), 58, '2020-2021'),
(3, 9, 3, TO_DATE('2021-07-19','YYYY-MM-DD'), 59, '2020-2021'),
(3, 10, 3, TO_DATE('2021-07-19','YYYY-MM-DD'), 72, '2020-2021'),
(4, 9, 3, TO_DATE('2021-07-19','YYYY-MM-DD'), 60, '2020-2021'),
(4, 10, 3, TO_DATE('2021-07-19','YYYY-MM-DD'), 47, '2020-2021'),
(5, 9, 3, TO_DATE('2021-07-19','YYYY-MM-DD'), 67, '2020-2021'),
(5, 10, 3, TO_DATE('2021-07-19','YYYY-MM-DD'), 53, '2020-2021'),
(6, 9, 3, TO_DATE('2021-07-19','YYYY-MM-DD'), 37, '2020-2021'),
(6, 10, 3, TO_DATE('2021-07-19','YYYY-MM-DD'), 75, '2020-2021'),
(7, 9, 3, TO_DATE('2021-07-19','YYYY-MM-DD'), 62, '2020-2021'),
(7, 10, 3, TO_DATE('2021-07-19','YYYY-MM-DD'), 37, '2020-2021'),
(8, 9, 3, TO_DATE('2021-07-19','YYYY-MM-DD'), 55, '2020-2021'),
(8, 10, 3, TO_DATE('2021-07-19','YYYY-MM-DD'), 47, '2020-2021'),
(9, 9, 3, TO_DATE('2021-07-19','YYYY-MM-DD'), 61, '2020-2021'),
(9, 10, 3, TO_DATE('2021-07-19','YYYY-MM-DD'), 70, '2020-2021'),
(10, 9, 3, TO_DATE('2021-07-19','YYYY-MM-DD'), 74, '2020-2021'),
(10, 10, 3, TO_DATE('2021-07-19','YYYY-MM-DD'), 65, '2020-2021');

INSERT INTO Note (idStudents, idMatiere, idTypeEvaluation, dateNote, nombreDePoint, anneeAcademique) VALUES
(1, 11, 3, TO_DATE('2021-07-20','YYYY-MM-DD'), 67, '2020-2021'),
(1, 12, 3, TO_DATE('2021-07-20','YYYY-MM-DD'), 68, '2020-2021'),
(2, 11, 3, TO_DATE('2021-07-20','YYYY-MM-DD'), 73, '2020-2021'),
(2, 12, 3, TO_DATE('2021-07-20','YYYY-MM-DD'), 76, '2020-2021'),
(3, 11, 3, TO_DATE('2021-07-20','YYYY-MM-DD'), 79, '2020-2021'),
(3, 12, 3, TO_DATE('2021-07-20','YYYY-MM-DD'), 79, '2020-2021'),
(4, 11, 3, TO_DATE('2021-07-20','YYYY-MM-DD'), 87, '2020-2021'),
(4, 12, 3, TO_DATE('2021-07-20','YYYY-MM-DD'), 74, '2020-2021'),
(5, 11, 3, TO_DATE('2021-07-20','YYYY-MM-DD'), 69, '2020-2021'),
(5, 12, 3, TO_DATE('2021-07-20','YYYY-MM-DD'), 72, '2020-2021'),
(6, 11, 3, TO_DATE('2021-07-20','YYYY-MM-DD'), 78, '2020-2021'),
(6, 12, 3, TO_DATE('2021-07-20','YYYY-MM-DD'), 70, '2020-2021'),
(7, 11, 3, TO_DATE('2021-07-20','YYYY-MM-DD'), 56, '2020-2021'),
(7, 12, 3, TO_DATE('2021-07-20','YYYY-MM-DD'), 73, '2020-2021'),
(8, 11, 3, TO_DATE('2021-07-20','YYYY-MM-DD'), 68, '2020-2021'),
(8, 12, 3, TO_DATE('2021-07-20','YYYY-MM-DD'), 47, '2020-2021'),
(9, 11, 3, TO_DATE('2021-07-20','YYYY-MM-DD'), 78, '2020-2021'),
(9, 12, 3, TO_DATE('2021-07-20','YYYY-MM-DD'), 75, '2020-2021'),
(10, 11, 3, TO_DATE('2021-07-20','YYYY-MM-DD'), 68, '2020-2021'),
(10, 12, 3, TO_DATE('2021-07-20','YYYY-MM-DD'), 65, '2020-2021');



SELECT
    firstName,
    lastName,
    sex,
    tel,
    class AS "Class de"
FROM Teachers t
JOIN ClassTeachers
    ON idTeachers = t.id
JOIN Class c
    ON idClass = c.id;