!
!--------------------------------------------------------------------------
      subroutine qvan3(iv,jv,is,qg,ylm_k,qr)
!--------------------------------------------------------------------------
!
!     calculate qg = SUM_LM (-I)^L AP(LM,iv,jv) YR_LM QRAD(iv,jv,L,is)
      USE kinds, ONLY: DP
      USE basis, ONLY: ntyp
      USE us, ONLY: lqx, dq, nbrx, indv, qrad, nhtol, nhtolm
      USE uspp, ONLY: nlx, lpl, lpx, ap

      implicit none
      integer :: iv,jv,is
      complex(DP) :: qg,sig
      real(DP) :: ylm_k(lqx*lqx)
      real(DP) :: qr(nbrx,nbrx,lqx,ntyp)
      
      integer ivs,jvs,ivl,jvl,ig,lp,l,i
!       IV  = 1..8    ! s_1 p_x1 p_y1 p_z1 s_2 p_x2 p_z2 p_y2
!       IVS = 1..4    ! s_1 s_2 p_1 p_2 d_1 d_2
!       IVL = 1..4    ! s p_x p_y p_z
!
!  NOTE :   IV  = 1..8 (sppp sppp)   IVS = 1..4 (sspp) OR 1..2 (sp)
!           IVL = 1..4 (sppp)
!
      ivs = indv(iv,is)
      jvs = indv(jv,is)
      ivl = nhtolm(iv,is)
      jvl = nhtolm(jv,is)

      IF(IVL.GT.NLX)  CALL ERRORE(' QVAN ',' IVL.GT.NLX  ',IVL)
      IF(JVL.GT.NLX)  CALL ERRORE(' QVAN ',' JVL.GT.NLX  ',JVL)
      IF(IVS.GT.NBRX) CALL ERRORE(' QVAN ',' IVS.GT.NBRX ',IVS)
      IF(JVS.GT.NBRX) CALL ERRORE(' QVAN ',' JVS.GT.NBRX ',JVS)
 
      qg = (0.0d0,0.0d0)

!odl                  Write(*,*) 'QVAN3  --  ivs jvs = ',ivs,jvs
!odl                  Write(*,*) 'QVAN3  --  ivl jvl = ',ivl,jvl
      do i=1,lpx(ivl,jvl)
!odl                  Write(*,*) 'QVAN3  --  i = ',i
        lp = lpl(ivl,jvl,i)
!odl                  Write(*,*) 'QVAN3  --  lp = ',lp

!     EXTRACTION OF ANGULAR MOMENT L FROM LP:

        if (lp.eq.1) then
          l = 1
        else if ((lp.ge.2) .and. (lp.le.4)) then
          l = 2
        else if ((lp.ge.5) .and. (lp.le.9)) then
          l = 3
        else if ((lp.ge.10).and.(lp.le.16)) then
          l = 4
        else if ((lp.ge.17).and.(lp.le.25)) then
          l = 5
        else if (lp.ge.26) then
          call errore(' qvan3 ',' lp.ge.26 ',lp)
        end if

        sig = (0.d0,-1.d0)**(l-1)
        sig = sig * ap(lp,ivl,jvl)

!odl                  Write(*,*) 'QVAN3  --  sig = ',sig

!        WRITE( stdout,*) 'qvan3',ng1,LP,L,ivs,jvs

          qg = qg + sig * ylm_k(lp) * qr(ivs,jvs,l,is)

      end do
      return
      end
