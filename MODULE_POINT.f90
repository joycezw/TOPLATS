MODULE MODULE_POINT

USE MODULE_IO

contains
! ====================================================================
!
!                        subroutine land_lake
!
! ====================================================================
!
! Solve the water and energy budget for a land surface area
!
! ====================================================================


      subroutine land_lake(newstorm,ipix,i,dt,inc_frozen,i_2l,lakpix,&

! Point Variables

       POINT_VARS,&

! Factor to multiply the regional parameters with

       mul_fac,&

! General vegetation parameters

       ivgtyp,&

! Snow pack variables

       PackWater,SurfWater,Swq,VaporMassFlux,TPack,TSurf,r_MeltEnergy,&
       Outflow,xleact_snow,hact_snow,rn_snow,PackWater_us,SurfWater_us,&
       Swq_us,VaporMassFlux_us,TPack_us,TSurf_us,r_MeltEnergy_us,Outflow_us,&
       xleact_snow_us,hact_snow_us,rn_snow_us,dens,dens_us,dsty,dsty_us,Sdepth,Sdepth_us,&

! Albedos of the over story, under story,&
! and moss layer

       alb_snow,&

! Meteorological data

       GRID_MET,&

! Temperature variables

       Tdeepstep,&

! Soil parameters

       GRID_SOIL,&
       ifcoarse,&
       zrzmax,&

! Vegetation parameters

       GRID_VEG,&

! Constants
       toleb,maxnri,&

! Energy balance variables

       rib,&

! Water balance variables
       
       GRID_VARS,&
       cuminf,sorp,cc,sesq,&
       corr,idifind,wcip1,par,smpet0,&

! Storm parameters

       istmst,intstm,intstp,endstm,istorm,&
       xintst,&

! Topmodel parameters

       ff,atanb,xlamda,&

! Regional saturation parameters

       REG,&

! Different option parameters

       iopthermc,iopgveg,iopthermc_v,iopsmini,ikopt,&
       irestype,ioppet,iopveg,iopstab,iopwv,&

! Catchment Data
        CAT)

      implicit none
      include "SNOW.h"
      include 'wgtpar.h'
      include 'LAKE.h'
      include 'help/land_lake.h'
      type (OPTIONS_template) :: OPTIONS
      type (GRID_VEG_template) :: GRID_VEG
      type (GRID_SOIL_template) :: GRID_SOIL
      type (GRID_MET_template) :: GRID_MET
      type (REGIONAL_template),intent(inout) :: REG
      type (GRID_VARS_template) :: GRID_VARS
      type (POINT_template) :: POINT_VARS
      type (CATCHMENT_template) :: CAT
      
      !type (GENERAL_template) :: GENERAL

! TEMPORARY LOCATION TO PASS STRUCTURE INFORMATION TO OLD FORMAT

!VEGETATION
xlai = GRID_VEG%xlai
emiss = GRID_VEG%emiss
zpd = GRID_VEG%zpd
z0m = GRID_VEG%z0m
z0h = GRID_VEG%z0h
rescan = GRID_VEG%rescan
tc = GRID_VEG%tc
tw = GRID_VEG%tw
rtact = GRID_VEG%rtact
rtdens = GRID_VEG%rtdens
psicri = GRID_VEG%psicri
respla = GRID_VEG%respla
rsmax = GRID_VEG%rsmax
Rpl = GRID_VEG%Rpl
f3vpdpar = GRID_VEG%f3vpdpar
rsmin = GRID_VEG%rsmin
trefk = GRID_VEG%trefk
f4temppar = GRID_VEG%f4temppar
canclos = GRID_VEG%canclos
extinct = GRID_VEG%extinct
albd = GRID_VEG%albd
albw = GRID_VEG%albw
zww = GRID_VEG%zww
za = GRID_VEG%za
Tslope1 = GRID_VEG%Tslope1
Tint1 = GRID_VEG%Tint1
Tslope2 = GRID_VEG%Tslope2
Tint2 = GRID_VEG%Tint2
Tsep = GRID_VEG%Tsep
Twslope1 = GRID_VEG%Twslope1
Twint1 = GRID_VEG%Twint1
Twslope2 = GRID_VEG%Twslope2
Twint2 = GRID_VEG%Twint2
Twsep = GRID_VEG%Twsep
wsc = GRID_VEG%wsc
tcbeta = GRID_VEG%tcbeta

!SOIL PROPERTIES
bcbeta = GRID_SOIL%bcbeta
psic = GRID_SOIL%psic
thetas = GRID_SOIL%thetas
thetar = GRID_SOIL%thetar
xk0 = GRID_SOIL%xk0
zdeep = GRID_SOIL%zdeep
tdeep = GRID_SOIL%tdeep
zmid = GRID_SOIL%zmid
tmid0 = GRID_SOIL%tmid0
rocpsoil = GRID_SOIL%rocpsoil
quartz = GRID_SOIL%quartz
srespar1 = GRID_SOIL%srespar1
srespar2 = GRID_SOIL%srespar2
srespar3 = GRID_SOIL%srespar3
a_ice = GRID_SOIL%a_ice
b_ice = GRID_SOIL%b_ice
bulk_dens = GRID_SOIL%bulk_dens
amp = GRID_SOIL%amp
phase = GRID_SOIL%phase
shift = GRID_SOIL%shift
bcgamm = GRID_SOIL%bcgamm
par = GRID_SOIL%par
corr = GRID_SOIL%corr

!METEOROLOGY
rsd = GRID_MET%rsd
rld = GRID_MET%rld
tdry = GRID_MET%tdry
rh = GRID_MET%rh
uzw = GRID_MET%uzw
press = GRID_MET%press
pptms = GRID_MET%pptms

