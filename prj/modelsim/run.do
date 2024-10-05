# vsim -c -do "do {run.do}" -l run.log
# vsim    -do "do {run.do}" -l run.log

vlib work
vmap work work

vlog -incr -mfcu -sv -work work +define+DUMP_VCD -f filelist.f

puts "\n\n\n\n\n"

vsim -voptargs="+acc" -L work work.TEST_0

view wave
view structure
view signals

run 0ns

# do {wave.do}

run -all
