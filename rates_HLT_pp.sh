#!/bin/bash

HLT_MENU="/dev/CMSSW_14_0_0/PRef/V107"
L1_MENU_URL="https://raw.githubusercontent.com/mitaylor/HIMenus/main/Menus/L1Menu_CollisionsPPRef2024_v0_0_0.xml"
L1_MENU="L1Menu_CollisionsPPRef2024_v0_0_0.xml"
GLOBALTAG="140X_mcRun3_2024_realistic_v9"

echo "cmsrel ..."

cmsrel CMSSW_14_0_0

cd CMSSW_14_0_0/src

cmsenv

echo "git init ..."

git cms-init

echo "scram ..."

scram build -j 4

echo "git cms-addpkg ..."

git cms-addpkg L1Trigger/L1TGlobal

mkdir -p L1Trigger/L1TGlobal/data/Luminosity/startup

cd L1Trigger/L1TGlobal/data/Luminosity/startup

echo "wget L1 menu ..."

wget $L1_MENU_URL

echo "git clone steamRates ..."

git clone https://github.com/sanuvarghese/SteamRatesEdmWorkflow.git

cd SteamRatesEdmWorkflow/Prod/

echo "creating config ..."

hltGetConfiguration $HLT_MENU --data --process MYHLT --type GRun --prescale HIon --globaltag $GLOBALTAG --max-events -1 --l1Xml $L1_MENU --customise HLTrigger/Configuration/customizeHLTforCMSSW.customiseFor2018Input > hlt.py

edmConfigDump hlt.py > hlt_config.py

echo "file list replace ..."

sed -i 's/list_cff/list_cff_HIon2/' run_steamflow_cfg.py

echo "make output dir ..."

mkdir output

echo "create condor submit ..."

./cmsCondorData.py run_steamflow_cfg.py $CMSSW_BASE/src $CMSSW_BASE/src/L1Trigger/L1TGlobal/data/Luminosity/startup/SteamRatesEdmWorkflow/Prod/output -n 1 -q workday

echo "submitting jobs ..."

./sub_total.jobb



