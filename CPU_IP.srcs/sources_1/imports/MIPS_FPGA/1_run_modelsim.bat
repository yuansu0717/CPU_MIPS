vlib work
vlog -f vflist
vsim -c -novopt work.tb_cpu_nomem  -do "run -all"
vfast -o dump.fsdb dump.vcd

pause

