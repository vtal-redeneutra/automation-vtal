*** Settings ***
Documentation                               Agrupador responsavel por chamar TC dos ROBS referentes ao cenario

Suite Setup                                 Setup cenario                           FTTP


Resource                                    ../../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ../../../RESOURCE/NETQ/UTILS.robot
Resource                                    ../../../RESOURCE/MS/UTILS.robot
Resource                                    ${DIR_SOM}/UTILS.robot
Resource                                    ${DIR_FW}/UTILS.robot
Resource                                    ${DIR_ROBS}/ROB0022_ValidarNotificacaoFW/ROB0022_ValidarNotificacaoFW.robot


*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/054_PreDiagnosticoCompletoEnderecoMultiplosComplementos.xlsx


*** Test Cases ***

54.1 - Gerar Token de Acesso 
    Retornar Token Vtal

54.02 - Realizar configuração na ferramenta de mock
    Alterar Campo no NETQ                   RESET_JSON=SIM
    
54.03 - Realizar pre-diagnostico
    Realizar PreDiagnostico ou Diagnostico                                          preDiagnostic

54.04 - Validar retorno do pre-diagnostico no FW
    Login ao Portal de Microserviços
    Acessar SOA no menu do PORTAL de Microserviços
    Procurar por ServiceTestManagement.ListenerServiceTestResultEvent referente ao preDiagId
    Validar dado do Bloco com a DAT          XML    INVOKE - Request enviado para a ClienteCo        state              state
    Validar dado do Bloco com o Argumento    XML    INVOKE - Request enviado para a ClienteCo        type               preDiagnostic
    Validar dado do Bloco com o Argumento    XML    END - Finalização do serviço                     msg:Description    Sucesso





