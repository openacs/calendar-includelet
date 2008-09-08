<?xml version="1.0"?>
<queryset>

<fullquery name="calendar_includelet_utilities::configure_calendar_id.get_group_calendar_id">
  <querytext>
    select calendar_id
    from calendars
    where private_p = 'f'
      and owner_id = :group_id
  </querytext>
</fullquery>
 
</queryset>
