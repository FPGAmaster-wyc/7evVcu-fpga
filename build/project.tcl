# Product Version: Vivado v2021.2 (64-bit)

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
        ../src/ctrl_axi_lite_slave.v
        ../src/datamover_ctrl.v
        ../src/fifo1.v
        ../src/fifomem.v
		../src/frame_freq_ctrl.v
		../src/gray_scale_data.v
		../src/mem_1r1w_2000x509.v
        ../src/mem_tmp_val_uram.v
        ../src/par_2_ser.v
	../src/system_wrapper.v
		../src/pixl_receive.v
		../src/pixl_top.v
		../src/pp_pix.v
		../src/pp_ram2_r_w_ctrl.v
		../src/proc_top_uram.v
		../src/reg_read_write.v
		../src/rptr_empty.v
		../src/save_image_1280x1024.v
		../src/save_image_1280x1024_mul_mul_17s_12ns_29_1_1.v
		../src/save_image_1280x1024_udiv_12s_8ns_12_16_1.v
		../src/spi_config.v
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
		../ip/ila_1280/ila_1280.xci
		../ip/ila_addr/ila_addr.xci
		../ip/ila_aurora/ila_aurora.xci
		../ip/ila_cnt/ila_cnt.xci
		../ip/ila_last/ila_last.xci
		../ip/proc_sys_reset_0/proc_sys_reset_0.xci
		../ip/vio_aurora/vio_aurora.xci
		../ip/vio_start/vio_start.xci
    }

    add_files -fileset [current_fileset -constrset] -force -norecurse {
        ../src/top.xdc
    }

    source {../bd/bd.tcl}

    # set_property CONFIG.FREQ_HZ 266664001 [get_bd_intf_pins /datamover_ctrl_0/M_AXIS_STS]
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


