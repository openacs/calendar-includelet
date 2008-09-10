
ad_proc calendar_includelet::get_private_calendar_id {
    -user_id:required
    -package_id:required
} {
    Return the user's private calendar id and create one if none exists.

    The calendar package doesn't scope calendars by which package it belongs to.  This
    includelet wants to scope a user's private calendar by package, to separate subsite
    contexts by default.

    @param user_id The id of the user we're interested in
    @param package_id The package id of the relevant instance of the calendar package
} {
    if { ![set calendar_id [calendar::have_private_p -return_id 1 -party_id $user_id]] } {
        set calendar_id [calendar::new \
                            -owner_id [ad_conn user_id] \
                            -private_p "t" \
                            -calendar_name Personal \
                            -package_id $package_id]
    }
    return $calendar_id
}

