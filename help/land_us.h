      integer ievcon_us,ipix,iffroz_us,iopthermc,ifcoarse,inc_frozen,i
      integer iopgveg,iopthermc_v,initer,ievcon_moss,i_und,i_moss,i_2l
      integer maxnri

      real*8 rain,snow,thermc1,thermc2,heatcap_moss,heatcap,heatcap1
      real*8 heatcap2,heatcapold,tkactd_us,tkmidactd_us,tskinactd_moss
      real*8 tkactd_moss,tkmidactd_moss,canclos,rnact_us,xleact_us
      real*8 hact_us,gact_us,dshact_us,tkact_us,tkmid_us,rnactd_us
      real*8 rnetw_us,xleactd_us,xlew_us,hactd_us,hw_us,gactd_us,gw_us
      real*8 dshactd_us,dshw_us,tkw_us,tkmidw_us,xlai_us,dc_us,fw_us
      real*8 trlup,xlhv_ic,row,evtact_us,tkmid,zmid,zrzmax,smtmp
      real*8 rzsm,tzsm,smold,rzsmold,tzsmold,thetar,thetas,psic
      real*8 bcbeta,quartz,rocpsoil,cph2o,roa,cp,roi,thermc
      real*8 rzdthetaudtemp,thermc_us,tcbeta_us,xlai,f3,albd_us
      real*8 emiss_us,ravd_us,rahd_us,rescan_us,tcel_ic,vppa_ic
      real*8 roa_ic,psychr_ic,zdeep,Tdeepstep,r_sdn,r_ldn,toleb
      real*8 dt,rld,rnetd_us,xled_us,hd_us,gd_us,dshd_us
      real*8 tkd_us,tkmidd_us,xleactd_moss,bsdew_moss,evtact_moss
      real*8 thermc_moss,tskinact_moss,tkact_moss,tkmid_moss
      real*8 hactd_moss,gactd_moss,dshactd_moss,rav_moss,rah_moss
      real*8 r_moss_depth,alb_moss,rnactd_moss,emiss_moss,eact_moss
      real*8 rnet_pot_moss,xle_p_moss,h_p_moss,g_p_moss,tk_p_moss
      real*8 tkmid_p_moss,tskin_p_moss,zmoss,r_mossm,thetas_moss
      real*8 rnact_moss,xleact_moss,hact_moss,gact_moss,dshact_moss
      real*8 gact,Swq_us,precip_u,za,zpd,z0h,RaSnow
      real*8 alb_snow,appa,vpsat_ic,uzw,PackWater_us,SurfWater_us
      real*8 VaporMassFlux_us,TPack_us,TSurf_us,r_MeltEnergy_us
      real*8 Outflow_us,xleact_snow_us,hact_snow_us,rn_snow_us
      real*8 dens_us,heatcap_us,tkel_ic,eps,ds_p_moss
      real*8 tsnow,told0,told1,told2,hold0,hold1,hold2
      real*8 tcold0,tcold1,tcold2,dum
      real*8 zero,one,two,three,four,five,six
      data zero,one,two,three,four,five,six/0.d0,1.d0,2.d0,&
             3.d0,4.d0,5.d0,6.d0/
