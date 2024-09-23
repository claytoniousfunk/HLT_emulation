#!/bin/bash

TRIGGERMENU="/users/cbennett/140X/HLT_ppRef_140X/V13"
GLOBALTAG="140X_dataRun3_v3"
L1MENU="L1Menu_CollisionsPPRef2024_v0_0_1.xml"
L1EMULATOR="uGT"
ERA="Run3"


files=("/store/hidata/HIRun2023A/HIEphemeralZeroBias1/RAW/v1/000/374/284/00000/9a5f4a90-1a07-48c3-8f19-1ae8d9ca7b91.root"
       "/store/hidata/HIRun2023A/HIEphemeralZeroBias1/RAW/v1/000/374/288/00000/14a14c08-ae2e-4266-87b1-105b27aaf6cd.root"
       "/store/hidata/HIRun2023A/HIEphemeralZeroBias1/RAW/v1/000/374/288/00000/15685588-a09c-48ab-b4a8-0f4e76a6881c.root"
       "/store/hidata/HIRun2023A/HIEphemeralZeroBias1/RAW/v1/000/374/288/00000/6eb5b25f-a50e-4e3d-a194-59a6aaa609c8.root"
       "/store/hidata/HIRun2023A/HIEphemeralZeroBias1/RAW/v1/000/374/288/00000/c57be2c6-acce-4d75-b99b-5e6e2c7259e2.root"
       "/store/hidata/HIRun2023A/HIEphemeralZeroBias1/RAW/v1/000/374/289/00000/0f0c088d-5c08-4268-98a6-6b9e3ef43ffa.root"
       "/store/hidata/HIRun2023A/HIEphemeralZeroBias1/RAW/v1/000/374/289/00000/5624fdef-9f78-4582-b92e-f1b5102b6550.root"
       "/store/hidata/HIRun2023A/HIEphemeralZeroBias1/RAW/v1/000/374/289/00000/6911a07d-389d-4eaa-a4ab-a0e2315506db.root"
       "/store/hidata/HIRun2023A/HIEphemeralZeroBias1/RAW/v1/000/374/289/00000/976a9218-39e7-4653-a2cf-f693f5f6aa3e.root"
       "/store/hidata/HIRun2023A/HIEphemeralZeroBias1/RAW/v1/000/374/289/00000/adfe50d3-b3a0-4fd3-ac0c-1c51f80deeca.root"
       "/store/hidata/HIRun2023A/HIEphemeralZeroBias1/RAW/v1/000/374/289/00000/d7e41c11-7e32-4b35-94c5-75daf8e01023.root"
       "/store/hidata/HIRun2023A/HIEphemeralZeroBias1/RAW/v1/000/374/306/00000/c0c86211-0b0d-4c0b-8678-8b806d2bbcdc.root"
       "/store/hidata/HIRun2023A/HIEphemeralZeroBias1/RAW/v1/000/374/319/00000/bc723d17-2825-4b0e-b56f-cf82ed48727b.root"
       "/store/hidata/HIRun2023A/HIEphemeralZeroBias1/RAW/v1/000/374/521/00000/14c64951-948d-4ab7-a360-a9a4fa3734f6.root"
       "/store/hidata/HIRun2023A/HIEphemeralZeroBias1/RAW/v1/000/374/521/00000/156dc70d-dd63-436e-973e-4fcd25c9522e.root"
       "/store/hidata/HIRun2023A/HIEphemeralZeroBias1/RAW/v1/000/374/521/00000/1a75a3e1-cc4b-4bbc-aa55-21852ee37253.root"
       "/store/hidata/HIRun2023A/HIEphemeralZeroBias1/RAW/v1/000/374/521/00000/1c6f8c83-9a1a-4682-bee2-de049d721cd0.root"
       "/store/hidata/HIRun2023A/HIEphemeralZeroBias1/RAW/v1/000/374/521/00000/261cc40e-cc14-40ea-93d4-92218b53c080.root"
       "/store/hidata/HIRun2023A/HIEphemeralZeroBias1/RAW/v1/000/374/521/00000/5a47d4d0-492e-49a8-8f54-0e5d53ffe025.root"
       "/store/hidata/HIRun2023A/HIEphemeralZeroBias1/RAW/v1/000/374/521/00000/5c2af1cf-9392-4e04-9439-6a87c0966253.root"
       "/store/hidata/HIRun2023A/HIEphemeralZeroBias1/RAW/v1/000/374/521/00000/831910a1-88c9-4943-8b9c-c1c245f0517a.root"
       "/store/hidata/HIRun2023A/HIEphemeralZeroBias1/RAW/v1/000/374/521/00000/857a41f0-25ec-4f3e-8cea-cd2949e1ba78.root"
       "/store/hidata/HIRun2023A/HIEphemeralZeroBias1/RAW/v1/000/374/521/00000/9ae41adb-6321-4db2-af71-df73fb55c852.root"
       "/store/hidata/HIRun2023A/HIEphemeralZeroBias1/RAW/v1/000/374/521/00000/9bcc9429-5570-473c-a76d-0a76b5ed1cfd.root"
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
       "/store/hidata/HIRun2023A/HIEphemeralZeroBias1/RAW/v1/000/374/588/00000/24bade7f-d9f9-44a3-b876-8afb5678eb5c.root"
       "/store/hidata/HIRun2023A/HIEphemeralZeroBias1/RAW/v1/000/374/588/00000/264b35ba-ce89-443d-8278-7a64db21aa5c.root"
       "/store/hidata/HIRun2023A/HIEphemeralZeroBias1/RAW/v1/000/374/588/00000/2def1455-b4fa-4710-a6a4-b240bf8fdf24.root"
       "/store/hidata/HIRun2023A/HIEphemeralZeroBias1/RAW/v1/000/374/588/00000/427d73e2-e4a1-4b83-a8b6-c2515f7e4a22.root"
       "/store/hidata/HIRun2023A/HIEphemeralZeroBias1/RAW/v1/000/374/588/00000/47f0a4b2-aa06-4ba8-b0b4-0110fa9ac8cb.root"
       "/store/hidata/HIRun2023A/HIEphemeralZeroBias1/RAW/v1/000/374/588/00000/55aa2efc-de7e-462e-9f30-e6c69119ec3e.root"
       "/store/hidata/HIRun2023A/HIEphemeralZeroBias1/RAW/v1/000/374/588/00000/5897f747-37a4-42e5-b91f-27f2094a20cd.root"
       "/store/hidata/HIRun2023A/HIEphemeralZeroBias1/RAW/v1/000/374/588/00000/601fdbf0-1544-419e-976d-963a0722085d.root"
       "/store/hidata/HIRun2023A/HIEphemeralZeroBias1/RAW/v1/000/374/588/00000/6c2f477c-4a88-483f-83bf-962aa77d4c43.root"
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

    echo "[triggerEmulation] Setting up configuration for file $i..."
    echo "[triggerEmulation] filename is $FILEPATH_i"

    echo "hltGetConfiguration $TRIGGERMENU --globaltag $GLOBALTAG --l1Xml $L1MENU --l1-emulator $L1EMULATOR --era $ERA --input $FILEPATH_i --process MyHLT --full --mc --unprescale --no-output --max-events -1" &> myGets/myGet_$i.txt

    ./setup_hltConfig.sh . myGets/myGet_$i.txt

    cmsRun test_pset.py 2>&1 | tee logs/log_$i.txt
    
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

    cmsRun Macro.py 2>&1 | tee macroLogs/macrolog_$i.txt

    cp openHLT.root openHLTfiles/openHLT_$i.root

    rm ./*.root ./*.py 
  


done



