# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is an Elm-based personal portfolio website that creates a terminal-like interface displaying "onn.sh". The site features a typewriter effect showing "./onn.sh" with a blinking cursor, time display, and social media links with FontAwesome icons.

## Development Commands

### Build and Development
- `make build` - Production build (compiles Elm with optimization, processes CSS with minification)
- `make build-release` - Release build (same as build but cleaner target)
- `make live` - Development server with hot reload using elm-live
- `make css` - Generate CSS from Tailwind input
- `make css-watch` - Watch CSS changes and regenerate automatically
- `make copy-static` - Copy static assets (fonts, HTML) to dist/

### Individual Commands
- `elm make src/Main.elm --output=dist/main.js` - Compile Elm to JavaScript
- `npx @tailwindcss/cli -i ./src/input.css -o ./dist/styles.css` - Process Tailwind CSS

## Architecture

### Single-Page Elm Application
- **Main Module**: `src/Main.elm` - Contains the entire application logic
- **Model Structure**: 
  - `TimeInfo` - Current time and timezone
  - `TitleState` - Typewriter effect state (displayed text, remaining text, typing status)
  - Links and prompt configuration

### Key Features
- **Typewriter Animation**: Characters appear one by one with random delays (100-1000ms)
- **Real-time Clock**: Updates every second with formatted HH:MM display
- **Responsive Design**: Uses viewport-based font sizing (`text-[14vw]` for mobile, `md:text-8xl` for desktop)
- **Dark/Light Theme**: Catppuccin color scheme with automatic system theme detection

### Styling System
- **Tailwind CSS v4**: Uses new `@theme` syntax in `src/input.css`
- **Custom Colors**: Catppuccin Latte (light) and Mocha (dark) themes
- **Custom Fonts**: Mononoki (monospace), Titillium Web (sans), loaded via `@font-face`
- **Animations**: Custom blink animation for cursor effect

### Build Pipeline
- Elm compilation to JavaScript
- Tailwind CSS processing with custom theme configuration
- Static asset copying (fonts, HTML)
- All outputs go to `dist/` directory

### Dependencies
- **Elm Packages**: FontAwesome icons, core Elm modules (Browser, Html, Time, Random)
- **Build Tools**: Tailwind CSS CLI, elm-live for development

The application has no backend - it's a static site that can be served from the `dist/` directory.