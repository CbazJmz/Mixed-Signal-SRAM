# ----------------------------------------
# Jasper Version Info
# tool      : Jasper 2025.09
# platform  : Linux 5.15.0-164-generic
# version   : 2025.09p002 64 bits
# build date: 2025.11.19 14:35:23 UTC
# ----------------------------------------
# started   : 2026-02-13 17:12:42 UTC
# hostname  : estudiantes1.(none)
# pid       : 94056
# arguments : '-style' 'windows' '-label' 'session_0' '-console' '//127.0.0.1:36711' '-data' 'AAAAdnicY2RgYLCp////PwMYMD6A0Aw2jAyoAMRnQhUJbEChGRhYUZWLMGQxpDPEM6QxFDCUMegxlDAkM+SAZQGmIgqG' '-bridge_url' ':-1' '-proj' '/home/sebas/Mixed-Signal-SRAM/fv/jgproject/sessionLogs/session_0' '-init' '-hidden' '/home/sebas/Mixed-Signal-SRAM/fv/jgproject/.tmp/.initCmds.tcl' 'jg_fpv.tcl'
clear -all

set_proofgrid_bridge off

analyze -sv12 ../../rtl/defines.svh
include jg_fpv.tcl
