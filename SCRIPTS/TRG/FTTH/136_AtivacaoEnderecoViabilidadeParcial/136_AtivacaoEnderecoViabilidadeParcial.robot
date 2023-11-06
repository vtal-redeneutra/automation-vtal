*** Settings ***
Documentation                               Agrupador responsavel por chamar TC dos ROBS referentes ao cenario


Suite Setup                                 Setup cenario                           Whitelabel

Resource                                    ../../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ../../../RESOURCE/MS/UTILS.robot
Resource                                    ${DIR_FSL}/UTILS.robot
Resource                                    ${DIR_SOM}/UTILS.robot
Resource                                    ${DIR_FW}/UTILS.robot
Resource                                    ${DIR_ROBS}/ROB0001_ConsultarIdEndereco/ROB0001_ConsultarIdEndereco.robot
Resource                                    ${DIR_ROBS}/ROB0002_ConsultarViabilidade/ROB0002_ConsultarViabilidade.robot
Resource                                    ${DIR_ROBS}/ROB0003_ConsultarSlot/ROB0003_ConsultarSlot.robot
Resource                                    ${DIR_ROBS}/ROB0004_RealizarAgendamento/ROB0004_RealizarAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0005_CriarOrdemAgendamento/ROB0005_CriarOrdemAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0006_ValidarOrdemSOM/ROB0006_ValidarOrdemSOM.robot
Resource                                    ${DIR_ROBS}/ROB0007_ValidarAtribuicaoCompromissoFSL/ROB0007_ValidarAtribuicaoCompromissoFSL.robot
Resource                                    ${DIR_ROBS}/ROB0008_AtualizarStatusSA/ROB0008_AtualizarStatusSA.robot
Resource                                    ${DIR_ROBS}/ROB0009_EncerrarAtualizarSA/ROB0009_EncerrarAtualizarSA.robot
Resource                                    ${DIR_ROBS}/ROB0010_ValidarSAFieldService/ROB0010_ValidarSAFieldService.robot
Resource                                    ${DIR_ROBS}/ROB0012_ConsultarAgendamento/ROB0012_ConsultarAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0022_ValidarNotificacaoFW/ROB0022_ValidarNotificacaoFW.robot
Resource                                    ${DIR_ROBS}/ROB0021_ValidarConfirmacaoAgendamento/ROB0021_ValidarConfirmacaoAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0025_AtualizacaoDeAgendamento/ROB0025_AtualizacaoDeAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0026_TrocaDeTecnicoFSL/ROB0026_TrocaDeTecnicoFSL.robot
Resource                                    ${DIR_ROBS}/ROB0039_AlteracaoCEPNetwin/ROB0039_AlteracaoCEPNetwin.robot
Resource                                    ${DIR_ROBS}/ROB0040_ProcessoObraSOM/ROB0040_ProcessoObraSOM.robot
Resource                                    ${DIR_ROBS}/ROB0018_TratarPendenciaSOM/ROB0018_TratarPendenciaSOM.robot
Resource                                    ${DIR_ROBS}/ROB0019_ValidarPendenciaSOM/ROB0019_ValidarPendenciaSOM.robot
Resource                                    ${DIR_ROBS}/ROB0025_AtualizacaoDeAgendamento/ROB0025_AtualizacaoDeAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0027_DesatribuirAtividadeFSL/ROB0027_DesatribuirAtividadeFSL.robot


*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/136_AtivacaoEnderecoViabilidadeParcial.xlsx


*** Test Cases ***
136.01 - “Transformando” o CEP de viável para parcial no Netwin
    [TAGS]                                  SCRIPT_A
    Transformar CEP Netwin

136.02 - Gerar Token de Acesso
    [TAGS]                                  SCRIPT_A
    Retornar Token Vtal

136.03-04 - Realizar Consulta de Logradouro e Complemento
    [TAGS]                                  SCRIPT_A
    Consulta Id Logradouro

136.05 - Realizar Consulta de Viabilidade
    [TAGS]                                  SCRIPT_A
    Retorna Viabilidade Produtos            RETORNO_ESPERADO=Viável com obra - CDO(s) sem porta livre e em célula disponível

136.06 - Realizar a Criação de Ordem (OS)
    [TAGS]                                  SCRIPT_A
    Criar ordem sem agendamento
    Escrever Variavel na Planilha           Atribuído                               Estado                                  Global

