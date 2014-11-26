DROP SEQUENCE pic_id_sequence;
DROP SEQUENCE group_id_sequence;
CREATE SEQUENCE pic_id_sequence;
CREATE SEQUENCE group_id_sequence start with 3;


CREATE INDEX mySubjectIndex ON images(SUBJECT) INDEXTYPE IS CTXSYS.CONTEXT;
CREATE INDEX myDesIndex ON images(DESCRIPTION) INDEXTYPE IS CTXSYS.CONTEXT;
CREATE INDEX myPlaceIndex ON images(PLACE) INDEXTYPE IS CTXSYS.CONTEXT;

insert into users values('admin','000',sysdate);
insert into persons values('admin','boss','man','University of Alberta','admin@ualberta.ca','7800000000');