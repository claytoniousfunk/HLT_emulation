#!/bin/bash

TRIGGERMENU="/users/cbennett/140X/HLT_PbPb_140X_integratedMenu/V3"
GLOBALTAG="140X_dataRun3_HLT_v3"
L1MENU="L1Menu_CollisionsHeavyIons2023_v1_1_5.xml"
L1EMULATOR="uGT"
ERA="Run3"


files=("/store/hidata/HIRun2023A/HIEphemeralZeroBias1/RAW/v1/000/374/588/00000/6c2f477c-4a88-483f-83bf-962aa77d4c43.root"
       "/store/hidata/HIRun2023A/HIEphemeralZeroBias1/RAW/v1/000/374/588/00000/7012ba12-e26a-404d-87f5-5fc0a0881fab.root"
       "/store/hidata/HIRun2023A/HIEphemeralZeroBias1/RAW/v1/000/374/588/00000/70171e5c-4100-40af-af79-9b187c74c0cd.root"
       "/store/hidata/HIRun2023A/HIEphemeralZeroBias1/RAW/v1/000/374/588/00000/75f64e25-47ea-4428-9247-c93c1a1dd0b4.root"
       "/store/hidata/HIRun2023A/HIEphemeralZeroBias1/RAW/v1/000/374/588/00000/7e4ca6c6-ed03-4cb7-81e7-8493c31eda1b.root"
       "/store/hidata/HIRun2023A/HIEphemeralZeroBias1/RAW/v1/000/374/588/00000/8655ee43-efe5-4812-b328-e9fc3b3e2fc5.root"
       "/store/hidata/HIRun2023A/HIEphemeralZeroBias1/RAW/v1/000/374/588/00000/8cf19744-3191-4b15-8f65-6f36146eaabc.root"
       "/store/hidata/HIRun2023A/HIEphemeralZeroBias1/RAW/v1/000/374/588/00000/98171886-edf5-41ad-b444-179521ea9e5e.root"
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