136.07 - Validar a Notificação da Criação da Ordem (OS) via Microserviços
    [TAGS]                                  SCRIPT_A
    Login ao Portal de Microserviços
    Acessar Microserviços no menu do PORTAL de Microserviços
    Procurar por ProductOrdering.listenerProductOrderAttributeValueChangeEvent referente ao associatedDocument
    Validar texto do Bloco com o Argumento  END - Finalização do serviço            204

136.08 - Validar a Criação da OS de Instalação via SOM
    [TAGS]                                  SCRIPT_A
    Valida Executar Processo de Obra

136.09 - “Transformando” o CEP de parcial para viavel no Netwin
    [TAGS]                                  SCRIPT_A
    Transformar CEP Netwin

136.10 - Realizar Processo de Obra - SOM
    [TAGS]                                  SCRIPT_A
    Realizar Processo de Obra

136.11 - Realizar consulta de slot para agendamento da instalação
    [TAGS]                                  SCRIPT_A
    Consulta Slot Agendamento

136.12 - Realizar agendamento da instalação
    [TAGS]                                  SCRIPT_A
    Realizar Agendamento

136.13 - Realizar resolução da pendência
    [TAGS]                                  SCRIPT_A
    Tratamento da Pendência

136.14 - Validar no SOM a resolução da pendência de agendamento
    [TAGS]                                  SCRIPT_A
    Validação da Pendência

136.15 - Realizar Validação no Microserviços
    [TAGS]                                  SCRIPT_A
    Login ao Portal de Microserviços
    Acessar Microserviços no menu do PORTAL de Microserviços
    Procurar por ProductOrdering.PatchProductOrder referente ao associatedDocument
    Validar texto do Bloco com o Argumento  END - Finalização do serviço            204

### Separado em script A e B pela necessidade de aguardar dia do agendamento para finalizar em TRG

XX.XX - Troca de técnico via FSL
    [TAGS]                                  SCRIPT_B
    Troca de Tecnico no Field Service
    Close Browser                           CURRENT

136.16 - Realizar o Encerramento da Os de instalação via FSL
    [TAGS]                                  SCRIPT_B
    Validar Atribuicao Automatica FSL
    Atualiza Status SA
    Validar Estado do pedido FSL
    Atualizar e Encerrar o SA
    Validar Estado do pedido FSL
    Close Browser                           CURRENT

136.17 - Validar no SOM o encerramento da OS de instalação
    [TAGS]                                  SCRIPT_B
    Validar Evento Simples SOM              VALOR_PESQUISA=associatedDocument
    ...                                     ORDER_TYPE=Vtal Fibra Instalação
    ...                                     ORDER_STATE=Completed

136.18 - Validar Mudança de Estados no Microserviços
    [TAGS]                                  SCRIPT_B
    ${state_list}=                          Create List                             EN_ROUTE                                IN_EXECUTION                            ACTIVITY_CONCLUDED_SUCESSFULLY
    
    Validar Mudanca de Estados no Portal de Microserviços                           associatedDocument                      ${state_list}                            WorkOrderManagement.ListenerWorkOrderStateChangeEvent                          tns:name      

136.19 - Validar no Field Service
    [TAGS]                                  SCRIPT_B
    Valida SA no Field Service

136.20 - Auditoria de Tarefas
    [TAGS]                                  SCRIPT_B
    Auditoria de Tarefas

136.21 - Validar a Notificação de Encerramento via Microserviços
    [TAGS]                                  SCRIPT_B
    Login ao Portal de Microserviços
    Acessar Microserviços no menu do PORTAL de Microserviços
    Procurar por ProductOrdering.ListenerProductOrderStateChangeEvent referente ao associatedDocument
    Validar texto do Bloco com o Argumento    END - Finalização do serviço      204 

#===========================================================================================================================#
### Cenário completo com agendamento para o mesmo dia apenas para testes
#===========================================================================================================================#
136.01 - “Transformando” o CEP de viável para parcial no Netwin
    [TAGS]                                  SCRIPT_COMPLETO
    Transformar CEP Netwin

136.02 - Gerar Token de Acesso
    [TAGS]                                  SCRIPT_COMPLETO
    Retornar Token Vtal

136.03-04 - Realizar Consulta de Logradouro e Complemento
    [TAGS]                                  SCRIPT_COMPLETO
    Consulta Id Logradouro

136.05 - Realizar Consulta de Viabilidade
    [TAGS]                                  SCRIPT_COMPLETO
    Retorna Viabilidade Produtos            Viável com obra - CDO(s) sem porta livre e em célula disponível

