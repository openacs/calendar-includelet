#
#  Copyright (C) 2001, 2002 MIT
#
#  This file is part of dotLRN.
#
#  dotLRN is free software; you can redistribute it and/or modify it under the
#  terms of the GNU General Public License as published by the Free Software
#  Foundation; either version 2 of the License, or (at your option) any later
#  version.
#
#  dotLRN is distributed in the hope that it will be useful, but WITHOUT ANY
#  WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
#  FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
#  details.
#

ad_library {

    Some useful utilities for calendar includelets.

    @author Don Baccus (dhogaza@pacifier.com)
    @cvs-id $Id$

}

namespace eval calendar_includelet_utilities {}

ad_proc calendar_includelet_utilities::configure_calendar_id {
    element_id
} {
    Set the includelet's calendar_id param, creating a new group calendar for the
    subsite if we're initializing its master template.

    DRB: This is really messed up, won't work except for a subsite master.

    @param element_id The calendar includelet

} {
    array set element [layout::element::get -element_id $element_id]

    set pageset_id [layout::page::get_column_value \
                        -page_id $element(page_id) \
                        -column pageset_id]
    array set pageset [layout::pageset::get -pageset_id $pageset_id]
    set group_id [application_group::group_id_from_package_id \
                     -no_complain \
                     -package_id $pageset(package_id)]

    if { [layout::pageset::is_master_template_p \
             -package_id $pageset(package_id) -pageset_id $pageset_id] &&
         $group_id ne "" } {

        # We're initializing the master template for a subsite or other package that
        # provides an application group for itself.  Create a group calendar.

        if { ![db_0or1row get_group_calendar_id {}] } {
            set calendar_id [calendar::new \
                                  -owner_id $group_id \
                                  -private_p "f" \
                                  -calendar_name Group \
                                  -package_id $element(package_id)]
        }

        layout::element::parameter::add_values \
            -element_id $element_id \
            -parameters [list calendar_id $calendar_id default_view day scoped_p f]
    }
}
