create or replace trigger trig_fhmhid
after update or insert on parents
declare
vm_count NUMBER;
vf_count NUMBER;
begin
select
count(*) into vm_count from human h, parents p
where p.mhid = h.hid and h.sex = 'M';
select
count(*) into vf_count from human h, parents p
where p.fhid = h.hid and h.sex = 'F';

if (vm_count > 0 or vf_count>0) then
raise_application_error(-20003, 'MHID 혹은 FHID입력 오류');
end if;
end trig_fhmhid;