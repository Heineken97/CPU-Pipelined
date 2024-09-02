transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/Manuel/Documents/TEC/Arqui\ 2/CPU/CPU-Pipelined/memory {C:/Users/Manuel/Documents/TEC/Arqui 2/CPU/CPU-Pipelined/memory/ROM.v}
vlog -vlog01compat -work work +incdir+C:/Users/Manuel/Documents/TEC/Arqui\ 2/CPU/CPU-Pipelined/memory {C:/Users/Manuel/Documents/TEC/Arqui 2/CPU/CPU-Pipelined/memory/RAM.v}
vlog -sv -work work +incdir+C:/Users/Manuel/Documents/TEC/Arqui\ 2/CPU/CPU-Pipelined {C:/Users/Manuel/Documents/TEC/Arqui 2/CPU/CPU-Pipelined/top.sv}
vlog -sv -work work +incdir+C:/Users/Manuel/Documents/TEC/Arqui\ 2/CPU/CPU-Pipelined/core {C:/Users/Manuel/Documents/TEC/Arqui 2/CPU/CPU-Pipelined/core/PC_register.sv}
vlog -sv -work work +incdir+C:/Users/Manuel/Documents/TEC/Arqui\ 2/CPU/CPU-Pipelined/core {C:/Users/Manuel/Documents/TEC/Arqui 2/CPU/CPU-Pipelined/core/mux_2inputs.sv}
vlog -sv -work work +incdir+C:/Users/Manuel/Documents/TEC/Arqui\ 2/CPU/CPU-Pipelined/core {C:/Users/Manuel/Documents/TEC/Arqui 2/CPU/CPU-Pipelined/core/FetchDecode_register.sv}
vlog -sv -work work +incdir+C:/Users/Manuel/Documents/TEC/Arqui\ 2/CPU/CPU-Pipelined/core {C:/Users/Manuel/Documents/TEC/Arqui 2/CPU/CPU-Pipelined/core/Regfile_scalar.sv}
vlog -sv -work work +incdir+C:/Users/Manuel/Documents/TEC/Arqui\ 2/CPU/CPU-Pipelined/core {C:/Users/Manuel/Documents/TEC/Arqui 2/CPU/CPU-Pipelined/core/controlUnit.sv}
vlog -sv -work work +incdir+C:/Users/Manuel/Documents/TEC/Arqui\ 2/CPU/CPU-Pipelined/core {C:/Users/Manuel/Documents/TEC/Arqui 2/CPU/CPU-Pipelined/core/DecodeExecute_register.sv}
vlog -sv -work work +incdir+C:/Users/Manuel/Documents/TEC/Arqui\ 2/CPU/CPU-Pipelined/core {C:/Users/Manuel/Documents/TEC/Arqui 2/CPU/CPU-Pipelined/core/ALU.sv}
vlog -sv -work work +incdir+C:/Users/Manuel/Documents/TEC/Arqui\ 2/CPU/CPU-Pipelined/core {C:/Users/Manuel/Documents/TEC/Arqui 2/CPU/CPU-Pipelined/core/adder.sv}
vlog -sv -work work +incdir+C:/Users/Manuel/Documents/TEC/Arqui\ 2/CPU/CPU-Pipelined/core {C:/Users/Manuel/Documents/TEC/Arqui 2/CPU/CPU-Pipelined/core/ExecuteMemory_register.sv}
vlog -sv -work work +incdir+C:/Users/Manuel/Documents/TEC/Arqui\ 2/CPU/CPU-Pipelined/core {C:/Users/Manuel/Documents/TEC/Arqui 2/CPU/CPU-Pipelined/core/MemoryWriteback_register.sv}
vlog -sv -work work +incdir+C:/Users/Manuel/Documents/TEC/Arqui\ 2/CPU/CPU-Pipelined/core {C:/Users/Manuel/Documents/TEC/Arqui 2/CPU/CPU-Pipelined/core/comparator_branch.sv}
vlog -sv -work work +incdir+C:/Users/Manuel/Documents/TEC/Arqui\ 2/CPU/CPU-Pipelined/core {C:/Users/Manuel/Documents/TEC/Arqui 2/CPU/CPU-Pipelined/core/mux_3inputs.sv}
vlog -sv -work work +incdir+C:/Users/Manuel/Documents/TEC/Arqui\ 2/CPU/CPU-Pipelined/core {C:/Users/Manuel/Documents/TEC/Arqui 2/CPU/CPU-Pipelined/core/hazard_detection_unit.sv}
vlog -sv -work work +incdir+C:/Users/Manuel/Documents/TEC/Arqui\ 2/CPU/CPU-Pipelined/core {C:/Users/Manuel/Documents/TEC/Arqui 2/CPU/CPU-Pipelined/core/forwarding_unit.sv}
vlog -sv -work work +incdir+C:/Users/Manuel/Documents/TEC/Arqui\ 2/CPU/CPU-Pipelined/core {C:/Users/Manuel/Documents/TEC/Arqui 2/CPU/CPU-Pipelined/core/zeroExtend.sv}

vlog -sv -work work +incdir+C:/Users/Manuel/Documents/TEC/Arqui\ 2/CPU/CPU-Pipelined/testbenches {C:/Users/Manuel/Documents/TEC/Arqui 2/CPU/CPU-Pipelined/testbenches/cpu_top_tb.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  cpu_top_tb

add wave *
view structure
view signals
run -all
