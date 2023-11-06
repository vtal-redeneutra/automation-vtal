*** Settings ***
Documentation                               Agrupador responsavel por chamar TC dos ROBS referentes ao cenario


Suite Setup                                 Setup cenario                           Whitelabel

Resource                                    ../../../RESOURCE/COMMON/RES_UTIL.robot                                    
Resource                                    ${DIR_ROBS}/ROB0001_ConsultarIdEndereco/ROB0001_ConsultarIdEndereco.robot
Resource                                    ${DIR_ROBS}/ROB0002_ConsultarViabilidade/ROB0002_ConsultarViabilidade.robot
Resource                                    ${DIR_ROBS}/ROB0003_ConsultarSlot/ROB0003_ConsultarSlot.robot
Resource                                    ${DIR_ROBS}/ROB0004_RealizarAgendamento/ROB0004_RealizarAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0005_CriarOrdemAgendamento/ROB0005_CriarOrdemAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0007_ValidarAtribuicaoCompromissoFSL/ROB0007_ValidarAtribuicaoCompromissoFSL.robot
Resource                                    ${DIR_ROBS}/ROB0012_ConsultarAgendamento/ROB0012_ConsultarAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0013_CancelarAgendamento/ROB0013_CancelarAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0019_ValidarPendenciaSOM/ROB0019_ValidarPendenciaSOM.robot
Resource                                    ${DIR_ROBS}/ROB0025_AtualizacaoDeAgendamento/ROB0025_AtualizacaoDeAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0022_ValidarNotificacaoFW/ROB0022_ValidarNotificacaoFW.robot 
Resource                                    ${DIR_ROBS}/ROB0026_TrocaDeTecnicoFSL/ROB0026_TrocaDeTecnicoFSL.robot
Resource                                    ${DIR_ROBS}/ROB0027_DesatribuirAtividadeFSL/ROB0027_DesatribuirAtividadeFSL.robot

*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/007_AtivacaoComCancelamentoAposConfirmacao.xlsx


*** Test Cases ***

07.01 - Gerar Token de Acesso
    Retornar Token Vtal

07.02-3 - Realizar Consulta de Logradouro
    Consulta Id Logradouro

07.04 - Realizar Consulta de Viabilidade
    Retorna Viabilidade dos Produtos

07.05 - Realizar Consulta de Slots
    Retornar Slot Agendamento

07.06 - Realizar o Agendamento
    Realizar Agendamento

07.07 - Validar a Criação do SA via FLS
    Sleep                                   20s                                     #SLEEP ADICIONADO PARA AGUARDAR APARECER A SA NO FSL
    Escrever Variavel na Planilha           Atribuído                               Estado                                  Global
    Validacao Basica FSL

07.08 - Realizar a Criação de Ordem (OS)
    Criar Ordem Agendamento                 VELOCIDADE=1000
 
07.09 - Realizar Validação no SOM
    Validacao SOM sem Pendencia

07.10 - Realizar Consulta do Agendamento
    Consultar o Agendamento

07.11 - Realizar o Reagendamento via API
    Reagendar Pedido OPM e FSL

XX.XX - Troca de técnico via FSL
    Troca de Tecnico no Field Service
    Close Browser                           CURRENT

07.12 - Realizar Consulta de Agendamento - Retorno
    Consultar o Agendamento
    
07.13 - Validar Notificação de Atualização via FW Console
    Validar Evento FW                       VALOR_BUSCA=workOrderId
    ...                                     XPATH_EVENTO=(//a[normalize-space()='Appointment.PatchAppointment'])[1]
    ...                                     RETORNO_ESPERADO=>200<

07.14 - Validar Atualização do Agendamento via FSL 
    Escrever Variavel na Planilha           Atribuído                               Estado                                  Global
    Validacao Basica FSL

07.15 - Realizar o Cancelamento do Agendamento
    Cancelar o Agendamento

07.15 - Validar Notificação de Atualização via FW Console
    Validar Evento FW                       VALOR_BUSCA=workOrderId
    ...                                     XPATH_EVENTO=(//a[normalize-space()='Appointment.CancelAppointment'])[1]
    ...                                     RETORNO_ESPERADO=>200<
    Escrever Variavel na Planilha           Não atribuído                           Estado                                  Global

07.16 - Realizar Validação no FSL
    Validar SA Cancelada FSL                Não atribuído                           Cancelamento do Agendamento

07.17 - Realizar Consulta de Agendamento - Retorno
    Consultar o Agendamento