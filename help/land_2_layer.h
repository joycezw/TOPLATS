      integer ipix,i,inc_frozen,i_2l,i_und,i_moss,ivgtyp
      integer irntyp,idifind,istmst,intstm,istmst_moss
      integer intstm_moss,intstp,istorm,iopthermc,iopgveg
      integer iopthermc_v,iopsmini,ikopt,irestype,ioppet,iopveg
      integer ievcon,ievcon_us,ievcon_moss,ifcoarse,iffroz
      integer istart,istop,ii,iffroz_us,initer,maxnri,newstorm

      real*8 rzsm_test,tzsm_test,rzsm_u_test,tzsm_u_test,thetas_add

      real*8 mul_fac
      real*8 dt,canclos,extinct,f_moss,f_und,PackWater,SurfWater
      real*8 Swq,VaporMassFlux,TPack,TSurf,r_MeltEnergy
      real*8 Outflow,xleact_snow,hact_snow,rn_snow,PackWater_us
      real*8 SurfWater_us,Swq_us,VaporMassFlux_us,TPack_us,TSurf_us
      real*8 r_MeltEnergy_us,Outflow_us,xleact_snow_us,hact_snow_us
      real*8 rn_snow_us,dens,dens_us,albd_us,alb_moss,alb_snow,albd
      real*8 rsd,rld,tcel,vppa,psychr,xlhv,tkel,zww,za,uzw,press
      real*8 pptms,appa,vpsat,tcel_ic,vppa_ic,psychr_ic,xlhv_ic
      real*8 tkel_ic,vpsat_ic,precip_o,precip_u,tkmid,tkact
      real*8 tkmid_us,tkact_us,tskinact_moss,tkact_moss,tkmid_moss
      real*8 tkmidpet,tkmidpet_us,tkmidpet_moss,tsoilold
      real*8 Tdeepstep,tkpet,dshact,rnetpn,gbspen,epetd,evtact
      real*8 bsdew,gact,rnact,xleact,hact,epetd_us
      real*8 dshact_moss,xle_act_moss,rnetd,xled,hd,gd,dshd
      real*8 tkd,tkmidd,rnetw,xlew,hw,gw,dshw,tkw,tkmidw
      real*8 rnact_us,xleact_us,hact_us,gact_us,dshact_us
      real*8 rnetw_us,xlew_us,hw_us,gw_us,dshw_us,tkw_us,tkmidw_us
      real*8 evtact_us,rnetd_us,xled_us,hd_us,gd_us,dshd_us
      real*8 tkd_us,tkmidd_us,bsdew_moss,evtact_moss
      real*8 rnet_pot_moss,xle_p_moss,h_p_moss,g_p_moss,tk_p_moss
      real*8 tkmid_p_moss,tskin_p_moss,eact_moss,rnact_moss,xleact_moss
      real*8 hact_moss,gact_moss,thetar,thetas,psic,bcbeta
      real*8 quartz,rocpsoil,tcbeta,tcbeta_us,bulk_dens
      real*8 a_ice,b_ice,xk0,bcgamm,srespar1,srespar2
      real*8 srespar3,zdeep,zmid,zrzmax,r_moss_depth,thetas_moss
      real*8 srespar1_moss,srespar2_moss,srespar3_moss,eps,emiss_moss
      real*8 zpd_moss,rib_moss,z0m_moss,z0h_moss,epet_moss,xlai
      real*8 xlai_us,emiss,zpd,zpd_us,z0m,z0h,z0h_us,f1par,f3vpd
      real*8 f4temp,f1par_us,f3vpd_us,f4temp_us,rescan,tc,tw,tc_us
      real*8 tw_us,rescan_us,rtact,rtdens,psicri,respla,f1,f2,f3
      real*8 emiss_us,row,cph2o,roa,cp,roi,toleb,roa_ic
      real*8 ravd,rahd,ravd_us,rahd_us,rav_moss,rah_moss,rib
      real*8 RaSnow,rzsm,tzsm,rzsm1,tzsm1,rzsm_u,tzsm_u,rzsm1_u
      real*8 tzsm1_u,rzsm_f,tzsm_f,rzsm1_f,tzsm1_f,r_mossm,r_mossm1
      real*8 r_mossm_f,r_mossm1_f,r_mossm_u,r_mossm1_u,zrz,ztz,r_mossmold
      real*8 smold,rzsmold,tzsmold,rzdthetaudtemp,rzdthetaidt,tzdthetaidt
      real*8 zw,zbar,zmoss,capflx,difrz,diftz,grz,gtz,pnet,cuminf
      real*8 sorp,cc,deltrz,xinact,satxr,xinfxr,runtot
      real*8 sesq,corr,dc,fw,dc_us,fw_us,wcip1
      real*8 par,wsc,dewrun,dsrz,rzrhs,dstz,tzrhs,ff,atanb,xlamda
      real*8 fwcat,fwreg,pr3sat,perrg2,pr2sat,pr2uns,perrg1
      real*8 pr1sat,pr1rzs,pr1tzs,pr1uns,persxr,perixr
      real*8 persac,peruac,perusc
      real*8 zero,one,two,three,four,five,six,tolinf
      real*8 rain,snow,ds_p_moss,thermc1,thermc2,heatcap1,heatcap2
      real*8 heatcapold,thermc,heatcap,thermc_us,heatcap_us
      real*8 thermc_moss,heatcap_moss,tkactd,tkmidactd,tkactd_us
      real*8 tkmidactd_us,tskinactd_moss,tkactd_moss,tkmidactd_moss
      real*8 xinfcp,r_ldn,r_sdn
!C     real*8 dewrz
      real*8 evrz_moss,r_mindiff,tt
      real*8 rnactd_us,xleactd_us,hactd_us,gactd_us,dshactd_us
      real*8 trlup,xleactd_moss,hactd_moss,gactd_moss,dshactd_moss
      real*8 rnactd_moss,r_lup,r_diff,xleactd,rnactd,hactd,gactd
      real*8 dshactd,tdiff,tfin,dumopt,ccc
      real*8 smcond,smcond_us,vegcap,vegcap_us,rzsmst
      real*8 rsoil,ebscap,smtmp,srzrel,psisoi,xksrz,ressoi
      real*8 xkrz,stzrel,xkstz,xktz
      real*8 a_ice_moss,b_ice_moss,bulk_dens_moss,zw0
      data zero,one,two,three,four,five,six/0.d0,1.d0,2.d0,&
             3.d0,4.d0,5.d0,6.d0/
