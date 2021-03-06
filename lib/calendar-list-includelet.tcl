ad_page_contract {
    The display logic for the calendar includelet

    @author Arjun Sanyal (arjun@openforce.net)
    @cvs-id $Id$
} {
    {view ""}
    {page_num ""}
    {date ""}
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

set calendar_url [site_node::get_url_from_object_id -object_id $package_id]

# get stuff out of the config array
if { $view eq "" } {
    set view $default_view
}

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

set start_date [ns_fmttime [expr [ns_time]] "%Y-%m-%d 00:00"]
set end_date [ns_fmttime [expr {[ns_time] + 60*60*24*$period_days}] "%Y-%m-%d 00:00"]

set date_format "YYYY-MM-DD HH24:MI"
set return_url "[ns_conn url]?[ns_conn query]"

ad_return_template
