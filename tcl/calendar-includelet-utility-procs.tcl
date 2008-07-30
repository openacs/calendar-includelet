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
    Set the includelet's calendar_id param, creating a new private calendar for the
    includelet's owner if necessary.

    @param element_id The calendar includelet

} {

    set pageset_id [layout::page::get_column_value \
                        -page_id [layout::element::get_column_value \
                                     -element_id $element_id \
                                     -column page_id] \
                        -column pageset_id]
    set package_id [layout::element::get_column_value \
                       -element_id $element_id \
                       -column package_id]
    set party_id [layout::pageset::get_column_value \
                     -pageset_id $pageset_id \
                     -column owner_id]
 
    if { $pageset_id == [layout::pageset::get_master_template_id] } {

        # We're initializing the master template's or admin portal's copy of
        # calendar, create a subsite group calendar if one does not already exist.

        set group_id [application_group::group_id_from_package_id \
                         -package_id [ad_conn subsite_id]]

        if { ![db_0or1row get_group_calendar_id {}] } {
            set calendar_id [calendar::new \
                                  -owner_id $group_id \
                                  -private_p "f" \
                                  -calendar_name Group \
                                  -package_id $package_id]
        }

    } else {

        # We're initializing a personal portal.  Create a calendar for the user
        # if they don't already have one.  The group calendar's id has already been
        # copied over by the portal package.

        if { ![db_0or1row get_calendar_id {}] } {
            set calendar_id [calendar::new \
                                -owner_id $party_id \
                                -private_p t \
                                -calendar_name Personal \
                                -package_id $package_id]
        }
    }

    layout::element::parameter::add_values \
        -element_id $element_id \
        -parameters [list calendar_id $calendar_id default_view day scoped_p f]

}
