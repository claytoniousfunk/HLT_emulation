#!/bin/bash

set -euo pipefail

# Check that exactly 2 arguments are provided
if [[ $# -ne 2 ]]; then
    echo "Usage: $0 <start_index> <end_index>"
    exit 1
fi

START_IDX=$1
END_IDX=$2

if ! [[ "$START_IDX" =~ ^[0-9]+$ ]] || ! [[ "$END_IDX" =~ ^[0-9]+$ ]]; then
    echo "Error: start and end indices must be integers."
    exit 1
fi



TRIGGERMENU="/users/cbennett/151X/HLT_jetTriggers_HIon_2025/V7"
#TRIGGERMENU="/users/cbennett/132X/HLT_HION_CsJetTriggerImport/V2"
GLOBALTAG="151X_mcRun3_2025_realistic_HI_v1"
L1MENU="L1Menu_CollisionsHeavyIons2025_v1_0_1.xml"
L1EMULATOR="uGT"
ERA="Run3_pp_on_PbPb_2025"

INPUT_DATASET="/Dijet_pTHatMin15_HydjetEmbedded_Pythia8_TuneCP5_1510pre6/fdamas-DIGIRAWHLT_151X_mcRun3_2025_realistic_HI_v1-cbd44d18142345ebc4de72df33778d6f/USER"
INPUT_INSTANCE="/prod/phys03"

filename_list="fileNames.txt"
if [[ -f "$filename_list" ]]; then
    touch "$filename_list"
fi

echo "retrieving list of files from dataset $INPUT_DATASET"
dasgoclient -query="file dataset=$INPUT_DATASET instance=$INPUT_INSTANCE" &> "$filename_list"

mapfile -t files < "$filename_list"

echo "################  SETTINGS  #######################################"
echo ".... trigger menu = $TRIGGERMENU"
echo ".... global tag   = $GLOBALTAG"
echo ".... L1 menu      = $L1MENU"
echo ".... L1 emulator  = $L1EMULATOR"
echo ".... era          = $ERA"
echo ".... Dataset      = $INPUT_DATASET $INPUT_INSTANCE"
echo "##################################################################"

#LIMIT=100
#LIMIT=1 # for testing
LIMIT=${#files[@]}   # loop through length of files array
echo "number of files to emulate : $LIMIT"


read -p "Clear log directories? (y/n): " answer
# Normalize input to lowercase
answer=${answer,,}
if [[ "$answer" == "y" || "$answer" == "yes" ]]; then
    rm -rf macroLogs myGets logs
    mkdir macroLogs myGets logs
    echo "Directories cleared."
else
    echo "Aborted."
fi

if [[ ! -d "openHLTfiles" ]]; then
    mkdir openHLTfiles
    echo "openHLTfiles directory created."
else
    echo "openHLTfiles already exists."
fi

# Validate indices
NUM_FILES=${#files[@]}
if (( START_IDX < 0 || END_IDX >= NUM_FILES || START_IDX > END_IDX )); then
    echo "Error: indices out of range (0 - $((NUM_FILES-1)))."
    exit 1
fi

i=0

#for((i=1; i <= LIMIT; i++)) ; do
#for value in "${files[@]}"; do
for ((i=START_IDX; i<=END_IDX; i++)); do

    FILEPATH_i="${files[i]}"

    #let "i=i+1"
    #FILEPATH_i="$value"

    echo "[triggerEmulation] filename is $FILEPATH_i"

    FILESUFFIX_i="$i.root"
    OUTPUT_i="openHLT_"
    OUTPUT_i+="$FILESUFFIX_i"

    echo "[triggerEmulation] output name = $OUTPUT_i"
    
    echo "[triggerEmulation] Setting up configuration for file $i..."
    
    echo "hltGetConfiguration $TRIGGERMENU --globaltag $GLOBALTAG --l1Xml $L1MENU --l1-emulator $L1EMULATOR --era $ERA --input $FILEPATH_i --process MyHLT --full --mc --unprescale --no-output --max-events -1" &> myGets/myGet_$i.txt

    ../setup_hltConfig/setup_hltConfig.sh . myGets/myGet_$i.txt

    cmsRun test_pset.py 2>&1 | tee logs/log_$i.txt
    #cmsRun test_pset.py
    
    echo '
import FWCore.ParameterSet.Config as cms
process = cms.Process("HLTANA")

# Input source
process.maxEvents = cms.untracked.PSet(input = cms.untracked.int32(-1))
process.source = cms.Source("PoolSource", fileNames = cms.untracked.vstring("file:output_130.root"))

process.load("Configuration.StandardSequences.FrontierConditions_GlobalTag_cff")
from Configuration.AlCa.GlobalTag import GlobalTag
process.GlobalTag = GlobalTag(process.GlobalTag, "151X_mcRun3_2025_realistic_HI_v1", "")

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
    #cmsRun Macro.py

    cp openHLT.root openHLTfiles/$OUTPUT_i

    rm ./*.root ./*.py 
    

done



