ndefine idxname = "mySubjectIndex"
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