!GRID VARIABLES
!Water Balance Variables
rzsm = GRID_VARS%rzsm
tzsm = GRID_VARS%tzsm
rzsm1 = GRID_VARS%rzsm1
tzsm1 = GRID_VARS%tzsm1
rzsm_f = GRID_VARS%rzsm_f
tzsm_f = GRID_VARS%tzsm_f
rzsm1_f = GRID_VARS%rzsm1_f
tzsm1_f = GRID_VARS%tzsm1_f
rzdthetaidt = GRID_VARS%rzdthetaidt
tzdthetaidt = GRID_VARS%tzdthetaidt
rzdthetaudtemp = GRID_VARS%rzdthetaudtemp
pnet = GRID_VARS%pnet
xinact = GRID_VARS%xinact
runtot = GRID_VARS%runtot
irntyp = GRID_VARS%irntyp
!Meteorological Variables
Tincan = GRID_VARS%Tincan
rh_ic = GRID_VARS%rh_ic
precip_o = GRID_VARS%precip_o
precip_u = GRID_VARS%precip_u
!Temperature Variables
tkmid = GRID_VARS%tkmid
tkact = GRID_VARS%tkact
tkmidpet = GRID_VARS%tkmidpet
tkpet = GRID_VARS%tkpet
!Energy Fluxes
dshact = GRID_VARS%dshact
rnetpn = GRID_VARS%rnetpn
gbspen = GRID_VARS%gbspen
evtact = GRID_VARS%evtact
ievcon = GRID_VARS%ievcon
gact = GRID_VARS%gact
rnact = GRID_VARS%rnact
xleact = GRID_VARS%xleact
hact = GRID_VARS%hact
ebspot = GRID_VARS%ebspot
dspet = GRID_VARS%dspet
rnpet = GRID_VARS%rnpet
xlepet = GRID_VARS%xlepet
hpet = GRID_VARS%hpet
gpet = GRID_VARS%gpet

!Point Data
!Water Balance
zrz = 0.d0!POINT_VARS%zrz
ztz = 0.d0!POINT_VARS%ztz
smold = 0.d0!POINT_VARS%smold
rzsmold = 0.d0!POINT_VARS%rzsmold
tzsmold = 0.d0!POINT_VARS%tzsmold
capflx = 0.d0!POINT_VARS%capflx
difrz = 0.d0!POINT_VARS%difrz
diftz = 0.d0!POINT_VARS%diftz
grz = 0.d0!POINT_VARS%grz
gtz = 0.d0!POINT_VARS%gtz
satxr = 0.d0!POINT_VARS%satxr
xinfxr = 0.d0!POINT_VARS%xinfxr
dc = 0.d0!POINT_VARS%dc
fw = 0.d0!POINT_VARS%fw
dsrz = 0.d0!POINT_VARS%dsrz
rzrhs = 0.d0!POINT_VARS%rzrhs
dstz = 0.d0!POINT_VARS%dstz
tzrhs = 0.d0!POINT_VARS%tzrhs
dswc = 0.d0!POINT_VARS%dswc
wcrhs = 0.d0!POINT_VARS%wcrhs
!Energy Fluxes
epwms = 0.d0!POINT_VARS%epwms
!Constants
row = POINT_VARS%row
cph2o = POINT_VARS%cph2o
cp = POINT_VARS%cp
roi = POINT_VARS%roi

!Catchment
!fwcat = CAT%fwcat
zbar = CAT%zbar

!if(i.eq. 2)print*,ipix,GRID_VARS

! ====================================================================
! If the vegetation type is greater than or equal to zero then
! solve the water and energy balance for a land area.
! ====================================================================

      if (ivgtyp.ge.0) then

! ....................................................................
! Calculate the local energy fluxes and set
! up the storm/interstorm event times and flags.
! ....................................................................
        
         call atmos(ipix,i,dt,inc_frozen,i_2l,&

! General vegetation parameters

       canclos,extinct,i_und,i_moss,ivgtyp,&

! Snow pack variables

       PackWater,SurfWater,Swq,VaporMassFlux,TPack,TSurf,r_MeltEnergy,Outflow,&
       xleact_snow,hact_snow,rn_snow,PackWater_us,SurfWater_us,Swq_us,&
       VaporMassFlux_us,TPack_us,TSurf_us,r_MeltEnergy_us,&
       Outflow_us,xleact_snow_us,hact_snow_us,rn_snow_us,dens,dens_us,&

! Albedos of the over story, under story,&
! and moss layer

       albd_us,alb_moss,alb_snow,albd,albw,albw_us,&

! Meteorological data

       rsd,rld,tcel,vppa,psychr,xlhv,tkel,zww,za,uzw,press,&
       appa,vpsat,tcel_ic,vppa_ic,psychr_ic,xlhv_ic,tkel_ic,vpsat_ic,&
       Tslope1,Tint1,Tslope2,Tint2,Tsep,Tincan,tdry,Twslope1,Twint1,&
       Twslope2,Twint2,Twsep,twet_ic,twet,rh,rh_ic,qv,qv_ic,ra,ra_ic,&

! Temperature variables

       tkmid,tkact,tkmid_us,tkact_us,tskinact_moss,tkact_moss,&
       tkmid_moss,Tdeepstep,amp,phase,shift,tdeep,tmid0,tmid0_moss,tk0moss,&

! Energy fluxes and states

       dshact,epetd,gact,epetd_us,dshact_moss,xle_act_moss,rnetd,xled,hd,&
       gd,dshd,tkd,tkmidd,rnetw,xlew,hw,gw,dshw,tkw,&
       tkmidw,tskinactd_moss,tkactd_moss,tkmidactd_moss,ds_p_moss,epetw,&
       dshact_us,rnetw_us,xlew_us,hw_us,gw_us,&
       dshw_us,tkw_us,tkmidw_us,epetw_us,&
       rnetd_us,xled_us,hd_us,gd_us,dshd_us,tkd_us,&
       tkmidd_us,rnet_pot_moss,xle_p_moss,&
       h_p_moss,g_p_moss,tk_p_moss,tkmid_p_moss,tskin_p_moss,eact_moss,ebspot,&
       tsoilold,tkmidpet,tkpet,tkmidpet_us,tkmidpet_moss,&
       dspet,dspet_us,dspet_moss,rnetpn,gbspen,&

! Soil parameters

       thetar,thetas,psic,bcbeta,quartz,ifcoarse,rocpsoil,tcbeta,&
       tcbeta_us,zdeep,zmid,zrzmax,&

! Moss parameters

       r_moss_depth,eps,emiss_moss,zpd_moss,rib_moss,&
       z0m_moss,z0h_moss,epet_moss,&

! Vegetation parameters

       xlai,xlai_us,emiss,zpd,zpd_us,z0m,z0h,z0m_us,z0h_us,&
       f1par,f3vpd,f4temp,f1par_us,f3vpd_us,f4temp_us,rescan,&
       rescan_us,f1,f2,f3,emiss_us,rsmin,rsmax,rsmin_us,rsmax_us,Rpl,&
       Rpl_us,f3vpdpar,f3vpdpar_us,trefk,f4temppar,trefk_us,f4temppar_us,&

! Constants

       row,cph2o,roa,cp,roi,toleb,maxnri,roa_ic,&

! Energy balance variables

       ravd,rahd,ravd_us,rahd_us,rav_moss,rah_moss,rib,RaSnow,rib_us,&
       ravw,ravw_us,rahw,rahw_us,&

! Water balance variables

       rzsm,tzsm,rzsm1,tzsm1,r_mossm,zrz,smold,rzdthetaudtemp,smpet0,&

! Different option paramters

       iopthermc,iopgveg,iopthermc_v,iopstab,ioppet,iopwv,iopsmini)

