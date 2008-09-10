<?xml version="1.0"?>
<queryset>
  
<fullquery name="calendar_includelet::get_private_calendar_id.get">
  <querytext>
    select calendar_id
    from calendars
    where owner_id = :user_id
    and package_id = :package_id
    and private_p = 't'
  </querytext>
</fullquery>
 
</queryset>
