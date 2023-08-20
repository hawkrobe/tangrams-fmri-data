

#---------------------------------
# New invocation of recon-all Thu Aug 10 12:09:15 UTC 2023 

 mri_convert /scratch/fmriprep_23_1_wf/single_subject_s002_wf/anat_preproc_wf/anat_template_wf/denoise/mapflow/_denoise0/sub-s002_T1w_noise_corrected.nii.gz /project/data/bids/derivatives/sourcedata/freesurfer/sub-s002/mri/orig/001.mgz 

#--------------------------------------------
#@# MotionCor Thu Aug 10 12:09:25 UTC 2023

 cp /project/data/bids/derivatives/sourcedata/freesurfer/sub-s002/mri/orig/001.mgz /project/data/bids/derivatives/sourcedata/freesurfer/sub-s002/mri/rawavg.mgz 


 mri_info /project/data/bids/derivatives/sourcedata/freesurfer/sub-s002/mri/rawavg.mgz 


 mri_convert /project/data/bids/derivatives/sourcedata/freesurfer/sub-s002/mri/rawavg.mgz /project/data/bids/derivatives/sourcedata/freesurfer/sub-s002/mri/orig.mgz --conform 


 mri_add_xform_to_header -c /project/data/bids/derivatives/sourcedata/freesurfer/sub-s002/mri/transforms/talairach.xfm /project/data/bids/derivatives/sourcedata/freesurfer/sub-s002/mri/orig.mgz /project/data/bids/derivatives/sourcedata/freesurfer/sub-s002/mri/orig.mgz 


 mri_info /project/data/bids/derivatives/sourcedata/freesurfer/sub-s002/mri/orig.mgz 

#--------------------------------------------
#@# Talairach Thu Aug 10 12:09:39 UTC 2023

 mri_nu_correct.mni --no-rescale --i orig.mgz --o orig_nu.mgz --ants-n4 --n 1 --proto-iters 1000 --distance 50 


 talairach_avi --i orig_nu.mgz --xfm transforms/talairach.auto.xfm 

talairach_avi log file is transforms/talairach_avi.log...

 cp transforms/talairach.auto.xfm transforms/talairach.xfm 

lta_convert --src orig.mgz --trg /opt/freesurfer/average/mni305.cor.mgz --inxfm transforms/talairach.xfm --outlta transforms/talairach.xfm.lta --subject fsaverage --ltavox2vox
#--------------------------------------------
#@# Talairach Failure Detection Thu Aug 10 12:14:28 UTC 2023

 talairach_afd -T 0.005 -xfm transforms/talairach.xfm 


 awk -f /opt/freesurfer/bin/extract_talairach_avi_QA.awk /project/data/bids/derivatives/sourcedata/freesurfer/sub-s002/mri/transforms/talairach_avi.log 


 tal_QC_AZS /project/data/bids/derivatives/sourcedata/freesurfer/sub-s002/mri/transforms/talairach_avi.log 

#--------------------------------------------
#@# Nu Intensity Correction Thu Aug 10 12:14:28 UTC 2023

 mri_nu_correct.mni --i orig.mgz --o nu.mgz --uchar transforms/talairach.xfm --n 2 --ants-n4 


 mri_add_xform_to_header -c /project/data/bids/derivatives/sourcedata/freesurfer/sub-s002/mri/transforms/talairach.xfm nu.mgz nu.mgz 

#--------------------------------------------
#@# Intensity Normalization Thu Aug 10 12:19:12 UTC 2023

 mri_normalize -g 1 -seed 1234 -mprage nu.mgz T1.mgz 



#---------------------------------
# New invocation of recon-all Thu Aug 10 12:56:33 UTC 2023 
#-------------------------------------
#@# EM Registration Thu Aug 10 12:56:34 UTC 2023

 mri_em_register -uns 3 -mask brainmask.mgz nu.mgz /opt/freesurfer/average/RB_all_2020-01-02.gca transforms/talairach.lta 