136.06 - Realizar a Criação de Ordem (OS)
    [TAGS]                                  SCRIPT_COMPLETO
    Criar Ordem sem agendamento
    Escrever Variavel na Planilha           Atribuído                               Estado                                  Global

136.07 - Validar a Notificação da Criação da Ordem (OS) via Microserviços
    [TAGS]                                  SCRIPT_COMPLETO
    Login ao Portal de Microserviços
    Acessar Microserviços no menu do PORTAL de Microserviços
    Procurar por ProductOrdering.listenerProductOrderAttributeValueChangeEvent referente ao associatedDocument
    Validar texto do Bloco com o Argumento    END - Finalização do serviço      204

136.08 - Validar a Criação da OS de Instalação via SOM
    [TAGS]                                  SCRIPT_COMPLETO
    Valida Executar Processo de Obra
    
136.09 - “Transformando” o CEP de parcial para viavel no Netwin
    [TAGS]                                  SCRIPT_COMPLETO
    Transformar CEP Netwin

136.10 - Realizar Processo de Obra - SOM
    [TAGS]                                  SCRIPT_COMPLETO
    Realizar Processo de Obra

136.11 - Realizar consulta de slot para agendamento da instalação
    [TAGS]                                  SCRIPT_COMPLETO
    Consulta Slot Agendamento

136.12 - Realizar agendamento da instalação
    [TAGS]                                  SCRIPT_COMPLETO
    Realizar Agendamento

136.13 - Realizar resolução da pendência
    [TAGS]                                  SCRIPT_COMPLETO
    Tratamento da Pendência

136.14 - Validar no SOM a resolução da pendência de agendamento
    [TAGS]                                  SCRIPT_COMPLETO
    Validação da Pendência

136.15 - Realizar Validação no Microserviços
    [TAGS]                                  SCRIPT_COMPLETO
    Login ao Portal de Microserviços
    Acessar Microserviços no menu do PORTAL de Microserviços
    Procurar por ProductOrdering.PatchProductOrder referente ao associatedDocument
    Validar texto do Bloco com o Argumento    END - Finalização do serviço      204

XX.XX - Atualização da data de agendamento via API
    [TAGS]                                  SCRIPT_COMPLETO
    Reagendar Pedido OPM e FSL              

XX.XX - Troca de técnico via FSL
    [TAGS]                                  SCRIPT_COMPLETO
    Troca de Tecnico no Field Service
    Close Browser                           CURRENT

136.16 - Realizar o Encerramento da Os de instalação via FSL
    [TAGS]                                  SCRIPT_COMPLETO
    Validar Atribuicao Automatica FSL
    Atualiza Status SA
    Validar Estado do pedido FSL
    Atualizar e Encerrar o SA
    Validar Estado do pedido FSL
    Close Browser                           CURRENT

136.17 - Validar no SOM o encerramento da OS de instalação
    [TAGS]                                  SCRIPT_COMPLETO
    Validar Evento Simples SOM              VALOR_PESQUISA=associatedDocument
    ...                                     ORDER_TYPE=Vtal Fibra Instalação
    ...                                     ORDER_STATE=Completed
    Close Browser                           CURRENT

136.18 - Validar Mudança de Estados no Microserviços
    [TAGS]                                  SCRIPT_COMPLETO
    ${state_list}=                          Create List                             EN_ROUTE                                IN_EXECUTION                            ACTIVITY_CONCLUDED_SUCESSFULLY
    
    Validar Mudanca de Estados no Portal de Microserviços                          associatedDocument                      ${state_list}                            WorkOrderManagement.ListenerWorkOrderStateChangeEvent                          tns:name      

136.19 - Validar no Field Service
    [TAGS]                                  SCRIPT_COMPLETO
    Valida SA no Field Service

136.20 - Auditoria de Tarefas
    [TAGS]                                  SCRIPT_COMPLETO
    Auditoria de Tarefas

136.21 - Validar a Notificação de Encerramento via Microserviços
    [TAGS]                                  SCRIPT_COMPLETO
    Login ao Portal de Microserviços
    Acessar Microserviços no menu do PORTAL de Microserviços
    Procurar por ProductOrdering.ListenerProductOrderStateChangeEvent referente ao associatedDocument
    Validar texto do Bloco com o Argumento    END - Finalização do serviço      204 