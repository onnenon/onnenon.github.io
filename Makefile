css:
	./tailwindcss -i ./src/input.css -o ./dist/styles.css

css-watch:
	./tailwindcss -i ./src/input.css -o ./dist/styles.css --watch

build: css
	elm make src/Main.elm --optimize --output=dist/main.js

live:
	elm-live src/Main.elm --pushstate --startpage=./dist/index.html --dir=./dist -- --output=dist/main.js
