create schema project;
use project; 
create table login(
id int primary key ,
user_name varchar(15) not null,
pass varchar(50)NOT NULL,
guard varchar(10)
    );
insert into login values(2206199,'youstena malak','123','student');
insert into login values(2206192,'walaa ahmed','456','student');
insert into login values(2206200,'samaa mohamed','789','student');
insert into login values(2206205,'karim basiouny','123123','student');
insert into login values(2206194,'ahmed adel','123456','student');
insert into login values(100,'eng.sarah','123789','admin');
insert into login values(2206201,'meky','654','student');
create table course (
crs_id varchar(20) primary key not null,
crs_title varchar(30) not null,
index idx_course_title (crs_title)
);
insert into course values('abc','cloud computing');
insert into course values('def','data base');
insert into course values('ghi','computer science');

create table enrollment(
enroll_id int primary key auto_increment,
id int , foreign key(id) references login (id),
crs_id varchar(20) , foreign key(crs_id) references course (crs_id)
);
insert into enrollment values(11,2206192,'abc');
insert into enrollment values(22,2206199,'abc');
insert into enrollment values(33,2206200,'abc');
insert into enrollment values(44,2206194,'abc');
insert into enrollment values(55,2206205,'abc');
insert into enrollment values(57,2206201,'abc');
create table grade(
grade_id int primary key auto_increment,
grade_value varchar(5) not null,
CGPA float ,
enroll_id int , foreign key(enroll_id) references enrollment (enroll_id)
);
insert into grade values(1,'a',3.5,33);
insert into grade values(2,'a',3.9,22);
insert into grade values(3,'a',3.7,11);
insert into grade values(4,'a',3.6,44);
insert into grade values(5,'a',3.8,55);
insert into grade values(6,'a',4,57);

create table user_info(
    user_name varchar(50),
    user_id int,
    course_name varchar(50),
    grade_value varchar(5),
    CGPA float,
    primary key(user_id, course_name),
    foreign key(user_id) references login(id),
    foreign key(course_name) references course(crs_title)
);

insert into user_info(user_name, user_id, course_name, grade_value,CGPA)
select l.user_name, e.id, c.crs_title, g.grade_value, g.CGPA
from enrollment e
join login l on e.id = l.id
join course c on e.crs_id = c.crs_id
join grade g on e.enroll_id = g.enroll_id;

select * from user_info;


select*from login;
select*from course;
select*from enrollment;
select*from grade;