#---------------------------------
# New invocation of recon-all Thu Aug 10 13:07:23 UTC 2023 
#--------------------------------------
#@# CA Normalize Thu Aug 10 13:07:24 UTC 2023

 mri_ca_normalize -c ctrl_pts.mgz -mask brainmask.mgz nu.mgz /opt/freesurfer/average/RB_all_2020-01-02.gca transforms/talairach.lta norm.mgz 

#--------------------------------------
#@# CA Reg Thu Aug 10 13:08:41 UTC 2023

 mri_ca_register -nobigventricles -T transforms/talairach.lta -align-after -mask brainmask.mgz norm.mgz /opt/freesurfer/average/RB_all_2020-01-02.gca transforms/talairach.m3z 

#--------------------------------------
#@# SubCort Seg Thu Aug 10 14:36:14 UTC 2023

 mri_ca_label -relabel_unlikely 9 .3 -prior 0.5 -align norm.mgz transforms/talairach.m3z /opt/freesurfer/average/RB_all_2020-01-02.gca aseg.auto_noCCseg.mgz 

#--------------------------------------
#@# CC Seg Thu Aug 10 15:23:45 UTC 2023

 mri_cc -aseg aseg.auto_noCCseg.mgz -o aseg.auto.mgz -lta /project/data/bids/derivatives/sourcedata/freesurfer/sub-s002/mri/transforms/cc_up.lta sub-s002 

#--------------------------------------
#@# Merge ASeg Thu Aug 10 15:24:26 UTC 2023

 cp aseg.auto.mgz aseg.presurf.mgz 

#--------------------------------------------
#@# Intensity Normalization2 Thu Aug 10 15:24:26 UTC 2023

 mri_normalize -seed 1234 -mprage -aseg aseg.presurf.mgz -mask brainmask.mgz norm.mgz brain.mgz 

#--------------------------------------------
#@# Mask BFS Thu Aug 10 15:27:17 UTC 2023

 mri_mask -T 5 brain.mgz brainmask.mgz brain.finalsurfs.mgz 

#--------------------------------------------
#@# WM Segmentation Thu Aug 10 15:27:19 UTC 2023

 AntsDenoiseImageFs -i brain.mgz -o antsdn.brain.mgz 


 mri_segment -wsizemm 13 -mprage antsdn.brain.mgz wm.seg.mgz 


 mri_edit_wm_with_aseg -keep-in wm.seg.mgz brain.mgz aseg.presurf.mgz wm.asegedit.mgz 


 mri_pretess wm.asegedit.mgz wm norm.mgz wm.mgz 

#--------------------------------------------
#@# Fill Thu Aug 10 15:30:24 UTC 2023

 mri_fill -a ../scripts/ponscc.cut.log -xform transforms/talairach.lta -segmentation aseg.presurf.mgz -ctab /opt/freesurfer/SubCorticalMassLUT.txt wm.mgz filled.mgz 

 cp filled.mgz filled.auto.mgz


#---------------------------------
# New invocation of recon-all Thu Aug 10 16:50:26 UTC 2023 
#@# white curv lh Thu Aug 10 16:50:27 UTC 2023
cd /project/data/bids/derivatives/sourcedata/freesurfer/sub-s002/mri
mris_place_surface --curv-map ../surf/lh.white 2 10 ../surf/lh.curv
   Update not needed
#@# white area lh Thu Aug 10 16:50:27 UTC 2023
cd /project/data/bids/derivatives/sourcedata/freesurfer/sub-s002/mri
mris_place_surface --area-map ../surf/lh.white ../surf/lh.area
   Update not needed
#@# pial curv lh Thu Aug 10 16:50:27 UTC 2023
cd /project/data/bids/derivatives/sourcedata/freesurfer/sub-s002/mri
mris_place_surface --curv-map ../surf/lh.pial 2 10 ../surf/lh.curv.pial
   Update not needed
