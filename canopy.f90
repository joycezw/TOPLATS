! ====================================================================
!
! 			subroutine canopy
!
! ====================================================================
!
! Subroutine to calculate interception by vegetation and calculate
! canopy water balance.
!
! ====================================================================

      subroutine canopy(ipix,dt,wc,wcip1,Swq,fw,wsc,dc,epetw,epwms,pnet,&
       pptms,precip_o,dswc,wcrhs,endstm,xintst,intstp,istmst,istorm,&
       intstm,Outflow,PackWater,SurfWater,rnpet,xlepet,hpet,gpet,&
       rnetd,xled,hd,gd,rnetw,xlew,hw,gw,ioppet,tkpet,tkmidpet,dspet,&
       tkd,tkmidd,dshd,tkw,tkmidw,dshw)

      implicit none
      integer ipix
      integer intstp,istmst,istorm,intstm,ioppet
      real*8 wc,wcip1,Swq,fw
      real*8 wsc,dc,epetw
      real*8 epwms,pnet,pptms,precip_o
      real*8 dswc,wcrhs
      real*8 endstm
      real*8 xintst,Outflow,PackWater,SurfWater,rnpet,xlepet,hpet
      real*8 gpet,rnetd,xled,hd,gd,rnetw,xlew,hw,gw,tkpet,tkmidpet
      real*8 dspet,tkd,tkmidd,dshd,tkw,tkmidw,dshw
      real*8 zero,one,two,three,four,five,six,dt,dummy
      data zero,one,two,three,four,five,six/0.d0,1.d0,2.d0,&
             3.d0,4.d0,5.d0,6.d0/

! ====================================================================
! Initialize interception storage depth to value from previous time
! step.
! ====================================================================

      wc = wcip1

! ====================================================================
! Set fraction of wet canopy which is considered 100% if canopy
! is wet and 0% if canopy is dry. 
! ====================================================================

      call calcfw(Swq,wc,zero,fw,wsc)

! ====================================================================
! If potential evaporation is negative, dew forms over the 
! whole canopy.  Set dc to zero for this case.  
! ====================================================================

      call calcdc(dc,one,epetw,zero)

! ====================================================================
! Calculate evaporation from the wet canopy
! ====================================================================

      call calcepw(epwms,epetw,one,dc,fw,dt,wc)

! ====================================================================
! Calculate through fall of rainfall.  This is the part of the
! rainfall that can get through the canopy to the underlying soil
! ====================================================================

      pnet = zero               

      if ((pptms-epwms)*dt.gt.(wsc-wc)) then

         pnet = (pptms-epwms)-((wsc-wc)/dt)

      endif 

! ====================================================================
! Perform water balance on canopy storage, calculate the new
! interception storage.
! ====================================================================

      wcip1 = wc + dt*(pptms-epwms-pnet)

! --------------------------------------------------------------------
! Don't allow canopy storage to go below zero.
! --------------------------------------------------------------------

      if (wcip1.lt.zero) then

         epwms = epwms + wcip1/dt 
         wcip1 = zero

      endif  

! ====================================================================
! Calculate the precipitation that will go to the overstory
! layer and that will not fall through.
! This is the precipitation input for the snow melt model for the
! over story.
! ====================================================================

      precip_o=pptms

! ====================================================================
! Check canopy water balance, calculate the change in water storage.
! ====================================================================

      dswc = wcip1-wc
      wcrhs=(pptms-epwms-pnet)*dt

! --------------------------------------------------------------------
! Double check : if no rain there is no precipitation input to the
! under story.
! --------------------------------------------------------------------

      if (pptms.eq.(0.d0)) pnet=0.d0

! ====================================================================
! Check if the present time step can be considered an interstorm
! period or not in the calculation of the soil water balance.
! ====================================================================

      call interstorm(ipix,pnet,Outflow,PackWater+SurfWater+Swq,&
                         xintst,dt,intstp,endstm,istmst,istorm,intstm)

! ====================================================================
! Add up pet terms of the over story to get average values.
! ====================================================================

      rnpet = rnetd*dc*(one-fw) + rnetw*(one-dc*(one-fw))
      xlepet = xled*dc*(one-fw) + xlew*(one-dc*(one-fw))
      hpet = hd*dc*(one-fw) + hw*(one-dc*(one-fw))
      gpet = gd*dc*(one-fw) + gw*(one-dc*(one-fw))

! --------------------------------------------------------------------
! Solve for temperature and heat storage only when energy balance 
! method is used.
! --------------------------------------------------------------------

      if (ioppet.eq.0) then

         tkpet = tkd*dc*(one-fw) + tkw*(one-dc*(one-fw))
         tkmidpet = tkmidd*dc*(one-fw) + tkmidw*(one-dc*(one-fw))
         dspet = dshd*dc*(one-fw) + dshw*(one-dc*(one-fw))

      else

         tkpet = zero
         tkmidpet = zero
         dspet = zero

      endif

      return

      end subroutine canopy

