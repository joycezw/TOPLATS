      integer nrow,ncol,ilandc(MAX_PIX),ipixnum(MAX_ROW,MAX_COL)
      integer nlandc,iopveg,ivgtyp(MAX_VEG),i_und(1+UST_FLG*(MAX_VEG-1))
      integer i_moss(1+MOS_FLG*(MAX_VEG-1))
      integer i_2l,ncatch,iopwc0,npix,icatch(MAX_PIX),iprn(MAX_FIL)

      real*8 xlai(MAX_VEG),xlai_wsc(MAX_VEG),albd(MAX_VEG)
      real*8 albw(MAX_VEG),emiss(MAX_VEG),za(MAX_VEG),zww(MAX_VEG)
      real*8 z0m(MAX_VEG),z0h(MAX_VEG),zpd(MAX_VEG),rsmin(MAX_VEG)
      real*8 rsmax(MAX_VEG),Rpl(MAX_VEG),f3vpdpar(MAX_VEG)
      real*8 f4temppar(MAX_VEG),trefk(MAX_VEG),tcbeta(MAX_VEG)
      real*8 extinct(MAX_VEG),canclos(MAX_VEG)
      real*8 Tslope1(MAX_VEG),Tint1(MAX_VEG),Tslope2(MAX_VEG)
      real*8 Tint2(MAX_VEG),Twslope1(MAX_VEG),Twint1(MAX_VEG)
      real*8 Twslope2(MAX_VEG),Twint2(MAX_VEG),Tsep(MAX_VEG)
      real*8 Twsep(MAX_VEG)
      real*8 f_und(1+UST_FLG*(MAX_VEG-1))
      real*8 xlai_us(1+UST_FLG*(MAX_VEG-1))
      real*8 xlai_wsc_us(1+UST_FLG*(MAX_VEG-1))
      real*8 albd_us(1+UST_FLG*(MAX_VEG-1))
      real*8 albw_us(1+UST_FLG*(MAX_VEG-1))
      real*8 emiss_us(1+UST_FLG*(MAX_VEG-1))
      real*8 z0m_us(1+UST_FLG*(MAX_VEG-1))
      real*8 z0h_us(1+UST_FLG*(MAX_VEG-1))
      real*8 zpd_us(1+UST_FLG*(MAX_VEG-1))
      real*8 rsmin_us(1+UST_FLG*(MAX_VEG-1))
      real*8 rsmax_us(1+UST_FLG*(MAX_VEG-1))
      real*8 Rpl_us(1+UST_FLG*(MAX_VEG-1))
      real*8 f3vpdpar_us(1+UST_FLG*(MAX_VEG-1))
      real*8 f4temppar_us(1+UST_FLG*(MAX_VEG-1))
      real*8 trefk_us(1+UST_FLG*(MAX_VEG-1))
      real*8 tcbeta_us(1+UST_FLG*(MAX_VEG-1))
      real*8 tc_us(1+UST_FLG*(MAX_VEG-1))
      real*8 tw_us(1+UST_FLG*(MAX_VEG-1))
      real*8 f_moss(1+MOS_FLG*(MAX_VEG-1))
      real*8 srespar1_moss(1+MOS_FLG*(MAX_VEG-1))
      real*8 srespar2_moss(1+MOS_FLG*(MAX_VEG-1))
      real*8 srespar3_moss(1+MOS_FLG*(MAX_VEG-1))
      real*8 thetas_moss(1+MOS_FLG*(MAX_VEG-1))
      real*8 tk0moss(1+MOS_FLG*(MAX_VEG-1))
      real*8 tmid0_moss(1+MOS_FLG*(MAX_VEG-1))
      real*8 r_mossmpet0(1+MOS_FLG*(MAX_VEG-1))
      real*8 alb_moss(1+MOS_FLG*(MAX_VEG-1))
      real*8 r_moss_depth(1+MOS_FLG*(MAX_VEG-1))
      real*8 eps(1+MOS_FLG*(MAX_VEG-1))
      real*8 zpd_moss(1+MOS_FLG*(MAX_VEG-1))
      real*8 z0m_moss(1+MOS_FLG*(MAX_VEG-1))
      real*8 z0h_moss(1+MOS_FLG*(MAX_VEG-1))
      real*8 emiss_moss(1+MOS_FLG*(MAX_VEG-1))
      real*8 a_ice_moss(1+MOS_FLG*(MAX_VEG-1))
      real*8 b_ice_moss(1+MOS_FLG*(MAX_VEG-1))
      real*8 bulk_dens_moss(1+MOS_FLG*(MAX_VEG-1)),rtact(MAX_VEG)
      real*8 rtdens(MAX_VEG)
      real*8 rtres(MAX_VEG)
      real*8 psicri(MAX_VEG)
      real*8 respla_us(1+UST_FLG*(MAX_VEG-1))
      real*8 rtact_us(1+UST_FLG*(MAX_VEG-1))
      real*8 rtdens_us(1+UST_FLG*(MAX_VEG-1))
      real*8 rtres_us(1+UST_FLG*(MAX_VEG-1))
      real*8 rescan(MAX_VEG)
      real*8 respla(MAX_VEG)
      real*8 rescan_us(1+UST_FLG*(MAX_VEG-1))
      real*8 wsc(MAX_VEG)
      real*8 wsc_us(1+UST_FLG*(MAX_VEG-1))
      real*8 wcip1(MAX_PIX)
      real*8 psicri_us(1+UST_FLG*(MAX_VEG-1))
      real*8 wcip1_us(1+UST_FLG*(MAX_PIX-1))
      real*8 pixsiz,area(MAX_CAT),fbs(MAX_CAT+1),fbsrg
      real*8 zero,one,two,three,four,five,six

      integer icount(MAX_VEG,MAX_CAT+1),kk,jj,m_kk,u_kk

      real*8 frcov(MAX_VEG,MAX_CAT+1),wc0,wc0_us
      data zero,one,two,three,four,five,six/0.d0,1.d0,2.d0,&
             3.d0,4.d0,5.d0,6.d0/
