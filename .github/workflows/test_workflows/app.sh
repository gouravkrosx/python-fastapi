# Build the project locally
sudo docker compose --env-file .env.keploy build

echo "Project built successfully"

docker volume ls

# Start the app in the background
sudo docker compose --env-file .env.keploy up &

# Wait for the service to be ready
echo "Waiting for the service to be ready..."
until curl -s -o /dev/null -w "%{http_code}" http://0.0.0.0:8000/api/home/ | grep -q "200"; do
  echo "Service is not ready yet. Waiting..."
  sleep 5
done

echo "Service is ready!"

# Perform curl requests
curl -X 'GET' \
  'http://0.0.0.0:8000/api/home/' \
  -H 'accept: application/json'

curl -X 'POST' \
  'http://0.0.0.0:8000/api/users/register' \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d '{
  "name": "Anas Nadeem",
  "email": "anas@gmail.com",
  "mobile": "1234567890",
  "password": "Test@123"
}'

# Bring down the app
sudo docker compose --env-file .env.keploy down
