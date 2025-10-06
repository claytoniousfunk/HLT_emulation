#!/bin/bash

TRIGGERMENU="/users/cbennett/140X/HLT_PbPb_140X_integratedMenu/V3"
GLOBALTAG="140X_dataRun3_HLT_v3"
L1MENU="L1Menu_CollisionsHeavyIons2023_v1_1_5.xml"
L1EMULATOR="uGT"
ERA="Run3"


files=("/store/hidata/HIRun2023A/HIEphemeralZeroBias1/RAW/v1/000/374/521/00000/9bcc9429-5570-473c-a76d-0a76b5ed1cfd.root"
       "/store/hidata/HIRun2023A/HIEphemeralZeroBias1/RAW/v1/000/374/521/00000/a335eeaa-b81f-4086-bf4b-8409412a2230.root"
       "/store/hidata/HIRun2023A/HIEphemeralZeroBias1/RAW/v1/000/374/521/00000/a7436761-cee2-454e-98f5-7b3fc58cdfc2.root"
       "/store/hidata/HIRun2023A/HIEphemeralZeroBias1/RAW/v1/000/374/521/00000/ab8d7964-9779-4b0f-a30b-c691d4adb3e6.root"
       "/store/hidata/HIRun2023A/HIEphemeralZeroBias1/RAW/v1/000/374/521/00000/b721e994-00c8-4bdc-9c8b-822affb86ec4.root"
       "/store/hidata/HIRun2023A/HIEphemeralZeroBias1/RAW/v1/000/374/521/00000/bd242475-e277-42d8-bfc5-603fa700b52c.root"
       "/store/hidata/HIRun2023A/HIEphemeralZeroBias1/RAW/v1/000/374/521/00000/c3fca677-957e-4867-bfe9-678aef4a8504.root"
       "/store/hidata/HIRun2023A/HIEphemeralZeroBias1/RAW/v1/000/374/521/00000/dcc8ce89-3d77-4fc5-9f73-111c52e342e1.root"
       "/store/hidata/HIRun2023A/HIEphemeralZeroBias1/RAW/v1/000/374/521/00000/e371a91f-636e-4068-b7e3-bd5cc7aa7e50.root"
       "/store/hidata/HIRun2023A/HIEphemeralZeroBias1/RAW/v1/000/374/521/00000/e3a32659-8ba8-4429-bb81-c72fec45bfe8.root"
       "/store/hidata/HIRun2023A/HIEphemeralZeroBias1/RAW/v1/000/374/521/00000/ebc86930-cd3e-4c00-9219-ab6cd28f168e.root"
       )



echo "[triggerEmulation] ######## SETTINGS ########"
echo "[triggerEmulation] pp trigger menu = $TRIGGERMENU"
echo "[triggerEmulation] .... global tag   = $GLOBALTAG"
echo "[triggerEmulation] .... L1 menu      = $L1MENU"
echo "[triggerEmulation] .... L1 emulator  = $L1EMULATOR"
echo "[triggerEmulation] .... era          = $ERA"
echo "[triggerEmulation] ##########################"

#LIMIT=100
#LIMIT=1 # for testing
LIMIT=${#files[@]}   # loop through length of files array
echo "number of files to emulate : $LIMIT"

rm -rf macroLogs
rm -rf myGets
rm -rf openHLTfiles
rm -rf logs

mkdir macroLogs
mkdir myGets
mkdir openHLTfiles
mkdir logs

i=0

#for((i=1; i <= LIMIT; i++)) ; do
for value in "${files[@]}"; do

    let "i=i+1"
    FILEPATH_i="$value"

    echo "[triggerEmulation] filename is $FILEPATH_i"

    FILESUFFIX_i="${FILEPATH_i:95}"
    OUTPUT_i="openHLT_"
    OUTPUT_i+="$FILESUFFIX_i"

    echo "[triggerEmulation] output name = $OUTPUT_i"

    


    echo "[triggerEmulation] Setting up configuration for file $i..."

    

    echo "hltGetConfiguration $TRIGGERMENU --globaltag $GLOBALTAG --l1Xml $L1MENU --l1-emulator $L1EMULATOR --era $ERA --input $FILEPATH_i --process MyHLT --full --mc --unprescale --no-output --max-events -1" &> myGets/myGet_$i.txt

    ./setup_hltConfig.sh . myGets/myGet_$i.txt

    #cmsRun test_pset.py 2>&1 | tee logs/log_$i.txt
    cmsRun test_pset.py
    
    echo '
import FWCore.ParameterSet.Config as cms
process = cms.Process("HLTANA")

# Input source
process.maxEvents = cms.untracked.PSet(input = cms.untracked.int32(-1))
process.source = cms.Source("PoolSource", fileNames = cms.untracked.vstring("file:output_130.root"))

process.load("Configuration.StandardSequences.FrontierConditions_GlobalTag_cff")
from Configuration.AlCa.GlobalTag import GlobalTag
process.GlobalTag = GlobalTag(process.GlobalTag, "140X_mcRun3_2024_realistic_v9", "")

# add HLTBitAnalyzer
process.load("HeavyIonsAnalysis.EventAnalysis.hltanalysis_cfi")
process.hltanalysis.hltResults = cms.InputTag("TriggerResults::MyHLT")
process.hltanalysis.l1tAlgBlkInputTag = cms.InputTag("hltGtStage2Digis::MyHLT")
process.hltanalysis.l1tExtBlkInputTag = cms.InputTag("hltGtStage2Digis::MyHLT")

process.load("HeavyIonsAnalysis.EventAnalysis.hltobject_cfi")
process.hltobject.triggerResults = cms.InputTag("TriggerResults::MyHLT")
process.hltobject.triggerEvent = cms.InputTag("hltTriggerSummaryAOD::MyHLT")

process.hltAnalysis = cms.EndPath(process.hltanalysis + process.hltobject)
process.TFileService = cms.Service("TFileService", fileName=cms.string("openHLT.root"))
' &> Macro.py

    #cmsRun Macro.py 2>&1 | tee macroLogs/macrolog_$i.txt
    cmsRun Macro.py 

    cp openHLT.root openHLTfiles/$OUTPUT_i

    rm ./*.root ./*.py 
  


done



