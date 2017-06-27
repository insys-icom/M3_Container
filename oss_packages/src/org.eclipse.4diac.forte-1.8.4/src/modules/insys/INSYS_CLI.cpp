/*************************************************************************
 *** FORTE Library Element
 ***
 *** This file was generated using the 4DIAC FORTE Export Filter V1.0.x!
 ***
 *** Name: INSYS_CLI
 *** Description: Service Interface Function Block Type
 *** Version: 
 ***     0.0: 2017-01-31/4DIAC-IDE - 4DIAC-Consortium - 
 *************************************************************************/

#include "INSYS_CLI.h"
#ifdef FORTE_ENABLE_GENERATED_SOURCE_CPP
#include "INSYS_CLI_gen.cpp"
#endif

#include <string>
using std::string;

DEFINE_FIRMWARE_FB(FORTE_INSYS_CLI, g_nStringIdINSYS_CLI)

const CStringDictionary::TStringId FORTE_INSYS_CLI::scm_anDataInputNames[] = {g_nStringIdQI, g_nStringIdCOMMAND};

const CStringDictionary::TStringId FORTE_INSYS_CLI::scm_anDataInputTypeIds[] = {g_nStringIdBOOL, g_nStringIdSTRING};

const CStringDictionary::TStringId FORTE_INSYS_CLI::scm_anDataOutputNames[] = {g_nStringIdSUCCESS, g_nStringIdRESPONSE};

const CStringDictionary::TStringId FORTE_INSYS_CLI::scm_anDataOutputTypeIds[] = {g_nStringIdBOOL, g_nStringIdWSTRING};

const TForteInt16 FORTE_INSYS_CLI::scm_anEIWithIndexes[] = {0, 2};
const TDataIOID FORTE_INSYS_CLI::scm_anEIWith[] = {0, 255, 0, 1, 255};
const CStringDictionary::TStringId FORTE_INSYS_CLI::scm_anEventInputNames[] = {g_nStringIdINIT, g_nStringIdREQ};

const TDataIOID FORTE_INSYS_CLI::scm_anEOWith[] = {0, 1, 255, 0, 1, 255};
const TForteInt16 FORTE_INSYS_CLI::scm_anEOWithIndexes[] = {0, 3, -1};
const CStringDictionary::TStringId FORTE_INSYS_CLI::scm_anEventOutputNames[] = {g_nStringIdINITO, g_nStringIdCNF};

const SFBInterfaceSpec FORTE_INSYS_CLI::scm_stFBInterfaceSpec = {
  2,  scm_anEventInputNames,  scm_anEIWith,  scm_anEIWithIndexes,
  2,  scm_anEventOutputNames,  scm_anEOWith, scm_anEOWithIndexes,  2,  scm_anDataInputNames, scm_anDataInputTypeIds,
  2,  scm_anDataOutputNames, scm_anDataOutputTypeIds,
  0, 0
};


void FORTE_INSYS_CLI::executeEvent(int pa_nEIID){
  switch(pa_nEIID){
	case scm_nEventINITID:

		cliCommandControl = std::make_unique<CliCommanderControl>(factory->getCliCommander());

		if(cliCommandControl) {
			setInitialised();

			SUCCESS() = cliCommandControl->isControlStatusOK();
			RESPONSE().fromString(cliCommandControl->getControlStatusMessage().c_str());
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

		string cliCommand, cliResponse;

		cliCommand = COMMAND().getValue();
		cliResponse = cliCommandControl->queryCliCommand(cliCommand);

		SUCCESS() = cliCommandControl->isControlStatusOK();

		if(!cliCommandControl->isControlStatusOK()) {
			RESPONSE().fromString(cliCommandControl->getControlStatusMessage().c_str());
		} else {
			RESPONSE().fromString(cliResponse.c_str());
		}

	  sendOutputEvent(scm_nEventCNFID);
	  break;
  }
}

FORTE_INSYS_CLI::~FORTE_INSYS_CLI() {}
