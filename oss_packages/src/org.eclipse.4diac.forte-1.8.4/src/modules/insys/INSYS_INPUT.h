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

#ifndef _INSYS_INPUT_H_
#define _INSYS_INPUT_H_

#include <funcbloc.h>
#include <forte_bool.h>
#include <forte_string.h>
#include <vector>
#include <string>

#include "InsysFunctionBlock.h"
#include <InputReaderControl.h>
#include <memory>

class FORTE_INSYS_INPUT: public CFunctionBlock, InsysFunctionBlock{
  DECLARE_FIRMWARE_FB(FORTE_INSYS_INPUT)

private:
  static const CStringDictionary::TStringId scm_anDataInputNames[];
  static const CStringDictionary::TStringId scm_anDataInputTypeIds[];
  CIEC_BOOL &QI() {
    return *static_cast<CIEC_BOOL*>(getDI(0));
  };

  CIEC_STRING &INPUT() {
    return *static_cast<CIEC_STRING*>(getDI(1));
  };

  static const CStringDictionary::TStringId scm_anDataOutputNames[];
  static const CStringDictionary::TStringId scm_anDataOutputTypeIds[];
  CIEC_BOOL &SUCCESS() {
    return *static_cast<CIEC_BOOL*>(getDO(0));
  };

  CIEC_STRING &RESPONSE() {
    return *static_cast<CIEC_STRING*>(getDO(1));
  };

  CIEC_BOOL &VALUE() {
    return *static_cast<CIEC_BOOL*>(getDO(2));
  };

  static const TEventID scm_nEventINITID = 0;
  static const TEventID scm_nEventREQID = 1;
  static const TForteInt16 scm_anEIWithIndexes[];
  static const TDataIOID scm_anEIWith[];
  static const CStringDictionary::TStringId scm_anEventInputNames[];

  static const TEventID scm_nEventINITOID = 0;
  static const TEventID scm_nEventCNFID = 1;
  static const TEventID scm_nEventCHANGEDID = 2;
  static const TForteInt16 scm_anEOWithIndexes[];
  static const TDataIOID scm_anEOWith[];
  static const CStringDictionary::TStringId scm_anEventOutputNames[];

  static const SFBInterfaceSpec scm_stFBInterfaceSpec;

   FORTE_FB_DATA_ARRAY(3, 2, 3, 0);

  void executeEvent(int pa_nEIID);

  bool lastState;
  bool firstRead;

  std::unique_ptr <InputReaderControl> input;

public:
  FUNCTION_BLOCK_CTOR(FORTE_INSYS_INPUT){
  };

virtual ~FORTE_INSYS_INPUT();

};

#endif //close the ifdef sequence from the beginning of the file

