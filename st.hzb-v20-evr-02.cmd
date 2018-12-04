epicsEnvSet("SYS", "HZB-V20:TS")
epicsEnvSet("PCI_SLOT", "1:0.0")
epicsEnvSet("DEVICE", "EVR-02")
epicsEnvSet("EVR", "$(DEVICE)")
epicsEnvSet("MRF_HW_DB", "evr-pcie-300dc-ess.db")
epicsEnvSet("E3_MODULES", "/epics/iocs/e3")
epicsEnvSet("EPICS_CMDS", "/epics/iocs/cmds")

######## Temporary until chopper group ###########
######## changes PV names              ###########
#epicsEnvSet("NCG_SYS", "HZB-V20:")
# Change to 02a: to avoid conflict with EVR2 names
#epicsEnvSet("NCG_DRV", "Chop-Drv-02tmp:")
##################################################

< "$(EPICS_CMDS)/mrfioc2-common-cmd/st.evr.cmd"

require dmsc_detector_interface,master
require stream,2.7.14p


############# -------- Detector Readout Interface ----------------- ##################
epicsEnvSet("DETINT_CMD_TOP","/epics/iocs/cmds/hzb-v20-evr-02-cmd") 
#epicsEnvSet("DETINT_DB_TOP", "$(E3_MODULES)/e3-detectorinterface/m-epics-detectorinterface-dev/db")
epicsEnvSet("STREAM_PROTOCOL_PATH","/epics/base-7.0.1.1/require/3.0.4/siteApps/dmsc_detector_interface/master/db")

epicsEnvSet("DET_CLK_RST_EVT", "15")
epicsEnvSet("DET_RST_EVT", "15")
epicsEnvSet("SYNC_EVNT_LETTER", "EvtF")
epicsEnvSet("SYNC_TRIG_EVT", "16")

epicsEnvSet("COM1_USB_DEV_NUM", "0")
epicsEnvSet("COM2_USB_DEV_NUM", "2")



# Load the detector interface module
iocshLoad("$(DETINT_CMD_TOP)/detint.cmd", "DEV1=RO1, DEV2=RO2, COM1=COM1, COM2=COM2,COM1_USB_DEV_NUM=$(COM1_USB_DEV_NUM),COM2_USB_DEV_NUM=$(COM2_USB_DEV_NUM), SYS=$(SYS), SYNC_EVNT=$(DET_RST_EVT), SYNC_EVNT_LETTER=$(SYNC_EVNT_LETTER), N_SEC_TICKS=1000000000 ")



iocInit()

# Global default values
# Set the frequency that the EVR expects from the EVG for the event clock
dbpf $(SYS)-$(DEVICE):Time-Clock-SP 88.0525


# Set delay compensation target. This is required even when delay compensation
# is disabled to avoid occasionally corrupting timestamps.
#dbpf $(SYS)-$(DEVICE):DC-Tgt-SP 70
dbpf $(SYS)-$(DEVICE):DC-Tgt-SP 100

# Connect prescaler reset to event DET_CLK_RST_EVT
dbpf $(SYS)-$(DEVICE):Evt-ResetPS-SP DET_CLK_RST_EVT

# Connect FP08 to PS0
dbpf $(SYS)-$(DEVICE):OutFPUV08-Ena-SP 1
dbpf $(SYS)-$(DEVICE):OutFPUV08-Src-SP 40 
dbpf $(SYS)-$(DEVICE):PS0-Div-SP 2

# Map pulser 9 to event code SYNC_TRIG_EVT
dbpf $(SYS)-$(DEVICE):DlyGen9-Evt-Trig0-SP 16
dbpf $(SYS)-$(DEVICE):DlyGen9-Width-SP 10

# Connect FP09 to Pulser 9
dbpf $(SYS)-$(DEVICE):OutFPUV09-Ena-SP 1
dbpf $(SYS)-$(DEVICE):OutFPUV09-Src-SP 9 

# Connect FP10 to PS0
dbpf $(SYS)-$(DEVICE):OutFPUV10-Ena-SP 1
dbpf $(SYS)-$(DEVICE):OutFPUV10-Src-SP 40 

# Connect FP11 to Pulser 9
dbpf $(SYS)-$(DEVICE):OutFPUV11-Ena-SP 1
dbpf $(SYS)-$(DEVICE):OutFPUV11-Src-SP 9 

# Connect FP2 to Pulser 9
dbpf $(SYS)-$(DEVICE):OutFPUV02-Ena-SP 1
dbpf $(SYS)-$(DEVICE):OutFPUV02-Src-SP 9 

dbpf $(SYS)-$(DEVICE):OutFPUV03-Ena-SP 1
dbpf $(SYS)-$(DEVICE):OutFPUV03-Src-SP 40 

