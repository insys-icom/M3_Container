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

#ifndef _INSYS_REBOOT_H_
#define _INSYS_REBOOT_H_

#include <funcbloc.h>
#include <string>

#include "InsysFunctionBlock.h"
#include <RebooterControl.h>
#include <memory>

class FORTE_INSYS_REBOOT: public CFunctionBlock, InsysFunctionBlock{
  DECLARE_FIRMWARE_FB(FORTE_INSYS_REBOOT)

private:
  static const TEventID scm_nEventINITID = 0;
  static const TEventID scm_nEventREQID = 1;
  static const TForteInt16 scm_anEIWithIndexes[];
  static const CStringDictionary::TStringId scm_anEventInputNames[];

  static const TEventID scm_nEventINITOID = 0;
  static const TEventID scm_nEventCNFID = 1;
  static const TForteInt16 scm_anEOWithIndexes[];
  static const CStringDictionary::TStringId scm_anEventOutputNames[];

  static const SFBInterfaceSpec scm_stFBInterfaceSpec;

   FORTE_FB_DATA_ARRAY(2, 0, 0, 0);

  void executeEvent(int pa_nEIID);

  std::unique_ptr<RebooterControl> reboot;

public:
  FUNCTION_BLOCK_CTOR(FORTE_INSYS_REBOOT){
  };

virtual ~FORTE_INSYS_REBOOT();

};
#endif //close the ifdef sequence from the beginning of the file

