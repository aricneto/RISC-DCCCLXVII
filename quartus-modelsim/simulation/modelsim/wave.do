onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -color Yellow /regfile_64_vlg_vec_tst/clock
add wave -noupdate -color Red /regfile_64_vlg_vec_tst/reset
add wave -noupdate -radix unsigned /regfile_64_vlg_vec_tst/rReg1
add wave -noupdate -radix unsigned /regfile_64_vlg_vec_tst/rReg2
add wave -noupdate /regfile_64_vlg_vec_tst/regWrite
add wave -noupdate /regfile_64_vlg_vec_tst/wData
add wave -noupdate /regfile_64_vlg_vec_tst/wReg
add wave -noupdate /regfile_64_vlg_vec_tst/rData1
add wave -noupdate /regfile_64_vlg_vec_tst/rData2
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {130000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {601907 ps} {896781 ps}
