*** Settings ***
Documentation                               Agrupador responsavel por chamar TC dos ROBS referentes ao cenario
...                                         INPUT: 
...                                         OUTPUT: 


Suite Setup                                 Setup cenario                           Whitelabel

Resource                                    ${DIR_API}/RES_API.robot
Resource                                    ${DIR_COMMON}/RES_UTIL.robot
Resource                                    ${DIR_ROBS}/ROB0001_ConsultarIdEndereco/ROB0001_ConsultarIdEndereco.robot
Resource                                    ${DIR_ROBS}/ROB0002_ConsultarViabilidade/ROB0002_ConsultarViabilidade.robot
Resource                                    ${DIR_ROBS}/ROB0028_AgendamentoDeRetirada/ROB0028_AgendamentoDeRetirada.robot
Resource                                    ${DIR_ROBS}/ROB0003_ConsultarSlot/ROB0003_ConsultarSlot.robot
Resource                                    ${DIR_ROBS}/ROB0007_ValidarAtribuicaoCompromissoFSL/ROB0007_ValidarAtribuicaoCompromissoFSL.robot
Resource                                    ${DIR_ROBS}/ROB0029_CriarOrdemDeRetirada/ROB0029_CriarOrdemDeRetirada.robot
Resource                                    ${DIR_ROBS}/ROB0006_ValidarOrdemSOM/ROB0006_ValidarOrdemSOM.robot
Resource                                    ${DIR_ROBS}/ROB0025_AtualizacaoDeAgendamento/ROB0025_AtualizacaoDeAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0026_TrocaDeTecnicoFSL/ROB0026_TrocaDeTecnicoFSL.robot
Resource                                    ${DIR_ROBS}/ROB0013_CancelarAgendamento/ROB0013_CancelarAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0022_ValidarNotificacaoFW/ROB0022_ValidarNotificacaoFW.robot
Resource                                    ${DIR_ROBS}/ROB0032_CancelarOrdem/ROB0032_CancelarOrdem.robot
Resource                                    ${DIR_ROBS}/ROB0027_DesatribuirAtividadeFSL/ROB0027_DesatribuirAtividadeFSL.robot
Resource                                    ${DIR_ROBS}/ROB0008_AtualizarStatusSA/ROB0008_AtualizarStatusSA.robot

*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/019_RealizarRetiradaSemCompComAgendamentoAtribuidoFSLComCancelamento.xlsx


*** Test Cases ***
19.01 - Gerar Token de Acesso 
    Retornar Token Vtal

19.02 - Realizar Consulta de Slots Para Atividade de Retirada
    Retornar Slot Agendamento Retirada

19.03 - Realizar Agendamento de Retirada
    Realizando Agendamento Retirada

19.04 - Validar Notificação do Agendamento via FW Console
    Validar Evento FW                       VALOR_BUSCA=associatedDocument
    ...                                     XPATH_EVENTO=(//a[normalize-space()='Appointment.PostAppointment'])[1]
    ...                                     RETORNO_ESPERADO=>201<

19.05 - Validar a Criação do SA de Retirada via FLS
    Escrever Variavel na Planilha           Atribuído                               Estado                                  Global
    Validar a Criação do SA de Retirada
    
19.06 - Realizar Abertura da Ordem de Retirada
    Criar Ordem Agendamento Retirada

19.07 - Realizar Validação no SOM
    Valida Ordem SOM Retirada

19.08 - Validar Notificação de Criação da Ordem via FW Console
    Validar Criação da Ordem                associatedDocument                     code>200<                               Retirada
   
19.09 - Realizar Reagendamento
    Reagendar Pedido OPM e FSL Retirada

19.10 - Validar Notificação de Atualização via FW Console
    Validar Evento FW                       VALOR_BUSCA=associatedDocument
    ...                                     XPATH_EVENTO=(//a[normalize-space()='Appointment.PatchAppointment'])[1]
    ...                                     RETORNO_ESPERADO=>200<
    
19.11 - Validar a Atualização do Agendamento via FLS
    Escrever Variavel na Planilha           Não atribuído                           Estado                                  Global
    Validar a Criação do SA de Retirada

19.12 - Realizar Atribuição ao Técnico via FLS
    Troca de Tecnico no Field Service
    Close Browser                           CURRENT

19.13 - Tramitar a OS de Retirada até o Ponto de Não Retorno
    Escrever Variavel na Planilha           Atribuído                               Estado                                  Global
    Atualiza Status Deslocamento SA    
    
19.14 - Realizar o Cancelamento da Ordem de Retirada
    Cancelar a Ordem

19.15 - Validar o Cancelamento da OS via FSL
    Escrever Variavel na Planilha           Cancelado                               Estado                                  Global
    Valida SA Cancelada

19.16 - Valida a Notificação de Cancelamento via FW Console
    Validar Evento FW                       VALOR_BUSCA=associatedDocument
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ProductOrdering.ListenerProductOrderStateChangeEvent'])[1]
    ...                                     RETORNO_ESPERADO=>204<

19.17 - Validar o Cancelamento da Ordem no SOM
    Valida Ordem SOM Retirada Cancelada