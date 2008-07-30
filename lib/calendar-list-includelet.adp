<style type="text/css" media="all">
  @import "/resources/calendar/calendar.css";
</style>

<include src="/packages/calendar/www/view-list-display" 
  start_date="@start_date@"
  date="@current_date@" 
  period_days="@period_days@"
  item_template="@item_template;noquote@"
  page_num="@page_num@"
  calendar_id_list="@list_of_calendar_ids@"
  url_template="@url_template;noquote@" 
  url_stub_callback="@url_stub_callback;noquote@" 
  sort_by="@sort_by@"> 
