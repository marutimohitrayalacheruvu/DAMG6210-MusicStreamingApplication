select * from app_admin.users;


BEGIN
  app_admin.update_user_from_user(p_user_id => 1, p_first_name => 'John', p_last_name => 'Doefdsfs', p_email => 'john.doe@exampleee.ccccccom', p_user_name => 'JOHNDOE');
END;






SELECT * FROM DBA_TAB_PRIVS WHERE GRANTEE = 'ARTIST_ROLE' AND PRIVILEGE = 'SELECT' AND TABLE_NAME = '<table_name>';