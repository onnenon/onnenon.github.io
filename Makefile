css:
	./bin/tailwindcss -i ./src/input.css -o ./dist/styles.css

css-watch:
	./bin/tailwindcss -i ./src/input.css -o ./dist/styles.css --watch

build: css
	elm make src/Main.elm --optimize --output=dist/main.js

live:
	elm-live src/Main.elm --pushstate --startpage=./dist/index.html --dir=./dist -- --output=dist/main.js

build-release:
	npx tailwindcss -i ./src/input.css -o ./dist/styles.css --minify
	elm make src/Main.elm --optimize --output=dist/main.js
