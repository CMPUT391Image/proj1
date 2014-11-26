define idxname = "myDesIndex"
define interval = "1"

set serveroutput on
declare
  job number;
begin
  dbms_job.submit(job, 'ctx_ddl.sync_index(''&idxname'');',
                  interval=>'SYSDATE+&interval/1440');
  commit;
  dbms_output.put_line('job '||job||' has been submitted.');
end;
/
define idxname = "myPlaceIndex"
define interval = "1"

set serveroutput on
declare
  job number;
begin
  dbms_job.submit(job, 'ctx_ddl.sync_index(''&idxname'');',
                  interval=>'SYSDATE+&interval/1440');
  commit;
  dbms_output.put_line('job '||job||' has been submitted.');
end;
/

define idxname = "mySubjectIndex"
define interval = "1"

set serveroutput on
declare
  job number;
begin
  dbms_job.submit(job, 'ctx_ddl.sync_index(''&idxname'');',
                  interval=>'SYSDATE+&interval/1440');
  commit;
  dbms_output.put_line('job '||job||' has been submitted.');
end;
/
DROP SEQUENCE pic_id_sequence;
DROP SEQUENCE group_id_sequence;
CREATE SEQUENCE pic_id_sequence;
CREATE SEQUENCE group_id_sequence start with 3;

DROP INDEX mySubjectIndex;
DROP INDEX myDesIndex ;
DROP INDEX myPlaceIndex; 
CREATE INDEX mySubjectIndex ON images(SUBJECT) INDEXTYPE IS CTXSYS.CONTEXT;
CREATE INDEX myDesIndex ON images(DESCRIPTION) INDEXTYPE IS CTXSYS.CONTEXT;
CREATE INDEX myPlaceIndex ON images(PLACE) INDEXTYPE IS CTXSYS.CONTEXT;

insert into users values('admin','000',sysdate);
insert into persons values('admin','boss','man','University of Alberta','admin@ualberta.ca','7800000000');
