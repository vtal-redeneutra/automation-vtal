*** Settings ***
Documentation                               Agrupador responsavel por chamar TC dos ROBS referentes ao cenario

Suite Setup                                 Setup cenario                           FTTP


Resource                                    ../../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ../../../RESOURCE/API/RES_API.robot
Resource                                    ../../../RESOURCE/MS/UTILS.robot
Resource                                    ${DIR_ROBS}/ROB0001_ConsultarIdEndereco/ROB0001_ConsultarIdEndereco.robot
Resource                                    ${DIR_ROBS}/ROB0002_ConsultarViabilidade/ROB0002_ConsultarViabilidade.robot
Resource                                    ${DIR_ROBS}/ROB0005_CriarOrdemAgendamento/ROB0005_CriarOrdemAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0006_ValidarOrdemSOM/ROB0006_ValidarOrdemSOM.robot
Resource                                    ${DIR_ROBS}/ROB0018_TratarPendenciaSOM/ROB0018_TratarPendenciaSOM.robot
Resource                                    ${DIR_ROBS}/ROB0022_ValidarNotificacaoFW/ROB0022_ValidarNotificacaoFW.robot
Resource                                    ${DIR_ROBS}/ROB0039_AlteracaoCEPNetwin/ROB0039_AlteracaoCEPNetwin.robot
Resource                                    ${DIR_ROBS}/ROB0040_ProcessoObraSOM/ROB0040_ProcessoObraSOM.robot
Resource                                    ${DIR_ROBS}/ROB0041_AbrirPendenciaObraSOM/ROB0041_AbrirPendenciaObraSOM.robot



*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/137_AtivacaoEnderecoViabilidadeParcial.xlsx


*** Test Cases ***

137.01 - “Transformando” o CEP de viável para parcial no Netwin 
    Transformar CEP Netwin

137.02 - Gerar Token de Acesso 
    Retornar Token Vtal

137.03 e 04 - Realizar Consulta de Logradouro e Consulta de Complemento
    Consulta Id Logradouro
    
137.05 - Realizar Consulta de Viabilidade
    Retorna Viabilidade Produtos            RETORNO_ESPERADO=Viável com obra - Survey sem CDO e em célula disponível

137.06 - Realizar a Criação de Ordem OS
    Criar Ordem Agendamento FTTP            VELOCIDADE=1000

137.07 - Validar a Notificação da Criação da Ordem OS via Microserviços
    Login ao Portal de Microserviços
    Acessar SOA no menu do PORTAL de Microserviços
    Procurar por ProductOrdering.PostProductOrder.v2.5 referente ao associatedDocument
    Validar texto do Bloco com o Argumento  END - Finalização do serviço            200

137.08 - Validar a Criação da OS de Instalação via SOM
    #Validacao da OS Completa FTTP
    Valida Executar Processo de Obra        FTTH_ou_FTTP=FTTP                       
    Valida Projeto de Rede                  

137.09 - “Transformando” o CEP de parcial para viável no Netwin
    Transformar CEP Netwin

137.10 - Realizar Processo de Obra - SOM
    Realizar Processo de Obra FTTP

137.11 - Realizar Validação de Retorno via SOM
   Valida Executar Processo de Obra FTTP    VELOCIDADE=1000

137.12 - Validar a Notificação de Encerramento via FW Console
    Login ao Portal de Microserviços
    Acessar Microserviços no menu do PORTAL de Microserviços
    Procurar por ProductOrdering.listenerProductOrderStateChangeEvent referente ao associatedDocument
    Validar texto do Bloco com o Argumento    END - Finalização do serviço      204  