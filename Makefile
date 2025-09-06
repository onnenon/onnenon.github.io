css:
	npx @tailwindcss/cli -i ./src/input.css -o ./dist/styles.css
copy-fonts:
    mkdir -p dist/fonts
    cp -r src/fonts/* dist/fonts/

css-watch:
	npx @tailwindcss/cli -i ./src/input.css -o ./dist/styles.css --watch

build: css
	npx @tailwindcss/cli -i ./src/input.css -o ./dist/styles.css --minify
	elm make src/Main.elm --optimize --output=dist/main.js

live:
	elm-live src/Main.elm --pushstate --startpage=./dist/index.html --dir=./dist -- --output=dist/main.js

build-release:
	npx @tailwindcss/cli -i ./src/input.css -o ./dist/styles.css --minify
	elm make src/Main.elm --optimize --output=dist/main.js
