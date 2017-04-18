/*************************************************************************
 *** FORTE Library Element
 ***
 *** This file was generated using the 4DIAC FORTE Export Filter V1.0.x!
 ***
 *** Name: MRX_INFO_LED
 *** Description: Service Interface Function Block Type
 *** Version: 
 ***     0.0: 2017-01-31/4DIAC-IDE - 4DIAC-Consortium - 
 *************************************************************************/

#include "MRX_INFO_LED.h"
#ifdef FORTE_ENABLE_GENERATED_SOURCE_CPP
#include "MRX_INFO_LED_gen.cpp"
#endif

#include <string>

DEFINE_FIRMWARE_FB(FORTE_MRX_INFO_LED, g_nStringIdMRX_INFO_LED)

const CStringDictionary::TStringId FORTE_MRX_INFO_LED::scm_anDataInputNames[] = {g_nStringIdQI, g_nStringIdMODE};

const CStringDictionary::TStringId FORTE_MRX_INFO_LED::scm_anDataInputTypeIds[] = {g_nStringIdBOOL, g_nStringIdSTRING};

const CStringDictionary::TStringId FORTE_MRX_INFO_LED::scm_anDataOutputNames[] = {g_nStringIdSUCCESS, g_nStringIdRESPONSE};

const CStringDictionary::TStringId FORTE_MRX_INFO_LED::scm_anDataOutputTypeIds[] = {g_nStringIdBOOL, g_nStringIdWSTRING};

const TForteInt16 FORTE_MRX_INFO_LED::scm_anEIWithIndexes[] = {0, 2};
const TDataIOID FORTE_MRX_INFO_LED::scm_anEIWith[] = {0, 255, 0, 1, 255};
const CStringDictionary::TStringId FORTE_MRX_INFO_LED::scm_anEventInputNames[] = {g_nStringIdINIT, g_nStringIdREQ};

const TDataIOID FORTE_MRX_INFO_LED::scm_anEOWith[] = {0, 1, 255, 0, 1, 255};
const TForteInt16 FORTE_MRX_INFO_LED::scm_anEOWithIndexes[] = {0, 3, -1};
const CStringDictionary::TStringId FORTE_MRX_INFO_LED::scm_anEventOutputNames[] = {g_nStringIdINITO, g_nStringIdCNF};

const SFBInterfaceSpec FORTE_MRX_INFO_LED::scm_stFBInterfaceSpec = {
  2,  scm_anEventInputNames,  scm_anEIWith,  scm_anEIWithIndexes,
  2,  scm_anEventOutputNames,  scm_anEOWith, scm_anEOWithIndexes,  2,  scm_anDataInputNames, scm_anDataInputTypeIds,
  2,  scm_anDataOutputNames, scm_anDataOutputTypeIds,
  0, 0
};


void FORTE_MRX_INFO_LED::executeEvent(int pa_nEIID){
  switch(pa_nEIID){
	case scm_nEventINITID:

		cliCommander = std::make_unique<CliCommanderControl>(factory->getCliCommander());

		if(cliCommander) {
			setInitialised();

			SUCCESS() = cliCommander->isControlStatusOK();
			RESPONSE().fromString(cliCommander->getControlStatusMessage().c_str());
		} else {
			resetInitialised();

			SUCCESS() = false;
			RESPONSE().fromString("ERROR: initialisation failed");
		}

		sendOutputEvent(scm_nEventINITOID);
	  break;
	case scm_nEventREQID:
		if(!QI()) {
			SUCCESS() = false;
			RESPONSE().fromString("QI is false");

			sendOutputEvent(scm_nEventCNFID);

			return;
		}

		if(!isInitialised()) {
    		SUCCESS() = false;
    		RESPONSE().fromString("ERROR: Not initialised");

    		sendOutputEvent(scm_nEventCNFID);

    		return;
		}

		const std::string mode(MODE().getValue());

		if(mode != "on" && mode != "off" && mode != "flash") {
			SUCCESS() = false;
			RESPONSE().fromString("ERROR: Invalid mode");

			sendOutputEvent(scm_nEventCNFID);

			return;
		}

		std::string cliCommand = "help.debug.info_led.info_led=";

		cliCommand.append(MODE().getValue());
		cliCommander->sendCliCommand(cliCommand);

		if(!cliCommander->isControlStatusOK()) {
			SUCCESS() = cliCommander->isControlStatusOK();
			RESPONSE().fromString(cliCommander->getControlStatusMessage().c_str());

			sendOutputEvent(scm_nEventCNFID);
			return;
		}

		cliCommand = "help.debug.info_led.submit";
		cliCommander->sendCliCommand(cliCommand);

		SUCCESS() = cliCommander->isControlStatusOK();
		RESPONSE().fromString(cliCommander->getControlStatusMessage().c_str());

		sendOutputEvent(scm_nEventCNFID);
	  break;
  }
}

FORTE_MRX_INFO_LED::~FORTE_MRX_INFO_LED() {}