#@# pial area lh Thu Aug 10 16:50:27 UTC 2023
cd /project/data/bids/derivatives/sourcedata/freesurfer/sub-s002/mri
mris_place_surface --area-map ../surf/lh.pial ../surf/lh.area.pial
   Update not needed
#@# thickness lh Thu Aug 10 16:50:27 UTC 2023
cd /project/data/bids/derivatives/sourcedata/freesurfer/sub-s002/mri
mris_place_surface --thickness ../surf/lh.white ../surf/lh.pial 20 5 ../surf/lh.thickness
   Update not needed
#@# area and vertex vol lh Thu Aug 10 16:50:27 UTC 2023
cd /project/data/bids/derivatives/sourcedata/freesurfer/sub-s002/mri
mris_place_surface --thickness ../surf/lh.white ../surf/lh.pial 20 5 ../surf/lh.thickness
   Update not needed
#@# white curv rh Thu Aug 10 16:50:27 UTC 2023
cd /project/data/bids/derivatives/sourcedata/freesurfer/sub-s002/mri
mris_place_surface --curv-map ../surf/rh.white 2 10 ../surf/rh.curv
   Update not needed
#@# white area rh Thu Aug 10 16:50:27 UTC 2023
cd /project/data/bids/derivatives/sourcedata/freesurfer/sub-s002/mri
mris_place_surface --area-map ../surf/rh.white ../surf/rh.area
   Update not needed
#@# pial curv rh Thu Aug 10 16:50:27 UTC 2023
cd /project/data/bids/derivatives/sourcedata/freesurfer/sub-s002/mri
mris_place_surface --curv-map ../surf/rh.pial 2 10 ../surf/rh.curv.pial
   Update not needed
#@# pial area rh Thu Aug 10 16:50:27 UTC 2023
cd /project/data/bids/derivatives/sourcedata/freesurfer/sub-s002/mri
mris_place_surface --area-map ../surf/rh.pial ../surf/rh.area.pial
   Update not needed
#@# thickness rh Thu Aug 10 16:50:27 UTC 2023
cd /project/data/bids/derivatives/sourcedata/freesurfer/sub-s002/mri
mris_place_surface --thickness ../surf/rh.white ../surf/rh.pial 20 5 ../surf/rh.thickness
   Update not needed
#@# area and vertex vol rh Thu Aug 10 16:50:27 UTC 2023
cd /project/data/bids/derivatives/sourcedata/freesurfer/sub-s002/mri
mris_place_surface --thickness ../surf/rh.white ../surf/rh.pial 20 5 ../surf/rh.thickness
   Update not needed
#--------------------------------------------
#@# Cortical ribbon mask Thu Aug 10 16:50:27 UTC 2023

 mris_volmask --aseg_name aseg.presurf --label_left_white 2 --label_left_ribbon 3 --label_right_white 41 --label_right_ribbon 42 --save_ribbon sub-s002 



#---------------------------------
# New invocation of recon-all Thu Aug 10 17:17:02 UTC 2023 
#--------------------------------------------
#@# WhiteSurfs lh Thu Aug 10 17:17:03 UTC 2023
cd /project/data/bids/derivatives/sourcedata/freesurfer/sub-s002/mri
mris_place_surface --adgws-in ../surf/autodet.gw.stats.lh.dat --seg aseg.presurf.mgz --threads 8 --wm wm.mgz --invol brain.finalsurfs.mgz --lh --i ../surf/lh.white.preaparc --o ../surf/lh.white --white --nsmooth 0 --rip-label ../label/lh.cortex.label --rip-bg --rip-surf ../surf/lh.white.preaparc --aparc ../label/lh.aparc.annot
   Update not needed
