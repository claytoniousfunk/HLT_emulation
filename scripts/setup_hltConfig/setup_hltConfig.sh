#!/bin/bash
shopt -s expand_aliases

SCRAM_ARCH=el8_amd64_gcc11
cd $1
eval `/cvmfs/cms.cern.ch/common/scram runtime -sh`

cd $CMSSW_BASE/src/HLTrigger/Configuration/test/workstation

#wget https://adiflori.web.cern.ch/adiflori/hlt_hion.py
#cp hlt_hion.py test_pset.py
source $2 > test_pset.py
HLTCONFIGFILE="test_pset.py"

sed -i "/add\ specific/,+16d" $HLTCONFIGFILE

echo '
# Define the output
process.output = cms.OutputModule("PoolOutputModule",
    outputCommands = cms.untracked.vstring("drop *", "keep *_TriggerResults_*_*", "keep *_hltTriggerSummaryAOD_*_*", "keep *_hltGtStage2Digis_*_*", "keep *_hltGtStage2ObjectMap_*_*"),
    fileName = cms.untracked.string("output_130.root"),
)
process.output_path = cms.EndPath(process.output)

process.schedule.append( process.output_path )  # enable this line if you want to get an output containing trigger info to be used for further analysis, e.g. "TriggerResults", digis etc
#process.GlobalTag.toGet = cms.VPSet(
#  cms.PSet(record = cms.string("SiPixelQualityFromDbRcd"),
#           tag = cms.string("SiPixelQuality_phase1_2023_v5_mc"),
#           label = cms.untracked.string("forRawToDigi"),
#           connect = cms.string("frontier://FrontierProd/CMS_CONDITIONS")
#           ),
#  cms.PSet(record = cms.string("SiPixelQualityFromDbRcd"),
#           tag = cms.string("SiPixelQuality_phase1_2023_v5_mc"),
#           label = cms.untracked.string(""),
#           connect = cms.string("frontier://FrontierProd/CMS_CONDITIONS")
#           )
#)

#process.siPixelQualityESProducer.siPixelQualityLabel = "forDigitizer"
' >> $HLTCONFIGFILE

