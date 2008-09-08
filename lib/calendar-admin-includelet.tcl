ad_page_contract {
    The display logic for the calendar admin includelet

    @author Arjun Sanyal (arjun@openforce.net)
    @author Ben Adida (ben@openforce.net)
    @cvs_id $Id$
} {
    {period_days:optional}
} -properties {
    
}

if { ![info exists period_days] } {
    set period_days [parameter::get -package_id $package_id -parameter ListView_DefaultPeriodDays]
} else {
    parameter::set_value -package_id $package_id -parameter ListView_DefaultPeriodDays -value $period_days
}

set url [site_node::get_url_from_object_id -object_id $package_id]

ad_return_template
