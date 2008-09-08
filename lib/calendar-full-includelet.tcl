ad_page_contract {
    The display logic for the calendar portlet

    @author Arjun Sanyal (arjun@openforce.net)
    @cvs_id $Id$
} {
    {view ""}
    {page_num ""}
    {date ""}
    {period_days:optional}
    {julian_date ""}
    {export ""}
    {sort_by ""}
} -properties {
    
} -validate {
    valid_date -requires { date } {
        if {![string equal $date ""]} {
            if {[catch {set date [clock format [clock scan $date] -format "%Y-%m-%d"]} err]} {
                ad_complain "Your input ($date) was not valid. It has to be in the form YYYYMMDD."
            }
        }
    }
}

# Note that the variable calendar_id is a list of all calendar_id parameter values set for
# this layout element.  

set private_calendar_id [calendar_includelet::get_private_calendar_id \
                        -user_id [ad_conn user_id] \
                        -package_id $package_id]
lappend calendar_id $private_calendar_id

if {[empty_string_p $view]} {
    set view $default_view
}

set ad_conn_url [ad_conn url]
set base_url [ad_conn package_url]
set calendar_url [site_node::get_url_from_object_id -object_id $package_id]

set notification_chunk [notification::display::request_widget \
                            -type calendar_notif \
                            -object_id $package_id \
                            -pretty_name [site_node::get_element \
                                             -node_id [site_node::get_node_id_from_object_id \
                                                          -object_id $package_id] \
                                             -element instance_name] \
                            -url $calendar_url]

if {$scoped_p == "t"} {
    set show_calendar_name_p 1
} else {
    set show_calendar_name_p 0
}

# Styles for calendar
template::head::add_css -href "/resources/calendar/calendar.css"

if { ![info exists period_days] } {
    set period_days [parameter::get -package_id $package_id -parameter ListView_DefaultPeriodDays -default 31]
}

# permissions
set admin_p [permission::permission_p -object_id $package_id -privilege admin]

# set up some vars
if {[empty_string_p $date]} {
    set date [dt_sysdate]
}

# global variables
set date_format "YYYY-MM-DD HH24:MI"
set return_url "[ns_conn url]?[ns_conn query]"

set add_item_url [export_vars -base ${calendar_url}cal-item-new {{date $date} {time_p 1} return_url}]

multirow create calendars calendar_name calendar_id calendar_admin_p url
foreach calendar $calendar_id {
    multirow append calendars [calendar::name $calendar] $calendar \
        [permission::permission_p -object_id $calendar -privilege admin] \
        [export_vars -base ${calendar_url}calendar-item-types {calendar_id}]
}

if {$view eq "list"} {
    set start_date [ns_fmttime [expr [ns_time]] "%Y-%m-%d 00:00"]
    set end_date [ns_fmttime [expr {[ns_time] + 60*60*24*$period_days}] "%Y-%m-%d 00:00"]
}

if { [lsearch [list csv vcalendar] $export] != -1 } {
    set user_id [ad_conn user_id]
    set package_id [ad_conn package_id]
    if { [string equal $view list] } {
        calendar::export::$export -calendar_id_list $calendar_id -view $view -date $date -start_date $start_date -end_date $end_date $user_id $package_id
    } else {
        calendar::export::$export -calendar_id_list $calendar_id -view $view -date $date $user_id $package_id
    }
    ad_script_abort
}

ad_return_template 
