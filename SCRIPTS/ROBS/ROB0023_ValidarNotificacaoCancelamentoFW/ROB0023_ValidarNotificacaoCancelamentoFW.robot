*** Settings ***
Documentation                               Validação de Cancelamento no FW
Resource                                    ../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ../../RESOURCE/API/RES_API.robot

Resource                                    ../../RESOURCE/FW/UTILS.robot
  

# *** Variables ***
# ${DAT_CENARIO}                            C:/IBM_VTAL/DATA/DAT013_RealizarAtivacaoCanceladaAntesAtividadeCampo.xlsx
   
                                
# *** Test Cases ***
# teste
#     Valida Cancelamento FW
    

*** Keywords ***
Valida Cancelamento FW
    [Documentation]                         Valida o cancelamento da ordem no FW.
    [Tags]                                  ValidarCancelamentoFW

    Login FWConsole
    Preencher o Work_Order_Id
    Validar Cancelamento 
    
#===================================================================================================================================================================
Preencher o Work_Order_Id
    [Documentation]                         Validação de agendamentoFW
    [Tags]                                  ValidarAgendamentoBAFW
    ${WORKORDERID}=                         Ler Variavel na Planilha                Work_Order_Id               	        Global
    Set Global Variable                     ${WORKORDERID}

#===================================================================================================================================================================