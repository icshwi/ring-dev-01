require dmsc_detector_interface,master
require stream,2.8.8
require autosave,5.9.0

epicsEnvSet("TOP", "$(E3_CMD_TOP)/..")
epicsEnvSet("IOCNAME", "pkt-mux-cmd")



epicsEnvSet("SYS", "PKT-MUX")
epicsEnvSet("DEV", "01")
epicsEnvSet("E3_MODULES", "/epics/iocs")
epicsEnvSet("EPICS_CMDS", "/epics/iocs/cmds")
epicsEnvSet("TMP", "/tmp")
epicsEnvSet("VIVADO_PROJ", "$(EPICS_CMDS)/$(IOCNAME)/dgro_master")
epicsEnvSet("DET_PARAM_GEN", "$(VIVADO_PROJ)/det_param_gen")


iocshLoad("$(autosave_DIR)/autosave.iocsh", "AS_TOP=$(TOP),IOCNAME=$(IOCNAME)")


############# -------- Detector Readout Interface ----------------- ##################

epicsEnvSet("STREAM_PROTOCOL_PATH","/epics/base-7.0.3/require/3.1.2/siteApps/dmsc_detector_interface/master/db")

epicsEnvSet("DET_CLK_RST_EVT", "15")
epicsEnvSet("DET_RST_EVT", "15")
epicsEnvSet("SYNC_EVNT_LETTER", "EvtF")
epicsEnvSet("SYNC_TRIG_EVT", "16")
epicsEnvSet("NANO_DELTA", "1000000000")

# Determine the USB bus enumeration and connect port
system "/bin/bash $(DETINT_CMD_TOP)/find_usb_bus_id.bash"
< "/tmp/usb_bus_id"

drvAsynSerialPortConfigure ("$(COM)", "/dev/$(USB_BUS_NUMA)")
asynOctetSetInputEos ("$(COM)",0,"\\r\\n")
asynOctetSetOutputEos ("$(COM)",0,"\\r\\n")
asynSetOption ("$(COM)", 0, "baud", "230400")
asynSetOption ("$(COM)", 0, "bits", "8")
asynSetOption ("$(COM)", 0, "parity", "none")
asynSetOption ("$(COM)", 0, "stop", "1")


## Run the db generate script 
system "/usr/bin/python $(DET_PARAM_GEN)/src/param_parse.py

iocshLoad("$(DET_PARAM_GEN)/output/EPICS/ctl_regs_mst.cmd", "DEV=$(DEV), COM=$(COM), SYS=$(SYS), PROTO=$(PROTO)")
iocshLoad("$(DET_PARAM_GEN)/output/EPICS/eng_regs_mst.cmd", "DEV=$(DEV), COM=$(COM), SYS=$(SYS), PROTO=$(PROTO)")
iocshLoad("$(DET_PARAM_GEN)/output/EPICS/ring_regs_mst.cmd", "DEV=$(DEV), COM=$(COM), SYS=$(SYS), PROTO=$(PROTO)")
iocshLoad("$(DET_PARAM_GEN)/output/EPICS/ring_regs_slv.cmd", "DEV=$(DEV), COM=$(COM), SYS=$(SYS), PROTO=$(PROTO)")
iocshLoad("$(DET_PARAM_GEN)/output/EPICS/usr_regs_slv.cmd", "DEV=$(DEV), COM=$(COM), SYS=$(SYS), PROTO=$(PROTO)")

iocInit()