#--------------------------------------------
#@# WhiteSurfs rh Thu Aug 10 17:17:03 UTC 2023
cd /project/data/bids/derivatives/sourcedata/freesurfer/sub-s002/mri
mris_place_surface --adgws-in ../surf/autodet.gw.stats.rh.dat --seg aseg.presurf.mgz --threads 8 --wm wm.mgz --invol brain.finalsurfs.mgz --rh --i ../surf/rh.white.preaparc --o ../surf/rh.white --white --nsmooth 0 --rip-label ../label/rh.cortex.label --rip-bg --rip-surf ../surf/rh.white.preaparc --aparc ../label/rh.aparc.annot
   Update not needed
#@# white curv lh Thu Aug 10 17:17:03 UTC 2023
cd /project/data/bids/derivatives/sourcedata/freesurfer/sub-s002/mri
mris_place_surface --curv-map ../surf/lh.white 2 10 ../surf/lh.curv
   Update not needed
#@# white area lh Thu Aug 10 17:17:03 UTC 2023
cd /project/data/bids/derivatives/sourcedata/freesurfer/sub-s002/mri
mris_place_surface --area-map ../surf/lh.white ../surf/lh.area
   Update not needed
#@# pial curv lh Thu Aug 10 17:17:03 UTC 2023
cd /project/data/bids/derivatives/sourcedata/freesurfer/sub-s002/mri
mris_place_surface --curv-map ../surf/lh.pial 2 10 ../surf/lh.curv.pial
   Update not needed
#@# pial area lh Thu Aug 10 17:17:03 UTC 2023
cd /project/data/bids/derivatives/sourcedata/freesurfer/sub-s002/mri
mris_place_surface --area-map ../surf/lh.pial ../surf/lh.area.pial
   Update not needed
#@# thickness lh Thu Aug 10 17:17:03 UTC 2023
cd /project/data/bids/derivatives/sourcedata/freesurfer/sub-s002/mri
mris_place_surface --thickness ../surf/lh.white ../surf/lh.pial 20 5 ../surf/lh.thickness
   Update not needed
#@# area and vertex vol lh Thu Aug 10 17:17:03 UTC 2023
cd /project/data/bids/derivatives/sourcedata/freesurfer/sub-s002/mri
mris_place_surface --thickness ../surf/lh.white ../surf/lh.pial 20 5 ../surf/lh.thickness
   Update not needed
#@# white curv rh Thu Aug 10 17:17:03 UTC 2023
cd /project/data/bids/derivatives/sourcedata/freesurfer/sub-s002/mri
mris_place_surface --curv-map ../surf/rh.white 2 10 ../surf/rh.curv
   Update not needed
#@# white area rh Thu Aug 10 17:17:03 UTC 2023
cd /project/data/bids/derivatives/sourcedata/freesurfer/sub-s002/mri
mris_place_surface --area-map ../surf/rh.white ../surf/rh.area
   Update not needed
#@# pial curv rh Thu Aug 10 17:17:03 UTC 2023
cd /project/data/bids/derivatives/sourcedata/freesurfer/sub-s002/mri
mris_place_surface --curv-map ../surf/rh.pial 2 10 ../surf/rh.curv.pial
   Update not needed
#@# pial area rh Thu Aug 10 17:17:03 UTC 2023
cd /project/data/bids/derivatives/sourcedata/freesurfer/sub-s002/mri
mris_place_surface --area-map ../surf/rh.pial ../surf/rh.area.pial
   Update not needed
#@# thickness rh Thu Aug 10 17:17:03 UTC 2023
cd /project/data/bids/derivatives/sourcedata/freesurfer/sub-s002/mri
mris_place_surface --thickness ../surf/rh.white ../surf/rh.pial 20 5 ../surf/rh.thickness
   Update not needed
#@# area and vertex vol rh Thu Aug 10 17:17:03 UTC 2023
cd /project/data/bids/derivatives/sourcedata/freesurfer/sub-s002/mri
mris_place_surface --thickness ../surf/rh.white ../surf/rh.pial 20 5 ../surf/rh.thickness
   Update not needed