! ....................................................................
! Calculate local wet canopy water balance.
! ....................................................................

         call canopy(ipix,dt,wc,wcip1,Swq,fw,wsc,dc,epetw,epwms,pnet,&
        pptms,precip_o,dswc,wcrhs,endstm,xintst,intstp,istmst,istorm,&
        intstm,Outflow,PackWater,SurfWater,rnpet,xlepet,hpet,gpet,&
        rnetd,xled,hd,gd,rnetw,xlew,hw,gw,ioppet,tkpet,tkmidpet,dspet,&
        tkd,tkmidd,dshd,tkw,tkmidw,dshw)

! ....................................................................
! Calculate the local land surface water/energy balance.
! ....................................................................

! ....................................................................
! Option 2 : the incoming long wave radiation for both under and over
! story is equal and is the atmospheri! incoming long wave radiation.
! The uncouples the radiation balances for both layers from each
! other.  This option is also used when under story is not represented.
! ....................................................................

            call land(newstorm,ipix,i,dt,inc_frozen,i_2l,&

! Factor to multiply the regional parameters with

       mul_fac,&

! General vegetation parameters

       canclos,extinct,i_und,i_moss,ivgtyp,f_moss,f_und,&

! Snow pack variables

       PackWater,SurfWater,Swq,VaporMassFlux,TPack,TSurf,&
       r_MeltEnergy,Outflow,xleact_snow,hact_snow,rn_snow,PackWater_us,&
       SurfWater_us,Swq_us,VaporMassFlux_us,TPack_us,TSurf_us,r_MeltEnergy_us,&
       Outflow_us,xleact_snow_us,hact_snow_us,rn_snow_us,dens,dens_us,&

! Albedos of the over story, under story,&
! and moss layer

       albd_us,alb_moss,alb_snow,albd,&

! Meteorological data

       rsd,rld,tcel,vppa,psychr,xlhv,tkel,zww,za,uzw,press,pptms,appa,&
       vpsat,tcel_ic,vppa_ic,psychr_ic,xlhv_ic,tkel_ic,vpsat_ic,precip_o,&
       precip_u,&

! Temperature variables

       tkmid,tkact,tkmid_us,tkact_us,tskinact_moss,tkact_moss,&
       tkmid_moss,tkmidpet,tkmidpet_us,tkmidpet_moss,tsoilold,Tdeepstep,&

! Energy fluxes

       dshact,rnetpn,gbspen,epetd,evtact,ievcon,bsdew,gact,&
       rnact,xleact,hact,epetd_us,dshact_moss,xle_act_moss,rnetd,xled,hd,&
       gd,dshd,tkd,tkmidd,rnetw,xlew,hw,gw,dshw,tkw,tkmidw,ievcon_us,rnact_us,&
       xleact_us,hact_us,gact_us,dshact_us,rnetw_us,xlew_us,hw_us,gw_us,&
       dshw_us,tkw_us,tkmidw_us,evtact_us,rnetd_us,xled_us,hd_us,gd_us,dshd_us,&
       tkd_us,tkmidd_us,ievcon_moss,bsdew_moss,evtact_moss,rnet_pot_moss,&
       xle_p_moss,h_p_moss,g_p_moss,tk_p_moss,tkmid_p_moss,&
       tskin_p_moss,eact_moss,rnact_moss,xleact_moss,hact_moss,gact_moss,&
       ds_p_moss,&

! Soil parameters

       thetar,thetas,psic,bcbeta,quartz,ifcoarse,rocpsoil,tcbeta,&
       tcbeta_us,bulk_dens,a_ice,b_ice,xk0,bcgamm,&
       srespar1,srespar2,srespar3,zdeep,zmid,zrzmax,&

! Moss parameters

       r_moss_depth,thetas_moss,srespar1_moss,srespar2_moss,srespar3_moss,&
       eps,emiss_moss,zpd_moss,rib_moss,z0m_moss,z0h_moss,epet_moss,&
       a_ice_moss,b_ice_moss,bulk_dens_moss,&

! Vegetation parameters

       xlai,xlai_us,emiss,zpd,zpd_us,z0m,z0h,&
       f1par,f3vpd,f4temp,f1par_us,f3vpd_us,f4temp_us,rescan,&
       tc,tw,tc_us,tw_us,rescan_us,rtact,rtdens,psicri,&
       respla,f1,f2,f3,emiss_us,&

! Constants

       row,cph2o,roa,cp,roi,toleb,maxnri,roa_ic,&

! Energy balance variables

       ravd,rahd,ravd_us,rahd_us,rav_moss,rah_moss,rib,RaSnow,&

! Water balance variables

       rzsm,tzsm,rzsm1,tzsm1,rzsm_u,tzsm_u,rzsm1_u,tzsm1_u,rzsm_f,&
       tzsm_f,rzsm1_f,tzsm1_f,r_mossm,r_mossm1,r_mossm_f,r_mossm1_f,r_mossm_u,&
       r_mossm1_u,zrz,ztz,r_mossmold,smold,rzsmold,tzsmold,rzdthetaudtemp,&
       rzdthetaidt,tzdthetaidt,zw,zbar,zmoss,&
       capflx,difrz,diftz,grz,gtz,pnet,cuminf,sorp,cc,deltrz,&
       xinact,satxr,xinfxr,runtot,irntyp,sesq,corr,&
       idifind,dc,fw,dc_us,fw_us,wcip1,par,dewrun,dsrz,rzrhs,dstz,tzrhs,&

! Storm parameters

       istmst,intstm,istmst_moss,intstm_moss,intstp,istorm,&

! Topmodel parameters

       ff,atanb,xlamda,&

! Regional saturation parameters

       fwcat,fwreg,pr3sat,perrg2,pr2sat,pr2uns,perrg1,pr1sat,&
       pr1rzs,pr1tzs,pr1uns,persxr,perixr,persac,peruac,perusc,&

! Different option paramters

       iopthermc,iopgveg,iopthermc_v,iopsmini,ikopt,&
       irestype,ioppet,iopveg)

