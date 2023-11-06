*** Settings ***
Documentation                               Agrupador responsavel por chamar TC dos ROBS referentes ao cenario


Suite Setup                                 Setup cenario                           Whitelabel


Resource                                    ../../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ../../../RESOURCE/FSL/UTILS.robot
Resource                                    ../../../RESOURCE/FW/UTILS.robot
Resource                                    ../../../RESOURCE/MS/UTILS.robot
Resource                                    ${DIR_FSL}/UTILS.robot
Resource                                    ${DIR_SOM}/UTILS.robot
Resource                                    ${DIR_ROBS}/ROB0003_ConsultarSlot/ROB0003_ConsultarSlot.robot
Resource                                    ${DIR_ROBS}/ROB0006_ValidarOrdemSOM/ROB0006_ValidarOrdemSOM.robot
Resource                                    ${DIR_ROBS}/ROB0007_ValidarAtribuicaoCompromissoFSL/ROB0007_ValidarAtribuicaoCompromissoFSL.robot
Resource                                    ${DIR_ROBS}/ROB0009_EncerrarAtualizarSA/ROB0009_EncerrarAtualizarSA.robot
Resource                                    ${DIR_ROBS}/ROB0022_ValidarNotificacaoFW/ROB0022_ValidarNotificacaoFW.robot
Resource                                    ${DIR_ROBS}/ROB0025_AtualizacaoDeAgendamento/ROB0025_AtualizacaoDeAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0026_TrocaDeTecnicoFSL/ROB0026_TrocaDeTecnicoFSL.robot
Resource                                    ${DIR_ROBS}/ROB0028_AgendamentoDeRetirada/ROB0028_AgendamentoDeRetirada.robot
Resource                                    ${DIR_ROBS}/ROB0029_CriarOrdemDeRetirada/ROB0029_CriarOrdemDeRetirada.robot
Resource                                    ${DIR_ROBS}/ROB0030_EnriquecimentoMassaSOM/ROB0030_EnriquecimentoMassaSOM.robot
Resource                                    ${DIR_ROBS}/ROB0008_AtualizarStatusSA/ROB0008_AtualizarStatusSA.robot
Resource                                    ${DIR_ROBS}/ROB0027_DesatribuirAtividadeFSL/ROB0027_DesatribuirAtividadeFSL.robot



*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/021_RealizarRetiradaSemPendenciaEnderecoMultiplosCompViaFSL.xlsx


*** Test Cases ***
21.01 - Gerar Token de Acesso
    Retornar Token Vtal

21.02 - Realizar Consulta de Slots Para Atividade de Retirada
    Retornar Slot Agendamento Retirada

21.03 - Realizar Agendamento de Retirada  
    Realizando Agendamento Retirada
    Escrever Variavel na Planilha           Atribuído                               Estado                                  Global

21.04 - Validar Notificação do Agendamento via Microserviços
    Login ao Portal de Microserviços
    Acessar SOA no menu do PORTAL de Microserviços
    Procurar por Appointment.PostAppointment referente ao associatedDocument
    Validar texto do Bloco com o Argumento  END - Finalização do serviço            201
    
21.05 - Validar a Criação do SA de Retirada via FSL
    Validar a Criação do SA de Retirada
    Close Browser                           CURRENT

21.06 - Realizar Abertura da Ordem de Retirada
    Criar Ordem Agendamento Retirada

21.07 - Realizar Validação no SOM
    Validar Evento Simples SOM              VALOR_PESQUISA=associatedDocument
    ...                                     ORDER_TYPE=Vtal Fibra Retirada
    ...                                     ORDER_STATE=In Progress
    Close Browser                           CURRENT

21.08 - Validar Notificação de Criação da Ordem via Microserviços   
    Login ao Portal de Microserviços
    Acessar SOA no menu do PORTAL de Microserviços
    Procurar por ProductOrdering.PostProductOrder.v2.5 referente ao associatedDocument
    Validar texto do Bloco com o Argumento  END - Finalização do serviço            200
    
#######################################################################################################################
# Adiciona tec. auxiliar antes de reagendar pois o FSL não permite realizar isso com data no passado.
21.XX - Atribuir Técnico Auxiliar
    Criacao e Validacao do Tecnico Auxiliar
    Close Browser                           CURRENT
########################################################################################################################

21.09 - Realizar Reagendamento
    Reagendar Pedido OPM e FSL Retirada
    Close Browser                           CURRENT

21.10 - Validar Notificação de Atualização via Microserviços
    Login ao Portal de Microserviços
    Acessar SOA no menu do PORTAL de Microserviços
    Procurar por Appointment.PatchAppointment referente ao associatedDocument
    Validar texto do Bloco com o Argumento  END - Finalização do serviço            200

21.11/12 - Validar a Atualização do Agendamento via FSL
    Escrever Variavel na Planilha           Não atribuído                           Estado                                  Global
    Validar a Criação do SA de Retirada
    Close Browser                           CURRENT

21.13 - Realizar o Encerramento de Retirada com Extravio
    Atualiza Status SA
    Atualizar e Encerrar com Extravio
    Close Browser                           CURRENT
   
21.14 - Valida a Notificação de Encerramento via Microserviços
    Login ao Portal de Microserviços
    Acessar Microserviços no menu do PORTAL de Microserviços
    Procurar por ProductOrdering.ListenerProductOrderStateChangeEvent referente ao associatedDocument
    Validar texto do Bloco com o Argumento  END - Finalização do serviço            204

21.15 - Validar o Encerramento da Ordem no SOM
    @{LIST}=                                Create List                             ${SOM_Ordem_numeroPedido}               ${SOM_infraType}                                                            
    ...                                     ${SOM_Cliente_idContrato}               

    @{RETORNO}=                             Create List                             associatedDocument                      InfraType                               
    ...                                     subscriberId    
                                                    
    Validar Evento Completo SOM             VALOR_PESQUISA=associatedDocument
    ...                                     ORDER_TYPE=Vtal Fibra Retirada
    ...                                     ORDER_STATE=Completed	
    ...                                     RETORNO_ESPERADO=${RETORNO}
    ...                                     XPATH_VALIDACOES=${LIST}
    Close Browser                           CURRENT

21.16 - Validar Mudança de Estados no Microserviços
    [TAGS]                                  COMPLETO
    ${state_list}=                          Create List                             EN_ROUTE                                IN_EXECUTION                            ACTIVITY_CONCLUDED_SUCESSFULLY
    
    Validar Mudanca de Estados no Portal de Microserviços                          associatedDocument                      ${state_list}                            WorkOrderManagement.ListenerWorkOrderStateChangeEvent                          tns:name      
    Close Browser                           CURRENT

21.17 - Auditoria de Tarefas
    Auditoria de Tarefas
    Close Browser                           CURRENT
