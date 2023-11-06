*** Settings ***

Suite Setup                                 Setup cenario                           Whitelabel

Resource                                    ../../../RESOURCE/NETQ/UTILS.robot
Resource                                    ../../../RESOURCE/API/RES_API.robot
Resource                                    ${DIR_FW}/UTILS.robot
Resource                                    ${DIR_SOM}/UTILS.robot
Resource                                    ${DIR_ROBS}/ROB0003_ConsultarSlot/ROB0003_ConsultarSlot.robot
Resource                                    ${DIR_ROBS}/ROB0004_RealizarAgendamento/ROB0004_RealizarAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0007_ValidarAtribuicaoCompromissoFSL/ROB0007_ValidarAtribuicaoCompromissoFSL.robot
Resource                                    ${DIR_ROBS}/ROB0022_ValidarNotificacaoFW/ROB0022_ValidarNotificacaoFW.robot
Resource                                    ${DIR_ROBS}/ROB0034_RealizarDiagnostico/ROB0034_RealizarDiagnostico.robot
Resource                                    ${DIR_ROBS}/ROB0037_AbrirChamadoTecnico/ROB0037_AbrirChamadoTecnico.robot



*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/186_AbrirTroubleTicketComAgendamentoPrevioParaEnderecoWhitelabel.xlsx


*** Test Cases ***
186.01 - Realizar configuração na ferramenta de mock
    Alterar Campo no NETQ                   CAMPO=GPON_OPTICAL_POWER                VALOR=GPON_01

186.02 - Gerar Token de Acesso
    Retornar Token Vtal

186.03 - Realizar Consulta de Slots
    Retornar Slot Agendamento Reparo

186.04 - Realizar o Agendamento
    Realizar Agendamento de Reparo          

186.05 - Validar a Notificação do Agendamento
    Validar Evento FW                       VALOR_BUSCA=associatedDocument
    ...                                     XPATH_EVENTO=(//a[normalize-space()='Appointment.PostAppointment'])[1]
    ...                                     RETORNO_ESPERADO=>201<

186.06 - Validar agendamento no FSL
    Escrever Variavel na Planilha           Atribuído                               Estado                                  Global
    Validar Criação do SA de Reparo
    Close Browser                           CURRENT

186.07 - Realizar pre-diagnostico
    Realizar PreDiagnostico ou Diagnostico                                          preDiagnostic

186.08 - Validar retorno do pre-diagnostico no FW
    Escrever Variavel na Planilha           FINISHED                                state                                   Global
    Validar Evento FW                       VALOR_BUSCA=preDiagId
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ServiceTestManagement.ListenerServiceTestResultEvent'])[1]
    ...                                     XPATH_XML=(//*[text()="INVOKE - Request enviado para a ClienteCo"]/../..//textarea)[1]
    ...                                     DADOS_XML=state
186.09 - Realizar Diagnostico
    Realizar PreDiagnostico ou Diagnostico                                          diagnostic

186.10 - Validar retorno do diagnostico no FW
    Validar Evento FW                       VALOR_BUSCA=diagId
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ServiceTestManagement.ListenerServiceTestResultEvent'])[1]
    ...                                     XPATH_XML=(//*[text()="INVOKE - Request enviado para a ClienteCo"]/../..//textarea)[1]
    ...                                     DADOS_XML=state
    Close Browser                           CURRENT

186.11 - Abrir Chamado Técnico
    Abrir Chamado Tecnico sem complemento   Lentidão na conexão

186.12 - Validação de reparo no FW
    Validar Evento FW                       VALOR_BUSCA=troubleTicketId
    ...                                     XPATH_EVENTO=(//a[normalize-space()='TroubleTicketManagement.ListenerTroubleTicketInformationRequiredEvent'])[1]
    ...                                     XPATH_XML=(//*[text()="INVOKE - Request enviado para o API Gateway[/api/troubleTicket/v1/listener/troubleTicketInformationRequiredEvent]"]/../..//textarea)[1]
    ...                                     RETORNO_ESPERADO=AGENDAMENTO DO PEDIDO


186.13 - Validar no SOM a abertura do reparo com pendência de agendamento
    Validar Evento Simples SOM              VALOR_PESQUISA=associatedDocument
    ...                                     TASK_NAME=T070 - Agendamento
    ...                                     ORDER_TYPE=Vtal Fibra Chamado Tecnico Ordem
    ...                                     ORDER_STATE=In Progress