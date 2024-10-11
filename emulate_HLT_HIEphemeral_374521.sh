#!/bin/bash

TRIGGERMENU="/users/cbennett/140X/HLT_PbPb_140X_integratedMenu/V3"
GLOBALTAG="140X_dataRun3_HLT_v3"
L1MENU="L1Menu_CollisionsHeavyIons2023_v1_1_5.xml"
L1EMULATOR="uGT"
ERA="Run3"


files=("/store/hidata/HIRun2023A/HIEphemeralZeroBias1/RAW/v1/000/374/521/00000/14c64951-948d-4ab7-a360-a9a4fa3734f6.root"
       "/store/hidata/HIRun2023A/HIEphemeralZeroBias1/RAW/v1/000/374/521/00000/156dc70d-dd63-436e-973e-4fcd25c9522e.root"
       "/store/hidata/HIRun2023A/HIEphemeralZeroBias1/RAW/v1/000/374/521/00000/1a75a3e1-cc4b-4bbc-aa55-21852ee37253.root"
       "/store/hidata/HIRun2023A/HIEphemeralZeroBias1/RAW/v1/000/374/521/00000/1c6f8c83-9a1a-4682-bee2-de049d721cd0.root"
       "/store/hidata/HIRun2023A/HIEphemeralZeroBias1/RAW/v1/000/374/521/00000/261cc40e-cc14-40ea-93d4-92218b53c080.root"
       "/store/hidata/HIRun2023A/HIEphemeralZeroBias1/RAW/v1/000/374/521/00000/5a47d4d0-492e-49a8-8f54-0e5d53ffe025.root"
       "/store/hidata/HIRun2023A/HIEphemeralZeroBias1/RAW/v1/000/374/521/00000/5c2af1cf-9392-4e04-9439-6a87c0966253.root"
       "/store/hidata/HIRun2023A/HIEphemeralZeroBias1/RAW/v1/000/374/521/00000/831910a1-88c9-4943-8b9c-c1c245f0517a.root"
       "/store/hidata/HIRun2023A/HIEphemeralZeroBias1/RAW/v1/000/374/521/00000/857a41f0-25ec-4f3e-8cea-cd2949e1ba78.root"
       "/store/hidata/HIRun2023A/HIEphemeralZeroBias1/RAW/v1/000/374/521/00000/9ae41adb-6321-4db2-af71-df73fb55c852.root"       
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



