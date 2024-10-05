vcs:
	echo ${vcs64}
	${vcs64} -timescale=1ns/1ps -debug_acc+all -f filelist.f +define+DUMP_FSDB

verdi:
	verdi +systemverilogext+.sv+.SV -f filelist.f -ssf out.fsdb

sim:
	./simv

clean:
	rm -rf csrc simv* *.lib *.lib++ nLint*
	rm -rf *.log *.vpd *.fsdb* *.key *log rtl.fsdb*
	rm -rf verdiLog novas*
