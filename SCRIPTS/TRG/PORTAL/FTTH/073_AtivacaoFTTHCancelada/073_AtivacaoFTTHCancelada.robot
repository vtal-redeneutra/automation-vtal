*** Settings ***
Documentation                               Agrupador responsavel por chamar TC dos ROBS referentes ao cenario
...                                         INPUT: Address, Number, CancelAppointmentReason, CancelAppointmentComments
...                                         OUTPUT: Address_Id, TypeComplement1, Value1, TypeComplement2, Value2, TypeComplement3, Value3,


Suite Setup                                 Setup cenario                           Whitelabel

Resource                                    ../../../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ../../../../RESOURCE/PORTAL/UTILS.robot
Resource                                    ../../../../ROBS/ROB0049_OrdensDeServiçoPortal/ROB0049_OrdensDeServiçoPortal.robot

*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/073_AtivacaoFTTHCancelada.xlsx

*** Test Cases ***

73.01/02/03/04/05 - Criar Ordem de Instalação via PORTAL
    [Tags]                                SCRIPT_A
    [Teardown]                            Logout Portal Operacional

    Login ao Portal Operacional
    Acessar Ordens de Serviço no menu do PORTAL
    Criar Ordem de Serviço de Instalação com VIABILIDADE TOTAL e velocidade 1000MBPS


# 73.09 - Realizar Cancelamento da OS via PORTAL
#     [Teardown]                            Logout Portal Operacional

#     Login ao Portal Operacional
#     Acessar Ordens de Serviço no menu do PORTAL
#     Realizar cancelamento da Ordem no PORTAL