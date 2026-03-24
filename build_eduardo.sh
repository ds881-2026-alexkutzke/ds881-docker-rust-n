#!/bin/bash

# Configurações
IMAGE_NAME="calculadora_api:scratch"
CONTAINER_NAME="calculadora_api"
PORTA_LOCAL=8080
PORTA_CONTAINER=8080

echo "---------------------------------------------------"
echo "🚀 Iniciando Automação DevOps - Eduardo"
echo "---------------------------------------------------"

if [ "$(docker ps -aq -f name=$CONTAINER_NAME)" ]; then
    echo "🧹 Removendo container antigo..."
    docker rm -f $CONTAINER_NAME
fi

echo "🏃 Rodando a imagem $IMAGE_NAME..."
docker run -d \
    --name $CONTAINER_NAME \
    -p $PORTA_LOCAL:$PORTA_CONTAINER \
    $IMAGE_NAME

echo "⏳ Aguardando a API inicializar..."
sleep 2

TAMANHO=$(docker images $IMAGE_NAME --format "{{.Size}}")
echo "📊 MÉTRICA: O tamanho final da imagem é: $TAMANHO"

echo "🧪 Testando endpoint /calcular..."
RESPONSE=$(curl -s -X POST http://localhost:$PORTA_LOCAL/calcular \
     -H "Content-Type: application/json" \
     -d '{"operador": "multiplicacao", "op1": 7, "op2": 6}')

echo "📥 Resposta da API: $RESPONSE"

if [[ $RESPONSE == *"42"* ]]; then
    echo "✅ SUCESSO: A calculadora está funcionando corretamente!"
else
    echo "❌ ERRO: A resposta não foi a esperada. Verifique os logs com: docker logs $CONTAINER_NAME"
fi

echo "---------------------------------------------------"