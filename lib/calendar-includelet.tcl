ad_page_contract {
    The display logic for the calendar includelet

    @author Arjun Sanyal (arjun@openforce.net)
    @cvs_id $Id$
} {
    {view ""}
    {page_num ""}
    {date ""}
    {period_days 30}
    {julian_date ""}
    {sort_by ""}
} -properties {

}  -validate {
    valid_date -requires { date } {
        if {$date ne ""} {
            if {[catch {set date [clock format [clock scan $date] -format "%Y-%m-%d"]} err]} {
                ad_complain "Your input ($date) was not valid. It has to be in the form YYYYMMDD."
            }
        }
    }
}

template::head::add_css -href /resources/calendar/calendar.css
set return_url "[ns_conn url]?[ns_conn query]"

# set up some vars
if {$date eq ""} {
    if {$julian_date eq ""} {
        set date [dt_sysdate]
    } else {
        set date [db_string select_from_julian "select to_date(:julian_date ,'J') from dual"]
    }
}

set view $default_view
set base_url [ad_conn package_url]
set calendar_url [site_node::get_url_from_object_id -object_id $package_id]

set scoped_p $scoped_p

if {$scoped_p == "t"} {
    set show_calendar_name_p 1
} else {
    set show_calendar_name_p 0
}

# Note that the variable calendar_id is a list of all calendar_id parameter values set for
# this layout element.

set private_calendar_id [calendar_includelet::get_private_calendar_id \
                        -user_id [ad_conn user_id] \
                        -package_id $package_id]
lappend calendar_id $private_calendar_id

set add_item_url [export_vars -base ${calendar_url}cal-item-new {{date $date} {time_p 1} return_url}]


if {$view eq "list"} {
    set start_date [ns_fmttime [expr [ns_time]] "%Y-%m-%d 00:00"]
    set end_date [ns_fmttime [expr {[ns_time] + 60*60*24*$period_days}] "%Y-%m-%d 00:00"]
}


ad_return_template