! ====================================================================
! Calculate the density and depth of the snow layers.
! ====================================================================

         if ( (Swq.gt.0.d0).and.(SNOW_RUN.eq.1) ) then

            call calcrain (tcel,snow,rain,precip_o,dt)
            call snow_density(dsty,snow,tcel,Swq,Sdepth,TSurf,dt)

         else

            Sdepth=0.d0
            dsty=0.d0

         endif

      endif

! ====================================================================
! In the vegetation type is lower than zero then solve the open 
! water energy and water balance.
! ====================================================================

      if (ivgtyp.eq.(-1)) then

! ....................................................................
! Calculate the deep soil temperature.
! ....................................................................

         if ( (amp.eq.(0.d0)).and.&
              (phase.eq.(0.d0)).and.&
              (shift.eq.(0.d0)) ) then

            Tdeepstep=tdeep

         else

            rrr=real(i)

            Tdeepstep=tdeep + amp*cos ( rrr*phase - shift )

         endif

      endif

!TEMPORARY - Convert variables back to structure
!GRID VARIABLES
GRID_VARS%rzsm = rzsm
GRID_VARS%tzsm = tzsm
GRID_VARS%rzsm1 = rzsm1
GRID_VARS%tzsm1 = tzsm1
GRID_VARS%rzsm_f = rzsm_f
GRID_VARS%tzsm_f = tzsm_f
GRID_VARS%rzsm1_f = rzsm1_f
GRID_VARS%tzsm1_f = tzsm1_f
GRID_VARS%rzdthetaidt = rzdthetaidt
GRID_VARS%tzdthetaidt = tzdthetaidt
GRID_VARS%rzdthetaudtemp = rzdthetaudtemp
GRID_VARS%pnet = pnet
GRID_VARS%xinact = xinact
GRID_VARS%runtot = runtot
GRID_VARS%irntyp = irntyp
!Meteorological Variables
GRID_VARS%Tincan = Tincan
GRID_VARS%rh_ic = rh_ic
GRID_VARS%precip_o = precip_o
GRID_VARS%precip_u = precip_u
!Temperature Variables
GRID_VARS%tkmid = tkmid
GRID_VARS%tkact = tkact
GRID_VARS%tkmidpet = tkmidpet
GRID_VARS%tkpet = tkpet
!Energy Fluxes
GRID_VARS%dshact = dshact
GRID_VARS%rnetpn = rnetpn
GRID_VARS%gbspen = gbspen
GRID_VARS%evtact = evtact
GRID_VARS%ievcon = ievcon
GRID_VARS%gact = gact
GRID_VARS%rnact = rnact
GRID_VARS%xleact = xleact
GRID_VARS%hact = hact
GRID_VARS%ebspot = ebspot
GRID_VARS%dspet = dspet
GRID_VARS%rnpet = rnpet
GRID_VARS%xlepet = xlepet
GRID_VARS%hpet = hpet
GRID_VARS%gpet = gpet

!$OMP ORDERED
!$OMP CRITICAL
!REGIONAL
REG%fwreg = REG%fwreg + fwreg
REG%pr3sat = REG%pr3sat + pr3sat
REG%perrg2 = REG%perrg2 + perrg2
REG%pr2sat = REG%pr2sat + pr2sat
REG%pr2uns = REG%pr2uns + pr2uns
REG%perrg1 = REG%perrg1 + perrg1
REG%pr1sat = REG%pr1sat + pr1sat
REG%pr1rzs = REG%pr1rzs + pr1rzs
REG%pr1tzs = REG%pr1tzs + pr1tzs
REG%pr1uns = REG%pr1uns + pr1uns
REG%persxr = REG%persxr + persxr
REG%perixr = REG%perixr + perixr
REG%persac = REG%persac + persac
REG%peruac = REG%peruac + peruac
REG%perusc = REG%perusc + perusc

!CATCHMENT
CAT%fwcat = CAT%fwcat + fwcat
!$OMP END CRITICAL
!$OMP END ORDERED

!Point Data
POINT_VARS%zrz = zrz
POINT_VARS%ztz = ztz
POINT_VARS%smold = smold
POINT_VARS%rzsmold = rzsmold
POINT_VARS%tzsmold = tzsmold
POINT_VARS%capflx = capflx
POINT_VARS%difrz = difrz
POINT_VARS%diftz = diftz
POINT_VARS%grz = grz
POINT_VARS%gtz = gtz
POINT_VARS%satxr = satxr
POINT_VARS%xinfxr = xinfxr
POINT_VARS%dc = dc
POINT_VARS%fw = fw
POINT_VARS%dsrz = dsrz
POINT_VARS%rzrhs = rzrhs
POINT_VARS%dstz = dstz
POINT_VARS%tzrhs = tzrhs 
POINT_VARS%dswc = dswc
POINT_VARS%wcrhs = wcrhs
!Energy Fluxes
POINT_VARS%epwms = epwms
!Constants
POINT_VARS%row = row
POINT_VARS%cph2o = cph2o
POINT_VARS%cp = cp
POINT_VARS%roi = roi

      return

      end subroutine land_lake

