/*************************************************************************
 *** FORTE Library Element
 ***
 *** This file was generated using the 4DIAC FORTE Export Filter V1.0.x!
 ***
 *** Name: INSYS_INPUT
 *** Description: Service Interface Function Block Type
 *** Version: 
 ***     0.0: 2017-01-31/4DIAC-IDE - 4DIAC-Consortium - 
 *************************************************************************/

#include "INSYS_INPUT.h"
#ifdef FORTE_ENABLE_GENERATED_SOURCE_CPP
#include "INSYS_INPUT_gen.cpp"
#endif

DEFINE_FIRMWARE_FB(FORTE_INSYS_INPUT, g_nStringIdINSYS_INPUT)

const CStringDictionary::TStringId FORTE_INSYS_INPUT::scm_anDataInputNames[] = {g_nStringIdQI, g_nStringIdINPUT};

const CStringDictionary::TStringId FORTE_INSYS_INPUT::scm_anDataInputTypeIds[] = {g_nStringIdBOOL, g_nStringIdSTRING};

const CStringDictionary::TStringId FORTE_INSYS_INPUT::scm_anDataOutputNames[] = {g_nStringIdSUCCESS, g_nStringIdRESPONSE, g_nStringIdVALUE};

const CStringDictionary::TStringId FORTE_INSYS_INPUT::scm_anDataOutputTypeIds[] = {g_nStringIdBOOL, g_nStringIdSTRING, g_nStringIdBOOL};

const TForteInt16 FORTE_INSYS_INPUT::scm_anEIWithIndexes[] = {0, 2};
const TDataIOID FORTE_INSYS_INPUT::scm_anEIWith[] = {0, 255, 0, 1, 255};
const CStringDictionary::TStringId FORTE_INSYS_INPUT::scm_anEventInputNames[] = {g_nStringIdINIT, g_nStringIdREQ};

const TDataIOID FORTE_INSYS_INPUT::scm_anEOWith[] = {0, 1, 255, 0, 1, 255, 2, 255};
const TForteInt16 FORTE_INSYS_INPUT::scm_anEOWithIndexes[] = {0, 3, -1, 6};
const CStringDictionary::TStringId FORTE_INSYS_INPUT::scm_anEventOutputNames[] = {g_nStringIdINITO, g_nStringIdCNF, g_nStringIdCHANGED};

const SFBInterfaceSpec FORTE_INSYS_INPUT::scm_stFBInterfaceSpec = {
  2,  scm_anEventInputNames,  scm_anEIWith,  scm_anEIWithIndexes,
  3,  scm_anEventOutputNames,  scm_anEOWith, scm_anEOWithIndexes,  2,  scm_anDataInputNames, scm_anDataInputTypeIds,
  3,  scm_anDataOutputNames, scm_anDataOutputTypeIds,
  0, 0
};


void FORTE_INSYS_INPUT::executeEvent(int pa_nEIID){
  switch(pa_nEIID){
	case scm_nEventINITID:

		input = std::make_unique<InputReaderControl>(factory->getInputControl());

		if(input) {
			setInitialised();

			SUCCESS() = input->isControlStatusOK();
			RESPONSE().fromString(input->getControlStatusMessage().c_str());
		} else {
			SUCCESS() = false;
			RESPONSE().fromString("ERROR: initialisation failed");
		}

		// set private variables
		lastState = false;
		firstRead= true;

		sendOutputEvent(scm_nEventINITOID);

	  break;
	case scm_nEventREQID:
		string inputValue;

		if(!QI()) {
			SUCCESS() = false;
    		RESPONSE().fromString("QI is false");
			return;
		}

		if(!isInitialised()) {
    		SUCCESS() = false;
    		RESPONSE().fromString("ERROR: Not initialised");
    		return;
		}

		input->setInputName(INPUT().getValue());

		inputValue = input->readInputState();

		SUCCESS() = input->isControlStatusOK();

		if(input->isControlStatusOK()){
			RESPONSE().fromString(inputValue.c_str());

			if(inputValue == "high") {
				VALUE() = true;
			} else {
				VALUE() = false;
			}

			if(lastState != VALUE()) {
				sendOutputEvent(scm_nEventCHANGEDID);
			}

			lastState = VALUE();
		} else {
			RESPONSE().fromString(input->getControlStatusMessage().c_str());
		}

		sendOutputEvent(scm_nEventCNFID);

	  break;
  }
}

FORTE_INSYS_INPUT::~FORTE_INSYS_INPUT() {}
