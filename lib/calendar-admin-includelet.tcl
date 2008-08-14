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

set url "calendar/"

ad_return_template
