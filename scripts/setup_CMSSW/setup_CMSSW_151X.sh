#!/bin/bash
shopt -s expand_aliases

export SCRAM_ARCH=el8_amd64_gcc12 # ensure you use the right arch
CMSSWV="${1:-CMSSW_15_1_0_pre6}" 
/cvmfs/cms.cern.ch/common/scramv1 project CMSSW $CMSSWV # cmsrel $CMSSWV
cd $CMSSWV/src
eval `/cvmfs/cms.cern.ch/common/scram runtime -sh` # cmsenv

git cms-init

# For HLT analyzers
git cms-addpkg HLTrigger/Configuration
git cms-addpkg L1Trigger/L1TGlobal
mkdir -p L1Trigger/L1TGlobal/data/Luminosity/startup/ && cd L1Trigger/L1TGlobal/data/Luminosity/startup/
#git checkout L1Trigger/L1TGlobal/data

wget https://raw.githubusercontent.com/claytoniousfunk/HIMenus/refs/heads/main/Menus/L1Menu_CollisionsHeavyIons2025_v1_0_1.xml

cd $CMSSW_BASE/src

#git cms-addpkg HLTrigger/HLTanalyzers

#git cms-merge-topic silviodonato:customizeHLTFor2023

# Build

git clone git@github.com:vince502/HLTBitAna.git HeavyIonsAnalysis/
scram b -j 4

cd HLTrigger/Configuration/test && mkdir workstation && cd workstation

ln -s /afs/cern.ch/work/s/soohwan/public/hltGetFiles
cp /afs/cern.ch/work/s/soohwan/public/HLTBitAna_config_tmpl.py .

cd $CMSSW_BASE/src;
ln -s $CMSSW_BASE/src/HLTrigger/Configuration/test/workstation
