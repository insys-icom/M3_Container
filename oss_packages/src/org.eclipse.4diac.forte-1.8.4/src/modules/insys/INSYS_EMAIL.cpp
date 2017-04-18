/*************************************************************************
 *** FORTE Library Element
 ***
 *** This file was generated using the 4DIAC FORTE Export Filter V1.0.x!
 ***
 *** Name: INSYS_EMAIL
 *** Description: Service Interface Function Block Type
 *** Version: 
 ***     0.0: 2017-01-31/4DIAC-IDE - 4DIAC-Consortium - 
 *************************************************************************/

#include "INSYS_EMAIL.h"
#ifdef FORTE_ENABLE_GENERATED_SOURCE_CPP
#include "INSYS_EMAIL_gen.cpp"
#endif

DEFINE_FIRMWARE_FB(FORTE_INSYS_EMAIL, g_nStringIdINSYS_EMAIL)

const CStringDictionary::TStringId FORTE_INSYS_EMAIL::scm_anDataInputNames[] = {g_nStringIdQI, g_nStringIdRECIPIENT, g_nStringIdSUBJECT, g_nStringIdTEXT};

const CStringDictionary::TStringId FORTE_INSYS_EMAIL::scm_anDataInputTypeIds[] = {g_nStringIdBOOL, g_nStringIdSTRING, g_nStringIdSTRING, g_nStringIdSTRING};

const CStringDictionary::TStringId FORTE_INSYS_EMAIL::scm_anDataOutputNames[] = {g_nStringIdSUCCESS, g_nStringIdRESPONSE};

const CStringDictionary::TStringId FORTE_INSYS_EMAIL::scm_anDataOutputTypeIds[] = {g_nStringIdBOOL, g_nStringIdSTRING};

const TForteInt16 FORTE_INSYS_EMAIL::scm_anEIWithIndexes[] = {0, 2};
const TDataIOID FORTE_INSYS_EMAIL::scm_anEIWith[] = {0, 255, 0, 2, 1, 3, 255};
const CStringDictionary::TStringId FORTE_INSYS_EMAIL::scm_anEventInputNames[] = {g_nStringIdINIT, g_nStringIdREQ};

const TDataIOID FORTE_INSYS_EMAIL::scm_anEOWith[] = {0, 1, 255, 0, 1, 255};
const TForteInt16 FORTE_INSYS_EMAIL::scm_anEOWithIndexes[] = {0, 3, -1};
const CStringDictionary::TStringId FORTE_INSYS_EMAIL::scm_anEventOutputNames[] = {g_nStringIdINITO, g_nStringIdCNF};

const SFBInterfaceSpec FORTE_INSYS_EMAIL::scm_stFBInterfaceSpec = {
  2,  scm_anEventInputNames,  scm_anEIWith,  scm_anEIWithIndexes,
  2,  scm_anEventOutputNames,  scm_anEOWith, scm_anEOWithIndexes,  4,  scm_anDataInputNames, scm_anDataInputTypeIds,
  2,  scm_anDataOutputNames, scm_anDataOutputTypeIds,
  0, 0
};


void FORTE_INSYS_EMAIL::executeEvent(int pa_nEIID){
  switch(pa_nEIID){
    case scm_nEventINITID:

    	emailSender = std::make_unique<EmailMessageSenderControl>(factory->getEmailMessageSender());

    	if(emailSender) {
    		setInitialised();

			SUCCESS() = emailSender->isControlStatusOK();
			RESPONSE().fromString(emailSender->getControlStatusMessage().c_str());
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
    		return;
    	}

    	if(!isInitialised()) {
    		SUCCESS() = false;
    		RESPONSE().fromString("ERROR: Not initialised");
    		return;
    	}

    	EmailMessage email;

    	email.recipient = RECIPIENT().getValue();
    	email.subject = SUBJECT().getValue();
    	email.text = TEXT().getValue();

    	emailSender->setEmailMessage(email);

    	emailSender->sendEmailMessage();

    	SUCCESS() = emailSender->isControlStatusOK();
    	RESPONSE().fromString(emailSender->getControlStatusMessage().c_str());

		sendOutputEvent(scm_nEventCNFID);
      break;
  }
}

FORTE_INSYS_EMAIL::~FORTE_INSYS_EMAIL() {}
