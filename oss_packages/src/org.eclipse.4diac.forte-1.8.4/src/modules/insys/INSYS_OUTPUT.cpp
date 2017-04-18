/*************************************************************************
 *** FORTE Library Element
 ***
 *** This file was generated using the 4DIAC FORTE Export Filter V1.0.x!
 ***
 *** Name: INSYS_OUTPUT
 *** Description: Service Interface Function Block Type
 *** Version: 
 ***     0.0: 2017-01-31/4DIAC-IDE - 4DIAC-Consortium - 
 *************************************************************************/

#include "INSYS_OUTPUT.h"
#ifdef FORTE_ENABLE_GENERATED_SOURCE_CPP
#include "INSYS_OUTPUT_gen.cpp"
#endif

#include <string>
#include <OutputState.h>

DEFINE_FIRMWARE_FB(FORTE_INSYS_OUTPUT, g_nStringIdINSYS_OUTPUT)

const CStringDictionary::TStringId FORTE_INSYS_OUTPUT::scm_anDataInputNames[] = {g_nStringIdQI, g_nStringIdOUTPUT, g_nStringIdCHANGE};

const CStringDictionary::TStringId FORTE_INSYS_OUTPUT::scm_anDataInputTypeIds[] = {g_nStringIdBOOL, g_nStringIdSTRING, g_nStringIdSTRING};

const CStringDictionary::TStringId FORTE_INSYS_OUTPUT::scm_anDataOutputNames[] = {g_nStringIdSUCCESS, g_nStringIdRESPONSE};

const CStringDictionary::TStringId FORTE_INSYS_OUTPUT::scm_anDataOutputTypeIds[] = {g_nStringIdBOOL, g_nStringIdSTRING};

const TForteInt16 FORTE_INSYS_OUTPUT::scm_anEIWithIndexes[] = {0, 2};
const TDataIOID FORTE_INSYS_OUTPUT::scm_anEIWith[] = {0, 255, 0, 2, 1, 255};
const CStringDictionary::TStringId FORTE_INSYS_OUTPUT::scm_anEventInputNames[] = {g_nStringIdINIT, g_nStringIdREQ};

const TDataIOID FORTE_INSYS_OUTPUT::scm_anEOWith[] = {0, 1, 255, 0, 1, 255};
const TForteInt16 FORTE_INSYS_OUTPUT::scm_anEOWithIndexes[] = {0, 3, -1};
const CStringDictionary::TStringId FORTE_INSYS_OUTPUT::scm_anEventOutputNames[] = {g_nStringIdINITO, g_nStringIdCNF};

const SFBInterfaceSpec FORTE_INSYS_OUTPUT::scm_stFBInterfaceSpec = {
  2,  scm_anEventInputNames,  scm_anEIWith,  scm_anEIWithIndexes,
  2,  scm_anEventOutputNames,  scm_anEOWith, scm_anEOWithIndexes,  3,  scm_anDataInputNames, scm_anDataInputTypeIds,
  2,  scm_anDataOutputNames, scm_anDataOutputTypeIds,
  0, 0
};


void FORTE_INSYS_OUTPUT::executeEvent(int pa_nEIID){
  switch(pa_nEIID){
    case scm_nEventINITID:

    	output = std::make_unique<OutputSetterControl>(factory->getOutputSetter());

    	if(output) {
    		setInitialised();

			SUCCESS() = output->isControlStatusOK();
			RESPONSE().fromString(output->getControlStatusMessage().c_str());
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
    		return;
    	}

    	std::string outputName;

    	outputName = OUTPUT().getValue();
    	output->setOutputName(outputName);

    	output->setOutputState(CHANGE().getValue());

    	SUCCESS() = output->isControlStatusOK();
    	RESPONSE().fromString(output->getControlStatusMessage().c_str());

		sendOutputEvent(scm_nEventCNFID);
  }
}

FORTE_INSYS_OUTPUT::~FORTE_INSYS_OUTPUT() {}
