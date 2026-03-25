#!/bin/sh

set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
image_name="arturfalavinha/calculadora-api:latest"
container_name="arturfalavinha-calculadora-api"
dockerfile_path="$script_dir/arturfalavinha.Dockerfile"
endpoint="http://localhost:8080/calcular"
payload='{"operador":"multiplicacao","op1":7,"op2":6}'

echo "Building image $image_name"
docker build --file "$dockerfile_path" --tag "$image_name" "$script_dir"

docker rm -f "$container_name" >/dev/null 2>&1 || true

echo "Starting container $container_name"
docker run --detach --name "$container_name" --publish 8080:8080 "$image_name" >/dev/null

attempt=1
max_attempts=20
response=""

while [ "$attempt" -le "$max_attempts" ]; do
    if response=$(curl --silent --show-error --fail \
        --header "Content-Type: application/json" \
        --data "$payload" \
        "$endpoint" 2>/dev/null); then
        break
    fi

    sleep 1
    attempt=$((attempt + 1))
done

if [ -z "$response" ]; then
    echo "The API did not become ready in time."
    docker logs "$container_name" || true
    exit 1
fi

case "$response" in
    *\"resultado\":42*)
        echo "API response: $response"
        ;;
    *)
        echo "Unexpected API response: $response"
        docker logs "$container_name" || true
        exit 1
        ;;
esac

image_size=$(docker images "$image_name" --format "{{.Size}}")
echo "Image size: $image_size"
