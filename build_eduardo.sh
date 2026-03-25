#!/bin/bash

IMAGE_NAME="edukaique_rust:v3"
CONTAINER_NAME="edukaique_rust"
DOCKERFILE="edukaique.Dockerfile"
PORTA_LOCAL=8080
PORTA_CONTAINER=8080

echo "---------------------------------------------------"
echo "🚀 Iniciando Pipeline DevOps - Eduardo Kaique"
echo "---------------------------------------------------"

echo "🛠️ Passo 1: Construindo imagem $IMAGE_NAME..."
docker build -t $IMAGE_NAME -f $DOCKERFILE .

if [ $? -ne 0 ]; then
    echo "❌ ERRO: Falha no build do Docker. Verifique seu Dockerfile."
    exit 1
fi

if [ "$(docker ps -aq -f name=$CONTAINER_NAME)" ]; then
    echo "🧹 Passo 2: Removendo container antigo..."
    docker rm -f $CONTAINER_NAME
fi

echo "🏃 Passo 3: Rodando o container $CONTAINER_NAME..."
docker run -d \
    --name $CONTAINER_NAME \
    -p $PORTA_LOCAL:$PORTA_CONTAINER \
    $IMAGE_NAME

echo "⏳ Aguardando a API inicializar..."
sleep 2

TAMANHO=$(docker images $IMAGE_NAME --format "{{.Size}}")
echo "📊 MÉTRICA: Tamanho final da imagem ($IMAGE_NAME): $TAMANHO"

echo "🧪 Passo 4: Testando endpoint /calcular..."
RESPONSE=$(curl -s -X POST http://localhost:$PORTA_LOCAL/calcular \
     -H "Content-Type: application/json" \
     -d '{"operador": "multiplicacao", "op1": 7, "op2": 6}')

echo "📥 Resposta da API: $RESPONSE"

if [[ $RESPONSE == *"42"* ]]; then
    echo "✅ SUCESSO: Otimização concluída e funcional!"
else
    echo "❌ ERRO: A API não respondeu corretamente. Verifique os logs."
    docker logs $CONTAINER_NAME
fi

echo "---------------------------------------------------"