!====================================================================
!
!                   subroutine calcfw
!
! ====================================================================
!
! Set fraction of wet canopy which is considered 100% if canopy
! is wet and 0% if canopy is dry.
!
! ====================================================================

      subroutine calcfw(Swq,wc,zero,fw,wsc)

      implicit none
      real*8 Swq,wc,zero,fw,wsc

      if (Swq.le.zero) then

         if (wc.gt.zero) then

            fw = (wc/wsc)**(0.667d0)

         else

            fw = zero

         endif

         if (wsc.eq.zero) fw=zero

      else

        fw=1.d0

      endif

      if (fw.ge.1.d0) fw=1.d0

      if ( (fw.ge.0.d0).and.(fw.le.1.d0) ) then

         fw=fw

      else

         write (*,*) 'CALCFW : fw : ',fw
         write (*,*) Swq,wc,zero,fw,wsc
         stop

      endif

      return

      end subroutine calcfw

! ====================================================================
!
!                  subroutine calcdc
!
! ====================================================================
!
! If potential evaporation is negative, dew forms over the
! whole canopy.
!
! ====================================================================

      subroutine calcdc(dc,one,epetw,zero)

      implicit none
      real*8 dc,one,epetw,zero

      dc = one
      if (epetw.lt.zero) dc=zero

      if ( (dc.ge.0.d0).and.(dc.le.1.d0) ) then

         dc=dc

      else

         write (*,*) 'CALCD! : d! out of bounds ',dc
         if (dc.lt.0.d0) dc=zero
         if (dc.gt.1.d0) dc=one

      endif

      return

      end subroutine calcdc

! ====================================================================
!
!                   subroutine calcepw
!
! ====================================================================
!
! Calculate evaporation from the wet canopy.
!
! ====================================================================

      subroutine calcepw(epwms,epetw,one,dc,fw,dt,wc)

      implicit none
      real*8 epwms,epetw,one,dc,fw,dt,wc

      epwms = epetw * (one-dc*(one-fw))

      if ((epwms*dt).gt.wc) then

         fw = fw*wc/(epwms*dt)
         epwms=epetw*(one-dc*(one-fw))

      endif

      if ( (fw.ge.0.d0).and.(fw.le.1.d0) ) then

         fw=fw

      else

         write (*,*) 'CALEPW : fw : ',fw
         write (*,*) epwms,epetw,one,dc,fw,dt,wc
         stop

      endif

      return

      end subroutine calcepw

! ====================================================================
!
!                   subroutine interstorm
!
! ====================================================================
!
! This subroutine checks if the soil under snow is treated as   *
! interstorm or storm period
!
! ====================================================================

      subroutine interstorm(ipix,precipi,outf,snowp,xintst,&
                            dt,intstp,endstm,istmst,istorm,intstm)

      implicit none      
      integer :: ipix,intstp,istmst,istorm,intstm
      real*8 :: precipi,outf,snowp,xintst,dt,endstm,r_input


! ====================================================================
! Calculate the water input to the ground.
! ====================================================================

      if (snowp.gt.(0.001d0)) then

         r_input=outf

      else

         r_input=precipi

      endif

! ====================================================================
! Define storm and interstorm events
! ====================================================================

! --------------------------------------------------------------------
! First if there is no precipitation this time step then add
! to the time since ppt ended.  Then check if time since end
! of ppt is greater than threshold which defines beginning of
! interstorm period.
! --------------------------------------------------------------------

      if (r_input.le.(0.d0))then

         xintst=xintst+dt

! --------------------------------------------------------------------
! Now check if time since end of ppt is past threshold
! then add one to number of time steps into the
! interstorm period.
! --------------------------------------------------------------------

         if (xintst.gt.endstm)then

            intstp=intstp+1

! --------------------------------------------------------------------
! Now, if this is the first step in the interstorm period then
! reset storm flags (istmst,istorm) and reset number of
! steps into storm period to zero.
! --------------------------------------------------------------------

            if (intstp.eq.1) then

               istmst=0
               istorm=0
               intstm=1

            endif

! --------------------------------------------------------------------
! If time since end of ppt is within threshold then continue
! to add step to the storm period.
! --------------------------------------------------------------------

         else

            istmst=istmst+1

         endif

! --------------------------------------------------------------------
! If there is precipitation then storm event is in progress --
! increment the number of steps in the storm period and reset
! the time from the end of precipitation to zero.
! --------------------------------------------------------------------

      else

         istmst=istmst+1
         xintst=0.d0

! --------------------------------------------------------------------
! If this is the first time step in the storm period
! then reset the storm flags and the number of time
! steps in the interstorm period.
! --------------------------------------------------------------------

         if (istmst.eq.1)then

            intstp=0
            intstm=0
            istorm=1

         endif

      endif

      return

      end subroutine interstorm

