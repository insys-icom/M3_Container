/*************************************************************************
 *** FORTE Library Element
 ***
 *** This file was generated using the 4DIAC FORTE Export Filter V1.0.x!
 ***
 *** Name: INSYS_REBOOT
 *** Description: Service Interface Function Block Type
 *** Version: 
 ***     0.0: 2017-01-31/4DIAC-IDE - 4DIAC-Consortium - 
 *************************************************************************/

#include "INSYS_REBOOT.h"
#ifdef FORTE_ENABLE_GENERATED_SOURCE_CPP
#include "INSYS_REBOOT_gen.cpp"
#endif

DEFINE_FIRMWARE_FB(FORTE_INSYS_REBOOT, g_nStringIdINSYS_REBOOT)

const TForteInt16 FORTE_INSYS_REBOOT::scm_anEIWithIndexes[] = {-1, -1};
const CStringDictionary::TStringId FORTE_INSYS_REBOOT::scm_anEventInputNames[] = {g_nStringIdINIT, g_nStringIdREQ};

const TForteInt16 FORTE_INSYS_REBOOT::scm_anEOWithIndexes[] = {-1, -1, -1};
const CStringDictionary::TStringId FORTE_INSYS_REBOOT::scm_anEventOutputNames[] = {g_nStringIdINITO, g_nStringIdCNF};

const SFBInterfaceSpec FORTE_INSYS_REBOOT::scm_stFBInterfaceSpec = {
  2,  scm_anEventInputNames,  0,  scm_anEIWithIndexes,
  2,  scm_anEventOutputNames,  0, 0,  0,  0, 0, 
  0,  0, 0,
  0, 0
};


void FORTE_INSYS_REBOOT::executeEvent(int pa_nEIID){
  switch(pa_nEIID){
    case scm_nEventINITID:

    	reboot = std::make_unique<RebooterControl>(factory->getRebooter());

    	if(reboot) {
    		setInitialised();
    	} else {
    		resetInitialised();
    	}

		sendOutputEvent(scm_nEventINITOID);
      break;
    case scm_nEventREQID:

    	if(!isInitialised()) {
    		return;
    	}

    	reboot->reboot();
    	sendOutputEvent(scm_nEventCNFID);
      break;
  }
}

FORTE_INSYS_REBOOT::~FORTE_INSYS_REBOOT() {}
