<style type="text/css" media="all">
  @import "/resources/calendar/calendar.css";
</style>

 <switch @view@>
  <case value="day">
    <include src="/packages/calendar/www/view-one-day-display" 
      return_url="@return_url;noquote"
      date="@date@" 
      start_display_hour="7"
      end_display_hour="22"
      page_num="@page_num@"
      base_url="@base_url@"
      calendar_url="@calendar_url@"
      calendar_id_list="@calendar_id@">
  </case>

  <case value="list">
    <include src="/packages/calendar/www/view-list-display" 
      return_url="@return_url;noquote"
      start_date="@start_date@"
      end_date="@end_date@"
      date="@date@"
      period_days="@period_days@"
      calendar_id_list="@calendar_id@"
      page_num="@page_num@"
      sort_by="@sort_by@"> 
  </case>
 
  <case value="week">
    <include src="/packages/calendar/www/view-week-display" 
      return_url="@return_url;noquote"
      date="@date@"
      calendar_id_list="@calendar_id@"
      page_num="@page_num@"
      calendar_url="@calendar_url@">
  </case>

  <case value="month">
    <include src="/packages/calendar/www/view-month-display"
      return_url="@return_url;noquote"
      date="@date@"
      calendar_id_list="@calendar_id@"
      base_url="@base_url@calendar/"
      page_num="@page_num@"
      calendar_url="@calendar_url@">
  </case>
</switch>
