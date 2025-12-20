# Help target - lists available commands
help:
	@echo "Available commands:"
	@echo "  make icons    - Generate app launcher icons using flutter_launcher_icons"

# Generate app launcher icons
icons:
	dart run flutter_launcher_icons
run-web-local:
	flutter run -d chrome \
	--dart-define=VERSION=0.x.x


build-web-local:
	flutter build web --no-web-resources-cdn --release

build-web-local-wasm:
	flutter build web --wasm --no-web-resources-cdn --release 

serve-web-local:
	cd build/web && python -m http.server 9000
# Default target (runs when you just type 'make')
.DEFAULT_GOAL := help