! ====================================================================
!
! 			subroutine sumflx
!
! ====================================================================
!
! Calculates the time step totals of evapotranspiration, runoff, 
! surface energy fluxes and vertical soil-water fluxes.
!
! ====================================================================

      subroutine sumflx(REG,POINT_VARS,CAT,GRID_VARS,&

! Factor to rescale all local fluxes

       rescale,&

! General vegetation parameters

       ivgtyp,i,iprn,canclos,ilandc,dt,&

! Condensation variables

       tair,pptms,wcip1,&

! Soil moisture variables

       inc_frozen,thetas,&
       Swq,Swq_us,Sdepth,Sdepth_us,&

! GRID Variables
       
       Tdeepstep)

      implicit none
      include "SNOW.h"
      include "wgtpar.h"
      
    
      include "help/sumflx.dif.h"
      type (REGIONAL_template) :: REG
      type (POINT_template) :: POINT_VARS
      type (GRID_VARS_template) :: GRID_VARS
      type (CATCHMENT_template) :: CAT

! TEMPORARY
!GRID
rnact = GRID_VARS%rnact
xleact = GRID_VARS%xleact
hact = GRID_VARS%hact
gact = GRID_VARS%gact
dshact = GRID_VARS%dshact
tkact = GRID_VARS%tkact
tkmid = GRID_VARS%tkmid
rnpet = GRID_VARS%rnpet
xlepet = GRID_VARS%xlepet
hpet = GRID_VARS%hpet
gpet = GRID_VARS%gpet
dspet = GRID_VARS%dspet
tkpet = GRID_VARS%tkpet
tkmidpet = GRID_VARS%tkmidpet
rzsm1 = GRID_VARS%rzsm1
tzsm1  = GRID_VARS%tzsm1
rzsm = GRID_VARS%rzsm
tzsm = GRID_VARS%tzsm
runtot = GRID_VARS%runtot
pnet = GRID_VARS%pnet
evtact = GRID_VARS%evtact
etpix = GRID_VARS%etpix

!Point Data
!Water Balance
zrz = POINT_VARS%zrz
ztz = POINT_VARS%ztz
smold = POINT_VARS%smold
rzsmold = POINT_VARS%rzsmold
tzsmold = POINT_VARS%tzsmold
capflx = POINT_VARS%capflx
difrz = POINT_VARS%difrz
diftz = POINT_VARS%diftz
grz = POINT_VARS%grz
gtz = POINT_VARS%gtz
satxr = POINT_VARS%satxr
xinfxr = POINT_VARS%xinfxr
dc = POINT_VARS%dc
fw = POINT_VARS%fw
dsrz = POINT_VARS%dsrz
rzrhs = POINT_VARS%rzrhs
dstz = POINT_VARS%dstz
tzrhs = POINT_VARS%tzrhs
dswc = POINT_VARS%dswc
wcrhs = POINT_VARS%wcrhs
!Energy fluxes
epwms = POINT_VARS%epwms

!Catchment Variables
!etstsum = CAT%etstsum
!etwtsum = CAT%etwtsum
!etbssum = CAT%etbssum
!etdcsum = CAT%etdcsum
!etwcsum = CAT%etwcsum
!contot = CAT%contot
!pptsum = CAT%pptsum
!pnetsum = CAT%pnetsum
!qsurf = CAT%qsurf
!sxrtot = CAT%sxrtot
!xixtot = CAT%xixtot
!ranrun = CAT%ranrun
!conrun = CAT%conrun
!gwtsum = CAT%gwtsum
!capsum = CAT%capsum
!tzpsum = CAT%tzpsum
!rzpsum = CAT%rzpsum

! ====================================================================
! Compute regional average evapotranspiration rate for the time step.    
! ====================================================================
 
  
      if (ivgtyp.eq.(-1)) then

! --------------------------------------------------------------------&
! In case of an open water pixel.
! --------------------------------------------------------------------&

         etpixloc=evtact
         ettot = ettot + etpixloc*rescale
         ettotrg = etpixloc*rescale

      else

! --------------------------------------------------------------------&
! In case of vegetated or bare soil pixels.
! --------------------------------------------------------------------&

         if ( (i_und.eq.0).and.(i_moss.eq.0) ) then

! ....................................................................
! If understory/moss is not represented.
! ....................................................................

            etpixloc = evtact*dc*(one-fw) + epwms*dc
            ettot = ettot + etpixloc*rescale
            ettotrg = etpixloc*rescale

         else

! ....................................................................
! Add the evapotranspiration rate from the understory/moss layer.
! ....................................................................

            xlhv=1000000000.*(2.501-0.002361*tair)
            dummy = canclos*xleact+ f_und*xleact_us+ f_moss*xleact_moss
            etpixloc = dummy/xlhv
            ettot = ettot + etpixloc*rescale
            ettotrg = etpixloc*rescale

         endif

      endif

! ====================================================================
! Split evapotranspiration by whether the water is supplied from
! below or above the water table.  Also sum evapotranspiration
! from each surface type.  Separate the evaporation from the
! water table by catchment for water table updating.
! ====================================================================

      if (ivgtyp.ge.0) then

         if (((ivgtyp.ne.2).and.(zrz.le.zero)).or.&
             ((ivgtyp.eq.2).and.(ztz.le.zero))) then

! --------------------------------------------------------------------&
! Add the evapotranspiration values up from pixels where the water
! is supplied from above the water table.
! --------------------------------------------------------------------&

            if (i_moss+i_und.eq.0) then

