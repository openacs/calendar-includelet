ad_library {

Procedures to support the calendar includelet display

@creation-date April 15, 2008
@cvs-id $Id$

}

namespace eval calendar_includelet_display {
    
    ad_proc -public get_url_stub {
        calendar_id
    } {
        return [site_node_object_map::get_url -object_id $calendar_id]
    }
    
}
