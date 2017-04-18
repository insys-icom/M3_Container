#############################################################################
# INSYS - FB
#############################################################################

forte_add_module(INSYS_Functionblocks "Function blocks for insys devices")
SET(FORTE_MODULE_INSYS_INCLUDE_DIR "" CACHE PATH "Path to MRX Includes")

if(EXISTS ${FORTE_MODULE_INSYS_INCLUDE_DIR})
    		forte_add_include_directories( ${FORTE_MODULE_INSYS_INCLUDE_DIR} )
endif(EXISTS ${FORTE_MODULE_INSYS_INCLUDE_DIR})

forte_add_link_library(libmrx_control.so)
forte_add_link_library(libFORTEControls.a)

forte_add_sourcefile_hcpp(InsysFunctionBlock
                          INSYS_EMAIL
                          INSYS_SMS
                          INSYS_OUTPUT
                          INSYS_INPUT
                          INSYS_CLI
                          INSYS_REBOOT
                          MRX_INFO_LED)
