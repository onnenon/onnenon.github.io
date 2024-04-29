css:
	./tailwindcss -i ./src/input.css -o ./dist/styles.css

build:
	elm make src/Main.elm --output=dist/main.js