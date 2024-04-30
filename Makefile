css:
	./tailwindcss -i ./src/input.css -o ./dist/styles.css --watch

css-watch:
	./tailwindcss -i ./src/input.css -o ./dist/styles.css --watch

build:
	elm make src/Main.elm --output=dist/main.js

live:
	elm-live src/Main.elm --pushstate --startpage=./dist/index.html --dir=./dist -- --output=dist/main.js