#if hasattr(process,"hltESPTrackSelectionTf"):
#	process.hltESPTrackSelectionTf.FileName = cms.FileInPath("RecoTracker/FinalTrackSelectors/data/TrackTfClassifier/MkFit_Run3_12_5_0_pre5.pb")
#if hasattr(process,"hltESPTrackSelectionTfPLess"):
#	process.hltESPTrackSelectionTfPLess.FileName = cms.FileInPath("RecoTracker/FinalTrackSelectors/data/TrackTfClassifier/MkFitPixelLessOnly_Run3_12_5_0_pre5.pb")
#if hasattr(process,"hltESPTrackSelectionTfCKF"):
#	process.hltESPTrackSelectionTfCKF.FileName = cms.FileInPath("RecoTracker/FinalTrackSelectors/data/TrackTfClassifier/CKF_Run3_12_5_0_pre5.pb")
#
#if hasattr(process,"InitialStepMkFitIterationConfigPreSplittingESProducer"):
#        process.InitialStepMkFitIterationConfigPreSplittingESProducer.config = cms.FileInPath("RecoTracker/MkFit/data/mkfit-phase1-initialStep.json")
#        process.InitialStepMkFitIterationConfigPreSplittingESProducer.ComponentName = cms.string("initialStepTrackCandidatesMkFitConfigPreSplitting")
#if hasattr(process,"InitialStepMkFitIterationConfigESProducer"):
#	process.InitialStepMkFitIterationConfigESProducer.config = cms.FileInPath("RecoTracker/MkFit/data/mkfit-phase1-initialStep.json")
#	process.InitialStepMkFitIterationConfigESProducer.ComponentName = cms.string("initialStepTrackCandidatesMkFitConfig")
#if hasattr(process,"HighPtTripletStepMkFitIterationConfigESProducer"):
#	process.HighPtTripletStepMkFitIterationConfigESProducer.ComponentName = cms.string("highPtTripletStepTrackCandidatesMkFitConfig")
#	process.HighPtTripletStepMkFitIterationConfigESProducer.config = cms.FileInPath("RecoTracker/MkFit/data/mkfit-phase1-highPtTripletStep.json")
#if hasattr(process,"DetachedQuadStepMkFitIterationConfigESProducer"):
#	process.DetachedQuadStepMkFitIterationConfigESProducer.ComponentName = cms.string("detachedQuadStepTrackCandidatesMkFitConfig")
#	process.DetachedQuadStepMkFitIterationConfigESProducer.config = cms.FileInPath("RecoTracker/MkFit/data/mkfit-phase1-detachedQuadStep.json")
#if hasattr(process,"DetachedTripletStepMkFitIterationConfigESProducer"):
#	process.DetachedTripletStepMkFitIterationConfigESProducer.ComponentName = cms.string("detachedTripletStepTrackCandidatesMkFitConfig")
#	process.DetachedTripletStepMkFitIterationConfigESProducer.config = cms.FileInPath("RecoTracker/MkFit/data/mkfit-phase1-detachedTripletStep.json")
#
#if hasattr(process,"hltFullIter0MkFitProducerPreSplittingPPOnAAForDmeson"):
#        process.hltFullIter0MkFitProducerPreSplittingPPOnAAForDmeson.config = cms.ESInputTag("","initialStepTrackCandidatesMkFitConfigPreSplitting")
#if hasattr(process,"hltFullIter0MkFitProducerPPRefForDmeson"):
#	process.hltFullIter0MkFitProducerPPRefForDmeson.config = cms.ESInputTag("","initialStepTrackCandidatesMkFitConfig")
#if hasattr(process,"hltFullIter2MkFitProducerPPRefForDmeson"):
#	process.hltFullIter2MkFitProducerPPRefForDmeson.config = cms.ESInputTag("","highPtTripletStepTrackCandidatesMkFitConfig")
#if hasattr(process,"hltFullIter4MkFitProducerPPRef"):
#	process.hltFullIter4MkFitProducerPPRef.config = cms.ESInputTag("","detachedQuadStepTrackCandidatesMkFitConfig")
#if hasattr(process,"hltFullIter5MkFitProducerPPRef"):
#	process.hltFullIter5MkFitProducerPPRef.config = cms.ESInputTag("","detachedTripletStepTrackCandidatesMkFitConfig")
#
isData=${3:-0}
if [ $isData -eq 2022 ]
then
echo '
# use rawDataRepacker and skip zero suppression
from PhysicsTools.PatAlgos.tools.helpers import massSearchReplaceAnyInputTag
massSearchReplaceAnyInputTag(process.SimL1Emulator, cms.InputTag("rawDataCollector","","@skipCurrentProcess"), cms.InputTag("rawDataRepacker","","@skipCurrentProcess"))
' >> $HLTCONFIGFILE
fi

if [ $isData -eq 2018 ]
then
echo '
# adapt the HCAL configuration to run over 2018 data
from HLTrigger.Configuration.customizeHLTforCMSSW import customiseFor2018Input
process = customiseFor2018Input(process)
process.hltHcalDigis.saveQIE10DataNSamples = cms.untracked.vint32(10)
process.hltHcalDigis.saveQIE10DataTags = cms.untracked.vstring("MYDATA")

from PhysicsTools.PatAlgos.tools.helpers import massSearchReplaceAnyInputTag
massSearchReplaceAnyInputTag(process.SimL1Emulator, cms.InputTag("rawDataCollector","","@skipCurrentProcess"), cms.InputTag("rawDataRepacker","","@skipCurrentProcess"))
#massSearchReplaceAnyInputTag(process.HLTFullIterativeTrackingPPOnAAForDmeson, cms.InputTag("highPurity","",""), cms.InputTag("loose","",""))
process.hltHITrackingSiStripRawToClustersFacilityZeroSuppression.DigiProducersList= cms.VInputTag("hltSiStripRawToDigi:ZeroSuppressed")
process.hltHITrackingSiStripRawToClustersFacilityFullZeroSuppression.DigiProducersList = cms.VInputTag("hltSiStripRawToDigi:ZeroSuppressed")
for lbl in ["hltSiStripZeroSuppression", "hltSiStripDigiToZSRaw", "rawDataRepacker", "hltSiStripClusterizerForRawPrime","hltSiStripClusters2ApproxClusters"]:
    delattr(process, lbl)

from HLTrigger.Configuration.common import producers_by_type
#for producer in producers_by_type(process, "PoolDBESSource"):
process.GlobalTag.toGet = cms.VPSet(
  cms.PSet( record = cms.string( "BeamSpotObjectsRcd" ),
    refreshTime = cms.uint64( 2 )
  )
)
' >> $HLTCONFIGFILE
fi
