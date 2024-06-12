# Product Version: Vivado v2019.2 (64-bit)

set projName 7ev_Vcu
set part xczu7ev-ffvc1156-2-i	
set top top	

proc run_create {} {
    global projName
    global part
    global top

    set outputDir ./$projName			

    file mkdir $outputDir

    create_project $projName $outputDir -part $part -force		

    set projDir [get_property directory [current_project]]

    add_files -fileset [current_fileset] -force -norecurse {
        ../src/asyncFifo.v
        ../src/axi_full_core.v
        ../src/axis2ddr_top.v
        ../src/axis2fifo.v
		../src/design_1_wrapper.v
        ../src/fifo.v
        ../src/fifo1.v
        ../src/fifomem.v
        ../src/mem_1r1w_2000x509.v
        ../src/mem_tmp_val_uram.v
        ../src/par_2_ser.v
		../src/pixl_receive.v
		../src/pixl_top.v
		../src/pp_pix.v
		../src/pp_ram2_r_w_ctrl.v
		../src/proc_top_uram.v
		../src/Reg_Controller.v
		../src/rptr_empty.v
		../src/save_image_1280x1024.v
		../src/save_image_1280x1024_mul_mul_17s_12ns_29_1_1.v
		../src/save_image_1280x1024_udiv_12s_8ns_12_16_1.v
		../src/sfp_power_on_reset.v
		../src/sim-axilite-s.v
		../src/spi_config.v
		../src/spikep_top.v
		../src/sum_io_empty.v
		../src/sum_io_empty_3_ram.v
		../src/sum_io_empty_12.v
		../src/sync_r2w.v
		../src/sync_w2r.v
		../src/syncFifo1.v
		../src/top.v
		../src/wptr_full.v
    }
	
    add_files -fileset [current_fileset] -force -norecurse {
        ../ip/aurora_64b66b_0/aurora_64b66b_0.xci
        ../ip/axis_clock_converter_0/axis_clock_converter_0.xci
        ../ip/axis_dwidth_converter_0/axis_dwidth_converter_0.xci
		../ip/clk_wiz_1/clk_wiz_1.xci
		../ip/fifo512bit_1k/fifo512bit_1k.xci
		../ip/ila_1080/ila_1080.xci
		../ip/ila_aurora/ila_aurora.xci
		../ip/ila_ram/ila_ram.xci
		../ip/ila_ram4/ila_ram4.xci
		../ip/ila_sensor/ila_sensor.xci
		../ip/ila_spike/ila_spike.xci
		../ip/ila_syncfifo/ila_syncfifo.xci
		../ip/vio_rst/vio_rst.xci
    }

    add_files -fileset [current_fileset -constrset] -force -norecurse {
        ../src/top.xdc
    }
	
	set_property ip_repo_paths "../ip/axi_lite_4reg_1.0" [current_project]
	update_ip_catalog

    source {../bd/bd.tcl}

    set_property top $top [current_fileset]
    set_property generic DEBUG=TRUE [current_fileset]

    set_property AUTO_INCREMENTAL_CHECKPOINT 1 [current_run -implementation]

    update_compile_order
}

proc run_build {} {         
    upgrade_ip [get_ips]

    # Synthesis
    launch_runs -jobs 12 [current_run -synthesis]
    wait_on_run [current_run -synthesis]

    # Implementation
    launch_runs -jobs 12 [current_run -implementation] -to_step write_bitstream
    wait_on_run [current_run -implementation]
}


