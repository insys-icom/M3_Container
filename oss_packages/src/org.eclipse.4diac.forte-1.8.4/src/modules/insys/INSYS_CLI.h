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

#ifndef _INSYS_CLI_H_
#define _INSYS_CLI_H_

#include <funcbloc.h>
#include <forte_bool.h>
#include <forte_string.h>
#include <forte_wstring.h>

#include "InsysFunctionBlock.h"
#include <CliCommanderControl.h>
#include <memory>

class FORTE_INSYS_CLI: public CFunctionBlock, InsysFunctionBlock{
  DECLARE_FIRMWARE_FB(FORTE_INSYS_CLI)

private:
  static const CStringDictionary::TStringId scm_anDataInputNames[];
  static const CStringDictionary::TStringId scm_anDataInputTypeIds[];
  CIEC_BOOL &QI() {
    return *static_cast<CIEC_BOOL*>(getDI(0));
  };

  CIEC_STRING &COMMAND() {
    return *static_cast<CIEC_STRING*>(getDI(1));
  };

  static const CStringDictionary::TStringId scm_anDataOutputNames[];
  static const CStringDictionary::TStringId scm_anDataOutputTypeIds[];
  CIEC_BOOL &SUCCESS() {
    return *static_cast<CIEC_BOOL*>(getDO(0));
  };

  CIEC_WSTRING &RESPONSE() {
    return *static_cast<CIEC_WSTRING*>(getDO(1));
  };

  static const TEventID scm_nEventINITID = 0;
  static const TEventID scm_nEventREQID = 1;
  static const TForteInt16 scm_anEIWithIndexes[];
  static const TDataIOID scm_anEIWith[];
  static const CStringDictionary::TStringId scm_anEventInputNames[];

  static const TEventID scm_nEventINITOID = 0;
  static const TEventID scm_nEventCNFID = 1;
  static const TForteInt16 scm_anEOWithIndexes[];
  static const TDataIOID scm_anEOWith[];
  static const CStringDictionary::TStringId scm_anEventOutputNames[];

  static const SFBInterfaceSpec scm_stFBInterfaceSpec;

   FORTE_FB_DATA_ARRAY(2, 2, 2, 0);

  void executeEvent(int pa_nEIID);

  std::unique_ptr<CliCommanderControl> cliCommandControl;

public:
  FUNCTION_BLOCK_CTOR(FORTE_INSYS_CLI){
  };

virtual ~FORTE_INSYS_CLI();

};
#endif //close the ifdef sequence from the beginning of the file

