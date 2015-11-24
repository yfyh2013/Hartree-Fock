MODULE CORE

    USE KINETIC, only: T_kinetic
    USE NUCLEAR, only: V_nuclear

    IMPLICIT NONE

    CONTAINS

        SUBROUTINE H_core(Kf,Nn,basis_D,basis_A,basis_L,basis_R,Rn,Zn,H)

            ! TODO Allow flexibility for basis sets other than STO-3G
            ! HARD CODED
            INTEGER, PARAMETER :: c = 3 ! Number of contractions per basis function

            ! INPUT
            INTEGER, intent(in) :: Kf                       ! Number of basis functions
            INTEGER, intent(in) :: Nn                       ! Total number of nuclei
            REAL*8, dimension(Kf,3), intent(in) :: basis_R  ! Basis set niclear positions
            INTEGER, dimension(Kf,3), intent(in) :: basis_L ! Basis set angular momenta
            REAL*8, dimension(Kf,3), intent(in) :: basis_D  ! Basis set contraction coefficients
            REAL*8, dimension(Kf,3), intent(in) :: basis_A  ! Basis set exponential contraction coefficients
            REAL*8, dimension(Nn,3), intent(in) :: Rn       ! Nuclear positions
            INTEGER, dimension(Nn), intent(in) :: Zn        ! Nuclear charges (> 0)

            ! INTERMEDIATE VARIABLE
            REAL*8, dimension(Kf,Kf) :: M   ! Matrix storing Hamiltonian components
            INTEGER :: i                    ! Loop index

            ! OUTPUT
            REAL*8, dimension(Kf,Kf), intent(out) :: H ! Core Hamiltonian

            H(:,:) = 0.0D0

            CALL T_kinetic(Kf,basis_D,basis_A,basis_L,basis_R,H)

            DO i = 1, Nn
                CALL V_nuclear(Kf,basis_D,basis_A,basis_L,basis_R,M,Rn(i,1:3),Zn(i))

                H = H + M
            END DO

        END SUBROUTINE H_core

        SUBROUTINE density()

        END SUBROUTINE density

END MODULE CORE