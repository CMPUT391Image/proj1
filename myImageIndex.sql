CREATE INDEX mySubjectIndex ON images(SUBJECT) INDEXTYPE IS CTXSYS.CONTEXT;
CREATE INDEX myDesIndex ON images(DESCRIPTION) INDEXTYPE IS CTXSYS.CONTEXT;
CREATE INDEX myPlaceIndex ON images(PLACE) INDEXTYPE IS CTXSYS.CONTEXT;