! ....................................................................
! Understory/moss is not represented.
! ....................................................................

               etstore = epwms*dc

            else

! ....................................................................
! Add understory/moss in the totals.
!....................................................................

               etstore = (1.-f_moss-f_und)*epwms*dc+f_und*epwms_us*dc_us

            endif

         else 

! --------------------------------------------------------------------&
! Add the evapotranspiration values up from pixels where the water
! is supplied from below the water table.
! --------------------------------------------------------------------&

            etstore = etpixloc

         endif

! ====================================================================
! Add up the regional values for evapotranspiration, either from
! the water table or from above the water table.
! ====================================================================
        
         etwt = etpixloc - etstore
         etpix=etpix+etpixloc*rescale
         etstsum = etstore*rescale
         etstsumrg = etstore*rescale
         etwtsum = etwt*rescale
         etwtsumrg = etwt*rescale

         if (ivgtyp.eq.0) then

! ====================================================================
! Add up evaporation from bare soil values.
! ====================================================================

            etbssum = evtact*rescale
            etbssumrg = evtact*rescale

         else

! ====================================================================
! Add up evaporation from dry and wet canopy for vegetated pixels.
! ====================================================================

            if ( (i_und.eq.0).and.(i_moss.eq.0) ) then

! --------------------------------------------------------------------&
! Understory/moss is not represented.
! --------------------------------------------------------------------&

               etdcsum = evtact*dc*(one-fw)*rescale
               etdcsumrg = evtact*dc*(one-fw)*rescale
               etwcsum = epwms*dc*rescale
               etwcsumrg = epwms*dc*rescale

            else

! --------------------------------------------------------------------&
! Add the values from the understory/moss in the totals.
! --------------------------------------------------------------------&

               etdcsum = ((1.-f_moss- f_und)*&
                                       evtact*dc*(one-fw) +&
                                       f_und*evtact_us*dc_us*(one-fw_us) +&
                                       f_moss*evtact_moss)*rescale
               etdcsumrg = ((1.-f_moss- f_und)*&
                                       evtact*dc*(one-fw) +&
                                       f_und*evtact_us*dc_us*(one-fw_us) +&
                                       f_moss*evtact_moss)*rescale

               etwcsum = (epwms*dc* (1.-f_moss- f_und)+&
                                       epwms_us*dc_us*f_und)*rescale
               etwcsumrg = (epwms*dc*(1.-f_moss-f_und)+&
                                        epwms_us*dc_us*f_und)*rescale

            endif

         endif

      else

         etlakesum=etlakesum+evtact*rescale
         etlakesumrg=etlakesumrg+evtact*rescale

      endif

! ====================================================================
! Compute total, catchment and regional condensation.
! ====================================================================

      if (ilandc.ge.0) then

         if (ivgtyp.eq.0) then

! --------------------------------------------------------------------&
! In case of bare soil the condensation is the dew onto the soil.
! --------------------------------------------------------------------&

            conpix = bsdew 

         else

! --------------------------------------------------------------------&
! In case of vegetated pixels the condensation is the negative
! evaporation onto the wet canopy.
! --------------------------------------------------------------------&

            conpix = epwms*(one-dc)

         endif

         if (ivgtyp.eq.(-1)) then

            conpix=0.d0

         endif

      endif

      contot = conpix*rescale
      contotrg = conpix*rescale

! ====================================================================
! Compute total precipitation and surface runoff for the time step.
! ====================================================================

      pptsum = pptms*rescale
      pptsumrg = pptms*rescale
      pnetsum = pnet*rescale
      pnetsumrg = pnet*rescale
      qsurf = runtot*rescale
      qsurfrg = runtot*rescale

! ====================================================================
! Compute total saturation and infiltration excess runoff for the
! time step.
! ====================================================================

      sxrtot = satxr *rescale
      sxrtotrg = satxr *rescale
      xixtot = xinfxr*rescale
      xixtotrg = xinfxr*rescale

! ====================================================================
! Compute total runoff due to rainfall and due to condensation.
! ====================================================================

      if (pptms.gt.zero) then

! --------------------------------------------------------------------&
! When under rainfall runoff has to be due to rain.
! --------------------------------------------------------------------&

         ranrun = runtot*rescale
         ranrunrg = runtot*rescale

      else

! --------------------------------------------------------------------&
! When no precipitation runoff has to be due to condensation.
! --------------------------------------------------------------------&

         conrun = runtot *rescale
         conrunrg = runtot *rescale

      endif  

! ====================================================================
! Compute checks on canopy water balance, root zone water balance,&
! and transmission zone balance.
! ====================================================================

      if (ivgtyp.ge.(0)) then

         dswcsum = dswc*rescale
         wcrhssum = wcrhs*rescale

         dsrzsum = dsrz*rescale
         rzrhssum = rzrhs*rescale

         dstzsum = dstz*rescale
         tzrhssum = tzrhs*rescale

! ====================================================================
! Compute drainage to the water table for time step.
! ====================================================================

         if (zrz.eq.zero) then
     
! --------------------------------------------------------------------&
! If the root zone is saturated there is no drainage towards the water 
! table.
! --------------------------------------------------------------------&

            gwt = zero
            difwt = difrz

        else if (ztz.eq.zero) then

! --------------------------------------------------------------------&
! If the transmission zone is saturated and the root zone is not
! the drainage and diffusion towards the water table comes from the
! root zone.
! --------------------------------------------------------------------&

            gwt = grz
            difwt = difrz

        else

! --------------------------------------------------------------------&
! If the transmission zone is not saturated the drainage and diffusion
! towards the water table comes from the  transmission zone.
! --------------------------------------------------------------------&
   
            gwt = gtz
            difwt = diftz
         endif

! ====================================================================
! Compute the regional totals of drainage to the water table and
! root and transmission zone drainage terms.
! ====================================================================


         gwtsum = gwt*rescale
         gwtsumrg = gwt*rescale
         grzsumrg = grz*rescale
         gtzsumrg = gtz*rescale

