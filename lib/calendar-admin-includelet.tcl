ad_page_contract {
    The display logic for the calendar admin includelet

    @author Arjun Sanyal (arjun@openforce.net)
    @author Ben Adida (ben@openforce.net)
    @cvs_id $Id$
}

# get stuff out of the config array
set view $default_view

if {[llength $calendar_id] > 1} {
    return -code error "shouldn't be more than one calendar in admin!"
}

template::head::add_css -href /resources/calendar/calendar.css
set url [site_node::get_url_from_object_id -object_id $package_id]

ad_return_template
