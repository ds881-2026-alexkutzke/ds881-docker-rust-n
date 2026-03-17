# Desafio DevOps: Otimização de Imagens Docker e Integração Contínua

Este repositório contém o código-fonte de uma API REST de Calculadora desenvolvida em Rust utilizando o framework Axum e o Serde para serialização. O gerenciamento de dependências e a compilação são orquestrados pelo Cargo (Cargo.toml). A aplicação expõe a porta 8080.

## 🎯 Objetivo da Atividade
O objetivo desta prática não é apenas executar a aplicação, mas aplicar a cultura DevOps (CALMS) para construir a **menor e mais eficiente imagem Docker possível**, colaborando com seus colegas no processo.

## 💻 Sobre a Aplicação
A API expõe um único endpoint na porta `8080`.
* **Rota:** `/calcular`
* **Método:** `POST`
* **Operadores Suportados:** `soma`, `subtracao`, `multiplicacao`, `divisao`

**Exemplo de carga útil (Payload):**

```json
{
  "operador": "multiplicacao",
  "op1": 7,
  "op2": 6
}
```

## ⚙️ Instruções Passo a Passo

### 1. Preparação Local

1. Faça o clone deste repositório para sua máquina local.
2. Crie uma nova branch com o seu nome: `git checkout -b build/seu-nome`.

### 2. Desenvolvimento (Automation)

1. Crie um arquivo Dockerfile nomeado com a sua identificação (ex: `joao.Dockerfile`).
2. Crie um script de automação (`.bat` ou `.sh`) contendo os comandos exatos para construir (`docker build`) e executar (`docker run`) a sua imagem, garantindo o mapeamento da porta 8080.
3. Teste a sua imagem localmente enviando uma requisição para a API. Utilize o comando abaixo no terminal:

```bash
curl -X POST http://localhost:8080/calcular \
     -H "Content-Type: application/json" \
     -d '{"operador": "multiplicacao", "op1": 7, "op2": 6}'
```

4. Faça o commit e o push da sua branch: `git push origin build/seu-nome`.

### 3. Revisão de Código (Sharing & Collaboration)

1. Abra um **Pull Request (PR)** da sua branch para a `main`.
2. **Revisão Obrigatória:** Atue como revisor no PR de pelo menos um colega. Adicione comentários sugerindo melhorias técnicas para reduzir o tamanho da imagem (ex: uso de Alpine, multi-stage builds, otimização de camadas, `.dockerignore`).
3. O PR só poderá ser mesclado após a aprovação de pelo menos um colega do grupo.

### 4. Registro de Métricas (Measurement)

1. Após compilar sua imagem final otimizada, verifique o tamanho localmente com `docker images`.
2. Acesse a aba **Issues** deste repositório.
3. Na Issue "Registro de Tamanho Final das Imagens", adicione um comentário informando:
* Seu nome.
* O tamanho final da imagem (em MB).
* Resumo das principais técnicas de otimização utilizadas.

## 🏆 Critérios de Avaliação (Total: 3 Pontos)

* **1 Ponto (Execução):** Criação funcional do seu `<nome>.Dockerfile` e do script de automação submetidos no PR.
* **1 Ponto (Revisão):** Participação ativa no PR de um colega com sugestões técnicas de melhoria.
* **1 Ponto Extra (Otimização Máxima):** Concedido ao aluno que registrar o **menor tamanho de imagem funcional** na Issue. Requer apresentação de 3 minutos na próxima aula explicando as técnicas utilizadas.

**Importante:** A aplicação deve continuar funcionando e respondendo corretamente ao comando `curl` após todas as otimizações. Imagens quebradas serão desclassificadas do ponto extra.
