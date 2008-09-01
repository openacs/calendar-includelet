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

if {[empty_string_p $view]} {
    set view $default_view
}

set ad_conn_url [ad_conn url]
set base_url [ad_conn package_url]
set calendar_url [site_node::get_url_from_object_id -object_id $package_id]

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

if {[llength $calendar_id] > 1} {
    set force_calendar_id [calendar::have_private_p -return_id 1 -calendar_id_list $calendar_id -party_id [ad_conn user_id]]
} else {
    set force_calendar_id [lindex $calendar_id 0]
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

# global variables
set current_date $date
set date_format "YYYY-MM-DD HH24:MI"
set return_url "[ns_conn url]?[ns_conn query]"

set encoded_return_url [ns_urlencode $return_url]
set add_item_url [export_vars -base ${calendar_url}cal-item-new {{date $current_date} {time_p 1} return_url}]

set item_template "<a href=\${url_stub}cal-item-view?show_cal_nav=0&return_url=$encoded_return_url&action=edit&cal_item_id=\$item_id>\[ad_quotehtml \$item\]</a>"

if {$create_p} {
    set hour_template "<a href=calendar/cal-item-new?date=$current_date&start_time=\$day_current_hour&return_url=$encoded_return_url>\$localized_day_current_hour</a>"
    set item_add_template "<a href=calendar/cal-item-new?start_time=&time_p=1&end_time=&julian_date=\$julian_date&return_url=$encoded_return_url title=\"[_ calendar.Add_Item]\">+</a>"
} else {
    set hour_template "\$localized_day_current_hour"
    set item_add_template ""
}

set url_stub_callback "calendar_portlet_display::get_url_stub" 

if {$view == "day"} {
    if {[catch {set yest [clock format [clock scan "1 day ago" -base [clock scan $date]] -format "%Y-%m-%d"]}]} {
	set previous_link ""
    } else {
	if {[catch {clock scan $yest}]} {
	    set previous_link ""
	} else {
	    set previous_link "<a href=\"?page_num=$page_num&date=\$yesterday\"><img border=0 src=\"[dt_left_arrow]\" alt=\"back one day\"></a>"
	}
    }

    if {[catch {set tomor [clock format [clock scan "1 day" -base [clock scan $date]] -format "%Y-%m-%d"]}]} {
        set next_link ""
    } else {
	if {[catch {clock scan $tomor}]} {
	    set next_link ""
	} else {
	    set next_link "<a href=\"?page_num=$page_num&date=\$tomorrow\"><img border=0 src=[dt_right_arrow] alt=\"forward one day\"></a>"
	}
    }
} 

if {$view == "week"} {
    if {[catch {set last_w [clock format [clock scan "1 week ago" -base [clock scan $date]] -format "%Y-%m-%d"]}]} {
        set previous_link ""
    } else {
	if {[catch {clock scan $last_w}]} {
	    set previous_link ""
	} else {
	    set previous_link "<a href=\"?date=\$last_week&view=week&page_num=$page_num\"><img border=0 src=[dt_left_arrow] alt=\"back one week\"></a>"
	}
    }

    if {[catch {set next_w [clock format [clock scan "1 week" -base [clock scan $date]] -format "%Y-%m-%d"]}]} {
        set next_link ""
    } else {
	if {[catch {clock scan $next_w}]} {
	    set next_link ""
	} else {
	    set next_link "<a href=\"?date=\$next_week&view=week&page_num=$page_num\"><img border=0 src=[dt_right_arrow] alt=\"forward one week\"></a>"
	}
    }

    set prev_week_template "<a href=\"?date=\[ad_urlencode \[dt_julian_to_ansi \[expr \$first_weekday_julian - 7\]\]\]&view=week&page_num=$page_num\"><img border=0 src=[dt_left_arrow] alt=\"back one week\"></a>" 
    set next_week_template "<a href=\"?date=\[ad_urlencode \[dt_julian_to_ansi \[expr \$first_weekday_julian + 7\]\]\]&view=week&page_num=$page_num\"><img border=0 src=[dt_right_arrow] alt=\"forward one week\"></a>" 
}


if {$view == "month"} {
    if {[catch {set prev_m [clock format [clock scan "1 month ago" -base [clock scan $date]] -format "%Y-%m-%d"]}]} {
        set prev_month_template ""
    } else {
	if {[catch {clock scan $prev_m}]} {
	    set prev_month_template ""
	} else {
	    set prev_month_template "<a href=?view=month&date=\[ad_urlencode \$prev_month\]&page_num=$page_num><img border=0 src=[dt_left_arrow] alt=\"back one month\"></a>"
	}
    }
	
    if {[catch {set next_m [clock format [clock scan "1 month" -base [clock scan $date]] -format "%Y-%m-%d"]}]} {
        set next_month_template ""
    } else {
	if {[catch {clock scan $next_m}]} {
	    set next_month_template ""
	} else {
	    set next_month_template "<a href=?view=month&date=\[ad_urlencode \$next_month\]&page_num=$page_num><img border=0 src=[dt_right_arrow] alt=\"forward one month\"></a>"
	}
    }
}


if {$view == "list"} {
    set sort_by [ns_queryget sort_by]


    set start_date [ns_fmttime [expr [ns_time]] "%Y-%m-%d 00:00"]
    set end_date [ns_fmttime [expr {[ns_time] + 60*60*24*$period_days}] "%Y-%m-%d 00:00"]

    set url_template "?view=list&sort_by=\$order_by&page_num=$page_num" 
}

set export [ns_queryget export]

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
