<include src="/packages/calendar/www/navbar"
  date="@date@"
  period_days="@period_days@"
  base_url="@ad_conn_url@"
  page_num="@page_num@"
  view="@view@">
  <div id="viewadp-mini-calendar">

      <include src="/packages/calendar/www/mini-calendar" 
        view="@view@" 
        date="@date@" 
        page_num="@page_num@"
      >
 
      <p>
        <a href="@add_item_url@" title="#calendar.Add_Item#" class="button">#calendar.Add_Item#</a>
        <if "@admin_p@">
          <a href="admin/" title="#calendar.lt_Calendar_Administrati#" class="button">
            #calendar.lt_Calendar_Administrati#
          </a>
        </if>
      </p>
      <p>
        @notification_chunk;noquote@
      </p>
      <if @calendars:rowcount@ gt 0>
        <p>
          #calendar.Calendars#:
          <ul>
            <multiple name="calendars">
            <li> @calendars.calendar_name@
              <if @calendars.calendar_admin_p@ true>
                [<a href="@calendars.url@" title="#calendar.Manage_Item_Types#">#calendar.Manage_Item_Types#</a>]
              </if>
            </multiple>
          </ul>
        </if>

       <p>

  </div>
  <div id="viewadp-cal-table">

      <switch "@view@">
         <case value="day">
          <include src="/packages/calendar/www/view-one-day-display" 
            portlet_mode_p="1"
            date="@date@" 
            start_display_hour="7"
            end_display_hour="22"
            page_num="@page_num@"
            calendar_id_list="@calendar_id@"
            base_url="@base_url@"
            calendar_url="@calendar_url@"
            return_url="@return_url;noquote@">
         </case>

        <case value="list">
          <include src="/packages/calendar/www/view-list-display" 
            start_date="@start_date@"
            end_date="@end_date@"
            date="@date@"
            period_days="@period_days@"
            calendar_id_list="@calendar_id@"
            page_num="@page_num@"
            return_url="@return_url;noquote@">
        </case>

        <case value="week">
          <include src="/packages/calendar/www/view-week-display" 
            portlet_mode_p="1"
            date="@date@"
            calendar_id_list="@calendar_id@"
            page_num="@page_num@"
            calendar_url="@calendar_url@"
            return_url="@return_url;noquote@"
            export="@export@">
         </case>

        <case value="month">
          <include src="/packages/calendar/www/view-month-display"
            portlet_mode_p="1"
            date="@date@"
            calendar_id_list="@calendar_id@"
            base_url="@base_url@calendar/"
            page_num="@page_num@"
            show_calendar_name_p="@show_calendar_name_p;noquote@"
            return_url="@return_url;noquote@"
            calendar_url="@calendar_url@"
            export="@export@">
        </case>
      </switch>
</div>