! ====================================================================
! Compute the diffusion totals for the time step.
! ====================================================================

         capsum = - difwt*rescale
         capsumrg =  - difwt*rescale
         difrzsumrg =  - difrz*rescale

! ====================================================================
! Compute change in storage above the water table for the time step 
! and perform water balance.
! ====================================================================

         dstore = dswc + dsrz + dstz
         dssum = dstore

! ====================================================================
! Add up all the input terms towards the water table and make the
! regional total.
! ======================================================================


         svarhs = dt*(pptms - etstore - runtot - gwt - difwt)

         svarhssum = svarhs*rescale

! ====================================================================
! Compute average soil moistures for the end of the time step.
! ====================================================================

         if (inc_frozen.eq.0) then

! --------------------------------------------------------------------&
! If frozen and liquid soil water are treated as liquid water than the
! liquid water content is the total water content.
! --------------------------------------------------------------------&

            rzsm1_u=rzsm1
            tzsm1_u=tzsm1

         endif

         rzsmav = rzsm1*rescale
         tzsmav = tzsm1*rescale
         Swqsum = Swq*rescale
         Swq_ussum = Swq_us*rescale
         Sdepthsum = Sdepth*rescale
         Sdepth_ussum = Sdepth_us*rescale


! ====================================================================
! Make a regional total of canopy interception storage.
! ====================================================================

         wcip1sum = wcip1*rescale

! ====================================================================
! Compute available porosity in root and transmission zones .or.&
! updating of average water table depth.  Only interested in
! the porosity for the zone above the water table.
! ====================================================================

         if (ztz.gt.zero) then

! --------------------------------------------------------------------&
! If the root and transmission zone are both unsaturated than
! the region of interest is the transmission zone.
! --------------------------------------------------------------------&

            tzpsum = (thetas-tzsm)*rescale

         else if (zrz.gt.zero) then

! --------------------------------------------------------------------&
! If the root zone is unsaturated and the transmission zone
! unsaturated than the region of interest is the root zone.
! --------------------------------------------------------------------&

            rzpsum = (thetas-rzsm)*rescale

         endif

      endif

! ====================================================================
! Write the components of the energy balance out if requested.
! ====================================================================

      if (ivgtyp.eq.(-1)) then

         tkmid=0.d0
         tkmidpet=0.d0
         tskinact_moss=0.d0

      endif

      if (iprn(110).eq.1) then

         write (110,125) i,rnact_moss,xleact_moss,hact_moss,&
                         gact_moss,dshact_moss,tskinact_moss,&
                         tkact_moss,tkmid_moss,r_mossm

      endif

      if (iprn(111).eq.1) then

         write (111,126) i,rnact_us,xleact_us,hact_us,&
                         gact_us,dshact_us,&
                         tkact_us,tkmid_us

      endif

      if (iprn(112).eq.1) then

         write (112,126) i,rnact,xleact,hact,gact,&
                         dshact,&
                         tkact,tkmid

      endif

! ====================================================================
! Compute pixel total energy fluxes at PET.
! ====================================================================

      if (i_moss+i_und.gt.0) then

! --------------------------------------------------------------------&
! If understory/moss is represented than add their fluxes temperatures
! in the total for the pixel.
! --------------------------------------------------------------------&

         rnpet = canclos*rnpet+ f_und*rnpet_us+ f_moss*rnpet_moss
         xlepet = canclos*xlepet+ f_und*xlepet_us+ f_moss*xlepet_moss
         hpet = canclos*hpet+ f_und*hpet_us+ f_moss*hpet_moss
         gpet = canclos*gpet+ f_und*gpet_us+ f_moss*gpet_moss
         dspet = canclos*dspet+ f_und*dspet_us+ f_moss*dspet_moss
         tkpet = (1.-f_moss-f_und)* tkpet+ f_und*tkpet_us+ f_moss*tkpet_moss
         tkmidpet = (1.-f_moss-f_und)* tkmidpet+ f_und*tkmidpet_us+&
                    f_moss*tkmidpet_moss

      endif

! ====================================================================
! Compute regional average energy fluxes at PET.
! ====================================================================

      rnpetsum = rnpet*rescale
      xlepetsum = xlepet*rescale
      hpetsum = hpet*rescale
      gpetsum = gpet*rescale
      dshpetsum = dspet*rescale
      tkpetsum = tkpet*rescale
      tkmidpetsum = tkmidpet*rescale
      tkdeepsum = Tdeepstep*rescale

! ====================================================================
! Compute pixel total actual surface energy fluxes for the time step.
! ====================================================================

      if (i_moss+i_und.gt.0) then

! --------------------------------------------------------------------&
! If understory/moss is represented than add their fluxes temperatures
! in the total for the pixel.
! --------------------------------------------------------------------&


         rnact = canclos*rnact+ f_und*rnact_us+ f_moss*rnact_moss
         xleact = canclos*xleact+ f_und*xleact_us+ f_moss*xleact_moss
         hact = canclos*hact+ f_und*hact_us+ f_moss*hact_moss
         gact = canclos*gact+ f_und*gact_us+ f_moss*gact_moss
         dshact = canclos*dshact+ f_und*dshact_us+ f_moss*dshact_moss
         tkact = (1.-f_moss-f_und)* tkact+ f_und*tkact_us+ f_moss*tkact_moss
         tkmid = (1.-f_moss-f_und)* tkmid+ f_und*tkmid_us+ f_moss*tkmid_moss

      endif

! ====================================================================
! Compute areal average actual surface energy fluxes for the time step.
! ====================================================================

      rnsum = rnact*rescale
      xlesum = xleact*rescale
      hsum = hact*rescale
      gsum = gact*rescale
      dshsum = dshact*rescale
      tksum = tkact*rescale
      tkmidsum = tkmid*rescale

! ====================================================================
! Format statements.
! ====================================================================

125   format (1i5,9(f11.5," "))
126   format (1i5,7(f11.5," "))

