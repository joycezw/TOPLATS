      integer t,u,v,natb,nlcs,npix,v_m,u_m
      integer ilandc(MAX_PIX),i_moss(1+MOS_FLG*(MAX_VEG-1))

      real*8 r_mossmpet0(1+MOS_FLG*(MAX_VEG-1))

      integer veg(MAX_PP1,MAX_VST)

      real*8 s_rzsm1(MAX_ATB,MAX_VST,MAX_PP1)
      real*8 s_tzsm1(MAX_ATB,MAX_VST,MAX_PP1)
      real*8 s_zmoss(MAX_ATB,1+MOS_FLG*(MAX_VST-1),1+MOS_FLG*(MAX_PP1-1))
      real*8 s_r_mossm1(MAX_ATB,1+MOS_FLG*(MAX_VST-1),1+MOS_FLG*(MAX_PP1-1))
      real*8 s_r_mossm(MAX_ATB,1+MOS_FLG*(MAX_VST-1),1+MOS_FLG*(MAX_PP1-1))
      real*8 s_rzsm1_u(MAX_ATB,MAX_VST,MAX_PP1)
      real*8 s_tzsm1_u(MAX_ATB,MAX_VST,MAX_PP1)
      real*8 s_rzsm1_f(MAX_ATB,MAX_VST,MAX_PP1)
      real*8 s_tzsm1_f(MAX_ATB,MAX_VST,MAX_PP1)
      real*8 s_r_mossm1_u(MAX_ATB,1+MOS_FLG*(MAX_VST-1),1+MOS_FLG*(MAX_PP1-1))
      real*8 s_r_mossm_u(MAX_ATB,1+MOS_FLG*(MAX_VST-1),1+MOS_FLG*(MAX_PP1-1))
      real*8 s_r_mossm1_f(MAX_ATB,1+MOS_FLG*(MAX_VST-1),1+MOS_FLG*(MAX_PP1-1))
      real*8 s_r_mossm_f(MAX_ATB,1+MOS_FLG*(MAX_VST-1),1+MOS_FLG*(MAX_PP1-1))
      real*8 s_rzdthetaidt(MAX_ATB,MAX_VST,MAX_PP1)
      real*8 s_tzdthetaidt(MAX_ATB,MAX_VST,MAX_PP1)
      real*8 s_cuminf(MAX_ATB,MAX_VST,MAX_PP1)
      real*8 s_sorp(MAX_ATB,MAX_VST,MAX_PP1)
      real*8 s_cc(MAX_ATB,MAX_VST,MAX_PP1)
      real*8 s_zw(MAX_ATB,MAX_VST,MAX_PP1)

      real*8 rzsm1(MAX_PIX)
      real*8 tzsm1(MAX_PIX)
      real*8 zmoss(1+MOS_FLG*(MAX_VST-1))
      real*8 r_mossm1(1+MOS_FLG*(MAX_PIX-1))
      real*8 r_mossm(1+MOS_FLG*(MAX_PIX-1))
      real*8 rzsm1_u(MAX_PIX)
      real*8 tzsm1_u(MAX_PIX)
      real*8 rzsm1_f(MAX_PIX)
      real*8 tzsm1_f(MAX_PIX)
      real*8 r_mossm1_u(1+MOS_FLG*(MAX_PIX-1))
      real*8 r_mossm_u(1+MOS_FLG*(MAX_PIX-1))
      real*8 r_mossm1_f(1+MOS_FLG*(MAX_PIX-1))
      real*8 r_mossm_f(1+MOS_FLG*(MAX_PIX-1))
      real*8 rzdthetaidt(MAX_PIX)
      real*8 tzdthetaidt(MAX_PIX)
      real*8 cuminf(MAX_PIX)
      real*8 sorp(MAX_PIX)
      real*8 cc(MAX_PIX)
      real*8 zw(MAX_PIX)
