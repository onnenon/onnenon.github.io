css:
	npx @tailwindcss/cli -i ./src/input.css -o ./dist/styles.css

copy-static:
	mkdir -p dist/fonts
	cp -r src/fonts/* dist/fonts/
	cp src/index.html dist/

css-watch:
	npx @tailwindcss/cli -i ./src/input.css -o ./dist/styles.css --watch

build: css copy-static
	npx @tailwindcss/cli -i ./src/input.css -o ./dist/styles.css --minify
	elm make src/Main.elm --optimize --output=dist/main.js

live:
	elm-live src/Main.elm --pushstate --startpage=./dist/index.html --dir=./dist -- --output=dist/main.js

build-release: copy-static
	npx @tailwindcss/cli -i ./src/input.css -o ./dist/styles.css --minify
	elm make src/Main.elm --optimize --output=dist/main.js