#-----------------------------------------
#@# Curvature Stats lh Thu Aug 10 17:17:03 UTC 2023

 mris_curvature_stats -m --writeCurvatureFiles -G -o ../stats/lh.curv.stats -F smoothwm sub-s002 lh curv sulc 


#-----------------------------------------
#@# Curvature Stats rh Thu Aug 10 17:17:07 UTC 2023

 mris_curvature_stats -m --writeCurvatureFiles -G -o ../stats/rh.curv.stats -F smoothwm sub-s002 rh curv sulc 

#-----------------------------------------
#@# Relabel Hypointensities Thu Aug 10 17:17:12 UTC 2023

 mri_relabel_hypointensities aseg.presurf.mgz ../surf aseg.presurf.hypos.mgz 

#-----------------------------------------
#@# APas-to-ASeg Thu Aug 10 17:17:38 UTC 2023

 mri_surf2volseg --o aseg.mgz --i aseg.presurf.hypos.mgz --fix-presurf-with-ribbon /project/data/bids/derivatives/sourcedata/freesurfer/sub-s002/mri/ribbon.mgz --threads 8 --lh-cortex-mask /project/data/bids/derivatives/sourcedata/freesurfer/sub-s002/label/lh.cortex.label --lh-white /project/data/bids/derivatives/sourcedata/freesurfer/sub-s002/surf/lh.white --lh-pial /project/data/bids/derivatives/sourcedata/freesurfer/sub-s002/surf/lh.pial --rh-cortex-mask /project/data/bids/derivatives/sourcedata/freesurfer/sub-s002/label/rh.cortex.label --rh-white /project/data/bids/derivatives/sourcedata/freesurfer/sub-s002/surf/rh.white --rh-pial /project/data/bids/derivatives/sourcedata/freesurfer/sub-s002/surf/rh.pial 


 mri_brainvol_stats sub-s002 

#-----------------------------------------
#@# AParc-to-ASeg aparc Thu Aug 10 17:17:54 UTC 2023

 mri_surf2volseg --o aparc+aseg.mgz --label-cortex --i aseg.mgz --threads 8 --lh-annot /project/data/bids/derivatives/sourcedata/freesurfer/sub-s002/label/lh.aparc.annot 1000 --lh-cortex-mask /project/data/bids/derivatives/sourcedata/freesurfer/sub-s002/label/lh.cortex.label --lh-white /project/data/bids/derivatives/sourcedata/freesurfer/sub-s002/surf/lh.white --lh-pial /project/data/bids/derivatives/sourcedata/freesurfer/sub-s002/surf/lh.pial --rh-annot /project/data/bids/derivatives/sourcedata/freesurfer/sub-s002/label/rh.aparc.annot 2000 --rh-cortex-mask /project/data/bids/derivatives/sourcedata/freesurfer/sub-s002/label/rh.cortex.label --rh-white /project/data/bids/derivatives/sourcedata/freesurfer/sub-s002/surf/rh.white --rh-pial /project/data/bids/derivatives/sourcedata/freesurfer/sub-s002/surf/rh.pial 

#-----------------------------------------
#@# AParc-to-ASeg aparc.a2009s Thu Aug 10 17:20:10 UTC 2023

 mri_surf2volseg --o aparc.a2009s+aseg.mgz --label-cortex --i aseg.mgz --threads 8 --lh-annot /project/data/bids/derivatives/sourcedata/freesurfer/sub-s002/label/lh.aparc.a2009s.annot 11100 --lh-cortex-mask /project/data/bids/derivatives/sourcedata/freesurfer/sub-s002/label/lh.cortex.label --lh-white /project/data/bids/derivatives/sourcedata/freesurfer/sub-s002/surf/lh.white --lh-pial /project/data/bids/derivatives/sourcedata/freesurfer/sub-s002/surf/lh.pial --rh-annot /project/data/bids/derivatives/sourcedata/freesurfer/sub-s002/label/rh.aparc.a2009s.annot 12100 --rh-cortex-mask /project/data/bids/derivatives/sourcedata/freesurfer/sub-s002/label/rh.cortex.label --rh-white /project/data/bids/derivatives/sourcedata/freesurfer/sub-s002/surf/rh.white --rh-pial /project/data/bids/derivatives/sourcedata/freesurfer/sub-s002/surf/rh.pial 

