ad_library {

    Forums Portlet Install library

    Procedures that deal with installing, instantiating, mounting.

    @creation-date 2003-12-31
    @author Don Baccus <dhogaza@pacifier.com>
    @cvs-id $Id$
}

namespace eval calendar_includelet::install {}

ad_proc -private calendar_includelet::install::package_install {} {
    Package installation callback proc
} {

    db_transaction {

        # Admin includelet
        layout::includelet::new \
            -name calendar_admin_includelet \
            -description "Displays calendar admin includelet" \
            -title #calendar-includelet.admin_pretty_name# \
            -application calendar \
            -template /packages/calendar-includelet/lib/calendar-admin-includelet \
            -required_privilege admin \
            -initializer calendar_includelet_utilities::configure_calendar_id \

        # List includelet
        layout::includelet::new \
            -name calendar_list_includelet \
            -description "Displays calendar list includelet" \
            -title #calendar-includelet.Schedule# \
            -application calendar \
            -template /packages/calendar-includelet/lib/calendar-list-includelet \
            -initializer calendar_includelet_utilities::configure_calendar_id

        # Full includelet
        layout::includelet::new \
            -name calendar_full_includelet \
            -description "Displays the calendar" \
            -title #calendar-includelet.full_includelet_pretty_name# \
            -application calendar \
            -template /packages/calendar-includelet/lib/calendar-full-includelet \
            -initializer calendar_includelet_utilities::configure_calendar_id

        # User includelet
        layout::includelet::new \
            -name calendar_includelet \
            -description "Displays the calendar" \
            -title #calendar-includelet.pretty_name# \
            -application calendar \
            -template /packages/calendar-includelet/lib/calendar-includelet \
            -initializer calendar_includelet_utilities::configure_calendar_id
    }
}

ad_proc -private calendar_includelet::install::package_uninstall {} {
    Package uninstallation callback proc
} {
    layout::includelet::delete -name calendar_includelet
    layout::includelet::delete -name calendar_admin_includelet
    layout::includelet::delete -name calendar_full_includelet
    layout::includelet::delete -name calendar_list_includelet
}

