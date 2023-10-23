# robot-python-structure

1) Configuração do Ambiente e projeto Python:
```
	b. NODE JS https://nodejs.org/dist/v18.15.0/node-v18.15.0-x64.msi
	c. PYTHON https://www.python.org/ftp/python/3.9.13/python-3.9.13-amd64.exe
```

2) Solicitar ao suporte para incluir os paths de instalação do GIT, NODE e PYTHON, caso necessário:
```
	Exemplo:
	
	%USERPROFILE%\AppData\Local\Programs\Python\Python39\Scripts
	%USERPROFILE%\AppData\Roaming\Python\Python39\Scripts
	C:\Program Files\Git\usr\bin
```

3) Com o suporte em linha, validar a instalação e execução:
```
    a. mkdir C:\IBM_VTAL
	b. cd \IBM_VTAL
	c. git clone https://dev.azure.com/vtaldevops/AUTOMATION-TEST
	d. mv ./Automacoes_TRG/* .
	e. dir
	
```

4) Preparação de execução: Criar uma pasta e executar download dos scripts de testes/geração de massa hospedados no Azure Devops:
```
	a. Acessar a pasta do projeto recentemente clonado com o CMD e executar o arquivo REQUIREMENTS.TXT, com o seguintes passos:
	dir requeriments.txt
	python -m ensurepip --upgrade
	pip install --user --upgrade pip
	pip install wheel
	pip install -r requeriments.txt
	rfbrowser init
	npm install -g appium
```

5) Executando teste:
```	
	a. COPIAR um cenário de testes para a pasta de execução
	   copy C:\IBM_VTAL\DATA\INPUT\Param_Global.xlsx C:\IBM_VTAL\DATA
	   copy C:\IBM_VTAL\DATA\INPUT\TRG_FTTH_DAT_001_AtivacaoSemComplementoViaFSL.xlsx C:\IBM_VTAL\DATA
	b. Entrar na pasta do cenário e executar script
	   cd C:\IBM_VTAL\SCRIPTS\TRG\FTTH\001_AtivacaoSemComplementoViaFSL
	   C:\IBM_VTAL\SCRIPTS\TRG\FTTH\script selecionado\000_script selecionado.bat

```

6) Ao término, abrir pasta de logs para ver os resultados dos testes:
```
	C:\IBM_VTAL\SCRIPTS\TRG\FTTH\000_script selecionado\RESULTS
```