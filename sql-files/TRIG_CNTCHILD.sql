create or replace trigger trig_cntchild
after
update or insert or delete on human
begin
  update parents p set p.childcount = (select COUNT(h.hid) from human h where h.pid = p.pid);
end trig_cntchild;