!GRID
GRID_VARS%rnact = rnact
GRID_VARS%xleact = xleact
GRID_VARS%hact = hact
GRID_VARS%gact = gact
GRID_VARS%dshact = dshact
GRID_VARS%tkact = tkact
GRID_VARS%tkmid = tkmid
GRID_VARS%rnpet = rnpet
GRID_VARS%xlepet = xlepet
GRID_VARS%hpet = hpet
GRID_VARS%gpet = gpet
GRID_VARS%dspet = dspet
GRID_VARS%tkpet = tkpet
GRID_VARS%tkmidpet = tkmidpet
GRID_VARS%runtot = runtot
GRID_VARS%pnet = pnet
GRID_VARS%evtact = evtact
GRID_VARS%etpix = etpix

!$OMP CRITICAL
!Regional 
REG%ettotrg = REG%ettotrg + ettotrg
REG%etstsumrg = REG%etstsumrg + etstsumrg
REG%etwtsumrg = REG%etwtsumrg + etwtsumrg
REG%etbssumrg = REG%etbssumrg + etbssumrg
REG%etdcsumrg = REG%etdcsumrg + etdcsumrg
REG%etwcsumrg = REG%etwcsumrg + etwcsumrg
REG%pptsumrg = REG%pptsumrg + pptsumrg
REG%pnetsumrg = REG%pnetsumrg + pnetsumrg
REG%contotrg = REG%contotrg + contotrg
REG%sxrtotrg = REG%sxrtotrg + sxrtotrg
REG%xixtotrg = REG%xixtotrg + xixtotrg
REG%qsurfrg = REG%qsurfrg + qsurfrg
REG%ranrunrg = REG%ranrunrg + ranrunrg
REG%conrunrg = REG%conrunrg + conrunrg
REG%gwtsumrg = REG%gwtsumrg + gwtsumrg
REG%grzsumrg = REG%grzsumrg + grzsumrg
REG%gtzsumrg = REG%gtzsumrg + gtzsumrg
REG%capsumrg = REG%capsumrg + capsumrg
REG%difrzsumrg = REG%difrzsumrg + difrzsumrg
REG%rnpetsum = REG%rnpetsum + rnpetsum
REG%xlepetsum = REG%xlepetsum + xlepetsum
REG%hpetsum = REG%hpetsum + hpetsum
REG%gpetsum = REG%gpetsum + gpetsum
REG%dshpetsum = REG%dshpetsum + dshpetsum
REG%tkpetsum = REG%tkpetsum + tkpetsum
REG%tkmidpetsum = REG%tkmidpetsum + tkmidpetsum
REG%tkdeepsum = REG%tkdeepsum + tkdeepsum
REG%wcip1sum = REG%wcip1sum + wcip1sum
REG%dswcsum = REG%dswcsum + dswcsum
REG%wcrhssum = REG%wcrhssum + wcrhssum
REG%dsrzsum = REG%dsrzsum + dsrzsum
REG%rzrhssum = REG%rzrhssum + rzrhssum
REG%dstzsum = REG%dstzsum + dstzsum
REG%tzrhssum = REG%tzrhssum + tzrhssum
REG%dssum = REG%dssum + dssum
REG%svarhssum = REG%svarhssum + svarhssum
REG%rzsmav = REG%rzsmav + rzsmav
REG%tzsmav = REG%tzsmav + tzsmav
REG%Swqsum = REG%Swqsum + Swqsum
REG%Swq_ussum = REG%Swq_ussum + Swq_ussum
REG%Sdepthsum = REG%Sdepthsum + Sdepthsum
REG%Sdepth_ussum = REG%Sdepth_ussum + Sdepth_ussum
REG%rnsum = REG%rnsum + rnsum
REG%xlesum = REG%xlesum + xlesum
REG%hsum = REG%hsum + hsum
REG%gsum = REG%gsum + gsum
REG%dshsum = REG%dshsum + dshsum
REG%tksum = REG%tksum + tksum
REG%tkmidsum = REG%tkmidsum + tkmidsum

!Catchment Variables
CAT%etstsum = CAT%etstsum + etstsum
CAT%etwtsum = CAT%etwtsum + etwtsum
CAT%etbssum = CAT%etbssum + etbssum
CAT%etdcsum = CAT%etdcsum + etdcsum
CAT%etwcsum = CAT%etwcsum + etwcsum
CAT%contot = CAT%contot + contot
CAT%pptsum = CAT%pptsum + pptsum
CAT%pnetsum = CAT%pnetsum + pnetsum
CAT%qsurf = CAT%qsurf + qsurf
CAT%sxrtot = CAT%sxrtot + sxrtot
CAT%xixtot = CAT%xixtot + xixtot
CAT%ranrun = CAT%ranrun + ranrun
CAT%conrun = CAT%conrun + conrun
CAT%gwtsum = CAT%gwtsum + gwtsum
CAT%capsum = CAT%capsum + capsum
CAT%tzpsum = CAT%tzpsum + tzpsum
CAT%rzpsum = CAT%rzpsum + rzpsum
!$OMP END CRITICAL 

!Point Data
!Water Balance
POINT_VARS%zrz = zrz
POINT_VARS%ztz = ztz
POINT_VARS%smold = smold
POINT_VARS%rzsmold = rzsmold
POINT_VARS%tzsmold = tzsmold
POINT_VARS%capflx = capflx
POINT_VARS%difrz = difrz
POINT_VARS%diftz = diftz
POINT_VARS%grz = grz
POINT_VARS%gtz = gtz
POINT_VARS%satxr = satxr
POINT_VARS%xinfxr = xinfxr
POINT_VARS%dc = dc
POINT_VARS%fw = fw
POINT_VARS%dsrz = dsrz
POINT_VARS%rzrhs = rzrhs
POINT_VARS%dstz = dstz
POINT_VARS%tzrhs = tzrhs
POINT_VARS%dswc = dswc
POINT_VARS%wcrhs = wcrhs
!Energy Fluxes
POINT_VARS%epwms = epwms

      return

      end subroutine sumflx

END MODULE MODULE_POINT
