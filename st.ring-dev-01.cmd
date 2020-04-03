

require dmsc_detector_interface,master
require stream,2.8.10
require autosave,5.10.0

epicsEnvSet("TOP", "$(E3_CMD_TOP)/..")
epicsEnvSet("IOCNAME", "ring-dev-01")



epicsEnvSet("SYS", "RNG-DEV")
epicsEnvSet("DEV", "01")
epicsEnvSet("E3_MODULES", "/epics/iocs")
epicsEnvSet("EPICS_CMDS", "/epics/iocs/cmds")
epicsEnvSet("TMP", "/tmp")
epicsEnvSet("VIVADO_PROJ", "$(EPICS_CMDS)/$(IOCNAME)/dgro_master")
epicsEnvSet("DET_PARAM_GEN", "$(VIVADO_PROJ)/det_param_gen")


# iocshLoad("$(autosave_DIR)/autosave.iocsh", "AS_TOP=$(TOP),IOCNAME=$(IOCNAME)")


############# -------- Detector Readout Interface ----------------- ##################

epicsEnvSet("STREAM_PROTOCOL_PATH","/epics/base-7.0.3.1/require/3.1.2/siteApps/dmsc_detector_interface/master/db")
epicsEnvSet("PROTO", "ics-dg.proto")
# Determine the USB bus enumeration and connect port
system "/bin/bash $(EPICS_CMDS)/$(IOCNAME)/find_usb_bus_id.bash"
< "/tmp/usb_bus_id"

epicsEnvSet("COM", "COM1")
drvAsynSerialPortConfigure ("$(COM)", "/dev/$(USB_BUS_NUMA)")
asynOctetSetInputEos ("$(COM)",0,"\r\n")
asynOctetSetOutputEos ("$(COM)",0,"\r\n")
asynSetOption ("$(COM)", 0, "baud", "230400")
asynSetOption ("$(COM)", 0, "bits", "8")
asynSetOption ("$(COM)", 0, "parity", "none")
asynSetOption ("$(COM)", 0, "stop", "1")

#var streamDebug 1


## Run the db generate script 
system "/usr/bin/python3 $(DET_PARAM_GEN)/src/param_parse.py $(VIVADO_PROJ)/param_def/"

iocshLoad("$(DET_PARAM_GEN)/output/EPICS/ctl_regs_mst.cmd", "DEV=$(DEV), COM=$(COM), SYS=$(SYS), PROTO=$(PROTO)")
#iocshLoad("$(DET_PARAM_GEN)/output/EPICS/eng_regs_mst.cmd", "DEV=$(DEV), COM=$(COM), SYS=$(SYS), PROTO=$(PROTO)")
#iocshLoad("$(DET_PARAM_GEN)/output/EPICS/ring_regs_mst.cmd", "DEV=$(DEV), COM=$(COM), SYS=$(SYS), PROTO=$(PROTO)")
#iocshLoad("$(DET_PARAM_GEN)/output/EPICS/ring_regs_slv.cmd", "DEV=$(DEV), COM=$(COM), SYS=$(SYS), PROTO=$(PROTO)")
#iocshLoad("$(DET_PARAM_GEN)/output/EPICS/usr_regs_slv.cmd", "DEV=$(DEV), COM=$(COM), SYS=$(SYS), PROTO=$(PROTO)")

iocInit()

