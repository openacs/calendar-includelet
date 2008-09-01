ad_page_contract {
    The display logic for the calendar includelet

    @author Arjun Sanyal (arjun@openforce.net)
    @cvs_id $Id$
} {
    {view ""}
    {page_num ""}
    {date ""}
    {julian_date ""}
    {period_days 60}
    {sort_by ""}
} -properties {
    
}  -validate {
    valid_date -requires { date } {
        if {![string equal $date ""]} {
            if {[catch {set date [clock format [clock scan $date] -format "%Y-%m-%d"]} err]} {
                ad_complain "Your input was not valid. It has to be in the form YYYYMMDD."
            }
        }
    }
}

template::head::add_css -href /resources/calendar/calendar.css

# get stuff out of the config array
if { $view eq "" } {
    set view $default_view
}
set list_of_calendar_ids $calendar_id

if {$scoped_p == "t"} {
    set show_calendar_name_p 1
} else {
    set show_calendar_name_p 0
}

if {[llength $list_of_calendar_ids] > 1} {
    set force_calendar_id [calendar::have_private_p \
                              -return_id 1 \
                              -calendar_id_list $list_of_calendar_ids \
                              -party_id [ad_conn user_id]]
} else {
    set force_calendar_id [lindex $list_of_calendar_ids 0]
}

# permissions
set create_p [ad_permission_p $force_calendar_id cal_item_create]
set edit_p [ad_permission_p $force_calendar_id cal_item_edit]
set admin_p [ad_permission_p $force_calendar_id calendar_admin]

# set up some vars
if {[empty_string_p $date]} {
    if {[empty_string_p $julian_date]} {
        set date [dt_sysdate]
    } else {
        set date [db_string select_from_julian "select to_date(:julian_date ,'J') from dual"]
    }
}

set current_date $date
set date_format "YYYY-MM-DD HH24:MI"
set return_url "[ns_conn url]?[ns_conn query]"
set encoded_return_url [ns_urlencode $return_url]

# List view only
set sort_by [ns_queryget sort_by]

set item_template "<a href=\${url_stub}cal-item-view?show_cal_nav=0&return_url=$encoded_return_url&action=edit&cal_item_id=\$item_id>\[ad_quotehtml \$item\]</a>"

set thirty_days [expr 60*60*24*30]
set start_date [ns_fmttime [expr [ns_time] - $thirty_days] "%Y-%m-%d 00:00"]

set url_template "?view=list&sort_by=\$order_by&page_num=$page_num" 
set url_stub_callback "calendar_includelet_display::get_url_stub" 

ad_return_template
