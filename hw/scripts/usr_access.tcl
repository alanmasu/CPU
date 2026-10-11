# USR_ACCESS: a 32-bit register of the bitstream, set by write_bitstream
# (property BITSTREAM.CONFIG.USR_ACCESS) without running synthesis or
# implementation again. It tells which build of the project is on the board:
#   [31:4]  the first 7 hex digits of the git commit of the product
#   [0]     dirty: hw/ had changes that were not committed
# Read it through JTAG in the Hardware Manager (REGISTER.USR_ACCESS of the
# device), or from the logic with the USR_ACCESSE2 primitive.
#
# Sourced by prj.tcl, so that prj::build knows the value the bitstream
# should have, and by write_bitstream_pre.tcl, the hook that sets it.

namespace eval ::prj_priv {}

# The value for the product in root, as a 32-bit integer. Outside git:
# commit 0, dirty.
proc ::prj_priv::usr_access_value {root} {
    if {[catch {exec git -C $root rev-parse --short=7 HEAD} hash]} {
        return 1
    }
    # git may print more digits when 7 are ambiguous: 28 bits hold 7.
    scan [string range $hash 0 6] %x commit
    # git diff --quiet exits with 1 when there are changes, and exec turns
    # that into an error.
    if {[catch {exec git -C $root diff --quiet HEAD -- hw}]} {
        set dirty 1
    } else {
        set dirty 0
    }
    return [expr {($commit << 4) | $dirty}]
}

proc ::prj_priv::usr_access_hex {value} {
    return [format 0x%08X $value]
}