#-----------------------------------------
#@# AParc-to-ASeg aparc.DKTatlas Thu Aug 10 17:22:14 UTC 2023

 mri_surf2volseg --o aparc.DKTatlas+aseg.mgz --label-cortex --i aseg.mgz --threads 8 --lh-annot /project/data/bids/derivatives/sourcedata/freesurfer/sub-s002/label/lh.aparc.DKTatlas.annot 1000 --lh-cortex-mask /project/data/bids/derivatives/sourcedata/freesurfer/sub-s002/label/lh.cortex.label --lh-white /project/data/bids/derivatives/sourcedata/freesurfer/sub-s002/surf/lh.white --lh-pial /project/data/bids/derivatives/sourcedata/freesurfer/sub-s002/surf/lh.pial --rh-annot /project/data/bids/derivatives/sourcedata/freesurfer/sub-s002/label/rh.aparc.DKTatlas.annot 2000 --rh-cortex-mask /project/data/bids/derivatives/sourcedata/freesurfer/sub-s002/label/rh.cortex.label --rh-white /project/data/bids/derivatives/sourcedata/freesurfer/sub-s002/surf/rh.white --rh-pial /project/data/bids/derivatives/sourcedata/freesurfer/sub-s002/surf/rh.pial 

#-----------------------------------------
#@# WMParc Thu Aug 10 17:24:47 UTC 2023

 mri_surf2volseg --o wmparc.mgz --label-wm --i aparc+aseg.mgz --threads 8 --lh-annot /project/data/bids/derivatives/sourcedata/freesurfer/sub-s002/label/lh.aparc.annot 3000 --lh-cortex-mask /project/data/bids/derivatives/sourcedata/freesurfer/sub-s002/label/lh.cortex.label --lh-white /project/data/bids/derivatives/sourcedata/freesurfer/sub-s002/surf/lh.white --lh-pial /project/data/bids/derivatives/sourcedata/freesurfer/sub-s002/surf/lh.pial --rh-annot /project/data/bids/derivatives/sourcedata/freesurfer/sub-s002/label/rh.aparc.annot 4000 --rh-cortex-mask /project/data/bids/derivatives/sourcedata/freesurfer/sub-s002/label/rh.cortex.label --rh-white /project/data/bids/derivatives/sourcedata/freesurfer/sub-s002/surf/rh.white --rh-pial /project/data/bids/derivatives/sourcedata/freesurfer/sub-s002/surf/rh.pial 


 mri_segstats --seed 1234 --seg mri/wmparc.mgz --sum stats/wmparc.stats --pv mri/norm.mgz --excludeid 0 --brainmask mri/brainmask.mgz --in mri/norm.mgz --in-intensity-name norm --in-intensity-units MR --subject sub-s002 --surf-wm-vol --ctab /opt/freesurfer/WMParcStatsLUT.txt --etiv 

#--------------------------------------------
#@# ASeg Stats Thu Aug 10 17:28:53 UTC 2023

 mri_segstats --seed 1234 --seg mri/aseg.mgz --sum stats/aseg.stats --pv mri/norm.mgz --empty --brainmask mri/brainmask.mgz --brain-vol-from-seg --excludeid 0 --excl-ctxgmwm --supratent --subcortgray --in mri/norm.mgz --in-intensity-name norm --in-intensity-units MR --etiv --surf-wm-vol --surf-ctx-vol --totalgray --euler --ctab /opt/freesurfer/ASegStatsLUT.txt --subject sub-s002 

